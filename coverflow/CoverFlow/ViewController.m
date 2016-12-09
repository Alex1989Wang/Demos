//
//  ViewController.m
//  CoverFlow
//
//  Created by xingdian on 2016/12/7.
//  Copyright © 2016年 xingdian. All rights reserved.
//


#import "ViewController.h"

@interface XDCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@end

@implementation XDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:self.label];
        self.label.frame = self.contentView.bounds;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

@end


static NSString *const kNameCardItemLayoutKind = @"kNameCardItemLayoutKind";

@interface XDCoverFlowLayout : UICollectionViewLayout
@property (nonatomic, assign) CGFloat xTranslation;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSDictionary *layoutInfo;
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
            
            nameCardLayoutAttribs.frame =
            [self itemAttributedFrameWithIndexPath:indexPath
                             horizontalTranslation:self.xTranslation];
            nameCardLayoutAttribs.transform =
            [self itemAttributedTransformWithIndexPath:indexPath
                                 horizontalTranslation:self.xTranslation];
            nameCardLayoutAttribs.zIndex =
            [self itemAttributedZIndexWithIndexPath:indexPath];
            
            [itemLayouts setObject:nameCardLayoutAttribs forKey:indexPath];
            
            NSLog(@"section: %lu ---- item: %lu", sec, item);
            NSLog(@"\nframe: %@   \n\
                  transform: %@   \n\
                  zindex: %lu \n\n\n",
                  NSStringFromCGRect(nameCardLayoutAttribs.frame),
                  NSStringFromCGAffineTransform(nameCardLayoutAttribs.transform),
                  nameCardLayoutAttribs.zIndex);
        }
    }
    
    [allLayoutAttribs setObject:itemLayouts forKey:kNameCardItemLayoutKind];
    
    self.layoutInfo = [allLayoutAttribs copy];
}


- (CGRect)itemAttributedFrameWithIndexPath:(NSIndexPath *)indexPath
                     horizontalTranslation:(CGFloat)xTranslation
{
    CGFloat collectionHeight = self.collectionView.bounds.size.height;
    CGFloat collectionWidth = self.collectionView.bounds.size.width;
    CGFloat minHeight = collectionHeight * 0.6;
    CGFloat maxHeight = collectionHeight * 0.8;
    CGFloat itemWith = self.collectionView.bounds.size.width - 60;
    CGFloat itemGap = 20;
    
    CGFloat itemX = (collectionWidth - itemWith - 2 * itemGap) * 0.5 +
    itemGap * indexPath.item;
    CGFloat itemY = (indexPath.item == 1) ?
    (collectionHeight - maxHeight) * 0.5 :
    (collectionHeight - minHeight) * 0.5;
    CGFloat itemHeight = (indexPath.item == 1) ? maxHeight: minHeight;
    
    return CGRectMake(itemX, itemY, itemWith, itemHeight);
}


- (NSUInteger)itemAttributedZIndexWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item)
    {
        case 0:
            return (self.xTranslation < 0) ? 1 : 2;
            break;
            
        case 1:
            return 3;
            break;
            
        case 2:
            return (self.xTranslation < 0) ? 2 : 1;
            break;
            
        default:
            return 0;
            break;
    }
}


- (CGAffineTransform)itemAttributedTransformWithIndexPath:(NSIndexPath *)indexPath
                                    horizontalTranslation:(CGFloat)xTranslation
{
    // 1个或0个的时候不用动画
    if ([self.collectionView numberOfItemsInSection:0] <= 1)
    {
        return CGAffineTransformIdentity;
    }

    //多个-固定第一个在最前
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGFloat ratio = fabs(xTranslation) / self.collectionView.bounds.size.width;
    switch (indexPath.item)
    {
        case 0:
        {
            //向右
            if (xTranslation > 0)
            {
                transform = CGAffineTransformMakeScale(1, 1+ratio);
                transform = CGAffineTransformTranslate(transform, xTranslation, 0);
            }
            break;
        }
            
            
        case 1:
        {
            NSInteger direction = (xTranslation > 0) ? 1 : -1;
            CGFloat angle = direction * M_PI_4 * ratio;
            transform = CGAffineTransformMakeRotation(angle);
            transform = CGAffineTransformTranslate(transform, xTranslation, 0);
        }
            
        case 2:
        {
            //向左
            if (xTranslation < 0)
            {
                transform = CGAffineTransformMakeScale(1, 1+ratio);
                transform = CGAffineTransformTranslate(transform, xTranslation, 0);
            }
            break;
        }
            
        default:
            break;
    }

    return transform;
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
            
        default:
        {
            if ([pan translationInView:self.view].x < -(self.collectionView.bounds.size.width/2)) {
                self.coverflowLayout.currentIndex = (self.coverflowLayout.currentIndex+1)%count;
            } else if ([pan translationInView:self.view].x > (self.collectionView.bounds.size.width/2)) {
                self.coverflowLayout.currentIndex = (self.coverflowLayout.currentIndex+count-1)%count;
            }
            
            [self.collectionView performBatchUpdates:^{
                self.coverflowLayout.xTranslation = 0;
                [self.collectionView reloadData];
            } completion:nil];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.item);
}

@end
