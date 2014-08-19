//
//  homeInfo.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "homeAddress.h"
typedef enum
{
    homeTypeNotDefined = 0,
    homeTypeSingleFamily = 1,
    homeTypeCondominium = 2
}homeType;

@interface homeInfo : NSObject
@property (nonatomic) homeType          mHomeType;
@property (nonatomic, copy) NSString*   mIdentifiyingHomeFeature;
@property (nonatomic) UInt64            mHomeListPrice;
@property (nonatomic) uint              mHOAFees;
@property (nonatomic, strong) homeAddress*      mHomeAddress;
@property (nonatomic) uint              mHomeId;

-(NSDictionary*) getDictionaryHomeObjectFromHomeInfo;
-(id) initWithDictionary:(NSDictionary*) homeDict;

@end
