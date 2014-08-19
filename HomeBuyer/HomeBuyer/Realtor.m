//
//  Realtor.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 11/5/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "Realtor.h"
#import <Parse/Parse.h>

static NSString* const kRealtorClassKey=@"Realtor";
static NSString* const kRealtorIDKey = @"realtorID";

@interface Realtor()
@property (nonatomic, strong) PFObject* mRealtorParseObject;
@end

@implementation Realtor

-(id) init
{
    self = [super init];
    if(self)
    {
        self.mFirstName = Nil;
        self.mLastName = nil;
        self.mCompanyName= nil;
        self.mEmail= nil;
        self.mSmallLogo= nil;
        self.mLargeLogo= nil;
        self.mAddress= nil;
        self.mWebsite= nil;
        self.mPhoneNumber= nil;
        self.mRealtorID=nil;
        self.mIsValid = NO;
    }
    
    return self;
}
-(BOOL) getRealtorForID:(NSString*) realtorID
{
    if(!realtorID)
        return NO;
    
    PFQuery* query = [PFQuery queryWithClassName:kRealtorClassKey];
    [query whereKey:kRealtorIDKey equalTo:realtorID];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *realtorObject, NSError *error)
     {
         if(!error && realtorObject)
         {
             self.mRealtorParseObject = realtorObject;
             NSLog(@"Realtor: %@", self.mRealtorParseObject);
             self.mFirstName = self.mRealtorParseObject[@"FirstName"];
             self.mLastName = self.mRealtorParseObject[@"LastName"];
             self.mAddress = self.mRealtorParseObject[@"address"];
             self.mCompanyName = self.mRealtorParseObject[@"CompanyName"];
             self.mEmail = self.mRealtorParseObject[@"email"];
             self.mPhoneNumber = self.mRealtorParseObject[@"phoneNumber"];
             self.mRealtorID = self.mRealtorParseObject[@"realtorID"];
             self.mWebsite = self.mRealtorParseObject[@"website"];
             
             PFFile* smallLogo = self.mRealtorParseObject[@"logoSmall"];
             [smallLogo getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
             {
                 if (!error) {
                     self.mSmallLogo = [UIImage imageWithData:imageData];
                 }
             }];
             
             PFFile* largeLogo = self.mRealtorParseObject[@"logoLarge"];
             [largeLogo getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
              {
                  if (!error) {
                      self.mLargeLogo = [UIImage imageWithData:imageData];
                  }
              }];
             
             self.mIsValid = YES;
         }
         
         if(self.mRealtorDelegate &&
            [self.mRealtorDelegate respondsToSelector:@selector(finishedReadingRealtorInfo:)])
         {
             [self.mRealtorDelegate finishedReadingRealtorInfo:error];
         }
     }];

    
    return YES;
}
@end
