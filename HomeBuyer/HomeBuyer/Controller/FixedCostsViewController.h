//
//  ExpensesViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/16/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"
#import <TSCurrencyTextField.h>

@protocol FixedCostsControllerDelegate <NSObject>
-(void) aboutYouFromFixedCosts;
@end

@interface FixedCostsViewController : FormViewController <userProfileInfoDelegate>

@property (nonatomic, strong) IBOutlet TSCurrencyTextField* mMonthlyRent;
@property (nonatomic, strong) IBOutlet TSCurrencyTextField* mMonthlyCarPayments;
@property (nonatomic, strong) IBOutlet TSCurrencyTextField* mMonthlyHealthInsurancePayments;
@property (nonatomic, strong) IBOutlet TSCurrencyTextField* mOtherMonthlyPayments;
@property (nonatomic, strong) IBOutlet UIButton*  mCurrentLifestyleIncomeButton;
@property (nonatomic, strong) IBOutlet UIButton*  mDashboardButton;
@property (nonatomic, strong) IBOutlet UIButton*  mHelpButton;
@property (nonatomic, strong) IBOutlet UIButton*  mAboutYouButton;

@property (nonatomic, strong) IBOutlet UISwitch*  mFixedTransportCosts;
@property (nonatomic, strong) IBOutlet UISwitch*  mFixedHealthCosts;
@property (nonatomic, strong) IBOutlet UISwitch*  mFixedOtherCosts;

@property (nonatomic, weak) id <FixedCostsControllerDelegate> mFixedCostsControllerDelegate;

-(IBAction)currentLifeStyleIncomeTapped:(id)sender;
-(IBAction)dashButtonTapped:(id)sender;
-(IBAction)helpButtonTapped:(id)sender;
-(IBAction)aboutYouButtonTapped:(id)sender;
@end
