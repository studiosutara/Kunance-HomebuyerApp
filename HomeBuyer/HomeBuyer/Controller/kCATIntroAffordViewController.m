//
//  kCATIntroAffordViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroAffordViewController.h"

@interface kCATIntroAffordViewController ()

@end

@implementation kCATIntroAffordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView* appName  = nil;
    UILabel* label = nil;
    UIImage* backImage = nil;
    UILabel* swipeLabel = nil;
    
    self.view.bounds = CGRectMake(0, 0, [Utilities getDeviceWidth], [Utilities getDeviceHeight]);
    
    //Renders based on screen size
    if (IS_WIDESCREEN)
    {
        backImage = [UIImage imageNamed:@"home-interior_01.jpg"];
        appName = [[UIImageView alloc] initWithFrame:CGRectMake(160, 65, 150, 52)];
        label = [[UILabel alloc] initWithFrame:CGRectMake(160, 150, 237, 40)];
        swipeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 280, 85, 20)];
    }
    else
    {
        backImage = [UIImage imageNamed:@"home-interior-iphone4_01.jpg"];
        appName = [[UIImageView alloc] initWithFrame:CGRectMake(160, 40, 150, 52)];
        label = [[UILabel alloc] initWithFrame:CGRectMake(160, 100, 237, 40)];
        swipeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 230, 85, 20)];
    }
    
    UIImageView* backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImageView.image = backImage;
    [self.view addSubview:backImageView];
    
    appName.center = CGPointMake(self.view.center.x, appName.center.y);
    appName.image = [UIImage imageNamed:@"appname.png"];
    [self.view addSubview:appName];
    
    
    label.center = CGPointMake(self.view.center.x, label.center.y);
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Turning first-time homebuyers into pros.";
    label.font = [UIFont fontWithName:@"cocon" size:16];
    label.textColor = [Utilities getKunanceBlueColor];
    [self.view addSubview:label];
    
    swipeLabel.numberOfLines = 1;
    swipeLabel.textAlignment = NSTextAlignmentCenter;
    swipeLabel.text = @"Swipe Right   >>";
    swipeLabel.font = [UIFont fontWithName:@"cocon" size:10];
    swipeLabel.textColor = [Utilities getKunanceBlueColor];
    [self.view addSubview:swipeLabel];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Looked at FTUE Screen 1 - Intro" properties:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
