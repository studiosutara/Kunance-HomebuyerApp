//
//  kCATIntroViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroViewController.h"
#import "kCATIntroAffordViewController.h"
#import "kCATIntroLifestyleViewController.h"
#import "kCATIntroRVBViewController.h"
#import "kCATIntroTaxViewController.h"

@interface kCATIntroViewController ()

@end

@implementation kCATIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) addButtons
{
    // Determine button location based on iPhone screen size
    
    if (IS_WIDESCREEN)
    {
        self.mSignInButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 520, 60, 44)];
        self.mSignUpButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 520, 100, 44)];
    }
    else
    {
        self.mSignInButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 438, 60, 44)];
        self.mSignUpButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 438, 100, 44)];
    }
    
    // Button color and font settings
    
    [self.mSignInButton setBackgroundColor:[UIColor clearColor]];
    [self.mSignInButton addTarget:self action:@selector(signInButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.mSignInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    self.mSignInButton.titleLabel.font = [UIFont fontWithName:@"cocon" size:16];
    [self.mSignInButton setTitleColor:[Utilities getKunanceBlueColor] forState:UIControlStateNormal];
    [self.pageController.view addSubview:self.mSignInButton];
    
    
    [self.mSignUpButton setBackgroundColor:[UIColor clearColor]];
    [self.mSignUpButton addTarget:self action:@selector(signUpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.mSignUpButton setTitle:@"Get Started" forState:UIControlStateNormal];
    self.mSignUpButton.titleLabel.font = [UIFont fontWithName:@"cocon" size:16];
    [self.mSignUpButton setTitleColor:[Utilities getKunanceBlueColor] forState:UIControlStateNormal];
    [self.pageController.view addSubview:self.mSignInButton];

    [self.pageController.view addSubview:self.mSignUpButton];

}

- (void)viewDidLoad
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    UIViewController* viewController1 = [[kCATIntroAffordViewController alloc] init];
    [self.mPageViewControllers addObject:viewController1];
    
    viewController1 = [[kCATIntroLifestyleViewController alloc] init];
    [self.mPageViewControllers addObject:viewController1];
    
    viewController1 = [[kCATIntroTaxViewController alloc] init];
    [self.mPageViewControllers addObject:viewController1];
    
    viewController1 = [[kCATIntroRVBViewController alloc] init];
    [self.mPageViewControllers addObject:viewController1];

    self.view.bounds = CGRectMake(0, 0, [Utilities getDeviceWidth], [Utilities getDeviceHeight]);
    self.mBackground = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    //Loads the appropriate image based on screen size
    
    if (IS_WIDESCREEN)
    {
        self.mBackground.image = [UIImage imageNamed:@"home-interior_01.jpg"];
    }
    else
    {
        self.mBackground.image = [UIImage imageNamed:@"home-interior-iphone4_01.jpg"];
    }
    
    [self.view addSubview:self.mBackground];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pageController.delegate = self;
    
    [[self.pageController view] setFrame:[[self view] bounds]];
    self.pageController.view.backgroundColor = [UIColor clearColor];

    [self.view setBackgroundColor:[UIColor clearColor]];
    [self addButtons];
    
}

#pragma mark UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    if (IS_WIDESCREEN)
    {
        NSString* imageName = [NSString stringWithFormat:@"home-interior_0%d.jpg", ((UIViewController*)pendingViewControllers[0]).view.tag+1];
        self.mBackground.image = [UIImage imageNamed:imageName];
    }
    else
    {
        NSString* imageName = [NSString stringWithFormat:@"home-interior-iphone4_0%d.jpg", ((UIViewController*)pendingViewControllers[0]).view.tag+1];
        self.mBackground.image = [UIImage imageNamed:imageName];
    }
    
}
#pragma end

-(void)signInButtonTapped:(id)sender
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Sign In Button Press" properties:Nil];
    
    [self.mkCATIntroDelegate signInFromIntro];
}

-(void)signUpButtonTapped:(id)sender
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Get Started Button Press" properties:Nil];
    
    [self.mkCATIntroDelegate signupFromIntro];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
