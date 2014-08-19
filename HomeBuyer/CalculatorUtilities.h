//
//  CalculatorUtilities.h
//  calculator
//
//  Created by Shilpa Modi on 10/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorUtilities : NSObject
+(NSDictionary*) getDictionaryFromPlistFile:(NSString*) fileName;
+(NSArray*) getArrayFromPlistFile:(NSString *)fileName;
@end
