//
//  IMAnimal.h
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMAnimal : NSObject

@property (nonatomic, retain) NSString *name;

+ (IMAnimal *)newAnimal;
+ (NSArray *)arrayOfAnimals:(int)count;

@end
