//
//  kCATCalculator.m
//  calculator
//
//  Created by Shilpa Modi on 10/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#define NUMBER_OF_YEARS_FOR_AVERAGE_INTEREST 10
#import "kCATCalculator.h"
#import "UserProfileObject.h"
#import "CalculatorUtilities.h"
#import "TaxBlock.h"

static const long kMortgageInterestDeductionUpperLimit = 1000000l;

@interface kCATCalculator()
@property (nonatomic, strong) NSDictionary* mDeductionsAndExemptions;
@property (nonatomic, strong) NSArray* mStateSingleTaxTable;
@property (nonatomic, strong) NSArray* mStateMFJTaxTable;
@property (nonatomic, strong) NSArray* mFederalSingleTaxTable;
@property (nonatomic, strong) NSArray* mFederalMFJTaxTable;
@property (nonatomic, strong) homeAndLoanInfo* mHome;
@end

@implementation kCATCalculator

- (id) initWithUserProfile:(UserProfileObject*) userProfile andHome:(homeAndLoanInfo *)home
{
    self = [super init];
    if (self)
    {
        // Initialization
        self.mUserProfile = userProfile;
        
        self.mDeductionsAndExemptions = [CalculatorUtilities getDictionaryFromPlistFile:@"ExemptionsAndStandardDeductions2013"];

        NSDateComponents *components = [[NSCalendar currentCalendar]
                                        components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger year = [components year];

        self.mStateSingleTaxTable = [self importTableFromFile:@"TaxTableStateSingle2013"];
        self.mStateMFJTaxTable = [self importTableFromFile:@"TaxTableStateMFJ2013"];
        
        NSString* federalSingleTableFile = [NSString stringWithFormat:@"TaxTableFederalSingle%d",year];
        self.mFederalSingleTaxTable = [self importTableFromFile:federalSingleTableFile];
        
        NSString* federalMFJTableFile = [NSString stringWithFormat:@"TaxTableFederalMFJ%d",year];
        self.mFederalMFJTaxTable = [self importTableFromFile:federalMFJTableFile];
        
        self.mHome = home;
    }
    
    return self;
}

-(float) getMonthlyLifeStyleIncome
{
    if(!self.mUserProfile)
        return 0;
    
    float annualStatesTaxesPaid = [self getAnnualStateTaxesPaid];
    float annualFederalTaxesPaid = [self getAnnualFederalTaxesPaid];
    
    float montlyGrossIncome = self.mUserProfile.mAnnualGrossIncome/NUMBER_OF_MONTHS_IN_YEAR;
    float monthlyStateTaxesPaid = annualStatesTaxesPaid/NUMBER_OF_MONTHS_IN_YEAR;
    float montlyFedralTaxesPaid = annualFederalTaxesPaid/NUMBER_OF_MONTHS_IN_YEAR;
    
    float monthlyRentOrMortgage = 0;
    if(self.mHome)
    {
        monthlyRentOrMortgage = [self.mHome getTotalMonthlyPayment];
    }
    else
    {
        monthlyRentOrMortgage = self.mUserProfile.mMonthlyRent;
    }
    
    float totalMonthlyCosts = monthlyRentOrMortgage +
                            self.mUserProfile.mMonthlyCarPayments +
                            self.mUserProfile.mMonthlyOtherFixedCosts +
                            self.mUserProfile.mMonthlyHealthInsurancePayments;
    float totalMonthlyTaxesPaid = monthlyStateTaxesPaid + montlyFedralTaxesPaid;
    
    float monthlyLifestyleIncome = montlyGrossIncome - (totalMonthlyCosts + totalMonthlyTaxesPaid);
    
    return  monthlyLifestyleIncome;
}

-(float) getTaxesForTable:(NSArray*)taxBlockArray andTaxableIncome:(float) taxableIncome
{
    if(!taxBlockArray)
        return 0;
    
    float differenceIncomeForBlock = 0;
    float applicableIncomeForBlock = 0;
    float baseIncomeForBlock = taxableIncome;
    float finalTaxesPaid = 0;

    uint count = 0;
    
    float upperLimitForPreviousBlock = 0;
    for (TaxBlock* currentTaxBlock in taxBlockArray)
    {
        float limitForCurrentBlock = currentTaxBlock.mUpperLimit;
        float percentageForCurrentBlock = currentTaxBlock.mPercentage;

        if(count == (taxBlockArray.count-1))
        {
            applicableIncomeForBlock = taxableIncome - limitForCurrentBlock;
        }
        else
        {
            differenceIncomeForBlock = baseIncomeForBlock - upperLimitForPreviousBlock;
            
            if(differenceIncomeForBlock < limitForCurrentBlock)
                applicableIncomeForBlock = differenceIncomeForBlock;
            else
                applicableIncomeForBlock = limitForCurrentBlock;
        }
        
        if(applicableIncomeForBlock < 0)
            break;
        
        float taxForCurrentBlock = (applicableIncomeForBlock * percentageForCurrentBlock/100);
        
        finalTaxesPaid += taxForCurrentBlock;
        
        upperLimitForPreviousBlock = limitForCurrentBlock;
        baseIncomeForBlock = differenceIncomeForBlock;
        
        count++;
    }

    return finalTaxesPaid;
}

-(float) getAnnualStateTaxesPaid
{
    if(!self.mUserProfile)
        return 0;
    
    float stateTaxableIncome = [self getAnnualStateTaxableIncome];
    NSArray* taxBlockArray = nil;
    if(self.mUserProfile.mMaritalStatus == StatusMarried)
        taxBlockArray = self.mStateMFJTaxTable;
    else
        taxBlockArray = self.mStateSingleTaxTable;

    float annualStateTaxes = [self getTaxesForTable:taxBlockArray andTaxableIncome:stateTaxableIncome];
    
    if(annualStateTaxes < 0)
        annualStateTaxes = 0;
    
    return annualStateTaxes;
}

-(float) getAnnualFederalTaxesPaid
{
    if(!self.mUserProfile)
        return 0;
    
    float federalTaxableIncome = [self getAnnualFederalTaxableIncome];
    NSArray* taxBlockArray = nil;
    if(self.mUserProfile.mMaritalStatus == StatusMarried)
        taxBlockArray = self.mFederalMFJTaxTable;
    else
        taxBlockArray = self.mFederalSingleTaxTable;
    
    float annualFederalTaxes = [self getTaxesForTable:taxBlockArray andTaxableIncome:federalTaxableIncome] + [self getFederalPayrollTax];
    
    if(self.mUserProfile.mNumberOfChildren > 0)
        annualFederalTaxes -= ([self.mDeductionsAndExemptions[@"ChildTaxCreditFederal"] floatValue] * self.mUserProfile.mNumberOfChildren);
    
    if(annualFederalTaxes < 0)
        annualFederalTaxes = 0;
    
    return annualFederalTaxes;
}

-(float) getAnnualAdjustedGrossIncome
{
    if(!self.mUserProfile)
        return 0;
    
    return (self.mUserProfile.mAnnualGrossIncome - self.mUserProfile.mAnnualRetirementSavings);
}
///////////////////////// ///////////////////////////////////////
///////////////////////// State calculations ////////////////////
///////////////////////// ///////////////////////////////////////
-(float) getStateStandardDeduction
{
    if(!self.mUserProfile)
        return 0;
    
    float finalDeduction = 0;
    
    if(self.mUserProfile.mMaritalStatus == StatusMarried)
        finalDeduction = [self.mDeductionsAndExemptions[@"MarriedDeductionCaliforniaState"] floatValue];
    else
        finalDeduction = [self.mDeductionsAndExemptions[@"SingleDeductionCaliforniaState"] floatValue];
    
    finalDeduction += (self.mUserProfile.mNumberOfChildren) * [self.mDeductionsAndExemptions[@"ChildrenDeductionCaliforniaState"] floatValue];

    return finalDeduction;
}

-(float) getStateItemizedDeduction
{
    if(!self.mUserProfile)
        return 0;
    
    float interestOnHomeMortgage = 0;
    float propertyTaxesPaid = 0;
    float PMIOnHome = 0;
    /*If mortgage owed =<$1M then all current equations exist
     If mortgage owed>$1M then the following:
     
     i (p)=interest paid in year
     i (d)=interest actually deductible in year
     m=mortgage owed at initiation of loan
     
     i(d)=($1,000,000/m)*[i(p)]
*/
    if(self.mHome)
    {
        float initialLoanBalance = [self.mHome getInitialLoanBalance];

        float averageInterestOverYears = [self.mHome getInterestAveragedOverYears:NUMBER_OF_YEARS_FOR_AVERAGE_INTEREST];
        
        if(initialLoanBalance <= kMortgageInterestDeductionUpperLimit)
        {
            interestOnHomeMortgage = averageInterestOverYears;
        }
        else
        {
            interestOnHomeMortgage =
            (kMortgageInterestDeductionUpperLimit/initialLoanBalance)* averageInterestOverYears;
        }
        
        propertyTaxesPaid = [self.mHome getAnnualPropertyTaxes];
        
        PMIOnHome = [self.mHome getAnnualPMIForHome];
    }

    return interestOnHomeMortgage + propertyTaxesPaid + PMIOnHome;
}

-(float) getStateExemptions
{
    if(!self.mUserProfile)
        return 0;
    
    float finalExemption = 0;
    
    if(self.mUserProfile.mMaritalStatus == StatusMarried)
        finalExemption = [self.mDeductionsAndExemptions[@"MarriedExemptionCaliforniaState"] floatValue];
    else
        finalExemption = [self.mDeductionsAndExemptions[@"SingleExemptionCaliforniaState"] floatValue];
    
    finalExemption += (self.mUserProfile.mNumberOfChildren) * [self.mDeductionsAndExemptions[@"ChildrenExemptionCaliforniaState"] floatValue];
    
    return finalExemption;
}

-(float) getAnnualStateTaxableIncome
{
    if(!self.mUserProfile)
        return 0;
    
    float standardDeduction = [self getStateStandardDeduction];
    float itemizedDeduction = [self getStateItemizedDeduction];
    
    float stateDeduction = (standardDeduction > itemizedDeduction) ? standardDeduction : itemizedDeduction;
    float exemption = [self getStateExemptions];
    float adjustedAnnualGrossIncome = [self getAnnualAdjustedGrossIncome];
    
    return (adjustedAnnualGrossIncome - (stateDeduction + exemption));
}

///////////////////////// ///////////////////////////////////////
///////////////////////// Federal Calculations ////////////////////
///////////////////////// ///////////////////////////////////////

-(float) getFederalStandardDeduction
{
    if(!self.mUserProfile)
        return 0;
    
    if(self.mUserProfile.mMaritalStatus == StatusMarried)
        return [self.mDeductionsAndExemptions[@"MarriedDeductionFederal"] floatValue];
    else
        return [self.mDeductionsAndExemptions[@"SingleDeductionFederal"] floatValue];;
}

-(float) getFederalItemizedDeduction
{
    if(!self.mUserProfile)
        return 0;
    
    float stateTaxesPaid = [self getAnnualStateTaxesPaid];
    float stateItemizedDeduction = [self getStateItemizedDeduction];
    
    return stateTaxesPaid + stateItemizedDeduction;
}

-(float) getFederalExemptions
{
    if(!self.mUserProfile)
        return 0;
    
    float finalExemption = 0;
    
    if(self.mUserProfile.mMaritalStatus == StatusMarried)
        finalExemption = [self.mDeductionsAndExemptions[@"MarriedExemptionFederal"] floatValue];
    else
        finalExemption = [self.mDeductionsAndExemptions[@"SingleExemptionFederal"] floatValue];
    
    finalExemption += (self.mUserProfile.mNumberOfChildren) * [self.mDeductionsAndExemptions[@"ChildrenExemptionFederal"] floatValue];
    
    return finalExemption;
}

-(float) getAnnualFederalTaxableIncome
{
    if(!self.mUserProfile)
        return 0;
    
    float stardardizedDeduction = [self getFederalStandardDeduction];
    float itemizedDeduction = [self getFederalItemizedDeduction];
    
    float federalDeduction = (stardardizedDeduction > itemizedDeduction) ? stardardizedDeduction : itemizedDeduction;
    float federalExemption = [self getFederalExemptions];
    
    float federalAdjustedGrossIncome = [self getAnnualAdjustedGrossIncome];
    
    float federalTaxableIncome = (federalAdjustedGrossIncome - federalDeduction - federalExemption);
    
    return federalTaxableIncome;
}

-(float) getFederalPayrollTax
{
    /* 6.2% of gross income on the first $117k for single or $234k for married
     1.45% on all gross income (no limit)
     For example someone making < $117k the taxable income will be 6.2% + 1.45% */
    
    if(!self.mUserProfile)
        return 0;
    
    float payrollTaxesPaid = 0;
    float medicareTaxesPaid = 0;
    
    float annualGrossIncome = self.mUserProfile.mAnnualGrossIncome;
    
    if ((self.mUserProfile.mMaritalStatus == StatusSingle && annualGrossIncome <= PAYROLL_SALARY_CUTOFF_SINGLE) || (self.mUserProfile.mMaritalStatus == StatusMarried && annualGrossIncome <= PAYROLL_SALARY_CUTOFF_MARRIED))
    {
        payrollTaxesPaid = annualGrossIncome * (SOCIAL_SECURITY_TAX + MEDICARE_TAX);
    }
    else if (self.mUserProfile.mMaritalStatus == StatusSingle && annualGrossIncome > PAYROLL_SALARY_CUTOFF_SINGLE)
    {
        if (annualGrossIncome > MEDICARE_TAX_CUTOFF_SINGLE)
        {
            medicareTaxesPaid = (MEDICARE_TAX_CUTOFF_SINGLE * MEDICARE_TAX) + ((annualGrossIncome - MEDICARE_TAX_CUTOFF_SINGLE) * (MEDICARE_TAX_ADDER_2014 + MEDICARE_TAX));
            payrollTaxesPaid = medicareTaxesPaid + MAX_SOCIAL_SECURITY_TAX_SINGLE;
        }
        else
        {
            payrollTaxesPaid = (annualGrossIncome * MEDICARE_TAX) + MAX_SOCIAL_SECURITY_TAX_SINGLE;
        }
    }
    else if (self.mUserProfile.mMaritalStatus == StatusMarried && annualGrossIncome > PAYROLL_SALARY_CUTOFF_MARRIED)
    {
        if (annualGrossIncome > MEDICARE_TAX_CUTOFF_MARRIED)
        {
            medicareTaxesPaid = (MEDICARE_TAX_CUTOFF_MARRIED * MEDICARE_TAX) + ((annualGrossIncome - MEDICARE_TAX_CUTOFF_MARRIED) * (MEDICARE_TAX_ADDER_2014 + MEDICARE_TAX));
            payrollTaxesPaid = medicareTaxesPaid + MAX_SOCIAL_SECURITY_TAX_MARRIED;
        }
        else
        {
            payrollTaxesPaid = (annualGrossIncome * MEDICARE_TAX) + MAX_SOCIAL_SECURITY_TAX_MARRIED;
        }
    }
    
    return payrollTaxesPaid;
}

-(NSArray*) importTableFromFile:(NSString*) fileName
{
    if(!fileName)
        return nil;
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSArray* tableDict = [CalculatorUtilities getArrayFromPlistFile:fileName];
    for (NSDictionary* blockDict in tableDict)
    {
        TaxBlock* block = [[TaxBlock alloc] init];
        block.mUpperLimit = [blockDict[@"limitsDifference"] floatValue];
        block.mPercentage = [blockDict[@"percentage"] floatValue];
        
        [array addObject:block];
    }
    
    return array;
}
@end
