//
//  DashUserPFInfoViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoEntryViewController.h"
#import "LoanInfoViewController.h"
#import "DashLeftMenuViewController.h"

@interface DashUserPFInfoViewController : DashLeftMenuViewController 
@property (nonatomic, strong) IBOutlet UIButton* mAddAHomeButton;
@property (nonatomic, strong) IBOutlet UIButton* mDashboardButton;
@property (nonatomic, strong) IBOutlet UILabel*  mLifestyleIncomeLabel;
@property (nonatomic, strong) IBOutlet UILabel*  mRentLabel;
@property (nonatomic, strong) IBOutlet UILabel*  mFixedCosts;
@property (nonatomic, strong) IBOutlet UILabel*  mEstimatedIncomeTaxesLabel;

@property (nonatomic, strong) HomeInfoEntryViewController* mHomeInfoViewController;
@property (nonatomic, strong) LoanInfoViewController* mLoanInfoViewController;
@property (nonatomic) BOOL mWasLoadedFromMenu;

-(IBAction)dasboardButtonTapped:(id)sender;
-(IBAction)addHomeInfo:(id)sender;
@end
