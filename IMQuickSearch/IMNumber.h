//
//  IMNumber.h
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMNumber : NSObject

@property (nonatomic, retain) NSNumber *number;

+ (IMNumber *)newNumber;
+ (NSArray *)arrayOfNumbers:(int)count;

@end
