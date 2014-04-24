//  The MIT License (MIT)
//
//  Copyright (c) 2014 Intermark Interactive
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "IMQuickSearchFilter.h"

@interface IMQuickSearchFilter()
@property (nonatomic, copy) NSSet *searchSet;
@property (nonatomic, copy) NSSet *lastSearchSet;
@property (nonatomic, copy) NSString *lastSearchValue;
@property (nonatomic, copy) NSArray *keys;
@end

@implementation IMQuickSearchFilter

#pragma mark - Create Filter
+ (IMQuickSearchFilter *)filterWithSearchArray:(NSArray *)searchArray keys:(NSArray *)keys {
    IMQuickSearchFilter *newFilter = [[IMQuickSearchFilter alloc] init];
    newFilter.searchSet = [NSSet setWithArray:searchArray];
    newFilter.keys = keys;
    
    return newFilter;
}

#pragma mark - Filter With Value
- (NSSet *)filteredObjectsWithValue:(id)value {
    // If no value, return all results
    if (!value) {
        return self.searchSet;
    }
    
    // Set Up
    NSMutableSet *filteredSet = [NSMutableSet new];
    BOOL shouldUseLastSearch = [value isKindOfClass:[NSString class]] && [self checkString:value withString:self.lastSearchValue];
    NSSet *newSearchSet = (self.lastSearchSet && shouldUseLastSearch) ? self.lastSearchSet : self.searchSet;
    
    // Filter for each key
    for (NSString *key in self.keys) {
        for (id obj in newSearchSet) {
            // Continue if it's there already
            if ([filteredSet containsObject:obj]) {
                continue;
            }
            
            // Compare values
            if ([self checkObject:obj withValue:value forKey:key]) {
                [filteredSet addObject:obj];
            }
        }
    }
    
    // Save
    self.lastSearchSet = filteredSet;
    self.lastSearchValue = value;
    
    // Return an array
    return filteredSet;
}

#pragma mark - Filtering Sub-Methods
- (BOOL)checkObject:(id)obj withValue:(id)value forKey:(NSString *)key {
    // Nil value returns the entire array
    if (!value) {
        return YES;
    }
    
    // The other 2 parameters must be here
    if (!obj || !key) {
        return NO;
    }
    
    // Make sure the object has a property for that key
    if (![obj respondsToSelector:NSSelectorFromString(key)]) {
        return NO;
    }
    
    // Make sure that property is filled
    if (![obj valueForKey:key]) {
        return NO;
    }
    
    // If it's an NSArray, loop through
    if ([[obj valueForKey:key] isKindOfClass:[NSArray class]]) {
        for (id arrObject in [obj valueForKey:key]) {
            if ([arrObject isKindOfClass:[NSString class]] || [value isKindOfClass:[NSString class]]) {
                if ([self checkString:arrObject withString:value]) {
                    return YES;
                }
            }
        }
        
        return NO;
    }
    
    // Check to make sure they are the same type
    if (![value isKindOfClass:[[obj valueForKey:key] class]] && ![[obj valueForKey:key] isKindOfClass:[value class]]) {
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
