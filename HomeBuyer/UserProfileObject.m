//
//  UserProfileObject.m
//  calculator
//
//  Created by Shilpa Modi on 10/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "UserProfileObject.h"

@implementation UserProfileObject
-(id) init
{
    self = [super init];
    
    
    if(self)
    {
        self.mAnnualGrossIncome = 0;
        self.mAnnualRetirementSavings = 0;
        self.mNumberOfChildren = 0;
        self.mMonthlyRent = 0;
        self.mMonthlyHealthInsurancePayments = 0;
        self.mMonthlyCarPayments = 0;
        self.mMonthlyHealthInsurancePayments = 0;
        self.mMonthlyOtherFixedCosts = 0;
    }
    
    return self;
}
@end
