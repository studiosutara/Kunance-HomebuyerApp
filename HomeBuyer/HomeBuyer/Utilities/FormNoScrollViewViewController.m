//
//  FormNoScrollViewViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/18/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "FormNoScrollViewViewController.h"

@interface FormNoScrollViewViewController ()
@property (nonatomic, strong) UIBarButtonItem* mPrevButton;
@property (nonatomic, strong) UIBarButtonItem* mNextButton;
@property (nonatomic, strong) UIBarButtonItem* mDoneButton;

@property (nonatomic, strong) NSTimer* mUpdateDataTimeoutTimer;
@property (nonatomic, strong) UIAlertView* mSlowNetworkAlert;

@end

@implementation FormNoScrollViewViewController

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mFormFields = nil;
        self.mActiveField = nil;
        self.mShowDoneButton = NO;
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
    
    if(self.mShowDoneButton)
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
    if(textField.tag == self.mFormFields.count-1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReturnButtonClickedOnSignupForm object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReturnButtonClickedOnSigninForm object:nil];
    }
    else
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

@end
