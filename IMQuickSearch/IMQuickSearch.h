//
//  IMQuickSearch.h
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMQuickSearchFilter.h"

@interface IMQuickSearch : NSObject

#pragma mark - Properties
@property (nonatomic, assign) float fuzziness;
@property (nonatomic, retain) NSArray *masterArray;

#pragma mark - Init
/**
 Initializes a new IMQuickSearchObject with an NSArray of IMQuickSearchFilter objects and a default fuzziness set to 0.
 @param filters - NSArray of IMQuickSearchFilter objects
 @returns IMQuickSearch
 */
- (instancetype)initWithFilters:(NSArray *)filters;

/**
 Initializes a new IMQuickSearchObject with an NSArray of IMQuickSearchFilter objects and a fuzziness value.
 @param filters - NSArray of IMQuickSearchFilter objects
 @param fuzziness - float between 0 and 1, where 0 is a direct match, and 1 gives more leeway
 @returns IMQuickSearch
 */
- (instancetype)initWithFilters:(NSArray *)filters fuzziness:(float)fuzziness;


#pragma mark - Filter
/**
 Filters all of the IMQuickSearchFilter objects with a given value. Each item in the array is unique.
 @param value   - A value to filter over
 @returns NSArray
 */
- (NSArray *)filteredObjectsWithValue:(id)value;

@end
