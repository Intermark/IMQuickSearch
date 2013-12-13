//
//  IMQuickSearchTests.m
//  IMQuickSearchTests
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import <XCTest/XCTest.h>

// QuickSearch
#import "IMQuickSearch.h"

// Demo Objects
#import "IMAnimal.h"
#import "IMPerson.h"
#import "IMNumber.h"

@interface IMQuickSearchTests : XCTestCase

@property (nonatomic, retain) NSArray *People;
@property (nonatomic, retain) NSArray *Animals;
@property (nonatomic, retain) NSArray *Numbers;
@property (nonatomic, retain) IMQuickSearch *QuickSearch;

@end

@implementation IMQuickSearchTests


#pragma mark - Set Up
- (void)setUp
{
    [super setUp];
    self.People = [IMPerson arrayOfPeople:1000];
    self.Animals = [IMAnimal arrayOfAnimals:1000];
    self.Numbers = [IMNumber arrayOfNumbers:1000];
    [self setUpQuickSearch];
}

- (void)setUpQuickSearch {
    // Create Filters
    IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:self.People keys:@[@"firstName",@"lastName"]];
    IMQuickSearchFilter *animalFilter = [IMQuickSearchFilter filterWithSearchArray:self.Animals keys:@[@"name"]];
    IMQuickSearchFilter *numberFilter = [IMQuickSearchFilter filterWithSearchArray:self.Numbers keys:@[@"number"]];
    
    // Init IMQuickSearch with those Filters
    self.QuickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter,animalFilter,numberFilter]];
}


#pragma mark - Tear Down
- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - Auxiliary Methods
- (BOOL)checkStringProperty:(NSString *)prop withValue:(NSString *)value {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", value];
    return [predicate evaluateWithObject:prop];
}

- (BOOL)checkNumericalProperty:(NSNumber *)prop withValue:(NSNumber *)value {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", value];
    return [predicate evaluateWithObject:prop];
}


#pragma mark - Tests
- (void)testAllStringFilteredResultsAreValid {
    NSString *filterValue = @"al";
    NSArray *filteredResults = [self.QuickSearch filterWithValue:filterValue];
    for (id obj in filteredResults) {
        if ([obj isKindOfClass:[IMPerson class]]) {
            BOOL firstNameMatches = [self checkStringProperty:[(IMPerson *)obj firstName] withValue:filterValue];
            BOOL lastNameMatches = [self checkStringProperty:[(IMPerson *)obj lastName] withValue:filterValue];
            XCTAssert(firstNameMatches || lastNameMatches, @"%s Failed.", __PRETTY_FUNCTION__);
            XCTAssertFalse(!firstNameMatches && !lastNameMatches, @"%s Failed.", __PRETTY_FUNCTION__);
        }
        else if ([obj isKindOfClass:[IMNumber class]]) {
            XCTAssert(NO, @"%s Failed.", __PRETTY_FUNCTION__);
        }
        else {
            BOOL animalMatches = [self checkStringProperty:[(IMAnimal *)obj name] withValue:filterValue];
            XCTAssert(animalMatches, @"%s Failed.", __PRETTY_FUNCTION__);
            XCTAssertFalse(!animalMatches, @"%s Failed.", __PRETTY_FUNCTION__);
        }
    }
}

- (void)testNumericalFilterResultsAreValid {
    NSNumber *filterValue = @(6);
    NSArray *filteredResults = [self.QuickSearch filterWithValue:filterValue];
    for (id obj in filteredResults) {
        if ([obj isKindOfClass:[IMPerson class]]) {
            XCTAssert(NO, @"%s Failed.", __PRETTY_FUNCTION__);
        }
        else if ([obj isKindOfClass:[IMNumber class]]) {
            BOOL numberMatches = [self checkNumericalProperty:[(IMNumber *)obj number] withValue:filterValue];
            XCTAssert(numberMatches, @"%s Failed.", __PRETTY_FUNCTION__);
        }
        else {
            XCTAssert(NO, @"%s Failed.", __PRETTY_FUNCTION__);
        }
    }
}

- (void)testNumbersDontFilterStrings {
    NSArray *filteredResults = [self.QuickSearch filterWithValue:@(100009)];
    XCTAssertEqualObjects(@(filteredResults.count), @(0), @"%s Failed.", __PRETTY_FUNCTION__);
}

- (void)testBlankStringReturnsAllStringValues {
    NSArray *filteredResults = [self.QuickSearch filterWithValue:@""];
    XCTAssertEqualObjects(@(filteredResults.count), @(self.People.count + self.Animals.count), @"%s Failed.", __PRETTY_FUNCTION__);
}

- (void)testNilFilterReturnsAllArrayValues {
    NSArray *filteredResults = [self.QuickSearch filterWithValue:nil];
    XCTAssertEqualObjects(@(filteredResults.count), @(self.People.count + self.Animals.count + self.Numbers.count), @"%s Failed.", __PRETTY_FUNCTION__);
}

@end
