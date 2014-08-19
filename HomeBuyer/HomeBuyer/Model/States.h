//
//  States.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/21/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UNDEFINED_STATE_CODE 0
#define CALIFORNIA_STATE_CODE 1

@interface States : NSObject
+(uint) getStateCodeForStateName:(NSString*)stateName;
+(NSString*) getStateNameForStateCode:(uint)stateCode;
@end
