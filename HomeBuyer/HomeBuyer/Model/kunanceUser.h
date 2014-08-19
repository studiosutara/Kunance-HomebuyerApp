//
//  kunanceUser.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/30/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userProfileInfo.h"
#import "UsersHomesList.h"
#import "usersLoansList.h"
#import "homeInfo.h"
#import "UsersHomesList.h"
#import <Parse/Parse.h>
#import "homeAndLoanInfo.h"
#import "Realtor.h"

@protocol kunanceUserDelegate <NSObject>
@optional
-(void) signupCompletedWithError:(NSError*) error;
-(void) loginCompletedWithError:(NSError*) error;
@end


@interface kunanceUser : NSObject<RealtorDelegate>
@property (nonatomic, strong) userProfileInfo* mkunanceUserProfileInfo;
@property (nonatomic, strong) UsersHomesList* mKunanceUserHomes;
@property (nonatomic, strong) usersLoansList* mKunanceUserLoans;
@property (nonatomic) kunanceUserProfileStatus mUserProfileStatus;
@property (nonatomic, weak) id <kunanceUserDelegate> mKunanceUserDelegate;
@property (nonatomic, strong, readonly) PFUser* mLoggedInKunanceUser;
@property (nonatomic, strong) Realtor* mRealtor;

-(BOOL) signupWithName:(NSString*) name
              password:(NSString*) password
                 email:(NSString*) email
           realtorCode:(NSString*) code;

-(BOOL) loginWithEmail:(NSString*) email
              password:(NSString*) password;


+ (kunanceUser*) getInstance;
-(BOOL) isUserLoggedIn;
-(BOOL) userAccountFoundOnDevice;
-(BOOL) loginSavedUser;

-(void) readRealtorInfo;
-(void) writeRealtorID;

-(void) updateStatusWithUserProfileInfo;
-(void) updateStatusWithHomeInfoStatus;

-(void) updateStatusWithLoanInfoStatus;
-(BOOL) hasUsableHomeAndLoanInfo;
-(void) logoutUser;
-(NSString*) getUserID;
-(NSString*) getFirstName;

+(homeAndLoanInfo*) getCalculatorHomeAndLoanFrom:(homeInfo*)aHome andLoan:(loan*)aLoan;
@end
