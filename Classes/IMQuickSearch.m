//
//  IMQuickSearch.m
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

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
        [filteredSet addObjectsFromArray:[quickFilter filteredObjectsWithValue:value]];
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
