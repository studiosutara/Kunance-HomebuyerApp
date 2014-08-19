//
//  homeInfo.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "homeAndLoanInfo.h"
#import "CalculatorUtilities.h"

#define HOME_OWNERS_INSURANCE_FOR_SINGLE_FAMILY .25
#define HOME_OWNERS_INSURANCE_FOR_CONDOMINIUM .1
#define DEFAULT_PROPERTY_TAX_RATE 1.25
#define MINIMUM_DOWN_PERCENT_FOR_NO_PMI 20
#define PMI_RATE 0.75

@interface homeAndLoanInfo()
@property (nonatomic, strong) NSDictionary* mCityPropertyTaxRates;
@property (nonatomic) float mPropertyTaxRate;
@end

@implementation homeAndLoanInfo

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mHomeListPrice = 0;
        self.mHOAFees = 0;
        self.mNumberOfMortgageMonths = 0;
        self.mLoanInterestRate = 0;
        self.mDownPaymentAmount = 0;
        self.mPropertyTaxRate = DEFAULT_PROPERTY_TAX_RATE;
        self.mHomeInCity = nil;
        self.mCityPropertyTaxRates = [CalculatorUtilities getDictionaryFromPlistFile:@"CityTaxRate"];
    }
    
    return self;
}

-(float) getInterestAveragedOverYears:(uint) numberOfYears
{
    float loanBalanceAfterPrevPayment = [self getInitialLoanBalance];
    float interestPaidForThisMonth = 0;
    float principalPaidForThisMonth = 0;

    float monthlyLoanPaymentForHome = [self getMonthlyLoanPaymentForHome];
    uint numberOfMOnths = numberOfYears*NUMBER_OF_MONTHS_IN_YEAR;
    float monthlyInterestRate = self.mLoanInterestRate/NUMBER_OF_MONTHS_IN_YEAR/100;

    NSMutableArray* monthlyInterest = [[NSMutableArray alloc] init];
    
    for (int i= 0; i < numberOfMOnths; i++)
    {
        interestPaidForThisMonth = loanBalanceAfterPrevPayment * monthlyInterestRate;
        principalPaidForThisMonth = monthlyLoanPaymentForHome - interestPaidForThisMonth;
        loanBalanceAfterPrevPayment -= principalPaidForThisMonth;
        [monthlyInterest addObject:[NSNumber numberWithFloat:interestPaidForThisMonth]];
    }
    
    float averageInterestOverYears = 0;
    
    for (NSNumber* interest in monthlyInterest)
    {
        averageInterestOverYears += interest.floatValue;
    }
    
    averageInterestOverYears =  averageInterestOverYears/numberOfMOnths*12;
    
    return averageInterestOverYears;
}

-(float) getTotalMonthlyPayment
{
    float mortgage = ceilf([self getMonthlyLoanPaymentForHome]);
    
    float propertyTaxes = ceilf([self getAnnualPropertyTaxes]/NUMBER_OF_MONTHS_IN_YEAR);
    
    float hoa = ceilf(self.mHOAFees);
    
    float insurance = ceilf([self getMonthlyHomeOwnersInsuranceForHome]);
    
    float PMI = ceilf([self getAnnualPMIForHome])/NUMBER_OF_MONTHS_IN_YEAR;
    
    float totalPayments = mortgage+propertyTaxes+hoa+insurance+PMI;
    
    return totalPayments;
}

-(float) getMonthlyLoanPaymentForHome
{
    float monthlyInterestRate = self.mLoanInterestRate/NUMBER_OF_MONTHS_IN_YEAR/100;
    float initialLoanBalance = [self getInitialLoanBalance];
    float numberOfMonths = self.mNumberOfMortgageMonths;
    
    double exp = pow((1+ monthlyInterestRate), numberOfMonths);
    double numerator = monthlyInterestRate * initialLoanBalance * exp;
    double denominator = exp - 1;
    
    double monthlyLoanPayment = numerator/denominator;
    
    return monthlyLoanPayment;
}

-(float) getAnnualPMIForHome
{
    float percentageDown = 100*(self.mDownPaymentAmount/self.mHomeListPrice);
 //   float percentageDown = 100-((self.mHomeListPrice - self.mDownPaymentAmount)/self.mHomeListPrice*100);
    if(percentageDown < MINIMUM_DOWN_PERCENT_FOR_NO_PMI)
    {
        return PMI_RATE * [self getInitialLoanBalance] /100;
    }
    else
    {
        return 0;
    }
}

-(float) getPropertyTaxRateForHome
{
    float taxRate = DEFAULT_PROPERTY_TAX_RATE;
    
    if(self.mHomeInCity)
    {
        if(self.mCityPropertyTaxRates[self.mHomeInCity])
            taxRate = [self.mCityPropertyTaxRates[self.mHomeInCity] floatValue];
    }
    
    return taxRate;
}

-(float) getMonthlyHomeOwnersInsuranceForHome
{
    float insurance = 0;
    if(self.mHomeType == homeTypeCondominium)
    {
        insurance = self.mHomeListPrice * HOME_OWNERS_INSURANCE_FOR_CONDOMINIUM /100;
    }
    else if(self.mHomeType == homeTypeSingleFamily)
    {
        insurance = self.mHomeListPrice * HOME_OWNERS_INSURANCE_FOR_SINGLE_FAMILY / 100;
    }
    
    return insurance/NUMBER_OF_MONTHS_IN_YEAR;
}

-(float) getInitialLoanBalance
{
    if(self.mDownPaymentAmount >= self.mHomeListPrice)
        return 0;
    else
        return self.mHomeListPrice - self.mDownPaymentAmount;
}

-(float) getAnnualPropertyTaxes
{
    return self.mHomeListPrice*[self getPropertyTaxRateForHome]/100;
}
@end
