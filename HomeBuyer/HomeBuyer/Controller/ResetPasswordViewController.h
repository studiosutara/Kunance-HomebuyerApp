//
//  ResetPasswordViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/22/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResetPasswordControllerDelegate <NSObject>
-(void) resetRequestSent;
@end

@interface ResetPasswordViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UITextField* mEmailField;
@property (nonatomic, strong) UIColor* mButtonColor;

@property (nonatomic, weak) id <ResetPasswordControllerDelegate> mResetPasswordDelegate;
@end
