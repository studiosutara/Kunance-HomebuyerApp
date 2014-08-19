//
//  HomeInfoViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeInfoEntryViewController.h"
#import "HelpHomeViewController.h"
#import "Cities.h"
#import "States.h"
#import <MBProgressHUD.h>

#define MAX_HOME_PRICE_LENGTH 10
#define MAX_HOA_PRICE_LENGTH 5
#define INVALID_LAT_LONG_INDICATOR -200

@interface HomeInfoEntryViewController ()
@property (nonatomic, copy) NSString* mHomeStreetAddress;
@property (nonatomic, copy) NSString* mHomeCity;
@property (nonatomic, copy) NSString* mHomeState;
@property (nonatomic, copy) NSString* mHomeZip;
@property (nonatomic) double mHomeLatitude;
@property (nonatomic) double mHomeLongitude;
@end

@implementation HomeInfoEntryViewController

- (id)initAsHomeNumber:(uint)homeNumber
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        self.mSelectedHomeType = homeTypeNotDefined;
        self.mHomeNumber = homeNumber;
        self.mLoanInfoController = nil;
        self.mHomeLatitude = INVALID_LAT_LONG_INDICATOR;
        self.mHomeLongitude = INVALID_LAT_LONG_INDICATOR;
    }

    return self;
}

-(void) addExistingHomeInfo
{
    self.mCorrespondingHomeInfo = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:self.mHomeNumber];
    if(self.mCorrespondingHomeInfo)
    {
        if(self.mCorrespondingHomeInfo.mHomeType == homeTypeSingleFamily)
            [self selectSingleFamilyHome];
        else if(self.mCorrespondingHomeInfo.mHomeType == homeTypeCondominium)
            [self selectCondominuim];
        
        if(self.mCorrespondingHomeInfo.mHomeListPrice)
            self.mAskingPriceField.text =
            [NSString stringWithFormat:@"%llu", self.mCorrespondingHomeInfo.mHomeListPrice];
        
        if(self.mCorrespondingHomeInfo.mIdentifiyingHomeFeature)
            self.mBestHomeFeatureField.text = self.mCorrespondingHomeInfo.mIdentifiyingHomeFeature;
        
        if(self.mCorrespondingHomeInfo.mHOAFees)
            self.mMontylyHOAField.text = [NSString stringWithFormat:@"%d", self.mCorrespondingHomeInfo.mHOAFees];
        
        if(self.mCorrespondingHomeInfo.mHomeAddress)
        {
            homeAddress* address = self.mCorrespondingHomeInfo.mHomeAddress;
            
            [Utilities emptyIfNil:address.mStreetAddress];
            [Utilities emptyIfNil:address.mCity];
            [Utilities emptyIfNil:address.mState];
            
            
            if(address.mState || address.mCity || address.mStreetAddress)
            {
                self.mHomeStreetAddress = address.mStreetAddress;
                self.mHomeCity = address.mCity;
                self.mHomeState = address.mState;
                self.mHomeZip = address.mZipCode;
                self.mHomeLongitude = address.longitude;
                self.mHomeLatitude = address.latitude;

                [self.mHomeAddressButton setTitle:[self getPrintableExistingAddress] forState:UIControlStateNormal];
            }
        }
    }
}

-(NSString*) getPrintableExistingAddress
{
    if(self.mHomeStreetAddress || self.mHomeCity || self.mHomeState)
    {
        NSMutableString* addressStr = [[NSMutableString alloc] init];

        if(self.mHomeStreetAddress)
            [addressStr appendString:self.mHomeStreetAddress];
        
        if(self.mHomeCity)
        {
            if(addressStr.length > 0)
                [addressStr appendString:[NSString stringWithFormat:@", %@",self.mHomeCity]];
            else
                [addressStr appendString:self.mHomeCity];
        }
        
        if(self.mHomeState)
        {
            if(addressStr.length > 0)
                [addressStr appendString:[NSString stringWithFormat:@", %@",self.mHomeState]];
            else
                [addressStr appendString:self.mHomeState];
        }

        return addressStr;

    }
    else
        return nil;
}

-(void) selectSingleFamilyHome
{
    [self.mSingleFamilyButton setImage:[UIImage imageNamed:@"sfh-homeinfo-selected.png"] forState:UIControlStateNormal];
    [self.mCondoButton setImage:[UIImage imageNamed:@"condo.png"] forState:UIControlStateNormal];
    
    self.mSelectedHomeType = homeTypeSingleFamily;
}

-(void) selectCondominuim
{
    [self.mSingleFamilyButton setImage:[UIImage imageNamed:@"sfh-homeinfo.png"] forState:UIControlStateNormal];
    [self.mCondoButton setImage:[UIImage imageNamed:@"condo-selected.png"] forState:UIControlStateNormal];;
    
    self.mSelectedHomeType = homeTypeCondominium;
}

-(void) setupGestureRecognizers
{
    [self.mFormScrollView setCanCancelContentTouches:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void) setupButtons
{
    if([[kunanceUser getInstance].mKunanceUserLoans getCurrentLoanCount])
    {
        self.mShowHomePayments.hidden = NO;
        self.mLoanInfoViewAsButton.hidden = YES;
    }
    else
    {
        self.mShowHomePayments.hidden = YES;
        self.mLoanInfoViewAsButton.hidden = NO;
    }
}

- (void)viewDidLoad
{
    self.mFormFields = [[NSArray alloc] initWithObjects:
    self.mBestHomeFeatureField,
    self.mAskingPriceField,
    self.mMontylyHOAField, nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupGestureRecognizers];
    
    [self setupButtons];
    [self addExistingHomeInfo];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.mFormScrollView setContentSize:CGSizeMake(320, 400)];

    self.mAskingPriceField.maxLength = MAX_HOME_PRICE_LENGTH;
    self.mMontylyHOAField.maxLength = MAX_HOA_PRICE_LENGTH;
    
   if(self.mHomeNumber == FIRST_HOME)
       self.navigationController.navigationBar.topItem.title = @"Enter First Home Info";
    else
        self.navigationController.navigationBar.topItem.title = @"Enter Second Home Info";
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Entered Dashboard Help Screen" properties:Nil];
    
    self.mHomeAddressButton.titleLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)viewDidAppear:(BOOL)animate
{
    [super viewDidAppear:animate];
    [self.mFormScrollView flashScrollIndicators];
}

-(void) uploadHomeInfo
{
    if(!self.mBestHomeFeatureField.text || self.mBestHomeFeatureField.text.length <= 0 ||
       [self.mAskingPriceField.amount floatValue]<= 0 ||
       (self.mSelectedHomeType == homeTypeNotDefined))
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all necessary fields"];
        return;
    }
    
    
    uint currentNumberOfHomes = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];
    
    
    homeInfo* aHomeInfo = nil;
    if(self.mCorrespondingHomeInfo)
        aHomeInfo = self.mCorrespondingHomeInfo;
    else
        aHomeInfo = [[homeInfo alloc] init];
    
    aHomeInfo.mHomeType = self.mSelectedHomeType;
    aHomeInfo.mIdentifiyingHomeFeature = self.mBestHomeFeatureField.text;
    aHomeInfo.mHomeListPrice = [self.mAskingPriceField.amount longValue];
    
    if(self.mMontylyHOAField.text)
        aHomeInfo.mHOAFees = [self.mMontylyHOAField.amount longValue];
    else if(self.mCorrespondingHomeInfo && self.mCorrespondingHomeInfo.mHOAFees)
        aHomeInfo.mHOAFees = self.mCorrespondingHomeInfo.mHOAFees;

    if(!aHomeInfo.mHomeAddress)
        aHomeInfo.mHomeAddress = [[homeAddress alloc] init];
    
    if(self.mHomeStreetAddress || self.mHomeState || self.mHomeCity || self.mHomeZip)
    {
        aHomeInfo.mHomeAddress.mStreetAddress = self.mHomeStreetAddress;
        aHomeInfo.mHomeAddress.mState = self.mHomeState;
        aHomeInfo.mHomeAddress.mCity = self.mHomeCity;
        aHomeInfo.mHomeAddress.mZipCode = self.mHomeZip;
        aHomeInfo.mHomeAddress.latitude = self.mHomeLatitude;
        aHomeInfo.mHomeAddress.longitude = self.mHomeLongitude;
    }
    
    if(![kunanceUser getInstance].mKunanceUserHomes)
        [kunanceUser getInstance].mKunanceUserHomes = [[UsersHomesList alloc] init];

    [kunanceUser getInstance].mKunanceUserHomes.mUsersHomesListDelegate = self;
    
    [self startAPICallWithMessage:@"Updating"];
    
    if(!self.mCorrespondingHomeInfo)
    {
        aHomeInfo.mHomeId = currentNumberOfHomes+1;
        
        if(![[kunanceUser getInstance].mKunanceUserHomes createNewHomeInfo:aHomeInfo])
        {
            [self cleanUpTimerAndAlert];
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to create home info"];
        }

        self.mCorrespondingHomeInfo = aHomeInfo;
    }
    else
    {
        if(![[kunanceUser getInstance].mKunanceUserHomes updateExistingHomeInfo:aHomeInfo])
        {
            [self cleanUpTimerAndAlert];
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update home info"];
        }
    }
}

#pragma mark actions gestures
-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(IBAction)showHomePaymentsButtonTapped:(id)sender
{
    [self uploadHomeInfo];
}

-(IBAction) enterHomeAddressButtonTapped
{
//    self.mHomeAddressView = [[HomeAddressViewController alloc] init];
//    self.mHomeAddressView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    self.mHomeAddressView.mHomeAddressViewDelegate = self;
//    if(self.mCorrespondingHomeInfo.mHomeAddress)
//    {
//        self.mHomeAddressView.mCorrespondingHomeInfo = self.mCorrespondingHomeInfo.mHomeAddress;
//    }

    self.googlePlacesViewController = [[SPGooglePlacesAutocompleteViewController alloc] init];
    {
        NSString* address = [NSString stringWithFormat:@"%@, %@, %@",
                             self.mHomeStreetAddress,
                             self.mHomeCity,
                             self.mHomeState];
        
        self.googlePlacesViewController.searchDisplayController.searchBar.text = address;
        self.googlePlacesViewController.existingAddress = [self getPrintableExistingAddress];

        if(self.mHomeLatitude != INVALID_LAT_LONG_INDICATOR)
            self.googlePlacesViewController.existingLatitude = self.mHomeLatitude;
        if(self.mHomeLongitude != INVALID_LAT_LONG_INDICATOR)
            self.googlePlacesViewController.existingLongitude = self.mHomeLongitude;
    }
    
    self.googlePlacesViewController.placemarkDelegate = self;
    [self.navigationController presentViewController:self.googlePlacesViewController animated:NO completion:nil];
}

-(IBAction)sfhButtonTapped:(id)sender
{
    [self selectSingleFamilyHome];
}

-(IBAction) condoButtonTapped:(id)sender
{
    [self selectCondominuim];
}

-(IBAction)loanInfoButtonTapped:(id)sender
{
    [self uploadHomeInfo];
}

-(IBAction)helpButtonTapped:(id)sender
{
    HelpHomeViewController* hPV = [[HelpHomeViewController alloc] init];
    [self.navigationController pushViewController:hPV animated:NO];
}
#pragma mark end

#pragma mark GooglePlacesDelegate
-(void) addressSelected:(CLPlacemark *)placemark
{
    NSMutableString* address = [[NSMutableString alloc] init];

    if(placemark)
    {
        NSLog(@"address: %@", placemark.addressDictionary);
        self.mHomeStreetAddress = placemark.addressDictionary[@"Street"];
        [Utilities emptyIfNil:self.mHomeStreetAddress];
        
        NSLog(@"Place coordinate: %f %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        NSLog(@"Regin: %@",placemark.region);
        self.mHomeCity = placemark.addressDictionary[@"City"];
        [Utilities emptyIfNil:self.mHomeCity];
        
        self.mHomeState = placemark.addressDictionary[@"State"];
        [Utilities emptyIfNil:self.mHomeState];
        
        self.mHomeZip = placemark.addressDictionary[@"ZIP"];
        [Utilities emptyIfNil:self.mHomeZip];
        
        if(self.mHomeStreetAddress)
            [address appendString:self.mHomeStreetAddress];
        
        if(self.mHomeCity)
        {
            if(address.length > 0)
                [address appendString:[NSString stringWithFormat:@", %@",self.mHomeCity]];
            else
                [address appendString:self.mHomeCity];
        }
        
        if(self.mHomeState)
        {
            if(address.length > 0)
                [address appendString:[NSString stringWithFormat:@", %@",self.mHomeState]];
            else
                [address appendString:self.mHomeState];
        }
        
        self.mHomeLongitude = placemark.location.coordinate.longitude;
        self.mHomeLatitude = placemark.location.coordinate.latitude;
        
        [self.mHomeAddressButton setTitle:address forState:UIControlStateNormal];
    }
    /*else if(self.googlePlacesViewController.searchDisplayController.searchBar.text.length > 0)
    {
        self.mHomeStreetAddress = self.googlePlacesViewController.searchDisplayController.searchBar.text;
        [address appendString:self.mHomeStreetAddress];
        [self.mHomeAddressButton setTitle:address forState:UIControlStateNormal];
    }*/
    
    [self.googlePlacesViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma end

#pragma mark HomeAddressViewDelegate
-(void) popHomeAddressFromHomeInfo
{
    if(self.mHomeAddressView.mStreetAddress.text && (self.mHomeAddressView.mStreetAddress.text.length > 0))
    {
        self.mHomeStreetAddress = self.mHomeAddressView.mStreetAddress.text;
    }
    
    if(self.mHomeAddressView.mCity.text && (self.mHomeAddressView.mCity.text.length > 0))
    {
        self.mHomeCity = [self.mHomeAddressView.mCity.text uppercaseString];
    }

    if(self.mHomeAddressView.mState.text && (self.mHomeAddressView.mState.text.length > 0))
    {
        self.mHomeState = self.mHomeAddressView.mState.text;
    }
    

    [self.mHomeAddressView dismissViewControllerAnimated:YES completion:nil];
}
#pragma end

#pragma mark APIHomeInfoServiceDelegate
-(void) finishedWritingHomeInfo
{
    [self cleanUpTimerAndAlert];

    [[kunanceUser getInstance] updateStatusWithHomeInfoStatus];
    if(!self.mLoanInfoViewAsButton.hidden)
    {
        if(!self.mLoanInfoController)
            self.mLoanInfoController = [[LoanInfoViewController alloc]
                                        initFromHomeInfoEntry:[NSNumber numberWithInt:self.mHomeNumber]];
        self.mLoanInfoController.mLoanInfoViewDelegate = self;
        
        [self.navigationController pushViewController:self.mLoanInfoController animated:NO];
    }
    else if(!self.mHomeAddressButton.hidden)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayHomeDashNotification object:[NSNumber numberWithInt:self.mHomeNumber]];
    }
}
#pragma end

#pragma mark LoanInfoDelegate
-(void) backToHomeInfo
{
    if(self.mLoanInfoController)
        [self.navigationController popViewControllerAnimated:NO];
}

#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
