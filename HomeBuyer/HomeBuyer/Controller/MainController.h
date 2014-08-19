//
//  MainController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/27/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "DashNoInfoViewController.h"
#import "userProfileInfo.h"
#import "DashUserPFInfoViewController.h"
#import "DashOneHomeEnteredViewController.h"
#import "DashTwoHomesEnteredViewController.h"
#import "LeftMenuViewController.h"
#import "DashLeftMenuViewController.h"
#import "kCATIntroViewController.h"
#import "UsersHomesList.h"

@protocol MainControllerDelegate <NSObject>
-(void) resetRootView:(UIViewController*) viewController;
@end

@interface MainController : NSObject

<SignUpDelegate,
userProfileInfoDelegate,
LoginDelegate,
LeftMenuDelegate,
UsersHomesListDelegate,
usersLoansListDelegate,
FixedCostsControllerDelegate,
kCATIntroViewDelegate,
UIAlertViewDelegate,
RealtorDelegate
>

@property (nonatomic, strong) UINavigationController* mMainNavController;
@property (nonatomic, weak) id <MainControllerDelegate> mMainControllerDelegate;
@property (nonatomic, strong) SignUpViewController* mSignUpViewController;
@property (nonatomic, strong) LoginViewController* mLoginViewController;
@property (nonatomic, strong) UIViewController*    mMainDashController;
@property (nonatomic, strong) LeftMenuViewController* mLeftMenuViewController;
@property (nonatomic, strong) UINavigationController* mFrontViewController;

-(id) initWithNavController:(UINavigationController*) navController;
-(void) start;
@end
