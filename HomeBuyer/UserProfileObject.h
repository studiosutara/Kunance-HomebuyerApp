//
//  UserProfileObject.h
//  calculator
//
//  Created by Shilpa Modi on 10/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    StatusMarried = 0,
    StatusSingle = 1,
    StatusNotDefined = 3
}userMaritalStatus;


@interface UserProfileObject : NSObject
@property (nonatomic) long mAnnualGrossIncome;
@property (nonatomic) long mAnnualRetirementSavings;
@property (nonatomic) uint mNumberOfChildren;
@property (nonatomic) uint mMonthlyRent;
@property (nonatomic) uint mMonthlyHealthInsurancePayments;
@property (nonatomic) uint mMonthlyCarPayments;
@property (nonatomic) uint mMonthlyOtherFixedCosts;
@property (nonatomic) userMaritalStatus mMaritalStatus;
@end
