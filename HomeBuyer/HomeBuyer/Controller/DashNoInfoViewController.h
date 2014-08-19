//
//  DashNoInfoViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutYouViewController.h"
#import <PKRevealController/PKRevealController.h>
#import "DashLeftMenuViewController.h"


@interface DashNoInfoViewController : DashLeftMenuViewController //<AboutYouControllerDelegate>
@property (nonatomic, strong) IBOutlet UIButton* mEnterProfileButton;
@property (nonatomic, strong) IBOutlet UIButton* mEnterProfileIcon;
-(IBAction)enterProfileIconTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton* mHelpButton;
-(IBAction)helpIconTapped:(id)sender;

@property (nonatomic, strong) AboutYouViewController* mAboutYouViewController;
@end
