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
// No Fuzziness for Now
/*
- (instancetype)initWithFilters:(NSArray *)filters fuzziness:(float)fuzziness;
 */


#pragma mark - Filter Management
/**
 Adds a new IMQuickSearchFilter to search with.
 @param filter  - IMQuickSearchFilter
 */
- (void)addFilter:(IMQuickSearchFilter *)filter;

/**
 Removes a given filter.
 @param filter  - IMQuickSearchFilter
 */
- (void)removeFilter:(IMQuickSearchFilter *)filter;


#pragma mark - Filter
/**
 Filters all of the IMQuickSearchFilter objects with a given value. Each item in the array is unique.
 @param value   - A value to filter over
 @returns NSArray
 */
- (NSArray *)filteredObjectsWithValue:(id)value;

/**
 Filters all of the IMQuickSearchFilter objects with a given value asynchronously, and uses the completion block callback to present the items when finished. Each item in the array is unique.
 @param value   - A value to filter over
 @returns NSArray
 */
- (void)asynchronouslyFilterObjectsWithValue:(id)value completion:(void (^)(NSArray *filteredResults))completion;


@end
