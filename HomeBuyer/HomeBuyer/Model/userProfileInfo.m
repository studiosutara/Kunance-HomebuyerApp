//
//  userPFInfo.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

static NSString* const kUserProfileClassKey = @"UserProfile";
static NSString* const kMaritalStatusKey = @"MaritalStatus";
static NSString* const kAnnualIncomeKey = @"AnnualGrossIncome";
static NSString* const kAnnualRetirementSavings = @"AnnualRetirementSavings";
static NSString* const kNumberOfChildren = @"NumberOfChildren";

static NSString* const kFixedCostsInfoEntered = @"FixedCostsEntered";
static NSString* const kMonthlyRentKey = @"MonthlyRent";
static NSString* const kCarPaymentsKey = @"CarPaymentKey";
static NSString* const kHealthInsurancePaymentsKey = @"HealthInsurance";
static NSString* const kOtherFixedCostsKey = @"OtherFixedCostsKey";

static NSString* const kUserKey          = @"User";

#import "userProfileInfo.h"
#import <Parse/Parse.h>

@interface userProfileInfo()
@property (nonatomic, strong) PFObject* mParseUserProfileObject;
@end

@implementation userProfileInfo
-(id) init
{
    self = [super init];
    if(self)
    {
        self.mParseUserProfileObject = nil;
    }
    
    return self;
}

-(UserProfileObject*) getCalculatorObject
{
    UserProfileObject* userProfile = [[UserProfileObject alloc] init];
    userProfile.mAnnualGrossIncome = [self getAnnualGrossIncome];
    userProfile.mAnnualRetirementSavings = [self getAnnualRetirementSavings];
    userProfile.mMaritalStatus = [self getMaritalStatus];
    userProfile.mNumberOfChildren = [self getNumberOfChildren];
    userProfile.mMonthlyHealthInsurancePayments = [self getHealthInsuranceInfo];
    userProfile.mMonthlyCarPayments = [self getCarPaymentsInfo];
    userProfile.mMonthlyOtherFixedCosts = [self getOtherFixedCostsInfo];
    userProfile.mMonthlyRent = [self getMonthlyRentInfo];
    
    return userProfile;
}

-(userMaritalStatus) getMaritalStatus
{
    if(self.mParseUserProfileObject && self.mParseUserProfileObject[kMaritalStatusKey])
    {
        return [self.mParseUserProfileObject[kMaritalStatusKey] integerValue];
    }
    else
        return StatusNotDefined;
}

-(long) getAnnualGrossIncome
{
    if(self.mParseUserProfileObject && self.mParseUserProfileObject[kAnnualIncomeKey])
    {
        return [self.mParseUserProfileObject[kAnnualIncomeKey] longValue];
    }
    else
        return 0;
}

-(long) getAnnualRetirementSavings
{
    if(self.mParseUserProfileObject && self.mParseUserProfileObject[kAnnualRetirementSavings])
    {
        return [self.mParseUserProfileObject[kAnnualRetirementSavings] longValue];
    }
    else
        return 0;
}

-(int) getNumberOfChildren
{
    if(self.mParseUserProfileObject && self.mParseUserProfileObject[kNumberOfChildren])
    {
        return [self.mParseUserProfileObject[kNumberOfChildren] integerValue];
    }
    else
        return 0;
}

-(int) getMonthlyRentInfo
{
    if(![self isFixedCostsInfoEntered])
        return 0;
    
    if(self.mParseUserProfileObject && self.mParseUserProfileObject[kMonthlyRentKey])
    {
        return [self.mParseUserProfileObject[kMonthlyRentKey] integerValue];
    }
    else
        return 0;
}

-(int) getHealthInsuranceInfo
{
    if(![self isFixedCostsInfoEntered])
        return 0;
    
    if(self.mParseUserProfileObject && self.mParseUserProfileObject[kHealthInsurancePaymentsKey])
    {
        return [self.mParseUserProfileObject[kHealthInsurancePaymentsKey] integerValue];
    }
    else
        return 0;
}

-(int) getCarPaymentsInfo
{
    if(![self isFixedCostsInfoEntered])
        return 0;

    if(self.mParseUserProfileObject && self.mParseUserProfileObject[kCarPaymentsKey])
    {
        return [self.mParseUserProfileObject[kCarPaymentsKey] integerValue];
    }
    else
        return 0;
}

-(int) getOtherFixedCostsInfo
{
    if(![self isFixedCostsInfoEntered])
        return 0;

    if(self.mParseUserProfileObject && self.mParseUserProfileObject[kOtherFixedCostsKey])
    {
        return [self.mParseUserProfileObject[kOtherFixedCostsKey] integerValue];
    }
    else
        return 0;
}

-(BOOL) isFixedCostsInfoEntered
{
    NSString* fixedCostsEntered = self.mParseUserProfileObject[kFixedCostsInfoEntered];
    if(fixedCostsEntered)
        return [fixedCostsEntered boolValue];
    else
        return NO;
}

-(void) readUserPFInfo
{
    PFQuery* query = [PFQuery queryWithClassName:kUserProfileClassKey];
    [query whereKey:kUserKey equalTo:[[kunanceUser getInstance] getUserID]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *userObject, NSError *error)
    {
        if(!error && userObject)
        {
            self.mParseUserProfileObject = userObject;
        }
        
        if(self.mUserProfileInfoDelegate &&
           [self.mUserProfileInfoDelegate respondsToSelector:@selector(finishedReadingUserPFInfo:)])
        {
            [self.mUserProfileInfoDelegate finishedReadingUserPFInfo:error];
        }
    }];
}

-(void) uploadObject:(PFObject*) parseUserPFInfo
{
    if(!parseUserPFInfo)
        return;
    
    [parseUserPFInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if(succeeded && !error)
         {
             if(!self.mParseUserProfileObject)
                 self.mParseUserProfileObject = parseUserPFInfo;
         }
         else
         {
             NSLog(@"Error creating User PF Info:");
         }
         
         if(self.mUserProfileInfoDelegate && [self.mUserProfileInfoDelegate respondsToSelector:@selector(finishedWritingUserPFInfo)])
         {
             [self.mUserProfileInfoDelegate finishedWritingUserPFInfo];
         }
     }];
}

-(BOOL) writeUserPFInfo:(UInt64)annualGross
       annualRetirement:(UInt64)annualRetirement
       numberOfChildren:(uint)numberOfChildren
          maritalStatus:(userMaritalStatus) status
{
    if(!annualGross)
        return NO;
    
    __block PFObject* parseUserPFInfo = nil;

    if(self.mParseUserProfileObject && self.mParseUserProfileObject.objectId)
    {
        parseUserPFInfo = self.mParseUserProfileObject;
    }
    else
    {
        parseUserPFInfo = [PFObject objectWithClassName:kUserProfileClassKey];
        self.mParseUserProfileObject[kFixedCostsInfoEntered] = [NSNumber numberWithBool:NO];
    }
    
    parseUserPFInfo[kMaritalStatusKey] = [NSNumber numberWithInt:status];
    parseUserPFInfo[kAnnualIncomeKey] = [NSNumber numberWithInt:annualGross];
    parseUserPFInfo[kAnnualRetirementSavings] = [NSNumber numberWithInt:annualRetirement];
    parseUserPFInfo[kNumberOfChildren] = [NSNumber numberWithInt:numberOfChildren];
    
    if(!parseUserPFInfo[kUserKey])
        parseUserPFInfo[kUserKey] = [[kunanceUser getInstance] getUserID];
    
    if(!parseUserPFInfo.ACL)
    {
        PFACL* userProfileACL = [PFACL ACLWithUser:[kunanceUser getInstance].mLoggedInKunanceUser];
        parseUserPFInfo.ACL = userProfileACL;
    }
    
    [self uploadObject:parseUserPFInfo];
    return YES;
}

-(BOOL) writeFixedCostsInfo:(UInt64)enteredMonthlyRent
          monthlyCarPaments:(UInt64)enteredCarPayments
            otherFixedCosts:(UInt64)enteredOtherCosts
     monthlyHealthInsurance:(UInt64)enteredHealthInsurancePayments
{
    if(!self.mParseUserProfileObject)
        return NO;
    
    self.mParseUserProfileObject[kMonthlyRentKey] = [NSNumber numberWithLong:enteredMonthlyRent];
    self.mParseUserProfileObject[kCarPaymentsKey] = [NSNumber numberWithLong:enteredCarPayments];
    self.mParseUserProfileObject[kHealthInsurancePaymentsKey] = [NSNumber numberWithLong:enteredHealthInsurancePayments];
    self.mParseUserProfileObject[kOtherFixedCostsKey] = [NSNumber numberWithLong:enteredOtherCosts];
    self.mParseUserProfileObject[kFixedCostsInfoEntered] = [NSNumber numberWithBool:YES];
    [self uploadObject:self.mParseUserProfileObject];
    
    return YES;
}
@end
