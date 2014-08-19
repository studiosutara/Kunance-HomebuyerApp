//
//  FormViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "FormViewController.h"

@interface FormViewController ()
@property (nonatomic, strong) UIBarButtonItem* mPrevButton;
@property (nonatomic, strong) UIBarButtonItem* mNextButton;
@property (nonatomic, strong) UIBarButtonItem* mDoneButton;

@property (nonatomic, strong) NSTimer* mUpdateDataTimeoutTimer;
@property (nonatomic, strong) UIAlertView* mSlowNetworkAlert;

@end

@implementation FormViewController

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mFormScrollView = nil;
        self.mFormFields = nil;
        self.mActiveField = nil;
        self.mUpdateDataTimeoutTimer = nil;
        self.mSlowNetworkAlert = nil;
    }
    
    return self;
}

-(void) startAPICallWithMessage:(NSString*) message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(message)
        hud.labelText = message;
    else
        hud.labelText = @"Updating";
    
    self.mUpdateDataTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:MAX_NETWORK_CALL_TIMEOUT_IN_SECS
                                                                       target:self
                                                                     selector:@selector(updateProfileCallTimedOut)
                                                                     userInfo:nil
                                                                      repeats:YES];
}

-(void) cleanUpTimerAndAlert
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.mUpdateDataTimeoutTimer invalidate];
    if(self.mSlowNetworkAlert)
    {
        [self.mSlowNetworkAlert dismissWithClickedButtonIndex:0 animated:NO];
        self.mSlowNetworkAlert = nil;
    }
}

-(void) updateProfileCallTimedOut
{
    if (!self.mSlowNetworkAlert)
    {
        self.mSlowNetworkAlert = [Utilities showSlowConnectionAlert];
        self.mSlowNetworkAlert.delegate = self;
    }
}

#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.mSlowNetworkAlert)
    {
        [self.mSlowNetworkAlert dismissWithClickedButtonIndex:0 animated:NO];
        self.mSlowNetworkAlert = nil;
    }
}
#pragma end


-(void) setupNavControl
{
    self.mKeyBoardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.mKeyBoardToolbar.barStyle = UIBarStyleDefault;
    self.mKeyBoardToolbar.backgroundColor = [UIColor lightGrayColor];
    
    self.mPrevButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(gotoPreviousTextField)];
    
    self.mNextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(gotoNextTextField)];

    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    
    self.mDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(dismissKeyboard)];

    self.mKeyBoardToolbar.items = [NSArray arrayWithObjects:
                                   self.mPrevButton,
                                   self.mNextButton,
                                   flexSpace,
                                   self.mDoneButton,
                                   nil];
    
    [self.mKeyBoardToolbar sizeToFit];
    
    uint tag = 0;
    for (UITextField* aField in self.mFormFields)
    {
        aField.delegate = self;
        aField.inputAccessoryView = self.mKeyBoardToolbar;
        aField.tag = tag++;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavControl];
	// Do any additional setup after loading the view.
    self.view.restorationIdentifier = @"restore";
    self.mFormScrollView.restorationIdentifier = @"restore";
}

-(void) viewDidAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self deregisterForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dismissKeyboard
{
    [self.mActiveField resignFirstResponder];
}

-(void) gotoNextTextField
{
    uint tag = self.mActiveField.tag;
    
    if((tag+1) < self.mFormFields.count)
    {
        UITextField* nextField = self.mFormFields[tag+1];
        if(nextField)
            [nextField becomeFirstResponder];
    }
    

}

-(void) gotoPreviousTextField
{
    uint tag = self.mActiveField.tag;
    if(tag > 0)
    {
        UITextField* prevField = self.mFormFields[tag-1];
        if(prevField)
            [prevField becomeFirstResponder];
    }
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self gotoNextTextField];
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.mActiveField = textField;
    
    if(textField.tag == 0)
    {
        self.mPrevButton.enabled = NO;
    }
    else
    {
        self.mPrevButton.enabled = YES;
    }
    
    if(textField.tag == (self.mFormFields.count -1) )
    {
        self.mNextButton.enabled = NO;
    }
    else
    {
        self.mNextButton.enabled = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.mActiveField = nil;
}

#pragma mark - Keyboard
-(void) deregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(20.0, 0.0, kbSize.height, 0.0);
    self.mFormScrollView.contentInset = contentInsets;
    self.mFormScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.mActiveField.frame.origin) )
    {
        [self.mFormScrollView scrollRectToVisible:self.mActiveField.frame animated:YES];
    }

    /*UIEdgeInsets contentInsets = UIEdgeInsetsMake(64.0, 0.0, kbSize.height, 0.0);
    self.mFormScrollView.contentInset = contentInsets;
//    self.mFormScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = self.mActiveField.frame.origin;
    origin.y -= self.mFormScrollView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.mActiveField.frame.origin.y-(aRect.size.height));
        [self.mFormScrollView setContentOffset:scrollPoint animated:YES];
    }*/
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mFormScrollView.contentInset = contentInsets;
    self.mFormScrollView.scrollIndicatorInsets = contentInsets;
}
@end
