//
//  ResetPasswordViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/22/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <MBProgressHUD.h>

@interface ResetPasswordViewController ()
@property (nonatomic, strong) UIButton* mDoneButton;
@end

@implementation ResetPasswordViewController

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
    self.mEmailField.delegate = self;
    
    self.mDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.mDoneButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.mDoneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchDown];
    self.mDoneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [self.mDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.mDoneButton.backgroundColor = [Utilities getKunanceBlueColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mDoneButton];
    [self.mEmailField becomeFirstResponder];
    [self disableDoneButton];
}

-(void) enableDoneButton
{
    self.mDoneButton.userInteractionEnabled = YES;
    self.mDoneButton.backgroundColor = [Utilities getKunanceBlueColor];
}

-(void) disableDoneButton
{
    self.mDoneButton.userInteractionEnabled = NO;
    self.mDoneButton.backgroundColor = [UIColor lightGrayColor];
}

-(void) doneButtonPressed
{
    [PFUser requestPasswordResetForEmailInBackground:self.mEmailField.text];
    [self.mEmailField resignFirstResponder];
    
    MBProgressHUD *hud = [Utilities getHUDViewWithText:@"Reset request sent" onView:self.view];
    [hud show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval: 1
                                     target: self
                                   selector: @selector(handleTimer)
                                   userInfo: nil
                                    repeats: NO];
}

-(void) handleTimer
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];

    if(self.mResetPasswordDelegate)
        [self.mResetPasswordDelegate resetRequestSent];
}

-(BOOL) textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString* newStr = [NSString stringWithFormat:@"%@%@",self.mEmailField.text, string];
    if([Utilities isValidEmail:newStr])
    {
        [self enableDoneButton];
    }
    else
    {
        [self disableDoneButton];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
