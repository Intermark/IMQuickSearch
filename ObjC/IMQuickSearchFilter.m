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
@property (nonatomic, copy) NSDictionary *alternativeSearchValues;
@end

@implementation IMQuickSearchFilter

#pragma mark - Create Filter
+ (IMQuickSearchFilter *)filterWithSearchArray:(NSArray *)searchArray keys:(NSArray *)keys {
    return [self filterWithSearchArray:searchArray keys:keys alternativeValues:nil];
}

+ (IMQuickSearchFilter *)filterWithSearchArray:(NSArray *)searchArray keys:(NSArray *)keys alternativeValues:(NSDictionary *)alternativeValues {
    IMQuickSearchFilter *newFilter = [[IMQuickSearchFilter alloc] init];
    newFilter.searchSet = [NSSet setWithArray:searchArray];
    newFilter.keys = keys;
    newFilter.alternativeSearchValues = alternativeValues;

    return newFilter;
}

#pragma mark - Filter With Value
- (NSSet *)filteredObjectsWithValue:(id)value {
    // If no value, return all results
    if (!value) {
        return self.searchSet;
    }

    // If value is a string and length == 0, return all results
    if ([value isKindOfClass:[NSString class]] && [(NSString *)value length] == 0) {
        return self.searchSet;
    }

    // Set Up
    BOOL shouldUseLastSearch = [value isKindOfClass:[NSString class]] && [self checkString:value withString:self.lastSearchValue];
    BOOL hasAlternativeSearchValues = self.alternativeSearchValues != nil && [self.alternativeSearchValues count] > 0;
    NSSet *newSearchSet = (self.lastSearchSet && shouldUseLastSearch && !hasAlternativeSearchValues) ? self.lastSearchSet : self.searchSet;

    // Create Predicate
    NSPredicate *predicate = [self predicateForKeys:self.keys value:value];
    NSSet *filteredSet = [newSearchSet filteredSetUsingPredicate:predicate];

    // Save
    self.lastSearchSet = filteredSet;
    self.lastSearchValue = value;

    // Return an array
    return filteredSet;
}

#pragma mark - Build Predicate
- (NSPredicate *)predicateForKeys:(NSArray *)keys value:(id)value {
    // No keys, no value, return nil
    if (!keys || !value) return nil;

    // Build Predicates
    NSMutableArray *predicates = [NSMutableArray array];
    for (NSString *key in keys) {
        // Next if key is not a string
        if (![key isKindOfClass:[NSString class]]) continue;
        // Create predicate
        NSPredicate *existsPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject respondsToSelector:NSSelectorFromString(key)];
        }];
        NSMutableArray *containsPredicateList = [@[[value isKindOfClass:[NSString class]] ?
                                                   [NSPredicate predicateWithFormat:@"(%K.description CONTAINS[cd] %@)", key, value] :
                                                   [NSPredicate predicateWithFormat:@"(%K.description == %@)", key, value]] mutableCopy];
                                                   //Check for alternative search values
                                                   if([value isKindOfClass:[NSString class]] && self.alternativeSearchValues != nil && [self.alternativeSearchValues count] > 0) {
                                                       for(NSString *altKeyValue in self.alternativeSearchValues) {
                                                           NSArray *alternativeValues = [self.alternativeSearchValues objectForKey:altKeyValue];
                                                           for (NSString *alternativeValue in alternativeValues) {
                                                               NSError *error = nil;
                                                               NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:value options:NSRegularExpressionCaseInsensitive error:&error];

                                                               NSString *tempSearchValue = @"";

                                                               if (error == nil) {
                                                                   NSString *tempSearchValue = [regex stringByReplacingMatchesInString:[value lowercaseString]options:0 range:NSMakeRange(0, [value length]) withTemplate:altKeyValue];
                                                               }

                                                               [containsPredicateList addObject:[NSPredicate predicateWithFormat:@"(%K.description CONTAINS[cd] %@)", key, tempSearchValue]];
                                                           }
                                                       }
                                                   }
                                                   //
        //
        NSCompoundPredicate *containsCompoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:containsPredicateList];
        //Add preidcates to compound predicate
        [predicates addObject:[NSCompoundPredicate andPredicateWithSubpredicates:@[existsPredicate, containsCompoundPredicate]]];
    }

    return [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
}

#pragma mark - Check if Substring
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
