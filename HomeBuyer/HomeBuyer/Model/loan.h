//
//  loan.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOLLAR_VALUE_DOWN_PAYMENT 0
#define PERCENT_VALUE_DOWN_PAYMENT 1

typedef enum
{
    loanDurationTenYears = 0,
    loanDurationFifteenYears = 1,
    loanDurationTwentyYears = 2,
    loanDurationThirtyYears = 3
}loanDurationIndex;


#define DEFAULT_LOAN_DURATION_IN_YEARS loanDurationThirtyYears


@interface loan : NSObject
    @property (nonatomic) float  mDownPayment;
    @property (nonatomic) uint   mDownPaymentType;
    @property (nonatomic) float  mLoanInterestRate;
    @property (nonatomic) uint   mLoanDuration;

-(id) initWithDictionary:(NSDictionary*) dict;
-(NSDictionary*) getDictionaryObjectWithLoan;
@end
