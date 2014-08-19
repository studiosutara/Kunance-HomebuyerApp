//
//  States.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/21/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "States.h"

@implementation States
+(uint) getStateCodeForStateName:(NSString*)stateName
{
    if([stateName isEqualToString:@"California"])
        return CALIFORNIA_STATE_CODE;
    else
        return UNDEFINED_STATE_CODE;
}

+(NSString*) getStateNameForStateCode:(uint)stateCode
{
    if(stateCode == CALIFORNIA_STATE_CODE)
        return @"California";
    else return @"Other";
}
@end
