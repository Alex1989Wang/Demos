//
//  JWMainTableViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 06/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWMainTableViewController.h"
#import "JWTestCoreAnimationCallStackViewController.h"
#import "JWGraidentMaskTestViewController.h"
#import "JWReplicatorLayerTestViewController.h"
#import "JWAnimationPauseTestViewController.h"

typedef NS_ENUM(NSUInteger, JWLayerTestType) {
    JWLayerTestTypeAnimationCallStack,
    JWLayerTestTypeGradientMask,
    JWLayerTestTypeReplicatorAnimation,
    JWLayerTestTypeAnimationPauseResume,
};

static NSString *JWMainTableViewCellReuseID = @"JWMainTableViewCellReuseID";

@interface JWMainTableViewController ()
@property (nonatomic, strong) NSDictionary *testTypesMap;
@end

@implementation JWMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Layer Tests";
    
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
        case JWLayerTestTypeAnimationCallStack: {
            //used to run an animation multiple times and profile it with Core Animation
            //profiler to get the call statck
            JWTestCoreAnimationCallStackViewController *testCon =
            [[JWTestCoreAnimationCallStackViewController alloc] init];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
        case JWLayerTestTypeGradientMask: {
            JWGraidentMaskTestViewController *testCon =
            [[JWGraidentMaskTestViewController alloc] init];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
            
        case JWLayerTestTypeReplicatorAnimation: {
            JWReplicatorLayerTestViewController *testCon =
            [[JWReplicatorLayerTestViewController alloc] init];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
            
        case JWLayerTestTypeAnimationPauseResume: {
            JWAnimationPauseTestViewController *testCon =
            [[JWAnimationPauseTestViewController alloc] init];
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
        _testTypesMap = @{@(JWLayerTestTypeAnimationCallStack) : @"Animation Call Stack",
                          @(JWLayerTestTypeGradientMask) : @"Gradient Mask",
                          @(JWLayerTestTypeReplicatorAnimation) : @"Replicator Animation",
                          @(JWLayerTestTypeAnimationPauseResume) : @"Animation Pause & Resume"};
    }
    return _testTypesMap;
}

@end
