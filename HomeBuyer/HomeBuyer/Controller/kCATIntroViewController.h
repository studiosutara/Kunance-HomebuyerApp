//
//  kCATIntroViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"

@protocol kCATIntroViewDelegate <NSObject>
-(void) signInFromIntro;
-(void) signupFromIntro;
@end

@interface kCATIntroViewController : BasePageViewController <UIPageViewControllerDelegate>
@property (nonatomic, strong) UIButton* mSignInButton;
@property (nonatomic, strong) UIButton* mSignUpButton;
@property (nonatomic, strong) UIImageView* mBackground;

@property (nonatomic, weak) id <kCATIntroViewDelegate> mkCATIntroDelegate;
-(void)signInButtonTapped:(id)sender;
-(void)signUpButtonTapped:(id)sender;
@end
