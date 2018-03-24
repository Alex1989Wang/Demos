//
//  JWMainTableViewController.m
//  JWInfiniteScroll
//
//  Created by JiangWang on 06/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWMainTableViewController.h"
#import "JWInfiniteScrollViewController.h"
#import "JWInfiniteCollectionViewController.h"

typedef NS_ENUM(NSUInteger, JWInfiniteScrollType) {
    JWInfiniteScrollTypeScrollView,
    JWInfiniteScrollTypeCollectionView,
};

static NSString *JWMainTableViewCellReuseID = @"JWMainTableViewCellReuseID";

@interface JWMainTableViewController ()
@property (nonatomic, strong) NSDictionary *testTypesMap;
@end

@implementation JWMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Infinite Scroll Tests";
    
    [self setupTableView];
}

#pragma mark - Private
- (void)setupTableView {
    UITableView *tableView = [self tableView];
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:JWMainTableViewCellReuseID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.testTypesMap.allValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:JWMainTableViewCellReuseID
                                    forIndexPath:indexPath];
    cell.textLabel.text = self.testTypesMap[@(indexPath.row)];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case JWInfiniteScrollTypeScrollView: {
            JWInfiniteScrollViewController *testCon =
            [[JWInfiniteScrollViewController alloc] init];
            testCon.title = self.testTypesMap[@(JWInfiniteScrollTypeScrollView)];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
        case JWInfiniteScrollTypeCollectionView: {
            JWInfiniteCollectionViewController *testCon =
            [[JWInfiniteCollectionViewController alloc] init];
            testCon.title = self.testTypesMap[@(JWInfiniteScrollTypeCollectionView)];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Lazy Loading
- (NSDictionary *)testTypesMap {
    if (nil == _testTypesMap) {
        _testTypesMap = @{@(JWInfiniteScrollTypeScrollView) : @"Scroll View Infinite Scroll",
                          @(JWInfiniteScrollTypeCollectionView) : @"Collection View Infinite Scroll",};
    }
    return _testTypesMap;
}

@end
