//
//  HomeInfoDashViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/11/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "HomeLifeStyleViewController.h"
#import "HomePaymentsViewController.h"
#import "HomeInfoEntryViewController.h"

@interface HomeInfoDashViewController : BasePageViewController <HomeLifeStyleDelegate, HomePaymentsDelegate>
@property (nonatomic, strong) UIButton* mHelpButton;
@property (nonatomic, strong) NSNumber* mHomeNumber;

@property (nonatomic, strong) UIButton* mDashButton;

-(id) initWithHomeNumber:(NSNumber*) homeNumber;

-(void) hideLeftView;
-(void)showLeftView;

@end
