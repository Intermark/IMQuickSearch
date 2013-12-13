//
//  IMPerson.h
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMPerson : NSObject

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;

+ (IMPerson *)newPerson;
+ (NSArray *)arrayOfPeople:(int)count;

@end
