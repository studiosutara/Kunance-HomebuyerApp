//
//  TaxBlock.m
//  calculator
//
//  Created by Shilpa Modi on 10/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TaxBlock.h"

@implementation TaxBlock

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mUpperLimit = 0;
        self.mPercentage = 0;
    }
    
    return self;
}
@end
