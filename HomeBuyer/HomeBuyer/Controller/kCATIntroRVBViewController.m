//
//  kCATIntroRVBViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroRVBViewController.h"

@interface kCATIntroRVBViewController ()

@end

@implementation kCATIntroRVBViewController

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
    self.view.bounds = CGRectMake(0, 0, [Utilities getDeviceWidth], [Utilities getDeviceHeight]);

    UILabel* label = nil;
    UIImage* backImage = nil;
    
    //Renders based on screen size
    if (IS_WIDESCREEN)
    {
        backImage = [UIImage imageNamed:@"home-interior_04.jpg"];
        label = [[UILabel alloc] initWithFrame:CGRectMake(160, 55, 270, 80)];
        label.text = @"Share results with family.\n\nConnect with realtors when ready.";
        label.numberOfLines = 3;
    }
    else
    {
        backImage = [UIImage imageNamed:@"home-interior-iphone4_04.jpg"];
        label = [[UILabel alloc] initWithFrame:CGRectMake(160, 35, 270, 70)];
        label.text = @"Share results with family.\nConnect with realtors when ready.";
        label.numberOfLines = 2;
    }
    
    UIImageView* backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImageView.image = backImage;
    [self.view addSubview:backImageView];
    
    label.center = CGPointMake(self.view.center.x, label.center.y);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"cocon" size:16];
    label.textColor = [Utilities getKunanceBlueColor];
    [self.view addSubview:label];

    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Looked at FTUE Screen 1 - Connect and Share" properties:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
