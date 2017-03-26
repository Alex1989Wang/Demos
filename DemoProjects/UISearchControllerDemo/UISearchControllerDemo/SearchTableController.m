//
//  SearchTableController.m
//  UISearchControllerDemo
//
//  Created by JiangWang on 15/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "SearchTableController.h"
#import "CustomSearchController.h"
#import "DemoSearchBar.h"

@interface SearchTableController ()
<UISearchResultsUpdating,
UISearchBarDelegate,
CustomSearchControllerDelegate>

@property (nonatomic, strong) NSArray<NSString *> *dataArray;
@property (nonatomic, strong) NSArray<NSString *> *filteredResults;
@property (nonatomic, assign) BOOL shouldShowSearchResults;

/* 搜索控制器 */
@property (nonatomic, strong) UISearchController *searchCon;
@property (nonatomic, strong) CustomSearchController *cusSearchCon;

@end

@implementation SearchTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载国家数据
    [self loadCountriesData];
    
    //配置搜索控制器
//    [self configureSearchController];
    
    [self configureCustomSearchController];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return (self.shouldShowSearchResults) ?
    self.filteredResults.count :
    self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"ShowCountryCell"
                                    forIndexPath:indexPath];
    
    cell.textLabel.text = (self.shouldShowSearchResults) ?
    self.filteredResults[indexPath.row] :
    self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
}

- (void)searchController:(CustomSearchController *)cusSearchCon
     didChangeSearchText:(NSString *)searchText
{
    NSString *searchTerm = cusSearchCon.customSearchBar.text;
  
    NSPredicate *filterPre = [NSPredicate predicateWithFormat:
                              @"SELF CONTAINS[c] %@", searchTerm];
    
    self.filteredResults = [self.dataArray filteredArrayUsingPredicate:filterPre];
    [self.tableView reloadData];
}

#pragma mark - UISearchBar
/*
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.shouldShowSearchResults = YES;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.shouldShowSearchResults = NO;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(!self.shouldShowSearchResults)
    {
        self.shouldShowSearchResults = YES;
        [self.tableView reloadData];
    }
    
    [self.searchCon.searchBar resignFirstResponder];
}
 */
- (void)searchControllerDidStartSearching:(CustomSearchController *)cusSearchCon
{
    self.shouldShowSearchResults = YES;
    [self.tableView reloadData];
}

- (void)searchControllerDidTapCancelBtn:(CustomSearchController *)cusSearchCon
{
    self.shouldShowSearchResults = NO;
    [cusSearchCon.customSearchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)searchControllerDidTapSearchBtn:(CustomSearchController *)cusSearchCon
{
    if (!self.shouldShowSearchResults)
    {
        self.shouldShowSearchResults = YES;
        [self.tableView reloadData];
    }
    [cusSearchCon.customSearchBar resignFirstResponder];
}



#pragma mark - Other Methods
- (void)loadCountriesData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countries"
                                                     ofType:@"txt"];
    NSString *allCountries = [NSString stringWithContentsOfFile:path
                                                       encoding:NSUTF8StringEncoding
                                                          error:NULL];
    self.dataArray = [allCountries componentsSeparatedByString:@"\n"];
    [self.tableView reloadData];
}

- (void)configureSearchController
{
    self.searchCon.searchResultsUpdater = self;
    self.searchCon.dimsBackgroundDuringPresentation = YES;
    
    self.searchCon.searchBar.placeholder = @"Search here ...";
    self.searchCon.searchBar.delegate = self;
    [self.searchCon.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchCon.searchBar;
}

- (void)configureCustomSearchController
{
    self.cusSearchCon.customSearchBar.placeholder = @"Search in this awesome bar...";
    self.tableView.tableHeaderView = self.cusSearchCon.customSearchBar;
}

#pragma mark - Lazy Loading 
- (UISearchController *)searchCon
{
    if (!_searchCon)
    {
        _searchCon =
        [[UISearchController alloc] initWithSearchResultsController:nil];
    }
    return _searchCon;
}

- (CustomSearchController *)cusSearchCon
{
    if (!_cusSearchCon)
    {
        CGSize tableSize = self.tableView.bounds.size;
        _cusSearchCon =
        [[CustomSearchController alloc]
         initWithSearchResultsController:nil
         searchBarFrame:CGRectMake(0, 0, tableSize.width, 50)
         searchBarFont:[UIFont fontWithName:@"Futura" size:16.f]
         searchBarTextColor:[UIColor orangeColor]
         searchBarTintColor:[UIColor blackColor]];
        _cusSearchCon.cusSearchConDelegate = self;
        
        }
    return _cusSearchCon;
}

@end
