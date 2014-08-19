//
//  LoanInfoViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"
#import "usersLoansList.h"
#import <TSCurrencyTextField.h>

@protocol LoanInfoViewDelegate <NSObject>
@optional
-(void) backToHomeInfo;
@end

@interface LoanInfoViewController : FormViewController <usersLoansListDelegate>

@property (nonatomic, strong) loan* mCorrespondingLoan;
@property (nonatomic, strong) NSNumber* mHomeNumber;
@property (nonatomic) BOOL mIsFromHomeEntry;
@property (nonatomic, strong) IBOutlet UISegmentedControl* mPercentDollarValueChoice;
@property (nonatomic, strong) IBOutlet TSCurrencyTextField*  mDownPaymentFixedAmountField;
@property (nonatomic, strong) IBOutlet TSCurrencyTextField*  mDownPaymentPercentageField;

@property (nonatomic, strong) IBOutlet TSCurrencyTextField*        mInterestRateField;
@property (nonatomic, strong) IBOutlet UISegmentedControl* mLoanDurationField;

@property (nonatomic, strong) IBOutlet UIButton*             mCompareHomesButton;
-(IBAction)compareHomeButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*             mDashboardIcon;
-(IBAction)dashButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*             mShowHomePaymentsButton;
-(IBAction)showHomePaymentButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*             mHelpButton;
-(IBAction)helpButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*             mHomeInfoButton;
-(IBAction) homeInfoButtonTapped:(id)sender;

-(id) initFromHomeInfoEntry:(NSNumber*) homeNumber;
-(id) initFromMenu;

@property (nonatomic, weak) id <LoanInfoViewDelegate> mLoanInfoViewDelegate;
@end
