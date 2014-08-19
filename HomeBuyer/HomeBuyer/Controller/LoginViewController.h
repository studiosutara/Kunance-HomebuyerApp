//
//  LoginViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/5/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormNoScrollViewViewController.h"
#import "ResetPasswordViewController.h"

@protocol LoginDelegate <NSObject>
-(void) loggedInUserSuccessfully;
-(void) signupButtonPressed;
-(void) cancelLoginScreen;
@end

@interface LoginViewController : FormNoScrollViewViewController
<UITextFieldDelegate, kunanceUserDelegate, ResetPasswordControllerDelegate>
@property (nonatomic, weak) id <LoginDelegate> mLoginDelegate;

@property (nonatomic, strong) IBOutlet UITextField* mLoginEmail;
@property (nonatomic, strong) IBOutlet UITextField* mPassword;
@property (nonatomic, strong) IBOutlet UIButton*    mForgetPasswordButton;
-(IBAction)forgotPassword:(id)sender;

@property (nonatomic, strong) UIButton*    mLoginButton;
@property (nonatomic, strong) UIColor* mLoginButtonColor;
@end
