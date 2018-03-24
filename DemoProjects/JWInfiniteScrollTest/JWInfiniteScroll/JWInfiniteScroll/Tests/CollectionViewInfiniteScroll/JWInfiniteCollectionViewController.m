//
//  JWInfiniteCollectionViewController.m
//  JWInfiniteScroll
//
//  Created by JiangWang on 23/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWInfiniteCollectionViewController.h"
#import "JWCollectionViewCell.h"
#import "JWCollectionView.h"
#import "JWInfiniteFlowLayout.h"

#define kItemSize ((CGSize){16, 24})

static NSString *kCollectionCellReuseID = @"com.jiangwang.infiniteCellID";

@interface JWInfiniteCollectionViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, strong) JWCollectionView *infiniteCollection;
@property (nonatomic, strong) NSArray<UIImage *> *images;
@end

@implementation JWInfiniteCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize selfViewSize = self.view.bounds.size;
    CGRect collectionRect = (CGRect){(selfViewSize.width - 200) * 0.5,
        (selfViewSize.height - 40) * 0.5, 200, 40};
    JWInfiniteFlowLayout *layout = (JWInfiniteFlowLayout *)self.infiniteCollection.collectionViewLayout;
    layout.dataSet = self.images;
    self.infiniteCollection.frame = collectionRect;
    [self.view addSubview:self.infiniteCollection];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    JWInfiniteFlowLayout *layout = (JWInfiniteFlowLayout *)collectionView.collectionViewLayout;
    return layout.leftPaddedCount + self.images.count + layout.rightPaddedCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JWInfiniteFlowLayout *layout = (JWInfiniteFlowLayout *)collectionView.collectionViewLayout;
    JWCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellReuseID
                                              forIndexPath:indexPath];
    NSInteger imageIndex = (indexPath.row - layout.leftPaddedCount < 0) ?
    ((indexPath.row - layout.leftPaddedCount)%(NSInteger)self.images.count + self.images.count)%(NSInteger)self.images.count :
    (indexPath.row - layout.leftPaddedCount)%(NSInteger)self.images.count;
    cell.imageView.image = self.images[imageIndex];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    JWInfiniteFlowLayout *layout = (JWInfiniteFlowLayout *)self.infiniteCollection.collectionViewLayout;
    CGPoint currentOffset = scrollView.contentOffset;
    if (scrollView.contentOffset.x < layout.minScrollableContentOffsetX) {
        scrollView.contentOffset = (CGPoint){layout.itemSpan + layout.minItemSpacing + currentOffset.x,
            currentOffset.y};
    }
    else if (scrollView.contentOffset.x > layout.maxScrollableContentOffsetX) {
        scrollView.contentOffset = (CGPoint){currentOffset.x - layout.itemSpan - layout.minItemSpacing,
            currentOffset.y};
    }
}

#pragma mark - Lazy Loading 
- (JWCollectionView *)infiniteCollection {
    if (!_infiniteCollection) {
        JWInfiniteFlowLayout *flowLayout = [[JWInfiniteFlowLayout alloc] init];
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //horizontal and one row of items;
        flowLayout.itemSize = kItemSize;
        flowLayout.minItemSpacing = 20.f;
        _infiniteCollection = [[JWCollectionView alloc] initWithFrame:CGRectZero
                                                 collectionViewLayout:flowLayout];
        [_infiniteCollection registerClass:[JWCollectionViewCell class]
                forCellWithReuseIdentifier:kCollectionCellReuseID];
        _infiniteCollection.delegate = self;
        _infiniteCollection.dataSource = self;
        [_infiniteCollection setShowsHorizontalScrollIndicator:NO];
        _infiniteCollection.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    }
    return _infiniteCollection;
}

- (NSArray<UIImage *> *)images {
    if (!_images) {
        NSArray *imageNames = @[
                                @"0_icon",
                                @"1_icon",
                                @"2_icon",
                                @"3_icon",
                                @"4_icon",
                                @"5_icon",
                                @"6_icon",
                                @"7_icon",
                                @"8_icon",
                                @"9_icon",
                                ];
        
        NSMutableArray<UIImage *> *images =
        [NSMutableArray arrayWithCapacity:imageNames.count];
        for (NSString *imageName in imageNames) {
            UIImage *image = [UIImage imageNamed:imageName];
            if (image) {
                [images addObject:image];
            }
        }
        _images = [images copy];
    }
    return _images;
}

@end
