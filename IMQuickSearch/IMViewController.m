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
    
    // Set up data
    self.People = [IMPerson arrayOfPeople:2000];
    self.Animals = [IMAnimal arrayOfAnimals:2000];
    [self setUpQuickSearch];
    
    // Set Up Filtered Array
    // nil value returns all results
    self.FilteredResults = [self.QuickSearch filteredObjectsWithValue:nil];
    [self filterResults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set Up the Quick Search
- (void)setUpQuickSearch {
    // Create Filters
    IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:self.People keys:@[@"firstName",@"lastName"]];
    IMQuickSearchFilter *animalFilter = [IMQuickSearchFilter filterWithSearchArray:self.Animals keys:@[@"name"]];
    
    // Init IMQuickSearch with those Filters
    self.QuickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter,animalFilter]];
}


#pragma mark - Filter the Quick Search
- (void)filterResults {
    // Asynchronously && BENCHMARK TEST
    NSLog(@"S");
    [self.QuickSearch asynchronouslyFilterObjectsWithValue:self.searchTextField.text completion:^(NSArray *filteredResults) {
        NSLog(@"E");
        [self updateTableViewWithNewResults:filteredResults];
    }];
    
    // Synchronously
    //[self updateTableViewWithNewResults:[self.QuickSearch filteredObjectsWithValue:self.searchTextField.text]];
}

- (void)updateTableViewWithNewResults:(NSArray *)results {
    self.FilteredResults = results;
    [self.searchTableView reloadData];
}



#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.FilteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellId"];
    }
    
    // Set Content
    id contentObject = self.FilteredResults[indexPath.row];
    NSString *title, *subtitle;
    if ([contentObject isKindOfClass:[IMPerson class]]) {
        title = [(IMPerson *)contentObject condensedName];
        subtitle = @"Person";
    }
    else {
        title = [(IMAnimal *)contentObject name];
        subtitle = @"Animal";
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    // Return Cell
    return cell;
}


#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self performSelector:@selector(filterResults) withObject:nil afterDelay:0.07];
    return YES;
}

@end
