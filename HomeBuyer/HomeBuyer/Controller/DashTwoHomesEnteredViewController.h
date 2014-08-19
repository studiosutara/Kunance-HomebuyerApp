//
//  DashTwoHomesEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import <PKRevealController/PKRevealController.h>
#import "TwoHomePaymentViewController.h"
#import "TwoHomeLifestyleIncomeViewController.h"
#import "TwoHomeTaxSavingsViewController.h"
#import "ContactRealtorViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface DashTwoHomesEnteredViewController : BasePageViewController
<TwoHomePaymentDelegate, TwoHomeLifestyleDelegate, TwoHomeTaxSavingsDelegate,
UIPageViewControllerDelegate, ContactRealtorDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UIButton* mContactRealtorIconButton;
@property (nonatomic, strong) UIButton* mContactRealtorButton;

@property (nonatomic, strong) UIButton* mHelpButton;

@property (nonatomic, strong) UIButton* mRentalButton;
@property (nonatomic, strong) UIButton* mHome1Button;
@property (nonatomic, strong) UIButton* mHome2Button;

-(void) hideLeftView;
-(void)showLeftView;
@end
