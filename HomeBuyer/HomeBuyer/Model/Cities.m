//
//  Cities.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/21/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "Cities.h"

@interface Cities()
@property (nonatomic, strong) NSMutableDictionary* mCities;
@property (nonatomic) uint mStateCode;
@end

@implementation Cities

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mCities = nil;
        self.mStateCode = UNDEFINED_STATE_CODE;
    }
    
    return self;
}

-(id) initForState:(uint) stateCode
{
    self = [super init];
    
    if(self)
    {
        NSString* cityPath = [NSString stringWithFormat:@"Cities_%d", stateCode];
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          cityPath ofType:@"plist"];
        self.mCities = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        for (NSString* key in [self.mCities allKeys])
        {
            NSString* cityName = self.mCities[key];
            if(cityName)
                [self.mCities setValue: [cityName uppercaseString] forKey:key];
        }
    }
    
    return self;
}

-(uint) getCityCodeForCityName:(NSString*) cityName
{
    NSArray* citiesKeys = [self.mCities allKeysForObject:[cityName uppercaseString]];
    if(citiesKeys && citiesKeys.count > 0)
    {
        NSString* cityKey = (NSString*) citiesKeys[0];
        if(cityKey)
            return [cityKey intValue];;
    }
    
    return OTHER_CITY_CODE;
}

-(NSString*) getCityNameForCityCode:(uint) cityCode
{
    return self.mCities[[NSString stringWithFormat:@"%d", cityCode]];
}

@end
