//
//  homeAddress.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeAddress : NSObject
@property (nonatomic, copy) NSString* mStreetAddress;
@property (nonatomic, copy) NSString* mCity;
@property (nonatomic, copy) NSString* mState;
@property (nonatomic, copy) NSString* mZipCode;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

-(NSString*) getPrintableHomeAddress;
-(id) initWithDictionary:(NSDictionary*) addressDict;
-(NSDictionary*) getDictionaryForAddressObject;
@end
