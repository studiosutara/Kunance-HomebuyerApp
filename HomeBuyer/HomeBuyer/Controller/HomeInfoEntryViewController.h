//
//  HomeInfoViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"
#import "homeInfo.h"
#import "LoanInfoViewController.h"
#import "HomeAddressViewController.h"
#import "UsersHomesList.h"
#import <TSCurrencyTextField.h>
#import "SPGooglePlacesAutocompleteViewController.h"

@interface HomeInfoEntryViewController : FormViewController
<UsersHomesListDelegate, LoanInfoViewDelegate, HomeAddressViewDelegate, GooglePlacesDelegate>
@property (nonatomic) homeType      mSelectedHomeType;
@property (nonatomic) uint mHomeNumber;
@property (nonatomic, strong) homeInfo*  mCorrespondingHomeInfo;
@property (nonatomic, strong) LoanInfoViewController* mLoanInfoController;
@property (nonatomic, strong) HomeAddressViewController* mHomeAddressView;
@property (nonatomic, strong) SPGooglePlacesAutocompleteViewController* googlePlacesViewController;
-(id) initAsHomeNumber:(uint) homeNumber;

@property (nonatomic, strong) IBOutlet UIButton*  mSingleFamilyButton;
-(IBAction)sfhButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*  mCondoButton;
-(IBAction) condoButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UITextField*   mBestHomeFeatureField;
@property (nonatomic, strong) IBOutlet TSCurrencyTextField*   mAskingPriceField;
@property (nonatomic, strong) IBOutlet TSCurrencyTextField*   mMontylyHOAField;

@property (nonatomic, strong) IBOutlet UIButton*       mHomeAddressButton;
-(IBAction) enterHomeAddressButtonTapped;

@property (nonatomic, strong) IBOutlet UIButton*       mLoanInfoViewAsButton;
-(IBAction)loanInfoButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*       mShowHomePayments;
-(IBAction)showHomePaymentsButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*       mDashboardIcon;
-(IBAction)dashButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*       mHelpButton;
-(IBAction)helpButtonTapped:(id)sender;
@end
