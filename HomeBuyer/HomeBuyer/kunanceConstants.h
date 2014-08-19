//
//  kunanceConstants.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#ifndef HomeBuyer_kunanceConstants_h
#define HomeBuyer_kunanceConstants_h


//Used to find out if the screen size is 3.5" or 4" Retina display. For iPad it defaults to 3.5" view
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height == 568 ))

// Used for saving to NSUserDefaults that a PIN has been set, and is the unique identifier for the Keychain.
#define PIN_SAVED @"hasSavedPIN"

// Used for saving the user's name to NSUserDefaults.
#define USERNAME @"username"


#define FIRST_HOME 0
#define SECOND_HOME 1

#define MAX_NETWORK_CALL_TIMEOUT_IN_SECS 8

#define MIN_PASSWORD_LENGTH 6
// Used to specify the application used in accessing the Keychain.
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

// Used to help secure the PIN.
// Ideally, this is randomly generated, but to avoid the unnecessary complexity and overhead of storing the Salt separately, we will standardize on this key.
#define SALT_HASH @"HASH"

#define SHINOBI_LICENSE_KEY @"YOUR LICENSE HERE"

static NSString* const kDisplayMainDashNotification=@"DisplayMainDash";
static NSString* const kDisplayHomeDashNotification=@"DisplayHomeDash";
static NSString* const kReturnButtonClickedOnSignupForm=@"ReturnButtonOnSingnupFOrm";
static NSString* const kReturnButtonClickedOnSigninForm=@"ReturnButtonOnSigninFOrm";
static NSString* const kHomeButtonTappedFromDash=@"HomeButtonTappedFromDash";
static NSString* const kDisplayUserDash=@"ShowUserDash";


#define USE_PARSE 1

// Typedefs just to make it a little easier to read in code.
typedef enum {
    kAlertTypePIN = 0,
    kAlertTypeSetup
} AlertTypes;

typedef enum {
    kTextFieldPIN = 1,
    kTextFieldName,
    kTextFieldPassword
} TextFieldTypes;

typedef enum{
    ProfileStatusUndefined = 0,
    ProfileStatusUserPersonalFinanceInfoEntered,  //1
    ProfileStatusPersonalFinanceAndFixedCostsInfoEntered, //2
    ProfileStatusUser1HomeInfoEntered,  //3
    ProfileStatusUser1HomeAndLoanInfoEntered, //4
    ProfileStatusUserTwoHomesButNoLoanInfoEntered, //5
    ProfileStatusUserTwoHomesAndLoanInfoEntered, //6
}kunanceUserProfileStatus;
#endif
