//
//  DashNoInfoViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashNoInfoViewController.h"
#import "HelpDashboardViewController.h"

@interface DashNoInfoViewController ()

@end

@implementation DashNoInfoViewController

-(id) init
{
    self = [super init];
    if(self)
    {
        self.mAboutYouViewController = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"DashNoInfoViewController"
                                                   owner:self
                                                options:nil];
    // Custom initialization
            if(views && views.count >= 2)
            {
                if (!IS_WIDESCREEN)
                {
                    self.view=views[1];
                }
            }
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer* tapAboutYou = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(aboutYouTapped)];
   
     [self.mEnterProfileButton addGestureRecognizer:tapAboutYou];
   
    NSString* firstName = [[kunanceUser getInstance] getFirstName];
     NSString* userName = (firstName ? [NSString stringWithFormat:@" %@!", firstName]:[NSString stringWithFormat:@"!"]);
     
     NSString* titleText = [NSString stringWithFormat:@"Welcome %@", userName];
     self.navigationController.navigationBar.topItem.title = titleText;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Entered Dashboard After Joining" properties:Nil];
    
}

-(void) loadAboutYou
{
    self.mAboutYouViewController = [[AboutYouViewController alloc] init];
    [self.navigationController pushViewController:self.mAboutYouViewController animated:YES];
}
#pragma mark target action functions geature recognizers
-(IBAction)enterProfileIconTapped:(id)sender
{
    [self loadAboutYou];
}

-(IBAction)helpIconTapped:(id)sender
{
    HelpDashboardViewController* helpvc = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:helpvc animated:NO];
}

-(void) aboutYouTapped
{
    [self loadAboutYou];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
