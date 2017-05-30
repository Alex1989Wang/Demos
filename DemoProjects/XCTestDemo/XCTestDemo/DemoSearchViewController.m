//
//  DemoSearchViewController.m
//  XCTestDemo
//
//  Created by JiangWang on 28/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoSearchViewController.h"
#import "DemoSearchManager.h"
#import "DemoUser.h"

@interface DemoSearchViewController ()
<UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITableView *resultsTable;
@property (nonatomic, strong) NSMutableArray <DemoUser *> *users;
@end

static NSString *resultCellID = @"XCTestDemo.searchResultCellID";
static const CGFloat SearchBarHeight = 44.f;
@implementation DemoSearchViewController

#pragma mark - Initialization 
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewController];
    
    [self setupViewHierachy];
}

- (void)configureViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Search Github Users";
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupViewHierachy {
    [self searchBar]; //set up search bar;
    [self resultsTable]; //set up search table;
}


#pragma mark - Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoUser *user = self.users[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:resultCellID];
        cell.textLabel.text = user.userName;
        cell.detailTextLabel.text = user.userLocation;
    }
    else {
        cell.textLabel.text = user.userName;
        cell.detailTextLabel.text = user.userLocation;
    }
    return cell;
}

//did click the search 
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSCharacterSet *blankSets = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *searchText = [searchBar.text stringByTrimmingCharactersInSet:blankSets];
    if (searchText.length) {
        __weak typeof(self) weakSelf = self;
        [[DemoSearchManager sharedManager] getUserInfoWithUserName:searchText
                                                         completed:
         ^(NSData *userInfoData) {
             NSLog(@"user info dictionary: %@", userInfoData);
             __strong typeof(weakSelf) strSelf = weakSelf;
             DemoUser *user = [[DemoUser alloc] initWithUserInfoData:userInfoData];
             if (user) {
                 [strSelf.users addObject:user];
                 [strSelf.resultsTable reloadData];
             }
         }];
    }
}

#pragma mark - Lazy Loading
- (UISearchBar *)searchBar {
    if (nil == _searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        _searchBar = searchBar;
        
        CGRect viewBounds = self.view.bounds;
        viewBounds.size.height = SearchBarHeight;
        searchBar.frame = viewBounds;
        [self.view addSubview:searchBar];
        
        //configure search bar
        searchBar.delegate = self;
        searchBar.barStyle = UISearchBarStyleProminent;
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _searchBar;
}

- (UITableView *)resultsTable {
    if (nil == _resultsTable) {
        UITableView *resultsTable = [[UITableView alloc] initWithFrame:CGRectZero
                                                                 style:UITableViewStylePlain];
        _resultsTable = resultsTable;
        
        CGRect viewBounds = self.view.bounds;
        viewBounds.size.height -= SearchBarHeight;
        viewBounds.origin.y = SearchBarHeight;
        resultsTable.frame = viewBounds;
        [self.view addSubview:resultsTable];
        
        //configure table
        resultsTable.backgroundColor = [UIColor grayColor];
        resultsTable.delegate = self;
        resultsTable.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    }
    return _resultsTable;
}

- (NSMutableArray<DemoUser *> *)users {
    if (nil == _users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
