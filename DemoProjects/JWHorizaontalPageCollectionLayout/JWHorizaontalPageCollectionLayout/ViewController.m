//
//  ViewController.m
//  JWHorizaontalPageCollectionLayout
//
//  Created by JiangWang on 04/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "JWHorizontalPageCollectionLayout.h"
#import "JWTestCollectionViewCell.h"

#define kTestItemCellReuseID @"kTestItemCellReuseID"

@interface JWTestSectionData : NSObject
@property (nonatomic, strong) NSArray<NSString *> *testItems;
@end

@implementation JWTestSectionData

#pragma mark - Lazy Loading
- (NSArray<NSString *> *)testItems {
    if (!_testItems) {
        NSUInteger testCount = 25 + arc4random() % 50;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:testCount];
        for (NSInteger start = 0; start < testCount; start++) {
            NSString *tip = [NSString stringWithFormat:@"No. %ld", start];
            [array addObject:tip];
        }
        _testItems = [array copy];
    }
    return _testItems;
}
@end

@interface ViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *testCollection;
@property (nonatomic, weak) UIButton *reloadButton;
@property (nonatomic, strong) NSArray<JWTestSectionData *> *testDataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect viewBounds = self.view.bounds;
    JWHorizontalPageCollectionLayout *layout = [[JWHorizontalPageCollectionLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 50);
    CGFloat height = viewBounds.size.height * 0.5;
    CGRect collectionRect = (CGRect){0, height, viewBounds.size.width, height};
    UICollectionView *testCollection =
    [[UICollectionView alloc] initWithFrame:collectionRect
                       collectionViewLayout:layout];
    _testCollection = testCollection;
    [self.view addSubview:testCollection];
    
    [testCollection registerClass:[JWTestCollectionViewCell class]
               forCellWithReuseIdentifier:kTestItemCellReuseID];
    testCollection.pagingEnabled = YES;
    testCollection.showsVerticalScrollIndicator = NO;
    testCollection.showsHorizontalScrollIndicator = NO;
    testCollection.delegate = self;
    testCollection.dataSource = self;
    testCollection.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *reloadButton = [[UIButton alloc] init];
    CGFloat width = 80;
    CGFloat buttonHeight = 40;
    reloadButton.frame = (CGRect){(viewBounds.size.width - width) * 0.5, 150, width, buttonHeight};
    [reloadButton addTarget:self
                     action:@selector(reloadData:)
           forControlEvents:UIControlEventTouchUpInside];
    [reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
    [reloadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:reloadButton];
}

- (void)reloadData:(UIButton *)reloadButton {
    _testDataArray = nil;
    [self.testCollection reloadData];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.testDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JWTestSectionData *sectionData = self.testDataArray[section];
    return sectionData.testItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JWTestCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kTestItemCellReuseID
                                              forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.testDataArray.count) {
        JWTestSectionData *sectionData = self.testDataArray[indexPath.section];
        if (indexPath.item < sectionData.testItems.count &&
            [cell isKindOfClass:[JWTestCollectionViewCell class]]) {
            [(JWTestCollectionViewCell *)cell contentLabel].text = sectionData.testItems[indexPath.item];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected index path: %@", indexPath);
}

#pragma mark - Lazy Loading
- (NSArray<JWTestSectionData *> *)testDataArray {
    if (!_testDataArray) {
        NSUInteger testCount = arc4random() % 6;
        NSMutableArray *sections = [NSMutableArray arrayWithCapacity:testCount];
        for (NSInteger section = 0; section < testCount; section++) {
            JWTestSectionData *section = [[JWTestSectionData alloc] init];
            [sections addObject:section];
        }
        _testDataArray = [sections copy];
    }
    return _testDataArray;
}

@end
