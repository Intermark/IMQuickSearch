//
//  IMViewController.h
//  IMQuickSearch
//
//  Created by Ben Gordon on 12/13/13.
//  Copyright (c) 2013 Intermark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMQuickSearch.h"

@interface IMViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IMQuickSearch *QuickSearch;
@property (nonatomic, strong) NSArray *People;
@property (nonatomic, strong) NSArray *Animals;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) NSArray *FilteredResults;

@end
