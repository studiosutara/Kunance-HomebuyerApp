//
//  FormNoScrollViewViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/18/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormNoScrollViewViewController : UIViewController<UITextFieldDelegate>
- (void)dismissKeyboard;

@property (nonatomic, strong) UITextField*  mActiveField;
@property (nonatomic, strong) NSArray*      mFormFields;
@property (nonatomic, strong) UIToolbar*    mKeyBoardToolbar;

@property (nonatomic) BOOL mShowDoneButton;

-(void) startAPICallWithMessage:(NSString*) message;
-(void) cleanUpTimerAndAlert;

@end
