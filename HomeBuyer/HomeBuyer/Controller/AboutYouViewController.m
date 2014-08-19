//
//  AboutYouViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/15/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "AboutYouViewController.h"
#import "userProfileInfo.h"
#import "kunanceUser.h"
#import "HelpProfileViewController.h"
#import <MBProgressHUD.h>

#define MAX_ANNUAL_GROSS_INCOME_LENGTH 10
#define MAX_ANNUAL_RETIREMENT_SAVINGS_LENGTH 7

@interface AboutYouViewController ()
@property (nonatomic, strong) UIAlertView* mSlowNetworkAlert;
@end

@implementation AboutYouViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.mSelectedMaritalStatus = StatusNotDefined;
        self.mFixedCostsController = nil;
        self.mSlowNetworkAlert = nil;
    }
    
    return self;
}

-(void) selectMarried
{
    [self.mMarriedButton setImage:[UIImage imageNamed:@"couple-selected.png"]
                                forState:UIControlStateNormal];
    [self.mSingleButton setImage:[UIImage imageNamed:@"single.png"]
                               forState:UIControlStateNormal];
    
    self.mSelectedMaritalStatus = StatusMarried;
}

-(void) selectSingle
{
    [self.mSingleButton setImage:[UIImage imageNamed:@"single-selected.png"] forState:UIControlStateNormal] ;
    [self.mMarriedButton setImage:[UIImage imageNamed:@"couple.png"] forState:UIControlStateNormal];

    self.mSelectedMaritalStatus = StatusSingle;
}

-(void) setupGestureRecognizers
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void) initWithCurrentUserPFInfo
{
    userProfileInfo* theUserPFInfo = [kunanceUser getInstance].mkunanceUserProfileInfo;
    kunanceUserProfileStatus status = [kunanceUser getInstance].mUserProfileStatus;
   
    if(!theUserPFInfo || status == ProfileStatusUndefined)
    {
        return;
    }
    
    NSLog(@"initWithCurrentUserPFInfo: user annul gross = %ld",
          [theUserPFInfo getAnnualGrossIncome]);

    if([theUserPFInfo getMaritalStatus] == StatusMarried)
        [self selectMarried];
    
    else if([theUserPFInfo getMaritalStatus] == StatusSingle)
        [self selectSingle];
    
    //if([theUserPFInfo getAnnualGrossIncome])
        self.mAnnualGrossIncomeField.text =
        [NSString stringWithFormat:@"%ld", [theUserPFInfo getAnnualGrossIncome] ];
    
    //if([theUserPFInfo getAnnualRetirementSavings])
        self.mAnnualRetirementContributionField.text =
        [NSString stringWithFormat:@"%ld", [theUserPFInfo getAnnualRetirementSavings]];
    
    self.mNumberOfChildrenControl.selectedSegmentIndex = [theUserPFInfo getNumberOfChildren];
}
/*
-(void) viewWillAppear:(BOOL)animated
{
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
}*/

- (void)viewDidLoad
{
    self.mFormFields = [[NSArray alloc] initWithObjects:self.mAnnualGrossIncomeField,
                        self.mAnnualRetirementContributionField, nil];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
//    [self.mFormScrollView setContentOffset:CGPointMake(0, 60)];
    [self setupGestureRecognizers];
    [self initWithCurrentUserPFInfo];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.mAnnualGrossIncomeField.maxLength = MAX_ANNUAL_GROSS_INCOME_LENGTH;
    self.mAnnualRetirementContributionField.maxLength = MAX_ANNUAL_RETIREMENT_SAVINGS_LENGTH;
    
    self.navigationItem.title = @"Profile";
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"View About You Screen" properties:Nil];
    
}

- (void)viewDidAppear:(BOOL)animate
{
    [super viewDidAppear:animate];
    [self.mFormScrollView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark action functions
//IBActions, action target methods, gesture targets

-(IBAction)helpButtonTapped:(id)sender
{
    HelpProfileViewController* hPV = [[HelpProfileViewController alloc] init];
    [self.navigationController pushViewController:hPV animated:NO];
}

-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(IBAction)marriedButtonTapped:(id)sender
{
    [self selectMarried];
}

-(IBAction)singleButtonTapped:(id)sender
{
    [self selectSingle];
}

-(IBAction)fixedCostsButtonTapped:(id)sender
{
    if(self.mSelectedMaritalStatus == StatusNotDefined)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please pick a marital status"];
        return;
    }
    
    if([self.mAnnualGrossIncomeField.amount floatValue] <= 0)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter Annual income"];
        return;
    }
    
    if(![kunanceUser getInstance].mkunanceUserProfileInfo)
        [kunanceUser getInstance].mkunanceUserProfileInfo = [[userProfileInfo alloc] init];
    
    [kunanceUser getInstance].mkunanceUserProfileInfo.mUserProfileInfoDelegate = self;
    
    [self startAPICallWithMessage:@"Updating"];
    
    if(![[kunanceUser getInstance].mkunanceUserProfileInfo
                writeUserPFInfo:[self.mAnnualGrossIncomeField.amount intValue]
               annualRetirement:[self.mAnnualRetirementContributionField.amount intValue]
               numberOfChildren:self.mNumberOfChildrenControl.selectedSegmentIndex
                  maritalStatus:self.mSelectedMaritalStatus])
    {
        [self cleanUpTimerAndAlert];
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update your fixed costs info"];
    }
}

#pragma mark userProfileInfoDelegate
-(void) finishedWritingUserPFInfo
{
    [self cleanUpTimerAndAlert];

    if([kunanceUser getInstance].mkunanceUserProfileInfo)
    {
        [[kunanceUser getInstance] updateStatusWithUserProfileInfo];
        if(!self.mFixedCostsController)
            self.mFixedCostsController = [[FixedCostsViewController alloc] init];
        self.mFixedCostsController.mFixedCostsControllerDelegate = self;
        [self.navigationController pushViewController:self.mFixedCostsController animated:NO];
        
    }
    else
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sorry, unable to update you info"];
    }
}
#pragma end

#pragma mark FixedCostsControllerDelegate
-(void) aboutYouFromFixedCosts
{
    if(self.mFixedCostsController)
        [self.navigationController popViewControllerAnimated:NO];
}
#pragma end
@end
