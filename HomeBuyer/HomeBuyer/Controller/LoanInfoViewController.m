//
//  LoanInfoViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LoanInfoViewController.h"
#import "HelpHomeViewController.h"
#import <MBProgressHUD.h>

#define LOAN_DURATION_10_YEARS 10
#define LOAN_DURATION_15_YEARS 15
#define LOAN_DURATION_20_YEARS 20
#define LOAN_DURATION_30_YEARS 30

#define MAX_POSSIBLE_INTEREST_RATE 10

#define MAX_DIGITS_DOWNPAYMENT_FIXED 10
#define MAX_DIGITS_DOWNPAYMENT_PERCENTAGE 2
#define MAX_DIGITS_INTEREST_RATE_FIELD 5

@interface LoanInfoViewController ()

@end

@implementation LoanInfoViewController

-(id) initFromHomeInfoEntry:(NSNumber*) homeNumber
{
    self = [super init];
    if(self)
    {
        if(homeNumber)
            self.mHomeNumber = homeNumber;
        self.mIsFromHomeEntry = YES;
    }
    
    return self;
}

-(id) initFromMenu
{
    self = [super init];
    if(self)
    {
        self.mIsFromHomeEntry = NO;
    }
    
    return self;
}

-(uint) getLoanDurationForIndex:(uint) index
{
    switch (index) {
        case loanDurationTenYears:
            return LOAN_DURATION_10_YEARS;
            break;
            
        case loanDurationFifteenYears:
            return LOAN_DURATION_15_YEARS;
            break;
            
        case loanDurationTwentyYears:
            return LOAN_DURATION_20_YEARS;
            break;
            
        case loanDurationThirtyYears:
            return LOAN_DURATION_30_YEARS;
            break;
            
        default:
            return LOAN_DURATION_30_YEARS;
    }
}

-(uint) getIndexForLoanDuration:(uint) loanDuration
{
    switch (loanDuration) {
        case LOAN_DURATION_10_YEARS:
            return loanDurationTenYears;
            
        case LOAN_DURATION_15_YEARS:
            return loanDurationFifteenYears;
            
        case LOAN_DURATION_20_YEARS:
            return loanDurationTwentyYears;
            
        case LOAN_DURATION_30_YEARS:
            return loanDurationThirtyYears;
            
        default:
            return loanDurationThirtyYears;
    }
}

-(void) updateDownPaymentFields
{
    if(self.mPercentDollarValueChoice.selectedSegmentIndex == PERCENT_VALUE_DOWN_PAYMENT)
    {
        self.mDownPaymentPercentageField.hidden = NO;
        self.mDownPaymentPercentageField.userInteractionEnabled = YES;
        
        self.mDownPaymentFixedAmountField.hidden = YES;
        self.mDownPaymentFixedAmountField.userInteractionEnabled = NO;
        
        self.mFormFields = [[NSArray alloc] initWithObjects:self.mDownPaymentPercentageField, self.mInterestRateField, nil];
    }
    else if(self.mPercentDollarValueChoice.selectedSegmentIndex == DOLLAR_VALUE_DOWN_PAYMENT)
    {
        self.mDownPaymentPercentageField.hidden = YES;
        self.mDownPaymentPercentageField.userInteractionEnabled = NO;
        
        self.mDownPaymentFixedAmountField.hidden = NO;
        self.mDownPaymentFixedAmountField.userInteractionEnabled = YES;
        
        self.mFormFields = [[NSArray alloc] initWithObjects:self.mDownPaymentFixedAmountField, self.mInterestRateField, nil];
    }
    
    [self setupNavControl];
}

-(void) setupWithExisitingLoan
{
    if(self.mCorrespondingLoan)
    {
        self.mPercentDollarValueChoice.selectedSegmentIndex = self.mCorrespondingLoan.mDownPaymentType;
        
        if(self.mCorrespondingLoan.mDownPaymentType == PERCENT_VALUE_DOWN_PAYMENT)
        {
            self.mDownPaymentPercentageField.text = [NSString  stringWithFormat:@"%.0f", self.mCorrespondingLoan.mDownPayment];
            
            self.mDownPaymentFixedAmountField.text = [NSString  stringWithFormat:@"%.0f", 0.0];
        }
        else if (self.mCorrespondingLoan.mDownPaymentType == DOLLAR_VALUE_DOWN_PAYMENT)
        {
             self.mDownPaymentFixedAmountField.text = [NSString  stringWithFormat:@"%.0f", self.mCorrespondingLoan.mDownPayment];
            self.mDownPaymentPercentageField.text = [NSString  stringWithFormat:@"%.0f", 0.0];
        }
        
        [self updateDownPaymentFields];
        self.mInterestRateField.text = [NSString stringWithFormat:@"%.2f", self.mCorrespondingLoan.mLoanInterestRate];
        
        self.mLoanDurationField.selectedSegmentIndex = [self getIndexForLoanDuration:self.mCorrespondingLoan.mLoanDuration];
    }
    else
    {
//        self.mDownPaymentFixedAmountField.text = [NSString  stringWithFormat:@"%.0f", 0.0];
//        self.mDownPaymentPercentageField.text = [NSString  stringWithFormat:@"%.0f", 0.0];
//        self.mInterestRateField.text = [NSString  stringWithFormat:@"%.0f", 0.0];
    }
}

-(void) setupButtons
{
    if(self.mIsFromHomeEntry)
    {
        self.mHomeInfoButton.enabled = YES;
        self.mHomeInfoButton.hidden = NO;
        self.mShowHomePaymentsButton.enabled = YES;
        self.mShowHomePaymentsButton.hidden = NO;
        self.mCompareHomesButton.enabled = NO;
        self.mCompareHomesButton.hidden = YES;
    }
    else
    {
        self.mHomeInfoButton.enabled = NO;
        self.mHomeInfoButton.hidden = YES;
        self.mShowHomePaymentsButton.enabled = NO;
        self.mShowHomePaymentsButton.hidden = YES;
        self.mCompareHomesButton.enabled = YES;
        self.mCompareHomesButton.hidden = NO;
    }
}

- (void)viewDidLoad
{
    NSString* titleText = [NSString stringWithFormat:@"Home Loan Info"];
    self.navigationController.navigationBar.topItem.title = titleText;

    self.mPercentDollarValueChoice.selectedSegmentIndex = PERCENT_VALUE_DOWN_PAYMENT;
    uint selectedSegment = PERCENT_VALUE_DOWN_PAYMENT;
    
    self.mCorrespondingLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    if(self.mCorrespondingLoan)
    {
         selectedSegment = self.mCorrespondingLoan.mDownPaymentType;
    }
    
    if(selectedSegment == PERCENT_VALUE_DOWN_PAYMENT)
    {
        self.mFormFields = [[NSArray alloc] initWithObjects:self.mDownPaymentPercentageField, self.mInterestRateField, nil];
    }
    else if (selectedSegment == DOLLAR_VALUE_DOWN_PAYMENT)
    {
        self.mFormFields = [[NSArray alloc] initWithObjects:self.mDownPaymentFixedAmountField, self.mInterestRateField, nil];
    }

    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.mFormScrollView setContentSize:CGSizeMake(320, 205)];
    self.mFormScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mDownPaymentFixedAmountField.translatesAutoresizingMaskIntoConstraints = NO;
    self.mDownPaymentPercentageField.translatesAutoresizingMaskIntoConstraints = NO;
    self.mInterestRateField.translatesAutoresizingMaskIntoConstraints = NO;
 //   [self.mFormScrollView setContentOffset:CGPointMake(0, 0)];
    
    [self.mPercentDollarValueChoice addTarget:self
                                       action:@selector(percentDollarChoiceChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    self.mLoanDurationField.selectedSegmentIndex = DEFAULT_LOAN_DURATION_IN_YEARS;
    
    [self setupButtons];
    
    self.mDownPaymentFixedAmountField.maxLength =  MAX_DIGITS_DOWNPAYMENT_FIXED;
    self.mInterestRateField.currencyNumberFormatter.maximumFractionDigits = 2;
    self.mInterestRateField.currencyNumberFormatter.minimumFractionDigits = 2;
    self.mInterestRateField.currencyNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.mInterestRateField.maxLength = MAX_DIGITS_INTEREST_RATE_FIELD;
    
    self.mDownPaymentPercentageField.currencyNumberFormatter.maximumFractionDigits = 0;
    self.mDownPaymentPercentageField.currencyNumberFormatter.minimumFractionDigits = 0;
    self.mDownPaymentPercentageField.currencyNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.mDownPaymentPercentageField.maxLength = MAX_DIGITS_DOWNPAYMENT_PERCENTAGE;
    
    [self setupWithExisitingLoan];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Entered Loan Info Screen" properties:Nil];
}

-(void) uploadLoanInfo
{
    if(![self.mInterestRateField.amount floatValue])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all the fields"];
        return;
    }
    
    loan* newLoanInfo = nil;
    
    if(self.mCorrespondingLoan)
        newLoanInfo = self.mCorrespondingLoan;
    else
        newLoanInfo = [[loan alloc] init];
    
    newLoanInfo.mDownPaymentType = self.mPercentDollarValueChoice.selectedSegmentIndex;
    if(newLoanInfo.mDownPaymentType == DOLLAR_VALUE_DOWN_PAYMENT)
    {
        newLoanInfo.mDownPayment = [self.mDownPaymentFixedAmountField.amount floatValue];
    }
    else if(newLoanInfo.mDownPaymentType == PERCENT_VALUE_DOWN_PAYMENT)
    {
        newLoanInfo.mDownPayment = [self.mDownPaymentPercentageField.amount floatValue];
    }
    
    NSNumber *interestRate = self.mInterestRateField.amount;//[numberFormatter numberFromString:self.mInterestRateField.text];
    if(interestRate)
        newLoanInfo.mLoanInterestRate = [interestRate floatValue];
    if(newLoanInfo.mLoanInterestRate < 0 || newLoanInfo.mLoanInterestRate > MAX_POSSIBLE_INTEREST_RATE)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"That does not appear to be a valid loan interest rate"];
        return;
    }
    
    newLoanInfo.mLoanDuration = [self getLoanDurationForIndex:self.mLoanDurationField.selectedSegmentIndex];
    
    if(![kunanceUser getInstance].mKunanceUserLoans)
        [kunanceUser getInstance].mKunanceUserLoans = [[usersLoansList alloc] init];

    [kunanceUser getInstance].mKunanceUserLoans.mLoansListDelegate = self;
    
    [self startAPICallWithMessage:@"Calculating"];
    
    if(![[kunanceUser getInstance].mKunanceUserLoans writeLoanInfo:newLoanInfo])
    {
        [self cleanUpTimerAndAlert];
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sorry unable to create loan info"];
        return;
    }
}

#pragma mark actions. gestures
-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(IBAction)showHomePaymentButtonTapped:(id)sender
{
    [self uploadLoanInfo];
}

-(IBAction)compareHomeButtonTapped:(id)sender
{
    [self uploadLoanInfo];
}

-(void) percentDollarChoiceChanged
{
    [self updateDownPaymentFields];
}

-(IBAction)helpButtonTapped:(id)sender
{
    HelpHomeViewController* hPV = [[HelpHomeViewController alloc] init];
    [self.navigationController pushViewController:hPV animated:NO];
}

-(IBAction) homeInfoButtonTapped:(id)sender
{
    if(self.mLoanInfoViewDelegate && [self.mLoanInfoViewDelegate respondsToSelector:@selector(backToHomeInfo)])
    {
        [self.mLoanInfoViewDelegate backToHomeInfo];
    }
        
}
#pragma end

#pragma APILoanInfoDelegate
-(void) finishedWritingLoanInfo
{
    [self cleanUpTimerAndAlert];

    [[kunanceUser getInstance] updateStatusWithLoanInfoStatus];
    if(self.mCompareHomesButton.enabled)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
    }
    else if(self.mShowHomePaymentsButton.enabled)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayHomeDashNotification object:self.mHomeNumber];
    }
}
#pragma end
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
