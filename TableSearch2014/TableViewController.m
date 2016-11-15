//
//  TableViewController.m
//  TableSearch2014
//
//  Created by Jay Versluis on 02/04/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *allData;
@property (nonatomic, strong) NSArray *searchResults;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)showSearchBar:(id)sender;

@end

@implementation TableViewController

- (NSArray *)allData
{
    if (!_allData) {
        _allData = @[@"One", @"Two", @"Three", @"Four", @"Five",
                     @"Six", @"Seven", @"Eight", @"Nine", @"Ten"];
    }
    return _allData;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // scroll the search bar off-screen
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableView)
    {
        return self.allData.count;
    }
    else
    {
        return self.searchResults.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // Configure the cell...
    if (tableView == self.tableView)
    {
        cell.textLabel.text = [self.allData objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    self.title = title;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Search Methods

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    self.searchResults = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", self.searchBar.text];
    self.searchResults = [self.allData filteredArrayUsingPredicate:predicate];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        [self viewWillAppear:YES];
    }
}

- (IBAction)showSearchBar:(id)sender {
    
    [self.searchDisplayController setActive:YES animated:YES];
}



@end
