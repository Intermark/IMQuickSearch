//
//  IMQuickSearchFilter.h
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMQuickSearchFilter : NSObject

#pragma mark - Properties
@property (nonatomic, retain) NSArray *searchArray;
@property (nonatomic, retain) NSArray *keys;


#pragma mark - Create Filter
/**
 Creates an IMQuickSearchFilter object from a given NSArray of objects and an NSArray of NSStrings that correspond to the keys/properties that you want to search over.
 @param searchArray - NSArray of NSObjects to search over
 @param keys        - NSArray of NSStrings that correspond to the properties of the searchArray objects that you want to focus on.
 @returns IMQuickSearchFilter
 */
+ (IMQuickSearchFilter *)filterWithSearchArray:(NSArray *)searchArray keys:(NSArray *)keys;


#pragma mark - Filter With Value
/**
 Filters the array for each key based on the input value parameter.
 @param value
 @returns NSArray
 */
- (NSArray *)filterWithValue:(id)value;

@end
