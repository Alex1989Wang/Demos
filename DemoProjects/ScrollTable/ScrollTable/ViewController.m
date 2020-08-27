//
//  ViewController.m
//  ScrollTable
//
//  Created by JiangWang on 2020/8/27.
//  Copyright © 2020 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, MIXHomeScrollMode) {
    MIXHomeScrollModeContainer,
    MIXHomeScrollModeTable,
};

@interface MIXHomeTableScrollingWrapper : UIScrollView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *redView;
@property (nonatomic, strong) UILabel *headerView;
@property (nonatomic, strong) UITableView *feedTable;
@property (nonatomic, assign) MIXHomeScrollMode mode;

@end

@implementation MIXHomeTableScrollingWrapper

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIs];
        [self initScrollMode];
    }
    return self;
}

#pragma mark - Private
- (void)initScrollMode {
    self.mode = MIXHomeScrollModeContainer;
}

- (void)setMode:(MIXHomeScrollMode)mode {
    _mode = mode;
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

#pragma mark - Overrides
- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    BOOL should = [super touchesShouldBegin:touches withEvent:event inContentView:view];
    NSLog(@"touchesShouldBegin: %@ event: %@ contentView: %@", touches, event, view);
    return should;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    BOOL should = [super touchesShouldCancelInContentView:view];
    NSLog(@"touchesShouldCancelInContentView: view: %@", view);
    return should;
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
    if (scrollView == self) {
//        NSLog(@"容器scroll了: %@", scrollView);
        // tag栏顶
        CGRect tagRectInView = [self convertRect:self.headerView.frame toView:self];
        if (tagRectInView.origin.y <= 0) {
            self.mode = MIXHomeScrollModeTable;
            self.contentOffset = CGPointMake(0, CGRectGetMaxY(self.redView.frame));
        }
    }
    if (scrollView == self.feedTable) {
//        NSLog(@"table scroll了: %@", scrollView);
        // 往下拉了table
        if (self.feedTable.contentOffset.y <= 0) {
            self.mode = MIXHomeScrollModeContainer;
            self.feedTable.contentOffset = CGPointZero;
        }
    }
}

#pragma mark - UIs
- (void)setupUIs {
    // 色块
    self.redView = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, 80)];
    self.redView.text = @"我是功能位功能位";
    [self addSubview:self.redView];
    self.delegate = self;
    self.redView.backgroundColor = [UIColor redColor];
    // 头部
    CGFloat headerY = CGRectGetMaxY(self.redView.frame);
    self.headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, headerY, self.bounds.size.width, 50)];
    self.headerView.text = @"我是Tag";
    [self addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor brownColor];
    // feed的table
    CGFloat tableY = CGRectGetMaxY(self.headerView.frame);
    CGFloat tableHeight = CGRectGetHeight(self.bounds) - 50;
    self.feedTable = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, self.bounds.size.width, tableHeight)];
    [self addSubview:self.feedTable];
    self.feedTable.backgroundColor = [UIColor yellowColor];
    self.feedTable.delegate = self;
    self.feedTable.dataSource = self;
    self.feedTable.estimatedRowHeight = 0;
    self.feedTable.estimatedSectionHeaderHeight = 0;
    self.feedTable.estimatedSectionFooterHeight = 0;
    [self.feedTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    CGFloat height = CGRectGetMaxY(self.feedTable.frame);
    [self setContentSize:CGSizeMake(self.bounds.size.width, height)];
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
}

@end
