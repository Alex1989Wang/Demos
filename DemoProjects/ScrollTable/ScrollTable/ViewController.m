//
//  ViewController.m
//  ScrollTable
//
//  Created by JiangWang on 2020/8/27.
//  Copyright © 2020 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

@interface PinHeader : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UICollectionView *collection;
@end

@implementation PinHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIs];
    }
    return self;
}

- (void)setupUIs {
    self.container = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.container];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake(80, 40);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.container addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container);
    }];
}

#pragma mark - c, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

@end

typedef NS_ENUM(NSUInteger, MIXHomeScrollMode) {
    MIXHomeScrollModeContainer,
    MIXHomeScrollModeTable,
};

@interface MIXHomeTableScrollingWrapper : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) UILabel *redView;
@property (nonatomic, strong) PinHeader *headerView;
@property (nonatomic, strong) UITableView *feedTable;
@property (nonatomic, assign) MIXHomeScrollMode mode;

@end

@implementation MIXHomeTableScrollingWrapper

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIs];
        [self initScrollMode];
        self.feedTable.scrollEnabled = NO;
        self.scrollContainer.scrollEnabled = YES;
    }
    return self;
}

#pragma mark - Private
- (void)initScrollMode {
    self.mode = MIXHomeScrollModeContainer;
}

- (void)setMode:(MIXHomeScrollMode)mode {
    _mode = mode;
    self.feedTable.scrollEnabled = NO;
    self.scrollContainer.scrollEnabled = YES;
//    switch (mode) {
//        case MIXHomeScrollModeContainer: {
//            self.feedTable.scrollEnabled = NO;
//            self.scrollEnabled = YES;
//            break;
//        }
//        case MIXHomeScrollModeTable: {
//            self.feedTable.scrollEnabled = YES;
//            self.scrollEnabled = NO;
//            break;
//        }
//        default:
//            break;
//    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"section: %ld index: %ld", indexPath.section, indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollContainer) {
        NSLog(@"容器scroll了: %@", scrollView);
        // tag栏顶
//        CGRect tagRectInView = [self convertRect:self.headerView.frame toView:self];
//        if (tagRectInView.origin.y <= 0) {
//            self.mode = MIXHomeScrollModeTable;
//            self.scrollContainer.contentOffset = CGPointMake(0, CGRectGetMaxY(self.redView.frame));
//        }
        
        // pin住header
        [self tryPinOrUnpinHeader];

        // table是不是滚上去了
        // 是否应该滚动table
        

//        if (self.scrollContainer.contentOffset.y >= CGRectGetMinY(self.headerView.frame)) {
//             CGFloat offset = self.scrollContainer.contentOffset.y - CGRectGetMinY(self.headerView.frame);
//            CGPoint trans = [scrollView.panGestureRecognizer translationInView:scrollView];
//            NSLog(@"scrollview pan guesture: %@ traslation: %@", scrollView.panGestureRecognizer, NSStringFromCGPoint(trans));
//            if (self.feedTable.contentOffset.y >= 0 && self.feedTable.contentOffset.y <= self.feedTable.contentSize.height - self.feedTable.bounds.size.height) {
//                self.scrollContainer.contentOffset = CGPointMake(0, CGRectGetMinY(self.headerView.frame));
//                CGPoint tableOffset = self.feedTable.contentOffset;
//                tableOffset.y += offset;
//                [self.feedTable setContentOffset:tableOffset];
//            }
//
//        }
//        else {
//            if (self.feedTable.contentOffset.y > 0) {
//                CGFloat offset = self.scrollContainer.contentOffset.y - CGRectGetMinY(self.headerView.frame);
//                self.scrollContainer.contentOffset = CGPointMake(0, CGRectGetMinY(self.headerView.frame));
//                CGPoint tableOffset = self.feedTable.contentOffset;
//                tableOffset.y += offset;
//                [self.feedTable setContentOffset:tableOffset];
//            }
//        }
        
         CGFloat offset = self.scrollContainer.contentOffset.y - CGRectGetMinY(self.headerView.frame);
        if ([self shouldScrollTable]) {
            self.scrollContainer.contentOffset = CGPointMake(0, CGRectGetMinY(self.headerView.frame));
            CGPoint tableOffset = self.feedTable.contentOffset;
            tableOffset.y += offset;
            [self.feedTable setContentOffset:tableOffset];
        }
        
    }
    if (scrollView == self.feedTable) {
        NSLog(@"table scroll了: %@", scrollView);
        // 往下拉了table
        if (self.feedTable.contentOffset.y <= 0) {
            self.mode = MIXHomeScrollModeContainer;
            self.feedTable.contentOffset = CGPointZero;
        }
    }
}

- (BOOL)shouldPinHeader {
    CGPoint newOffset = self.scrollContainer.contentOffset;
    return newOffset.y >= CGRectGetMinY(self.headerView.frame);
}

- (BOOL)shouldScrollTable {
    // 两种情况
    CGFloat headerMinY = CGRectGetMinY(self.headerView.frame);
    if (self.scrollContainer.contentOffset.y >= headerMinY) {
        // header已经pin住 && table可以滚动
//        return self.feedTable.contentOffset.y >= 0 && self.feedTable.contentOffset.y <= self.feedTable.contentSize.height - self.feedTable.bounds.size.height;
        return self.feedTable.contentOffset.y <= self.feedTable.contentSize.height - self.feedTable.bounds.size.height;
    } else {
        // header可以滑动 && table可以滚动
        return self.feedTable.contentOffset.y > 0;
    }
}

- (void)tryPinOrUnpinHeader {
    UIView *headerContentView = [self.headerView container];
    if ([self shouldPinHeader]) {
        [headerContentView removeFromSuperview];
        [self.superview addSubview:headerContentView];
        [headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.mas_equalTo(headerContentView.bounds.size.width);
            make.height.mas_equalTo(headerContentView.bounds.size.height);
            make.centerX.equalTo(self);
        }];
    } else {
        [headerContentView removeFromSuperview];
        [self.headerView addSubview:headerContentView];
        headerContentView.frame = self.headerView.bounds;
    }
}

#pragma mark - UIs
- (void)setupUIs {
    self.scrollContainer = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.scrollContainer];
    //
    self.redView = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, 80)];
    self.redView.text = @"我是功能位功能位";
    [self.scrollContainer addSubview:self.redView];
    self.scrollContainer.delegate = self;
    self.redView.backgroundColor = [UIColor redColor];
    // 头部
    CGFloat headerY = CGRectGetMaxY(self.redView.frame);
    self.headerView = [[PinHeader alloc] initWithFrame:CGRectMake(0, headerY, self.bounds.size.width, 50)];
    [self.scrollContainer addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor brownColor];
    // feed的table
    CGFloat tableY = CGRectGetMaxY(self.headerView.frame);
    CGFloat tableHeight = CGRectGetHeight(self.bounds) - 50;
    self.feedTable = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, self.bounds.size.width, tableHeight)];
    [self.scrollContainer addSubview:self.feedTable];
    self.feedTable.backgroundColor = [UIColor yellowColor];
    self.feedTable.delegate = self;
    self.feedTable.dataSource = self;
    self.feedTable.estimatedRowHeight = 0;
    self.feedTable.estimatedSectionHeaderHeight = 0;
    self.feedTable.estimatedSectionFooterHeight = 0;
    [self.feedTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    CGFloat height = CGRectGetMaxY(self.feedTable.frame);
    [self.scrollContainer setContentSize:CGSizeMake(self.bounds.size.width, height)];
}

@end


@interface ViewController ()
@property (nonatomic, strong) UIScrollView *scrollContainer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUIs];
}

#pragma mark - UIs
- (void)setupUIs {
    self.scrollContainer = [[MIXHomeTableScrollingWrapper alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollContainer];
//    self.scrollContainer.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(didRefresh)];
}

- (void)didRefresh {
//    [self.scrollContainer.mj_footer endRefreshing];
}

@end
