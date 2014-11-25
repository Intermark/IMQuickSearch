//
//  IMAnimal.m
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import "IMAnimal.h"

@implementation IMAnimal

+ (IMAnimal *)newAnimal {
    NSArray *names = @[@"Aligator",@"Bear",@"Cheetah",@"Snake",@"Zebra",@"Crocodile",@"Elephant",@"Tiger",@"Lion",@"Grasshoper",@"Buffalo",@"Eagle",@"Hawk",@"Ant",@"Rabbit",@"Dolphin",@"Iguana",@"Giraffe"];
    
    IMAnimal *newAnimal = [[IMAnimal alloc] init];
    newAnimal.name = names[arc4random()%names.count];
    
    return newAnimal;
}

+ (NSArray *)arrayOfAnimals:(int)count {
    NSMutableArray *animals = [NSMutableArray array];
    for (int x = 0; x < count; x++) {
        [animals addObject:[IMAnimal newAnimal]];
    }
    
    return animals;
}

@end
