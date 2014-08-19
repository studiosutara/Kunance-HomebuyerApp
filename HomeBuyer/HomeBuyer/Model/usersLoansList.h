//
//  userLoansInfo.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "loan.h"

@protocol usersLoansListDelegate <NSObject>
@optional
-(void) finishedWritingLoanInfo;
-(void) finishedReadingLoanInfo;
@end


@interface usersLoansList : NSObject
-(BOOL) writeLoanInfo:(loan*) aLoan;
-(BOOL) readLoanInfo;

@property (nonatomic, weak) id <usersLoansListDelegate> mLoansListDelegate;

-(uint) getCurrentLoanCount;
-(loan*) getLoanInfo;
@end
