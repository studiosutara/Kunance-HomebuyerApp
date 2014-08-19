//
//  FormViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashLeftMenuViewController.h"

@interface FormViewController : DashLeftMenuViewController <UITextFieldDelegate>
{
 
}

- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
- (void)dismissKeyboard;
-(void) setupNavControl;
-(void) deregisterForKeyboardNotifications;
-(void) registerForKeyboardNotifications;
-(void) startAPICallWithMessage:(NSString*) message;
-(void) cleanUpTimerAndAlert;

@property (nonatomic, strong) IBOutlet UIScrollView* mFormScrollView;
@property (nonatomic, strong) UITextField*  mActiveField;
@property (nonatomic, strong) NSArray*      mFormFields;
@property (nonatomic, strong) UIToolbar*    mKeyBoardToolbar;
@end
