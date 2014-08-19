//
//  SignUpViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormNoScrollViewViewController.h"
#import "Realtor.h"

@protocol SignUpDelegate <NSObject>
-(void) userSignedUpSuccessfully;
-(void) loadSignInClicked;
-(void) cancelSignUpScreen;
@end

@interface SignUpViewController : FormNoScrollViewViewController <UITextFieldDelegate, kunanceUserDelegate, RealtorDelegate>
@property (nonatomic, weak) id <SignUpDelegate> mSignUpDelegate;

@property (nonatomic) IBOutlet UIButton* mPrivacyPolicyButton;
-(IBAction)privacyPolicyClicked:(id)sender;

@property (nonatomic) IBOutlet UIButton* mTermsButton;
-(IBAction)termsClicked:(id)sender;
@end
