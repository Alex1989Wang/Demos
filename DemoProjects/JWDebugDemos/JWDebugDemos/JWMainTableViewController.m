//
//  JWMainTableViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 06/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWMainTableViewController.h"
#import "JWMemoryGraphDebugViewController.h"

typedef NS_ENUM(NSUInteger, JWDebugDemoType) {
    JWDebugDemoTypeMemGraph,
};

static NSString *JWMainTableViewCellReuseID = @"JWMainTableViewCellReuseID";

@interface JWMainTableViewController ()
@property (nonatomic, strong) NSDictionary *debugTypesMap;
@end

@implementation JWMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Debug Types";
    
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
    return self.debugTypesMap.allValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:JWMainTableViewCellReuseID
                                    forIndexPath:indexPath];
    cell.textLabel.text = self.debugTypesMap[@(indexPath.row)];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case JWDebugDemoTypeMemGraph: {
            JWMemoryGraphDebugViewController *testCon =
            [[JWMemoryGraphDebugViewController alloc] init];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Lazy Loading
- (NSDictionary *)debugTypesMap {
    if (nil == _debugTypesMap) {
        _debugTypesMap = @{@(JWDebugDemoTypeMemGraph) : @"Memory Graph",};
    }
    return _debugTypesMap;
}

@end
