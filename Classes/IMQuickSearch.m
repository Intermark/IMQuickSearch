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

#import "IMQuickSearch.h"

@implementation IMQuickSearch

#pragma mark - Init
- (instancetype)initWithFilters:(NSArray *)filters {
    // Fuzziness is not implemented due to speed considerations
    // This value does not matter at all.
    return [self initWithFilters:filters fuzziness:0.0];
}

- (instancetype)initWithFilters:(NSArray *)filters fuzziness:(float)fuzziness {
    if (self = [super init]) {
        self.masterArray = filters;
        self.fuzziness = fuzziness;
    }
    
    return self;
}


#pragma mark - Filter
- (NSArray *)filteredObjectsWithValue:(id)value {
    // Set Up Filter
    NSMutableSet *filteredSet = [NSMutableSet set];
    
    // Create copy of array to prevent mutability of filters mid-search
    NSArray *copyMasterArray = [self.masterArray copy];
    
    // Filter each object based on value
    for (IMQuickSearchFilter *quickFilter in copyMasterArray) {
        [filteredSet unionSet:[quickFilter filteredObjectsWithValue:value]];
    }
    
    // Return array from set
    return [filteredSet allObjects];
}

- (void)asynchronouslyFilterObjectsWithValue:(id)value completion:(void (^)(NSArray *filteredResults))completion {
    // Start another thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *filteredObjects = [self filteredObjectsWithValue:value];
        // Get Main Thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(filteredObjects);
        });
    });
}


#pragma mark - Filter Management
- (void)addFilter:(IMQuickSearchFilter *)filter {
    if (filter) {
        NSMutableArray *newMasterArray = [self.masterArray mutableCopy];
        [newMasterArray addObject:filter];
        self.masterArray = newMasterArray;
    }
}

- (void)removeFilter:(IMQuickSearchFilter *)filter {
    if (filter) {
        NSMutableArray *newMasterArray = [self.masterArray mutableCopy];
        [newMasterArray removeObject:filter];
        self.masterArray = newMasterArray;
    }
}

@end
