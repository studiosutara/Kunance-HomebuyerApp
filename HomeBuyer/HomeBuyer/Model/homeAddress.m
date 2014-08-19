//
//  homeAddress.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "homeAddress.h"
#import "Cities.h"
#import "States.h"

static NSString* const kHomeAddressStreetAddressKey = @"HomeStreetAddress";
static NSString* const kHomeAddressCityKey = @"HomeAddressCity";
static NSString* const kHomeAddressStateKey = @"HomeAddressState";
static NSString* const kHomeAddressZipCodeKey = @"HomeAddressZipCode";
static NSString* const kHomeAddressLatitudeKey = @"HomeAddressLatitudeCode";
static NSString* const kHomeAddressLongitudeKey = @"HomeAddresslongitudeCode";

@implementation homeAddress

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mStreetAddress = nil;
        self.mCity = nil;
        self.mState = nil;
        self.mZipCode = nil;
        self.longitude = 0;
        self.latitude = 0;
    }
    
    return self;
}

-(id) initWithDictionary:(NSDictionary*) addressDict
{
    self = [super init];
    
    if(self)
    {
        if(!addressDict)
            return self;
        
        if(addressDict[kHomeAddressStreetAddressKey])
            self.mStreetAddress = addressDict[kHomeAddressStreetAddressKey];
        else
            self.mStreetAddress = nil;
        
        if(addressDict[kHomeAddressCityKey])
            self.mCity = addressDict[kHomeAddressCityKey];
        else
            self.mCity = nil;
        
        if(addressDict[kHomeAddressStateKey])
            self.mState = addressDict[kHomeAddressStateKey];
        else
            self.mState = nil;
        
        if(addressDict[kHomeAddressZipCodeKey])
            self.mZipCode = addressDict[kHomeAddressZipCodeKey];
        else
            self.mZipCode = nil;
        
        if(addressDict[kHomeAddressLatitudeKey])
            self.latitude = [addressDict[kHomeAddressLatitudeKey] doubleValue];
        else
            self.latitude = 0;
        
        if(addressDict[kHomeAddressLongitudeKey])
            self.longitude = [addressDict[kHomeAddressLongitudeKey] doubleValue];
        else
            self.longitude = 0;
    }
    
    return self;
}

-(NSString*) getPrintableHomeAddress
{
    if(self.mStreetAddress || self.mCity || self.mState || self.mZipCode)
    {
        NSMutableString* addressStr = [[NSMutableString alloc] init];

        if(self.mStreetAddress)
            [addressStr appendString:self.mStreetAddress];
        
        if(self.mCity)
        {
            if(addressStr.length > 0)
                [addressStr appendString:[NSString stringWithFormat:@", %@",self.mCity]];
            else
                [addressStr appendString:self.mCity];
        }
        
        if(self.mState)
        {
            if(addressStr.length > 0)
                [addressStr appendString:[NSString stringWithFormat:@", %@",self.mState]];
            else
                [addressStr appendString:self.mState];
        }

        if(self.mZipCode)
        {
            if(addressStr.length > 0)
                [addressStr appendString:[NSString stringWithFormat:@", %@",self.mZipCode]];
            else
                [addressStr appendString:self.mZipCode];
        }
    
        return addressStr;
    }
    else
        return nil;
}

-(NSDictionary*) getDictionaryForAddressObject
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    if(self.mStreetAddress)
        dict[kHomeAddressStreetAddressKey] = self.mStreetAddress;
    
    if(self.mCity)
        dict[kHomeAddressCityKey] = self.mCity;
    
    if(self.mState)
        dict[kHomeAddressStateKey] = self.mState;
    
    if(self.mZipCode)
        dict[kHomeAddressZipCodeKey] = self.mZipCode;
    
    dict[kHomeAddressLatitudeKey] = [NSString stringWithFormat:@"%f",self.latitude];
    dict[kHomeAddressLongitudeKey] =  [NSString stringWithFormat:@"%f",self.longitude];
    
    return dict;
}
@end
