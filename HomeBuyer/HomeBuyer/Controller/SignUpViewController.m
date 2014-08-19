    //
//  SignUpViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "SignUpViewController.h"
#import "kunanceUser.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface SignUpViewController ()
@property (nonatomic, strong) UIButton* mRegisterButton;

@property (nonatomic, strong) IBOutlet UITextField* mNameField;
@property (nonatomic, strong) IBOutlet UITextField* mEmailField;
@property (nonatomic, strong) IBOutlet UITextField* mPasswordField;
@property (nonatomic, strong) IBOutlet UITextField* mRealtorCodeField;
@property (nonatomic, strong) UIColor* mRegisterButtonEnabledColor;

@property (nonatomic, strong) UIToolbar *mKeyBoardToolbar;

@property (nonatomic, strong) UITextField* mActiveField;
-(IBAction) showSignInView :(id)sender;
@end

@implementation SignUpViewController

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerUser:)
                                                 name:kReturnButtonClickedOnSignupForm
                                               object:nil];
}

- (void)viewDidLoad
{
    if (IS_WIDESCREEN)
    {
        self.mFormFields = [[NSArray alloc] initWithObjects:self.mNameField, self.mEmailField, self.mPasswordField, self.mRealtorCodeField, nil];
    }
    
    [super viewDidLoad];
    
    NSString* titleText = [NSString stringWithFormat:@"Create Account"];
    self.navigationController.navigationBar.topItem.title = titleText;

    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemDone target:self action:@selector(cancelScreen)];

     self.mRegisterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.mRegisterButton setTitle:@"Join" forState:UIControlStateNormal];
    [self.mRegisterButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchDown];
    self.mRegisterButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [self.mRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.mRegisterButton.backgroundColor = [Utilities getKunanceBlueColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mRegisterButton];
    
    self.mRegisterButtonEnabledColor = self.mRegisterButton.backgroundColor;
    
    [self.mNameField becomeFirstResponder];
    [self disableRegisterButton];
    
    
    self.mPasswordField.delegate = self;
    self.mEmailField.delegate = self;
    self.mNameField.delegate = self;
}

-(void) cancelScreen
{
    if(self.mSignUpDelegate && [self.mSignUpDelegate respondsToSelector:@selector(cancelSignUpScreen)])
    {
        [self.mSignUpDelegate cancelSignUpScreen];
    }
}

-(void) disableRegisterButton
{
    self.mRegisterButton.enabled = NO;
    self.mRegisterButton.backgroundColor = [UIColor grayColor];
}

-(void) enableRegisterButton
{
    self.mRegisterButton.enabled = YES;
    self.mRegisterButton.backgroundColor = self.mRegisterButtonEnabledColor;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) showSignInView :(id)sender
{
    if(self.mSignUpDelegate && [self.mSignUpDelegate respondsToSelector:@selector(loadSignInClicked)])
    {
        [self.mSignUpDelegate loadSignInClicked];
    }
}

-(BOOL) isPassowrdValid
{
    if(self.mPasswordField.text && self.mPasswordField.text.length >= MIN_PASSWORD_LENGTH)
        return YES;
    else
        return NO;
}

-(void) registerUser:(id)sender
{
    if([Utilities isUITextFieldEmpty:self.mNameField] ||
       [Utilities isUITextFieldEmpty:self.mEmailField] ||
       [Utilities isUITextFieldEmpty:self.mPasswordField])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all necessary fields"];
        return;
    }
    
    if(![Utilities isValidEmail:self.mEmailField.text])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter a valid email"];
        return;
    }
    
    if(![self isPassowrdValid])
    {
        [Utilities showAlertWithTitle:@"Error"
                           andMessage:[NSString stringWithFormat:@"Password should be at least %d characters long", MIN_PASSWORD_LENGTH]];
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    [kunanceUser getInstance].mKunanceUserDelegate = self;

    [self startAPICallWithMessage:@"Signing Up"];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    if(![[kunanceUser getInstance] signupWithName:self.mNameField.text
                             password:self.mPasswordField.text
                                email:self.mEmailField.text
                          realtorCode:self.mRealtorCodeField.text])
    {
        [self disableRegisterButton];
        self.mPasswordField.text = @"";
        [self cleanUpTimerAndAlert];
                self.navigationItem.leftBarButtonItem.enabled = YES;
        self.view.userInteractionEnabled = YES;
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sign Up failed"];
    }
}

-(IBAction)privacyPolicyClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"/privacy.html"]];
}

-(IBAction)termsClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"/terms.html"]];
}

#pragma RealtorDelegate
-(void) finishedReadingRealtorInfo:(NSError *)error
{
    if(!error)
    {
        NSLog(@"realtor = %@", [kunanceUser getInstance].mRealtor);
    }
    else
    {
        [Utilities showAlertWithTitle:@"Sorry" andMessage:@"We were unable to find a realtor with that ID"];
    }
}
#pragma end

#pragma LoginSignupServiceDelegate
-(void) signupCompletedWithError:(NSError *)error
{
    [self cleanUpTimerAndAlert];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    
    if(error)
    {
        NSDictionary* userInfo = error.userInfo;
        NSString* message = userInfo[@"error"];
        self.view.userInteractionEnabled = YES;
        self.mPasswordField.text = @"";
        [self disableRegisterButton];
        if(!message)
            message = @"Signup Failed";
        [Utilities showAlertWithTitle:@"Error" andMessage:message];
    }
    else
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Created Account Successfully" properties:Nil];

        if(self.mRealtorCodeField && self.mRealtorCodeField.text.length)
        {
            if(![kunanceUser getInstance].mRealtor)
                [kunanceUser getInstance].mRealtor = [[Realtor alloc] init];
            
            [kunanceUser getInstance].mRealtor.mRealtorDelegate = self;
            if(![[kunanceUser getInstance].mRealtor getRealtorForID:self.mRealtorCodeField.text])
            {
                [Utilities showAlertWithTitle:@"Sorry" andMessage:@"We were unable to find a realtor with that ID"];
            }
            
        }
        
        if(self.mSignUpDelegate &&
           [self.mSignUpDelegate respondsToSelector:@selector(userSignedUpSuccessfully)])
        {
            [self.mSignUpDelegate userSignedUpSuccessfully];
        }
    }
}
#pragma end

///////Keyboard Animation Related

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int futurePasswordLength = 0;
    int futureEmailLength = 0;
    int futureNameLength = 0;
    
    if(textField == self.mPasswordField)
    {
        if([string isEqualToString:@""])
        {
            futurePasswordLength = self.mPasswordField.text.length -1;
        }
        else
        {
            futurePasswordLength = self.mPasswordField.text.length +1;
        }
        
        futureEmailLength = self.mEmailField.text.length;
        futureNameLength = self.mNameField.text.length;
    }
    else if(textField == self.mNameField)
    {
        if([string isEqualToString:@""])
        {
            futureNameLength = self.mNameField.text.length -1;
        }
        else
        {
            futureNameLength = self.mNameField.text.length +1;
        }
        
        futureEmailLength = self.mEmailField.text.length;
        futurePasswordLength = self.mPasswordField.text.length;
    }
    else if(textField == self.mEmailField)
    {
        if([string isEqualToString:@""])
        {
            futureEmailLength = self.mEmailField.text.length -1;
        }
        else
        {
            futureEmailLength = self.mEmailField.text.length +1;
        }
        
        futurePasswordLength = self.mPasswordField.text.length;
        futureNameLength = self.mNameField.text.length;
    }
    else
    {
        futureEmailLength = self.mEmailField.text.length;
        futureNameLength = self.mNameField.text.length;
        futurePasswordLength = self.mPasswordField.text.length;
    }
    
    if(futurePasswordLength >= MIN_PASSWORD_LENGTH && futureNameLength > 0 && futureEmailLength > 0)
    {
        [self enableRegisterButton];
    }
    else
    {
        [self disableRegisterButton];
    }
    
    return YES;
}
@end
