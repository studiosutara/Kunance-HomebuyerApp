//
//  HomeInfoDashViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/11/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeInfoDashViewController.h"
#import "HelpDashboardViewController.h"
#import "ContactRealtorViewController.h"
#import "DashLeftMenuViewController.h"

@interface HomeInfoDashViewController ()

@end

@implementation HomeInfoDashViewController

-(id) initWithHomeNumber:(NSNumber*) homeNumber
{
    self = [super init];
    
    if(self)
    {
        if(homeNumber)
            self.mHomeNumber = homeNumber;
    }
    
    return self;
}

-(void) addPages
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    HomeLifeStyleViewController* viewController2 = [[HomeLifeStyleViewController alloc] init];
    viewController2.mHomeLifeStyleDelegate = self;
    viewController2.mHomeNumber = self.mHomeNumber;
    [self.mPageViewControllers addObject: viewController2];
    
    HomePaymentsViewController* viewController1 = [[HomePaymentsViewController alloc] init];
    viewController1.mHomePaymentsDelegate = self;
    viewController1.mHomeNumber = self.mHomeNumber;
    [self.mPageViewControllers addObject:viewController1];
}

-(void) addButtons
{
    if([kunanceUser getInstance].mUserProfileStatus == ProfileStatusUser1HomeAndLoanInfoEntered ||
       [kunanceUser getInstance].mUserProfileStatus == ProfileStatusUserTwoHomesAndLoanInfoEntered)
    {
        if (IS_WIDESCREEN)
        {
            self.mDashButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 510, 44, 44)];
        }
        else
        {
            self.mDashButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 422, 44, 44)];
        }
        [self.mDashButton setImage:[UIImage imageNamed:@"dashboard.png"] forState:UIControlStateNormal];
        [self.mDashButton addTarget:self action:@selector(dashButtonTapped) forControlEvents:UIControlEventTouchDown];
        [self.pageController.view addSubview:self.mDashButton];
    }
    
    if (IS_WIDESCREEN)
    {
        self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 518, 44, 44)];
    }
    else
    {
        self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 425, 44, 44)];
    }
    
    [self.mHelpButton setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [self.mHelpButton addTarget:self action:@selector(helpButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHelpButton];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                  target:self
                                                  action:@selector(editHome)];
}

-(void) dashButtonTapped
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

- (void)viewDidLoad
{
    [self addPages];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *revealImagePortrait = [UIImage imageNamed:@"MenuIcon.png"];
    
    if ([self.navigationController.revealController hasLeftViewController])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImagePortrait
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView)];
    }
    
    CGRect pageBound = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,
                                  self.view.bounds.size.width, self.view.bounds.size.height);
    self.pageController.view.frame = pageBound;
    self.pageController.view.backgroundColor = [UIColor clearColor];
    
    [self addButtons];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Entered Home Info Dashboard" properties:Nil];
}

-(void) setNavTitle:(NSString *)title
{
    if(title)
        self.navigationItem.title = title;
}

-(void) editHome
{
    HomeInfoEntryViewController* homeEntry = [[HomeInfoEntryViewController alloc]
                                              initAsHomeNumber:[self.mHomeNumber intValue]];
    [self.navigationController pushViewController:homeEntry animated:NO];
}

-(void) helpButtonTapped
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
}

-(void)contactRealtor
{
    ContactRealtorViewController* contactRealtor = [[ContactRealtorViewController alloc] init];
    [self.navigationController pushViewController:contactRealtor animated:NO];
}

-(void) hideLeftView
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController
         showViewController:self.navigationController.revealController.frontViewController];
    }
}

-(void)showLeftView
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController
         showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController
         showViewController:self.navigationController.revealController.leftViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
