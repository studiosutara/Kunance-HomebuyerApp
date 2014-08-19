//
//  AboutYouViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/15/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userProfileInfo.h"
#import "FormViewController.h"
#import "FixedCostsViewController.h"
#import "userProfileInfo.h"
#import "TSCurrencyTextField.h"

@interface AboutYouViewController : FormViewController
<userProfileInfoDelegate, FixedCostsControllerDelegate, UITextFieldDelegate>
@property (nonatomic) userMaritalStatus      mSelectedMaritalStatus;
@property (nonatomic, strong) FixedCostsViewController* mFixedCostsController;

@property (nonatomic) IBOutlet UIButton*  mMarriedButton;
-(IBAction)marriedButtonTapped:(id)sender;

@property (nonatomic) IBOutlet UIButton*  mSingleButton;
-(IBAction)singleButtonTapped:(id)sender;

@property (nonatomic) IBOutlet TSCurrencyTextField*   mAnnualGrossIncomeField;
@property (nonatomic) IBOutlet TSCurrencyTextField*   mAnnualRetirementContributionField;
@property (nonatomic) IBOutlet UISegmentedControl* mNumberOfChildrenControl;

@property (nonatomic, strong) IBOutlet UIButton*  mDashboardButton;
@property (nonatomic, strong) IBOutlet UIButton*  mHelpButton;
@property (nonatomic, strong) IBOutlet UIButton*  mFixedCostsButton;

-(IBAction)fixedCostsButtonTapped:(id)sender;
-(IBAction)dashButtonTapped:(id)sender;
-(IBAction)helpButtonTapped:(id)sender;

@end
