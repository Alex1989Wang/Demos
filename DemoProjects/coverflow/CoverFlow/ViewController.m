//
//  ViewController.m
//  CoverFlow
//
//  Created by xingdian on 2016/12/7.
//  Copyright © 2016年 xingdian. All rights reserved.
//


#import "ViewController.h"

#define kCollectionViewHeight self.collectionView.bounds.size.height
#define kCollectionViewWidth self.collectionView.bounds.size.width
#define kTriggerCardChangeThreshold (kCollectionViewWidth * 0.3)
#define kItemHorizontalGap 10
#define kItemVerticalHeightGap 15

//for testing
#define kDefaultNameCardMaxHeight self.collectionView.bounds.size.height * 0.8
#define kDefaultNameCardMinHeight self.collectionView.bounds.size.height * 0.6


@interface XDCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@end

@implementation XDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:self.label];
        self.label.frame = self.contentView.bounds;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth|
        UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

@end


static NSString *const kNameCardItemLayoutKind = @"kNameCardItemLayoutKind";

@interface XDCoverFlowLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat xTranslation;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic, assign) CGRect cellBounds;

@end

@implementation XDCoverFlowLayout

- (CGSize)collectionViewContentSize
{
    return self.collectionView.bounds.size;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSMutableDictionary *allLayoutAttribs = [NSMutableDictionary dictionary];
    NSMutableDictionary *itemLayouts = [NSMutableDictionary dictionary];
    
    //计算名片卡布局属性
    NSUInteger sectionNum = self.collectionView.numberOfSections;
    for (NSUInteger sec = 0; sec < sectionNum; sec++)
    {
        NSUInteger itemNum = [self.collectionView numberOfItemsInSection:sec];
        for (NSUInteger item = 0; item < itemNum; item++)
        {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:sec];
            UICollectionViewLayoutAttributes *nameCardLayoutAttribs =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            nameCardLayoutAttribs.center =
            [self centerForItemAtIndexPath:indexPath
                     horizontalTranslation:self.xTranslation];
            nameCardLayoutAttribs.bounds =
            [self boundsForItemAtIndexPath:indexPath
                     horizontalTranslation:self.xTranslation];
            nameCardLayoutAttribs.zIndex =
            [self zIndexForItemAtIndexPath:indexPath];
            nameCardLayoutAttribs.alpha =
            [self alphaForItemAtIndexPath:indexPath
                    horizontalTranslation:self.xTranslation];
            
            [itemLayouts setObject:nameCardLayoutAttribs forKey:indexPath];
            
            NSLog(@"section: %lu ---- item: %lu", sec, item);
            NSLog(@"\nframe: %@   \n\
                  alpha: %f     \n",
                  NSStringFromCGRect(nameCardLayoutAttribs.frame),
                  nameCardLayoutAttribs.alpha);
        }
    }
    
    [allLayoutAttribs setObject:itemLayouts forKey:kNameCardItemLayoutKind];
    
    self.layoutInfo = [allLayoutAttribs copy];
}

- (CGPoint)centerForItemAtIndexPath:(NSIndexPath *)indexPath
              horizontalTranslation:(CGFloat)xTranslation
{
    //元数据
    CGFloat xTranslationAbs =
    (fabs(xTranslation) > kTriggerCardChangeThreshold) ?
    kTriggerCardChangeThreshold : fabs(xTranslation);
    CGFloat changeRate = xTranslationAbs / kTriggerCardChangeThreshold;
    CGPoint collectionCenter = CGPointMake(kCollectionViewWidth * 0.5,
                                           kCollectionViewHeight * 0.5);
    
    CGFloat centerX = collectionCenter.x;
    CGFloat centerY = collectionCenter.y;
    if (indexPath.item == [self leftItemIndex])
    {
        if (xTranslation >= 0)
        {
            centerX = centerX - kItemHorizontalGap +
            changeRate * kItemHorizontalGap;
        }
    }
    else if (indexPath.item == self.currentIndex)
    {
        centerX += xTranslation * 4;
    }
    else if (indexPath.item == [self rightItemIndex])
    {
        if (xTranslation <= 0)
        {
            centerX = centerX + kItemHorizontalGap -
            changeRate * kItemHorizontalGap;
        }
    }
    return CGPointMake(centerX, centerY);
}

- (CGRect)boundsForItemAtIndexPath:(NSIndexPath *)indexPath
             horizontalTranslation:(CGFloat)xTranslation
{
    //元数据
    CGFloat xTranslationAbs =
    (fabs(xTranslation) > kTriggerCardChangeThreshold) ?
    kTriggerCardChangeThreshold : fabs(xTranslation);
    CGFloat changeRate = xTranslationAbs / kTriggerCardChangeThreshold;
    CGFloat cellWidth = self.cellBounds.size.width;
    CGFloat cellHeight = self.cellBounds.size.height;
    
    CGFloat newHeight = (indexPath.item == self.currentIndex) ?
    cellHeight : (cellHeight - kItemVerticalHeightGap);
    
    if (indexPath.item == [self leftItemIndex])
    {
        if (xTranslation > 0)
        {
            newHeight += changeRate * kItemVerticalHeightGap;
        }
    }
    else if (indexPath.item == [self rightItemIndex])
    {
        if (xTranslation < 0)
        {
            newHeight += changeRate * kItemVerticalHeightGap;
        }
    }
    
    return CGRectMake(0, 0, cellWidth, newHeight);
}


- (NSUInteger)zIndexForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == [self leftItemIndex])
    {
        return (self.xTranslation >= 0) ? 2 : 1;
    }
    else if (indexPath.item == self.currentIndex)
    {
        return 3;
    }
    else 
    {
        return (self.xTranslation <= 0) ? 2 : 1;
    }
}

- (CGFloat)alphaForItemAtIndexPath:(NSIndexPath *)indexPath
             horizontalTranslation:(CGFloat)xTranslation
{
    CGFloat ratio = xTranslation / self.collectionView.bounds.size.width;
    if (indexPath.item == self.currentIndex)
    {
        return (1 - fabs(ratio));
    }
    else
    {
        CGFloat xTranslationAbs =
        (fabs(xTranslation) > kTriggerCardChangeThreshold) ?
        kTriggerCardChangeThreshold : fabs(xTranslation);
        
        CGFloat diffToThreshold = kTriggerCardChangeThreshold - xTranslationAbs;
        CGFloat alphaDiff = 1 - diffToThreshold / kTriggerCardChangeThreshold;
        
        return MAX(0.6, alphaDiff);
    }
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[kNameCardItemLayoutKind][indexPath];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSDictionary *itemLayouts = self.layoutInfo[kNameCardItemLayoutKind];
    NSAssert([itemLayouts isKindOfClass:[NSDictionary class]],
             @"item layouts are all stored in a dictionary.");
    
    NSMutableArray *possibleLayouts = [NSMutableArray arrayWithCapacity:itemLayouts.count];
    
    [itemLayouts enumerateKeysAndObjectsUsingBlock:
    ^(NSIndexPath *indexPath,
      UICollectionViewLayoutAttributes *itemLayoutAttribs,
      BOOL * _Nonnull stop)
    {
        if (CGRectIntersectsRect(rect, itemLayoutAttribs.frame))
        {
            [possibleLayouts addObject:itemLayoutAttribs];
        }
    }];
    return [possibleLayouts copy];
}

- (void)setXTranslation:(CGFloat)xTranslation
{
    _xTranslation = xTranslation;
    [self invalidateLayout];
}

- (void)setCellBounds:(CGRect)cellBounds
{
    if (!CGRectEqualToRect(_cellBounds, cellBounds))
    {
        _cellBounds = cellBounds;
        [self invalidateLayout];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex != currentIndex)
    {
        _currentIndex = currentIndex;
        [self invalidateLayout];
    }
}

- (NSUInteger)leftItemIndex
{
    NSUInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    return (self.currentIndex + itemsCount - 1) % itemsCount;
}

- (NSUInteger)rightItemIndex
{
    NSUInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    return(self.currentIndex + 1) % itemsCount;
}

@end

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) XDCoverFlowLayout *coverflowLayout;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    XDCoverFlowLayout *coverflow = [[XDCoverFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = coverflow;
    CGRect collectionFrame = CGRectInset(self.view.bounds, 10, 40);
    UICollectionView *collectionView =
    [[UICollectionView alloc] initWithFrame:collectionFrame
                       collectionViewLayout:coverflow];
    collectionView.backgroundColor = [UIColor brownColor];
    self.collectionView = collectionView;
    [self.collectionView registerClass:[XDCollectionViewCell class]
            forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(didPandOnView:)];
    
    self.coverflowLayout = coverflow;
    [self.view addGestureRecognizer:pan];
}

- (void)didPandOnView:(UIPanGestureRecognizer *)pan
{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    if (count <= 0)
    {
        return;
    }

    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            self.coverflowLayout.xTranslation =
            [pan translationInView:self.view].x;
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:
        {
            //向左滑动超过一半
            if ([pan translationInView:self.view].x < (-kTriggerCardChangeThreshold))
            {
                self.coverflowLayout.currentIndex =
                (self.coverflowLayout.currentIndex + 1) % count;
            }
            //向右滑动超过一半
            else if ([pan translationInView:self.view].x > (kTriggerCardChangeThreshold))
            {
                self.coverflowLayout.currentIndex =
                (self.coverflowLayout.currentIndex + count - 1) % count;
            }
            
            [self.collectionView performBatchUpdates:
             ^{
                 self.coverflowLayout.xTranslation = 0;
                 [self.collectionView reloadData];
             }
                                          completion:nil];
        }
    }
}

#pragma mark - Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XDCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell"
                                              forIndexPath:indexPath];
    CGRect cellOriginalBounds =
    CGRectMake(0, 0, 250, 380);
    cell.bounds = cellOriginalBounds;
    self.coverflowLayout.cellBounds = cellOriginalBounds;
    
    
    cell.backgroundColor = [UIColor orangeColor];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    cell.layer.borderColor = [[UIColor redColor] CGColor];
    cell.layer.borderWidth = 2;
    cell.layer.shadowColor = [[UIColor grayColor] CGColor];
    cell.layer.shadowOffset = CGSizeMake(2, 2);
    cell.label.text = [NSString stringWithFormat:@"item: %ld",indexPath.item];

    cell.label.textAlignment = NSTextAlignmentCenter;
    cell.label.font = [UIFont systemFontOfSize:50];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.item);
}

@end
