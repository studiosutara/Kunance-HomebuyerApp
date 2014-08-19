//
//  CalculatorUtilities.m
//  calculator
//
//  Created by Shilpa Modi on 10/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "CalculatorUtilities.h"

@implementation CalculatorUtilities

+(NSDictionary*) getDictionaryFromPlistFile:(NSString *)fileName
{
    if(!fileName)
        return nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}

+(NSArray*) getArrayFromPlistFile:(NSString *)fileName
{
    if(!fileName)
        return nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    return [[NSArray alloc] initWithContentsOfFile:path];
}

@end
