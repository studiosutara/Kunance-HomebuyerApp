//
//  Cities.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/21/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "States.h"

#define OTHER_CITY_CODE 0

@interface Cities : NSObject
-(id) initForState:(uint) stateCode;

-(uint) getCityCodeForCityName:(NSString*) cityName;
-(NSString*) getCityNameForCityCode:(uint)cityCode;
@end
