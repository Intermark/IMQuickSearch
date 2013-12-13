//
//  IMQuickSearchFilter.m
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import "IMQuickSearchFilter.h"

@implementation IMQuickSearchFilter

#pragma mark - Create Filter
+ (IMQuickSearchFilter *)filterWithSearchArray:(NSArray *)searchArray keys:(NSArray *)keys {
    IMQuickSearchFilter *newFilter = [[IMQuickSearchFilter alloc] init];
    newFilter.searchArray = searchArray;
    newFilter.keys = keys;
    
    return newFilter;
}

#pragma mark - Filter With Value
- (NSArray *)filterWithValue:(id)value {
    // If no value, return all results
    if (!value) {
        return self.searchArray;
    }
    
    // Set Up
    NSMutableSet *filteredSet = [NSMutableSet set];
    
    // Filter for each key
    for (NSString *key in self.keys) {
        for (id obj in self.searchArray) {
            // Continue if it's there already
            if ([filteredSet containsObject:obj]) {
                continue;
            }
            
            // Compare Values
            if ([self checkObject:obj withValue:value forKey:key]) {
                [filteredSet addObject:obj];
            }
        }
    }
    
    // Return an array
    return [filteredSet allObjects];
}


#pragma mark - Filtering Sub-Methods
- (BOOL)checkObject:(id)obj withValue:(id)value forKey:(NSString *)key {
    // If no value, add the object, because it's like returning the enire list
    if (!value) {
        return YES;
    }
    
    // The other 2 parameters must be here
    if (!obj || !key) {
        return NO;
    }
    
    // An object must have a property for the key
    if (![obj valueForKey:key]) {
        return NO;
    }
    
    // Check to make sure they are the same type
    if (![[obj valueForKey:key] isKindOfClass:[value class]]) {
        return NO;
    }
    
    // If it's an NSString, check a case-insensitive compare
    if ([[obj valueForKey:key] isKindOfClass:[NSString class]]) {
        return [self checkString:[obj valueForKey:key] withString:value];
    }
    
    // Finally check if they are equal if it is not an NSString
    return [[obj valueForKey:key] isEqual:value];
}

- (BOOL)checkString:(NSString *)mainString withString:(NSString *)searchString {
    // All strings contain a @"" string, so return YES
    if (searchString.length == 0) {
        return YES;
    }
    
    // Evaluate with searchString
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchString];
    return [predicate evaluateWithObject:mainString];
}

@end
