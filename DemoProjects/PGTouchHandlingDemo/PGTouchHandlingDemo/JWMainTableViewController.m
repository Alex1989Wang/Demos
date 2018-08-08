//
//  JWMainTableViewController.m
//  JWInfiniteScroll
//
//  Created by JiangWang on 06/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWMainTableViewController.h"
#import "PGRawTouchViewController.h"
#import "PGButtonTapMixViewController.h"
#import "PGTapForwardViewController.h"

typedef NS_ENUM(NSUInteger, PGTouchHandlingType) {
    PGTouchHandlingTypeRawTouches,
    PGTouchHandlingTypeButtonTapMix,
    PGTouchHandlingTypeTapForward,
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
        case PGTouchHandlingTypeRawTouches: {
            PGRawTouchViewController *testCon =
            [[PGRawTouchViewController alloc] initWithNibName:@"PGRawTouchViewController" bundle:nil];
            testCon.title = self.testTypesMap[@(PGTouchHandlingTypeRawTouches)];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
        case PGTouchHandlingTypeButtonTapMix: {
            PGButtonTapMixViewController *testCon =
            [[PGButtonTapMixViewController alloc] initWithNibName:@"PGButtonTapMixViewController" bundle:nil];
            testCon.title = self.testTypesMap[@(PGTouchHandlingTypeButtonTapMix)];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
        case PGTouchHandlingTypeTapForward: {
            PGTapForwardViewController *testCon =
            [[PGTapForwardViewController alloc] initWithNibName:@"PGTapForwardViewController" bundle:nil];
            testCon.title = self.testTypesMap[@(PGTouchHandlingTypeTapForward)];
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
        _testTypesMap = @{@(PGTouchHandlingTypeRawTouches) : @"Raw Touches",
                          @(PGTouchHandlingTypeButtonTapMix) : @"Button With Tap Gesture",
                          @(PGTouchHandlingTypeTapForward) : @"Tap Forward",};
    }
    return _testTypesMap;
}

@end
