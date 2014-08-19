//
//  ExpensesViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/16/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "FixedCostsViewController.h"
#import "kunanceUser.h"
#import "HelpProfileViewController.h"
#import <MBProgressHUD.h>

#define MAX_RENT_LENGTH 7
#define MAX_CAR_PAYMENTS_LENGTH 5
#define MAX_HEALTH_PAYMENTS_LENGTH 5
#define MAX_FIXED_COSTS_LENGTH  5

@interface FixedCostsViewController ()
@property (nonatomic) float currentTransportValue;
@property (nonatomic) float currentHealthValue;
@property (nonatomic) float currentOtherCostsValue;

@end

@implementation FixedCostsViewController

-(void) addGestureRecognizers
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void) initWithExisitingFixedCosts
{
    userProfileInfo* userInfo = [kunanceUser getInstance].mkunanceUserProfileInfo;
    kunanceUserProfileStatus status = [kunanceUser getInstance].mUserProfileStatus;
    
    if(!userInfo || status == ProfileStatusUndefined || status == ProfileStatusUserPersonalFinanceInfoEntered)
    {
        return;
    }
    
    if(userInfo && [userInfo isFixedCostsInfoEntered])
    {
        //if([userInfo getMonthlyRentInfo])
            self.mMonthlyRent.text = [NSString stringWithFormat:@"%d", [userInfo getMonthlyRentInfo]];
        //if([userInfo getCarPaymentsInfo])
            self.mMonthlyCarPayments.text = [NSString stringWithFormat:@"%d", [userInfo getCarPaymentsInfo]];
        //if([userInfo getHealthInsuranceInfo])
            self.mMonthlyHealthInsurancePayments.text = [NSString stringWithFormat:@"%d", [userInfo getHealthInsuranceInfo]];
        //if([userInfo getOtherFixedCostsInfo])
            self.mOtherMonthlyPayments.text = [NSString stringWithFormat:@"%d", [userInfo getOtherFixedCostsInfo]];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
}

- (void)viewDidLoad
{
    NSString* titleText = [NSString stringWithFormat:@"Monthly Fixed Costs"];
    self.navigationController.navigationBar.topItem.title = titleText;
    
    self.currentOtherCostsValue = 0;
    self.currentHealthValue = 0;
    self.currentOtherCostsValue = 0;
    
    self.mFormFields = [[NSArray alloc] initWithObjects:self.mMonthlyRent,
                self.mMonthlyCarPayments, self.mMonthlyHealthInsurancePayments, self.mOtherMonthlyPayments, nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mMonthlyRent.maxLength = MAX_RENT_LENGTH;
    self.mMonthlyCarPayments.maxLength = MAX_CAR_PAYMENTS_LENGTH;
    self.mMonthlyHealthInsurancePayments.maxLength = MAX_HEALTH_PAYMENTS_LENGTH;
    self.mOtherMonthlyPayments.maxLength = MAX_FIXED_COSTS_LENGTH;
    
    [self addGestureRecognizers];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initWithExisitingFixedCosts];
    
    // this code allows the user to feel that the state of the switch is saved in the cloud.
    // Right now hard coded to CA values, will need to add switch status in cloud later on.
    if ([self.mMonthlyCarPayments.amount intValue] == 694)
    {
        [self.mFixedTransportCosts setOn:YES];
    }
    if ([self.mMonthlyHealthInsurancePayments.amount intValue] == 230)
    {
        [self.mFixedHealthCosts setOn:YES];
    }
    if ([self.mOtherMonthlyPayments.amount intValue] == 217)
    {
        [self.mFixedOtherCosts setOn:YES];
    }
    
    [self.mFixedTransportCosts addTarget:self action:@selector(transportButtonTapped:) forControlEvents:UIControlEventValueChanged];
    [self.mFixedHealthCosts addTarget:self action:@selector(healthButtonTapped:) forControlEvents:UIControlEventValueChanged];
    [self.mFixedOtherCosts addTarget:self action:@selector(otherFixedButtonTapped:) forControlEvents:UIControlEventValueChanged];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"View Fixed Costs Screen" properties:Nil];
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

#pragma mark userProfileInfoDelegate
-(void) finishedWritingUserPFInfo
{
    [self cleanUpTimerAndAlert];

    if([[kunanceUser getInstance].mkunanceUserProfileInfo isFixedCostsInfoEntered])
    {
        [[kunanceUser getInstance] updateStatusWithUserProfileInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
    }
    else
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sorry. Unable to connect to server"];
    }
}
#pragma end

#pragma mark Action Functions
//IBActions, target action, gesture targets
-(IBAction)aboutYouButtonTapped:(id)sender
{
    if(self.mFixedCostsControllerDelegate &&
       [self.mFixedCostsControllerDelegate respondsToSelector:@selector(aboutYouFromFixedCosts)])
       {
           [self.mFixedCostsControllerDelegate aboutYouFromFixedCosts];
       }
}

-(IBAction)helpButtonTapped:(id)sender
{
    HelpProfileViewController* hPV = [[HelpProfileViewController alloc] init];
    [self.navigationController pushViewController:hPV animated:NO];
}

-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(IBAction)currentLifeStyleIncomeTapped:(id)sender
{
    if(!self.mMonthlyRent.text.length)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter your current rent"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }

    userProfileInfo* userProfileInfo = [kunanceUser getInstance].mkunanceUserProfileInfo;
    if(userProfileInfo)
    {
        userProfileInfo.mUserProfileInfoDelegate =self;
        [self startAPICallWithMessage:@"Calculating"];
        
        if(![userProfileInfo writeFixedCostsInfo:[self.mMonthlyRent.amount intValue]
                   monthlyCarPaments:[self.mMonthlyCarPayments.amount intValue]
                     otherFixedCosts:[self.mOtherMonthlyPayments.amount intValue]
             monthlyHealthInsurance:[self.mMonthlyHealthInsurancePayments.amount intValue]])
        {
            [self cleanUpTimerAndAlert];
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update your information."];
        }
    }
    else
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update your information."];
    }
}

-(IBAction)transportButtonTapped:(id)sender
{
    if (self.mFixedTransportCosts.isOn)
    {
        self.currentTransportValue = [self.mMonthlyCarPayments.amount intValue];
        self.mMonthlyCarPayments.text = @"$694"; //avg transportation costs in CA per month
    }
    else
    {
        self.mMonthlyCarPayments.text = [NSString stringWithFormat:@"%.0f", self.currentTransportValue];
    }
}

-(IBAction)healthButtonTapped:(id)sender
{
    if (self.mFixedHealthCosts.isOn)
    {
        self.currentHealthValue = [self.mMonthlyHealthInsurancePayments.amount intValue];
        self.mMonthlyHealthInsurancePayments.text = @"$230"; //avg healthcare spending in CA per month
    }
    else
    {
        self.mMonthlyHealthInsurancePayments.text = [NSString stringWithFormat:@"%.0f", self.currentHealthValue];
    }
}

-(IBAction)otherFixedButtonTapped:(id)sender
{
    if (self.mFixedOtherCosts.isOn)
    {
        self.currentOtherCostsValue = [self.mOtherMonthlyPayments.amount intValue];
        self.mOtherMonthlyPayments.text = @"$217"; //avg entertainment spending in CA per month
    }
    else
    {
        self.mOtherMonthlyPayments.text = [NSString stringWithFormat:@"%.0f", self.currentOtherCostsValue];
    }
}

@end
