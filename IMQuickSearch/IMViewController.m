//
//  IMViewController.m
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import "IMViewController.h"
#import "IMPerson.h"
#import "IMAnimal.h"

@interface IMViewController ()

@end

@implementation IMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self createPeople];
    [self createAnimals];
    [self setUpQuickSearch];
    [self testQuickSearchWithText:@"al"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set Up
- (void)createPeople {
    NSMutableArray *people = [NSMutableArray array];
    for (int x = 0; x < 100; x++) {
        [people addObject:[IMPerson newPerson]];
    }
    
    self.People = people;
}

- (void)createAnimals {
    NSMutableArray *animals = [NSMutableArray array];
    for (int x = 0; x < 50; x++) {
        [animals addObject:[IMAnimal newAnimal]];
    }
    
    self.Animals = animals;
}

- (void)setUpQuickSearch {
    // Create Filters
    IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:self.People keys:@[@"firstName",@"lastName"]];
    IMQuickSearchFilter *animalFilter = [IMQuickSearchFilter filterWithSearchArray:self.Animals keys:@[@"name"]];
    
    // Init IMQuickSearch with those Filters
    self.QuickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter,animalFilter]];
}


#pragma mark - Test Quick Search
- (void)testQuickSearchWithText:(NSString *)searchText {
    NSArray *filteredArray = [self.QuickSearch filteredObjectsWithValue:@(69)];
    NSLog(@"%@", filteredArray.count > 0 ? [filteredArray[0] firstName] : @"Hello");
}

@end
