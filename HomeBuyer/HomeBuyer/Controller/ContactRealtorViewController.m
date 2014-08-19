//
//  ContactRealtorViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/9/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "ContactRealtorViewController.h"

@interface ContactRealtorViewController ()

@end

@implementation ContactRealtorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showDashboardIcon = NO;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    Realtor* realtor = [kunanceUser getInstance].mRealtor;
    NSString* title = nil;
    
    if(realtor && realtor.mIsValid && realtor.mFirstName)
        title = [NSString stringWithFormat:@"Contact %@", realtor.mFirstName];
    else
        title = @"Contact Realtor";
    
    if(self.mContactRealtorDelegate)
        [self.mContactRealtorDelegate setNavTitle:title];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Realtor* realtor = [kunanceUser getInstance].mRealtor;
    
    if(!realtor.mIsValid)
        return;
    
    if(realtor.mFirstName)
        self.navigationItem.title = [NSString stringWithFormat:@"Contact %@", realtor.mFirstName];
    else
        self.navigationItem.title = @"Contact Realtor";
    
    self.mContactName.text = [NSString stringWithFormat:@"%@ %@", realtor.mFirstName, realtor.mLastName];
    
    self.mAddress.text = realtor.mAddress;
    self.mCompanyName.text = realtor.mCompanyName;
    
    if(realtor.mLargeLogo)
        self.mLogoImage.image = realtor.mLargeLogo;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Contact Realtor View Opened" properties:Nil];
    
    if(![kunanceUser getInstance].mRealtor.mPhoneNumber)
        self.mCallNumber.hidden = YES;
    
    if(![kunanceUser getInstance].mRealtor.mEmail)
        self.mEmail.hidden = YES;
    
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
        self.mCallNumber.enabled = NO;

    if(![MFMailComposeViewController canSendMail])
        self.mEmail.enabled = NO;

    if(![MFMessageComposeViewController canSendText])
        self.mTextNumber.enabled = NO;
    
    if(!self.showDashboardIcon)
        self.mDashboard.hidden = YES;
    else
        self.mDashboard.hidden = NO;
    
    if (!IS_WIDESCREEN)
    {
        self.mHome2DashContactRealtor.frame = CGRectMake(self.mHome2DashContactRealtor.frame.origin.x,90, self.mHome2DashContactRealtor.frame.size.width, self.mHome2DashContactRealtor.frame.size.height);
        self.mDashboard.frame = CGRectMake(14,422, self.mDashboard.frame.size.width, self.mDashboard.frame.size.height);
    }
}

-(IBAction)callRealtor:(id)sender
{
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Call Realtor Button Tapped" properties:Nil];

    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[kunanceUser getInstance].mRealtor.mPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(IBAction)emailRealtor:(id)sender
{
    Realtor* realtor = [kunanceUser getInstance].mRealtor;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Email Realtor Button Tapped" properties:Nil];

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[realtor.mEmail]];
        
        NSString* toName = nil;
        if(realtor.mFirstName)
            toName = realtor.mFirstName;
        else if(realtor.mCompanyName)
            toName = realtor.mCompanyName;
        
        NSString* hiString = nil;
        if(toName)
            hiString = [NSString stringWithFormat:@"Hi %@,\n\n", toName];

        [composeViewController setMessageBody:hiString isHTML:NO];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)textRealtor:(id)sender
{
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Text Realtor Button Tapped" properties:Nil];
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        NSArray* receipient = [[NSArray alloc] initWithObjects:[kunanceUser getInstance].mRealtor.mPhoneNumber, nil];
        
        controller.recipients = receipient;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)showDash:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
