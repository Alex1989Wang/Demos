//
//  JWMainTableViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 06/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWMainTableViewController.h"
#import "JWCurlPageViewController.h"
#import "JWScrollPageViewController.h"

typedef NS_ENUM(NSUInteger, JWPagerViewTestType) {
    JWPagerViewTestTypeUIPagerCurl,
    JWPagerViewTestTypeUIPagerScroll,
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
        case JWPagerViewTestTypeUIPagerCurl: {
            NSDictionary *pageControllerOpts =
            @{UIPageViewControllerOptionSpineLocationKey :
                  @(UIPageViewControllerSpineLocationMid)};
            JWCurlPageViewController *testCon =
            [[JWCurlPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                            navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                          options:pageControllerOpts];
            testCon.title = self.testTypesMap[@(JWPagerViewTestTypeUIPagerCurl)];
            NSInteger viewConsCount = 2;
            NSMutableArray *viewCons = [NSMutableArray arrayWithCapacity:viewConsCount];
            for (NSInteger index = 0; index < viewConsCount; index++) {
                UIViewController *viewCon = [[UIViewController alloc] init];
                viewCon.title = [@(index) description];
                viewCon.view.backgroundColor =
                [UIColor colorWithRed:0.1 * index green:0.2 * index blue:(0.15 * index + 0.15) alpha:1.0];
                [viewCons addObject:viewCon];
            }
            [testCon setViewControllers:[viewCons copy]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:YES
                             completion:nil];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
        case JWPagerViewTestTypeUIPagerScroll: {
            NSDictionary *pageControllerOpts =
            @{UIPageViewControllerOptionInterPageSpacingKey : @(20)};
            JWCurlPageViewController *testCon =
            [[JWCurlPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                            navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                          options:pageControllerOpts];
            testCon.title = self.testTypesMap[@(JWPagerViewTestTypeUIPagerScroll)];
            NSInteger viewConsCount = 1;
            NSMutableArray *viewCons = [NSMutableArray arrayWithCapacity:viewConsCount];
            for (NSInteger index = 0; index < viewConsCount; index++) {
                UIViewController *viewCon = [[UIViewController alloc] init];
                viewCon.title = [@(index) description];
                viewCon.view.backgroundColor =
                [UIColor colorWithRed:0.1 * index green:0.2 * index blue:(0.15 * index + 0.15) alpha:1.0];
                [viewCons addObject:viewCon];
            }
            [testCon setViewControllers:[viewCons copy]
                              direction:UIPageViewControllerNavigationDirectionReverse
                               animated:YES
                             completion:nil];
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
        _testTypesMap = @{@(JWPagerViewTestTypeUIPagerCurl) : @"UIPagerViewController Curl Test",
                          @(JWPagerViewTestTypeUIPagerScroll) : @"UIPagerViewController Scroll Test",
                          };
    }
    return _testTypesMap;
}

@end
