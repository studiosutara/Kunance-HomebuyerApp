//
//  DashTwoHomesEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashTwoHomesEnteredViewController.h"
#import "HelpDashboardViewController.h"
#import "ContactRealtorViewController.h"

@interface DashTwoHomesEnteredViewController ()
{
    TwoHomeLifestyleIncomeViewController* lifestyleViewController;
    TwoHomeTaxSavingsViewController* taxSavingsViewController;
    TwoHomePaymentViewController* paymentViewController;
    ContactRealtorViewController* contactRealtorView;
    UIViewController* mCurrentViewController;
}
@end

@implementation DashTwoHomesEnteredViewController

-(void) addButtons
{
    [self.mHelpButton setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [self.mHelpButton addTarget:self action:@selector(helpButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHelpButton];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(shareGraph)];
}

-(void) addButtonsToPageView:(UIView*) view
{
    self.mHome1Button = [[UIButton alloc] initWithFrame:CGRectMake(21, 95, 120, 40)];
    self.mHome2Button = [[UIButton alloc] initWithFrame:CGRectMake(179, 95, 120, 40)];
    self.mRentalButton = [[UIButton alloc] initWithFrame:CGRectMake(21, 165, 120, 40)];
    
    if (IS_WIDESCREEN)
    {
        self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 520, 44, 44)];
    }
    else
    {
        self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 436, 44, 44)];
    }
    
    self.mRentalButton.backgroundColor = [UIColor clearColor];
    [self.mRentalButton addTarget:self
                           action:@selector(rentalButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.mRentalButton];
    
    
    self.mHome1Button.backgroundColor = [UIColor clearColor];
    [self.mHome1Button addTarget:self
                          action:@selector(home1ButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.mHome1Button];
    
    
    self.mHome2Button.backgroundColor = [UIColor clearColor];
    [self.mHome2Button addTarget:self
                          action:@selector(home2ButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.mHome2Button];
    
}

-(void) addPages
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    lifestyleViewController = [[TwoHomeLifestyleIncomeViewController alloc] init];
    lifestyleViewController.mTwoHomeLifestyleDelegate = self;
    [self addButtonsToPageView:lifestyleViewController.view];
    [self.mPageViewControllers addObject:lifestyleViewController];
    
    taxSavingsViewController = [[TwoHomeTaxSavingsViewController alloc] init];
    taxSavingsViewController.mTwoHomeTaxSavingsDelegate = self;
    [self addButtonsToPageView:taxSavingsViewController.view];
    [self.mPageViewControllers addObject:taxSavingsViewController];
    
    paymentViewController = [[TwoHomePaymentViewController alloc] init];
    paymentViewController.mTwoHomePaymentDelegate = self;
    [self addButtonsToPageView:paymentViewController.view];
    [self.mPageViewControllers addObject:paymentViewController];
    
    if([kunanceUser getInstance].mRealtor && [kunanceUser getInstance].mRealtor.mIsValid)
    {
        contactRealtorView= [[ContactRealtorViewController alloc] init];
        contactRealtorView.mContactRealtorDelegate = self;
        [self.mPageViewControllers addObject:contactRealtorView];
        
        if (!IS_WIDESCREEN)
        {
            contactRealtorView.mHome2DashContactRealtor.frame = CGRectMake(0, 90, contactRealtorView.mHome2DashContactRealtor.frame.size.width,
                                                                           contactRealtorView.mHome2DashContactRealtor.frame.size.height);
        }
        
    }
    
    [[self.pageController view] setFrame:[[self view] bounds]];

}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        mCurrentViewController = [pageViewController.viewControllers lastObject];
        if(mCurrentViewController == contactRealtorView)
        {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        else
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
}

- (void)viewDidLoad
{
    [self addPages];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    self.pageController.delegate = self;
    
    mCurrentViewController = lifestyleViewController;
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed 2-home dashboard" properties:Nil];
}

-(void)shareGraph
{
    NSMutableString *htmlMsg = [NSMutableString string];
    UIImage *chartImage  = nil;
    [htmlMsg appendString:@"\nI compared a couple of homes we were interested in using Kunance. Here are the results."];
    NSString* imageType = nil;
    
    homeInfo* home1 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    homeInfo* home2 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:SECOND_HOME];

    NSString* home1Addr = nil;
    NSString* home2Addr = nil;
    
    if(home1.mHomeAddress && [home1.mHomeAddress getPrintableHomeAddress])
        home1Addr = [NSString stringWithFormat:@"\nHome 1 Address: %@", [home1.mHomeAddress getPrintableHomeAddress]];
    else
        home1Addr = @"\n Home 1 Address: None";
    
    if(home2.mHomeAddress && [home2.mHomeAddress getPrintableHomeAddress])
        home2Addr = [NSString stringWithFormat:@"Home 2 Address: %@", [home2.mHomeAddress getPrintableHomeAddress]];
    else
        home2Addr = @"Home 2 Address: None";
    
    if(mCurrentViewController == taxSavingsViewController)
    {
        chartImage = [Utilities takeSnapshotOfView:taxSavingsViewController.view];
        imageType = @"\nIncome tax savings on the different homes compared to rental:";
    }
    else if (mCurrentViewController == paymentViewController)
    {
        chartImage = [Utilities takeSnapshotOfView:paymentViewController.view];
        imageType = @"\nTotal payments on the different homes compared to rental:";
    }
    else if(mCurrentViewController == lifestyleViewController)
    {
        chartImage = [Utilities takeSnapshotOfView:lifestyleViewController.view];
        imageType = @"\nCash flow on the different homes compared to rental:";
    }
    

    NSArray *activityItems = @[htmlMsg, chartImage, home1Addr, home2Addr, imageType];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,UIActivityTypePostToFacebook,
                                                     UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,
                                                     UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToTencentWeibo,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAirDrop];

    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];

    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) rentalButtonTapped:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayUserDash object:Nil];
}

-(void) home1ButtonTapped:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHomeButtonTappedFromDash
                                                        object:[NSNumber numberWithInt:FIRST_HOME]];
}

-(void) home2ButtonTapped:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHomeButtonTappedFromDash
                                                        object:[NSNumber numberWithInt:SECOND_HOME]];
}

-(void) helpButtonTapped
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
}

-(void) setNavTitle:(NSString *)title
{
    if(title)
        self.navigationItem.title = title;
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
