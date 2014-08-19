//
//  LoginViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/5/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface LoginViewController ()
@property (nonatomic, strong) ResetPasswordViewController* mResetController;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginUser)
                                                 name:kReturnButtonClickedOnSigninForm
                                               object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    NSString* titleText = [NSString stringWithFormat:@"Sign In"];
    self.navigationController.navigationBar.topItem.title = titleText;

    self.mFormFields = [[NSArray alloc] initWithObjects:self.mLoginEmail, self.mPassword, nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mLoginEmail.delegate = self;
    self.mPassword.delegate = self;
    
    self.mLoginButton.enabled = NO;
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemDone target:self action:@selector(cancelScreen)];

    [self.mLoginEmail becomeFirstResponder];
    self.mLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.mLoginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.mLoginButton addTarget:self action:@selector(loginUser) forControlEvents:UIControlEventTouchDown];
    self.mLoginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [self.mLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.mLoginButton.backgroundColor = [Utilities getKunanceBlueColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mLoginButton];

    self.mLoginButtonColor = self.mLoginButton.backgroundColor;
    

    [self disableLoginButton];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) disableLoginButton
{
    self.mLoginButton.enabled = NO;
    self.mLoginButton.backgroundColor = [UIColor grayColor];
}

-(void) enableLoginButton
{
    self.mLoginButton.enabled = YES;
    self.mLoginButton.backgroundColor = self.mLoginButtonColor;
}

-(void) loginUser
{
    NSString* email = self.mLoginEmail.text;
    NSString* password = self.mPassword.text;
    
    if(!email || !password || !email.length || !password.length)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Password and Email cannot be empty"];
        return;
    }
    
    if(![Utilities isValidEmail:email])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter a valid Email"];
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    [self disableLoginButton];
    
    [self startAPICallWithMessage:@"Logging In"];
    [kunanceUser getInstance].mKunanceUserDelegate = self;
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    if(![[kunanceUser getInstance] loginWithEmail:email password:password])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Login Failed. Please try again."];
        self.mPassword.text = @"";
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.view.userInteractionEnabled = YES;
        [self disableLoginButton];
        [self cleanUpTimerAndAlert];
    }
}

#pragma ResetPasswordDelegate1
-(void) resetRequestSent
{
    [self.navigationController popViewControllerAnimated:NO];    
}
#pragma end


#pragma mark LoginSignupServiceDelegate
-(void) loginCompletedWithError:(NSError *)error
{
    [self cleanUpTimerAndAlert];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    
    if(error)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Login Failed. Please try again."];
        self.mPassword.text = @"";
        self.view.userInteractionEnabled = YES;
        [self disableLoginButton];
    }
    else
    {
        if(self.mLoginDelegate && [self.mLoginDelegate respondsToSelector:@selector(loggedInUserSuccessfully)])
        {
            [self.mLoginDelegate loggedInUserSuccessfully];
        }

    }
}
#pragma end

#pragma mark action functions
//IBActions, action target methods, gesture targets
-(IBAction)forgotPassword:(id)sender
{
    self.mResetController = [[ResetPasswordViewController alloc] init];
    self.mResetController.mResetPasswordDelegate = self;
    [self.navigationController pushViewController:self.mResetController animated:NO];
}

-(void) cancelScreen
{
    if(self.mLoginDelegate && [self.mLoginDelegate respondsToSelector:@selector(cancelLoginScreen)])
    {
        [self.mLoginDelegate cancelLoginScreen];
    }
}

-(IBAction) loginButtonPressed:(id)sender
{
    [self loginUser];
}

-(IBAction) signupButtonPressedAction:(id)sender
{
    if(self.mLoginDelegate && [self.mLoginDelegate respondsToSelector:@selector(signupButtonPressed)])
    {
        [self.mLoginDelegate signupButtonPressed];
    }
}
#pragma end

#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int futurePasswordLength = 0;
    int futureEmailLength = 0;
    
    if(textField == self.mPassword)
    {
        if([string isEqualToString:@""])
        {
            futurePasswordLength = self.mPassword.text.length -1;
        }
        else
        {
            futurePasswordLength = self.mPassword.text.length +1;
        }
        
        futureEmailLength = self.mLoginEmail.text.length;
    }
    else if(textField == self.mLoginEmail)
    {
        if([string isEqualToString:@""])
        {
            futureEmailLength = self.mLoginEmail.text.length -1;
        }
        else
        {
            futureEmailLength = self.mLoginEmail.text.length +1;
        }
        
        futurePasswordLength = self.mPassword.text.length;
    }

    if(futurePasswordLength >= 1 && futureEmailLength > 0)
    {
        [self enableLoginButton];
    }
    else
    {
        [self disableLoginButton];
    }
    
    return YES;
}

#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
