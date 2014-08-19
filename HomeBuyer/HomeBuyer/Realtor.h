//
//  Realtor.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 11/5/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RealtorDelegate <NSObject>
@optional
-(void) finishedReadingRealtorInfo:(NSError*) error;
@end

@interface Realtor : NSObject
@property (nonatomic, copy) NSString* mFirstName;
@property (nonatomic, copy) NSString* mLastName;
@property (nonatomic, copy) NSString* mCompanyName;
@property (nonatomic, copy) NSString* mEmail;
@property (nonatomic, strong) UIImage*mSmallLogo;
@property (nonatomic, strong) UIImage*mLargeLogo;
@property (nonatomic, copy) NSString* mAddress;
@property (nonatomic, copy) NSString* mWebsite;
@property (nonatomic, copy) NSString* mPhoneNumber;
@property (nonatomic, copy) NSString* mRealtorID;
@property (nonatomic) BOOL mIsValid;

-(BOOL) getRealtorForID:(NSString*) realtorID;

@property (nonatomic, weak) id <RealtorDelegate> mRealtorDelegate;
@end
