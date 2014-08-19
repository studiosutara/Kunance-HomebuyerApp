//
//  kCATCalculator.h
//  calculator
//
//  Created by Shilpa Modi on 10/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#define PAYROLL_SALARY_CUTOFF_SINGLE 117000.0
#define PAYROLL_SALARY_CUTOFF_MARRIED 234000.0
#define MEDICARE_TAX 0.0145 //PERCENT
#define MEDICARE_TAX_ADDER_2014 0.009 //PERCENT
#define SOCIAL_SECURITY_TAX 0.062 //PERCENT
#define MAX_SOCIAL_SECURITY_TAX_SINGLE 7254.0 //$
#define MAX_SOCIAL_SECURITY_TAX_MARRIED 14508.0 //$
#define MEDICARE_TAX_CUTOFF_SINGLE 200000.0
#define MEDICARE_TAX_CUTOFF_MARRIED 250000.0

#import <Foundation/Foundation.h>
#import "UserProfileObject.h"
#import "homeAndLoanInfo.h"

@interface kCATCalculator : NSObject
@property (nonatomic, strong) UserProfileObject* mUserProfile;

- (id) initWithUserProfile:(UserProfileObject*) userProfile andHome:(homeAndLoanInfo*) home;

-(float) getMonthlyLifeStyleIncome;
-(float) getAnnualStateTaxesPaid;
-(float) getAnnualFederalTaxesPaid;

-(float) getStateStandardDeduction;
-(float) getStateItemizedDeduction;
-(float) getStateExemptions;
-(float) getAnnualStateTaxableIncome;

-(float) getFederalStandardDeduction;
-(float) getFederalItemizedDeduction;
-(float) getFederalExemptions;
-(float) getAnnualFederalTaxableIncome;
@end
