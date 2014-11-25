//
//  IMNumber.m
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import "IMNumber.h"

@implementation IMNumber

+ (IMNumber *)newNumber {
    IMNumber *newNumber = [[IMNumber alloc] init];
    newNumber.number = @(arc4random()%10);
    
    return newNumber;
}

+ (NSArray *)arrayOfNumbers:(int)count {
    NSMutableArray *numbers = [NSMutableArray array];
    for (int x = 0; x < count; x++) {
        [numbers addObject:[IMNumber newNumber]];
    }
    
    return numbers;
}

@end
