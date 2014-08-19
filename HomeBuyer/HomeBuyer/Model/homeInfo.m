//
//  homeInfo.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "homeInfo.h"

static NSString* const kHomeTypeKey = @"HomeType";
static NSString* const kIdentifyingFeatureKey = @"IdentifiyingHomeFeature";
static NSString* const kHomeListProceKey = @"HomeListPrice";
static NSString* const kHOAFeesKey = @"HOAFees";
static NSString* const kHomeAddressKey = @"HomeAddress";
static NSString* const kHomeIDKey = @"mHomeId";

@implementation homeInfo

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mHomeType = 0;
        self.mIdentifiyingHomeFeature = nil;
        self.mHOAFees = 0;
        self.mHomeAddress = nil;
        self.mHomeListPrice = 0;
        self.mIdentifiyingHomeFeature = nil;
        self.mHomeId = 0;
    }
    
    return self;
}

-(NSDictionary*) getDictionaryHomeObjectFromHomeInfo
{
    NSMutableDictionary* parseHomeInfo = [[NSMutableDictionary alloc] init];
    
    parseHomeInfo[kHomeTypeKey] = [NSNumber numberWithInt:self.mHomeType];
    parseHomeInfo[kIdentifyingFeatureKey] = self.mIdentifiyingHomeFeature;
    parseHomeInfo[kHomeListProceKey] = [NSNumber numberWithLong:self.mHomeListPrice];
    parseHomeInfo[kHOAFeesKey] = [NSNumber numberWithLong:self.mHOAFees];
    parseHomeInfo[kHomeAddressKey] = [self.mHomeAddress getDictionaryForAddressObject];
    parseHomeInfo[kHomeIDKey] = [NSNumber numberWithInteger:self.mHomeId];
    
    return parseHomeInfo;
}

-(id) initWithDictionary:(NSDictionary*) homeDict
{
    self = [super init];

    if(self)
    {
        if(!homeDict)
            return self;
    
        if(homeDict[kHomeTypeKey])
            self.mHomeType = [homeDict[kHomeTypeKey] integerValue];
        if(homeDict[kIdentifyingFeatureKey])
            self.mIdentifiyingHomeFeature = homeDict[kIdentifyingFeatureKey];
        if(homeDict[kHomeListProceKey])
            self.mHomeListPrice = [homeDict[kHomeListProceKey] longValue];
        if(homeDict[kHOAFeesKey])
            self.mHOAFees = [homeDict[kHOAFeesKey] longValue];
        if(homeDict[kHomeIDKey])
            self.mHomeId = [homeDict[kHomeIDKey] integerValue];
        if(homeDict[kHomeAddressKey])
            self.mHomeAddress = [[homeAddress alloc] initWithDictionary:homeDict[kHomeAddressKey]];
    }
    
    return self;
}

@end
