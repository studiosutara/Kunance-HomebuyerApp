//
//  HelpProfileViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/25/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HelpProfileViewController.h"


@interface HelpProfileViewController ()

@end

@implementation HelpProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"HelpProfileViewController"
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Entered Profile Help Screen" properties:Nil];
}

-(IBAction)dashButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
