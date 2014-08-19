//
//  DashOneHomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashOneHomeEnteredViewController.h"
#import "HelpDashboardViewController.h"
#import "ContactRealtorViewController.h"

@interface DashOneHomeEnteredViewController ()
{
    OneHomeLifestyleViewController* lifestyleCOntroller;
    OneHomeTaxSavingsViewController* taxsavingsController;
    OneHomePaymentViewController* paymentController;
    UIViewController* currentViewcontroller;
}
@end

@implementation DashOneHomeEnteredViewController

-(void) addPages
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    lifestyleCOntroller = [[OneHomeLifestyleViewController alloc] init];
    lifestyleCOntroller.mOneHomeLifestyleViewDelegate = self;
    [self.mPageViewControllers addObject:lifestyleCOntroller];
    
    taxsavingsController = [[OneHomeTaxSavingsViewController alloc] init];
    taxsavingsController.mOneHomeTaxSavingsDelegate = self;
    [self.mPageViewControllers addObject: taxsavingsController];
    
     paymentController = [[OneHomePaymentViewController alloc] init];
    paymentController.mOneHomePaymentViewDelegate = self;
    [self.mPageViewControllers addObject:paymentController];
}

-(void) addButtons
{
    self.mRentalButton = [[UIButton alloc] initWithFrame:CGRectMake(21, 95, 120, 40)];
    self.mHome1Button = [[UIButton alloc] initWithFrame:CGRectMake(179, 95, 120, 40)];
    
    if (IS_WIDESCREEN)
    {
        self.mContactRealtorIconButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 471, 25, 25)];
        self.mContactRealtorButton = [[UIButton alloc] initWithFrame:CGRectMake(52, 464, 100, 44)];
        self.mContactRealtorButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 520, 44, 44)];
    }
    else
    {
        self.mContactRealtorIconButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 408, 25, 25)];
        self.mContactRealtorButton = [[UIButton alloc] initWithFrame:CGRectMake(52, 401, 100, 40)];
        self.mContactRealtorButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 436, 44, 44)];
    }
    
    self.mRentalButton.backgroundColor = [UIColor clearColor];
    [self.mRentalButton addTarget:self
                           action:@selector(rentalButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mRentalButton];
    
    
    self.mHome1Button.backgroundColor = [UIColor clearColor];
    [self.mHome1Button addTarget:self
                          action:@selector(home1ButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHome1Button];

    if([kunanceUser getInstance].mRealtor.mIsValid)
    {
        if([kunanceUser getInstance].mRealtor.mSmallLogo)
            [self.mContactRealtorIconButton setImage:[kunanceUser getInstance].mRealtor.mSmallLogo
                                            forState:UIControlStateNormal];
        
        if([kunanceUser getInstance].mRealtor.mFirstName)
        {
            [self.mContactRealtorButton setTitle:[NSString stringWithFormat:@"Contact %@", [kunanceUser getInstance].mRealtor.mFirstName]
                                        forState:UIControlStateNormal];
        }
        else
        {
            [self.mContactRealtorButton setTitle:@"Contact Realtor" forState:UIControlStateNormal];
        }
        
        self.mContactRealtorButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        [self.mContactRealtorButton setTitleColor:[Utilities getKunanceBlueColor] forState:UIControlStateNormal] ;
        self.mContactRealtorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.mContactRealtorIconButton addTarget:self action:@selector(contactRealtor) forControlEvents:UIControlEventTouchUpInside];
        [self.pageController.view addSubview:self.mContactRealtorIconButton];

        [self.mContactRealtorButton addTarget:self action:@selector(contactRealtor) forControlEvents:UIControlEventTouchUpInside];
        [self.pageController.view addSubview:self.mContactRealtorButton];
        
    }

    [self.mHelpButton setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [self.mHelpButton addTarget:self action:@selector(helpButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];

    [self.pageController.view addSubview:self.mHelpButton];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(shareGraph)];

}

-(void)shareGraph
{
    NSMutableString *htmlMsg = [NSMutableString string];
    UIImage *chartImage  = nil;
    [htmlMsg appendString:@"\nI compared a home we were interested in using Kunance. Here are the results."];
    NSString* imageType = nil;
    
    homeInfo* home1 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    
    NSString* home1Addr = nil;
    
    if(home1.mHomeAddress && [home1.mHomeAddress getPrintableHomeAddress])
        home1Addr = [NSString stringWithFormat:@"\nHome Address: %@", [home1.mHomeAddress getPrintableHomeAddress]];
    else
        home1Addr = @"\n Home Address: None";
    
    if(currentViewcontroller == taxsavingsController)
    {
        chartImage = [Utilities takeSnapshotOfView:taxsavingsController.view];
        imageType = @"\nIncome tax savings on the home compared to rental:";
    }
    else if (currentViewcontroller == paymentController)
    {
        chartImage = [Utilities takeSnapshotOfView:paymentController.view];
        imageType = @"\nTotal payments on the home compared to rental:";
    }
    else if(currentViewcontroller == lifestyleCOntroller)
    {
        chartImage = [Utilities takeSnapshotOfView:lifestyleCOntroller.view];
        imageType = @"\nCash flow on the home compared to rental:";
    }
    
    
    NSArray *activityItems = @[htmlMsg, chartImage, home1Addr, imageType];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,UIActivityTypePostToFacebook,
                                                     UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,
                                                     UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToTencentWeibo,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAirDrop];
    
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
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
    self.pageController.delegate = self;
    
    currentViewcontroller = lifestyleCOntroller;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed 1-home dashboard" properties:Nil];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        currentViewcontroller = [pageViewController.viewControllers lastObject];
    }
}

-(void) setNavTitle:(NSString *)title
{
    if(title)
        self.navigationItem.title = title;
}

-(void) helpButtonTapped
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
}

-(void)contactRealtor
{
    ContactRealtorViewController* contactRealtor = [[ContactRealtorViewController alloc] init];
    contactRealtor.showDashboardIcon = YES;
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
