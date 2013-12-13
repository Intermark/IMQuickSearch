//
//  IMPerson.m
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import "IMPerson.h"

@implementation IMPerson

+ (IMPerson *)newPerson {
    NSArray *firstNames = @[@"Bob",@"Alan",@"Nancy",@"Jennifer",@"Jessica",@"Jim",@"Pam",@"Abdul",@"Fred",@"Ben",@"Wallace",@"Nick",@"Gus",@"Robert",@"Alexandra",@"Timothy",@"Demetrius",@"Catherine",@"Kathy",@"Erica",@"Mary"];
    NSArray *lastNames = @[@"Clark",@"Stephens",@"Gordon",@"Peterson",@"Robertson",@"Frederickson",@"Smith",@"Davidson",@"Wood",@"Jackson",@"Sampson",@"Alberts",@"West",@"Breland",@"Richardson",@"Ingram",@"Upchurch",@"Upshaw"];
    
    IMPerson *newPerson = [[IMPerson alloc] init];
    newPerson.firstName = firstNames[arc4random()%firstNames.count];
    newPerson.lastName = lastNames[arc4random()%lastNames.count];
    
    return newPerson;
}

+ (NSArray *)arrayOfPeople:(int)count {
    NSMutableArray *people = [NSMutableArray array];
    for (int x = 0; x < count; x++) {
        [people addObject:[IMPerson newPerson]];
    }
    
    return people;
}

@end
