//
//  JWMainTableViewController.m
//  JWInfiniteScroll
//
//  Created by JiangWang on 06/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWMainTableViewController.h"
#import "UIEffectViewBlurViewController.h"
#import "JWAccelerateFrameworkBlurViewController.h"
#import "JWCoreImageBlurViewController.h"

typedef NS_ENUM(NSUInteger, JWBlurImageType) {
    JWBlurImageTypeUIEffectView,
    JWBlurImageTypePixelManipulation,
    JWBlurImageTypeCoreImage,
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
        case JWBlurImageTypeUIEffectView: {
            UIEffectViewBlurViewController *testCon =
            [[UIEffectViewBlurViewController alloc] initWithNibName:@"UIEffectViewBlurViewController" bundle:nil];
            testCon.title = self.testTypesMap[@(JWBlurImageTypeUIEffectView)];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
        case JWBlurImageTypePixelManipulation: {
            JWAccelerateFrameworkBlurViewController *testCon =
            [[JWAccelerateFrameworkBlurViewController alloc] initWithNibName:@"JWAccelerateFrameworkBlurViewController" bundle:nil];
            testCon.title = self.testTypesMap[@(JWBlurImageTypePixelManipulation)];
            [self.navigationController pushViewController:testCon animated:YES];
            break;
        }
        case JWBlurImageTypeCoreImage: {
            JWCoreImageBlurViewController *testCon =
            [[JWCoreImageBlurViewController alloc] initWithNibName:@"JWCoreImageBlurViewController" bundle:nil];
            testCon.title = self.testTypesMap[@(JWBlurImageTypeCoreImage)];
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
        _testTypesMap = @{@(JWBlurImageTypeUIEffectView) : @"UI Effect View Blur",
                          @(JWBlurImageTypePixelManipulation) : @"Use Accelerate Framework",
                          @(JWBlurImageTypeCoreImage) : @"Core Image Blur",};
    }
    return _testTypesMap;
}

@end
