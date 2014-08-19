//
//  HelpHomeViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 9/25/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpHomeViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIButton* mDashButton;
-(IBAction)dashButtonPressed:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton* mHelpButton;
-(IBAction)helpButtonTapped:(id)sender;
@end
