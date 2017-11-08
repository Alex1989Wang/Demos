//
//  PTHomeViewController.m
//  Partner
//
//  Created by JiangWang on 12/08/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "PTHomeViewController.h"

/* views */
#import <TYPagerController/TYPagerView.h>
#import "PTHomeTopTabBar.h"

#define kTopBarHeight (84)
#define kTopBarCellReuseID @"kTopBarCellReuseID"

@interface PTHomeViewController ()
<TYTabPagerBarDataSource,
TYTabPagerBarDelegate,
TYPagerViewDelegate,
TYPagerViewDataSource>

@property (nonatomic, strong) PTHomeTopTabBar *topBar;
@property (nonatomic, strong) TYPagerView *containerView;
@property (nonatomic, strong) NSArray<__kindof UIViewController *> *customChildVCs;
@end

@implementation PTHomeViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customChildVCs];
    [self topBar];
    [self containerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.topBar reloadData];
    [self.containerView reloadData];
}

- (void)dealloc {
    self.customChildVCs = nil;
}

#pragma mark - Private
- (void)selectMiddle {
    [self.containerView scrollToViewAtIndex:1 animate:NO]; //未显示
    [self.topBar scrollToItemFromIndex:1 toIndex:1 animate:NO];
}

- (void)configureTopBarLayoutWithTopBar:(PTHomeTopTabBar *)topBar {
    TYTabPagerBarLayout *layout = [[TYTabPagerBarLayout alloc] initWithPagerTabBar:topBar];
    NSInteger itemNum = self.customChildVCs.count;
    layout.cellWidth = floorf(self.view.bounds.size.width / itemNum);
    layout.cellSpacing = 0;
    layout.cellEdging = 0;
    layout.textColorProgressEnable = NO;
    layout.barStyle = TYPagerBarStyleProgressElasticView;
    topBar.layout = layout;
}

#pragma mark - TYPagerViewDataSource
- (NSInteger)numberOfViewsInPagerView {
    return self.customChildVCs.count;
}

- (UIView *)pagerView:(TYPagerView *)pagerView
         viewForIndex:(NSInteger)index
          prefetching:(BOOL)prefetching {
    NSAssert(index >= 0 && index < self.customChildVCs.count,
             @"index invalid.");
    return self.customChildVCs[index].view;
}

#pragma mark - TYPagerViewDelegate
- (void)pagerView:(TYPagerView *)pagerView
transitionFromIndex:(NSInteger)fromIndex
          toIndex:(NSInteger)toIndex
         animated:(BOOL)animated {
    NSAssert(toIndex >= 0 && toIndex < self.customChildVCs.count,
             @"index invalid.");
    [self.topBar scrollToItemFromIndex:fromIndex
                               toIndex:toIndex
                               animate:YES];
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.customChildVCs.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar
                                              cellForItemAtIndex:(NSInteger)index {
    NSAssert(index >= 0 && index < self.customChildVCs.count,
             @"index invalid.");
    PTHomeTopTabBarCell *cell =
    [pagerTabBar dequeueReusableCellWithReuseIdentifier:kTopBarCellReuseID
                                               forIndex:index];
    cell.cellImageView.image = [UIImage imageNamed:@"ic_dock_self_off"];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    NSAssert(index >= 0 && index < self.customChildVCs.count,
             @"index invalid.");
    [self.containerView scrollToViewAtIndex:index animate:YES];
}

#pragma mark - Lazy Loading 
- (PTHomeTopTabBar *)topBar {
    if (!_topBar) {
        CGSize viewSize = self.view.bounds.size;
        CGRect topBarRect = CGRectMake(0, 0, viewSize.width, kTopBarHeight);
        _topBar = [[PTHomeTopTabBar alloc] initWithFrame:topBarRect];
        [self configureTopBarLayoutWithTopBar:_topBar];
        [self.view addSubview:_topBar];
        
        _topBar.delegate = self;
        _topBar.dataSource = self;
        [_topBar registerClass:[PTHomeTopTabBarCell class]
    forCellWithReuseIdentifier:kTopBarCellReuseID];
    }
    return _topBar;
}

- (TYPagerView *)containerView {
    if (!_containerView) {
        CGSize viewSize = self.view.bounds.size;
        CGRect containerRect = CGRectMake(0, kTopBarHeight, viewSize.width,
                                          viewSize.height - kTopBarHeight);
        _containerView = [[TYPagerView alloc] initWithFrame:containerRect];
        _containerView.dataSource = self;
        _containerView.delegate = self;
        [self.view addSubview:_containerView];
    }
    return _containerView;
}

- (NSArray<UIViewController *> *)customChildVCs {
    if (!_customChildVCs) {
        UIViewController *redCon = [[UIViewController alloc] init];
        [redCon willMoveToParentViewController:self];
        redCon.view.backgroundColor = [UIColor redColor];
        [self addChildViewController:redCon];
        [redCon didMoveToParentViewController:self];
        
        UIViewController *blueCon = [[UIViewController alloc] init];
        [blueCon willMoveToParentViewController:self];
        blueCon.view.backgroundColor = [UIColor blueColor];
        [self addChildViewController:blueCon];
        [blueCon didMoveToParentViewController:self];
        
        UIViewController *orangeCon = [[UIViewController alloc] init];
        [orangeCon willMoveToParentViewController:self];
        orangeCon.view.backgroundColor = [UIColor orangeColor];
        [self addChildViewController:orangeCon];
        [orangeCon didMoveToParentViewController:self];
        _customChildVCs = @[redCon, blueCon, orangeCon];
    }
    return _customChildVCs;
}

@end
