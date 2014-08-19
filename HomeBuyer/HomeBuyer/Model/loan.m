//
//  loan.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "loan.h"

static NSString* const kLoanDownPaymentKey = @"DownPaymentKey";
static NSString* const kDownPaymentTypeKey = @"DownPaymentTypeKey";
static NSString* const kLoanInterestKey = @"LoanInterestKey";
static NSString* const kLoanDurationKey = @"LoanDurationKey";

@implementation loan
-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mDownPayment = 0;
        self.mDownPaymentType = PERCENT_VALUE_DOWN_PAYMENT;
        self.mLoanInterestRate = 0;
        self.mLoanDuration = 0;
    }
    
    return self;
}

-(id) initWithDictionary:(NSDictionary*) dict
{
    self = [super init];
    
    if(self)
    {
        if(!dict)
            return self;
        
        self.mDownPayment = [dict[kLoanDownPaymentKey] floatValue];
        self.mDownPaymentType = [dict[kDownPaymentTypeKey] integerValue];
        self.mLoanInterestRate = [dict[kLoanInterestKey] floatValue];
        self.mLoanDuration = [dict[kLoanDurationKey] integerValue];
    }
    
    return self;

}

-(NSDictionary*) getDictionaryObjectWithLoan
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    dict[kLoanDownPaymentKey] = [NSNumber numberWithFloat:self.mDownPayment];
    dict[kDownPaymentTypeKey] = [NSNumber numberWithInt:self.mDownPaymentType];
    dict[kLoanDurationKey] = [NSNumber numberWithInt:self.mLoanDuration];
    dict[kLoanInterestKey] = [NSNumber numberWithFloat:self.mLoanInterestRate];
    
    return dict;
}

@end
