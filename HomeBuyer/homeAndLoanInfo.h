//
//  homeInfo.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#define NUMBER_OF_MONTHS_IN_YEAR 12.0

#import <Foundation/Foundation.h>
@interface homeAndLoanInfo : NSObject
@property (nonatomic) float            mHomeListPrice;
@property (nonatomic) float              mHOAFees;
@property (nonatomic) uint  mNumberOfMortgageMonths;
@property (nonatomic) float mLoanInterestRate;
@property (nonatomic) float mDownPaymentAmount;
@property (nonatomic) uint mHomeType;
@property (nonatomic, copy) NSString* mHomeInCity;

-(float) getInterestAveragedOverYears:(uint)numOfYears;
-(float) getAnnualPropertyTaxes;
-(float) getMonthlyLoanPaymentForHome;
-(float) getInitialLoanBalance;
-(float) getMonthlyHomeOwnersInsuranceForHome;
-(float) getAnnualPMIForHome;
-(float) getTotalMonthlyPayment;
@end
