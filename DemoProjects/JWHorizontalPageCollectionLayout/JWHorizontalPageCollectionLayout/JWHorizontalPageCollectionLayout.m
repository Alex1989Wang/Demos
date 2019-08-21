//
//  JWHorizontalPageCollectionLayout.m
//  JWHorizaontalPageCollectionLayout
//
//  Created by JiangWang on 04/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWHorizontalPageCollectionLayout.h"

#define kDefaultItemSize ((CGSize){50, 50})

@interface JWSectionLayouInfo : NSObject
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger startPageIndex;
@property (nonatomic, assign) NSInteger numberOfItems;
@end
@implementation JWSectionLayouInfo
@end

@interface JWLayoutInfo : NSObject
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger itemsNumPerRow;
@property (nonatomic, assign) NSInteger rowNumPerPage;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, strong) NSArray<JWSectionLayouInfo *> *sections;
@end
@implementation JWLayoutInfo
@end

@interface JWHorizontalPageCollectionLayout()
@property (nonatomic, strong) JWLayoutInfo *layoutInfo;
@property (nonatomic, strong) NSDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *layoutAttributes;
@end

@implementation JWHorizontalPageCollectionLayout
#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpInitialValues];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpInitialValues];
    }
    return self;
}

#pragma mark - Private
- (void)setUpInitialValues {
    _itemSize = kDefaultItemSize;
    _layoutInfo = nil;
}

- (void)calculateLayoutInfos {
    //横竖个数
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    CGFloat actualWidth = CGRectGetWidth(self.collectionView.bounds) -
    contentInsets.left - contentInsets.right;
    CGFloat actualHeight = CGRectGetHeight(self.collectionView.bounds) -
    contentInsets.top - contentInsets.bottom;
    
    NSInteger itemsNumPerRow = (NSInteger)floor(actualWidth / self.itemSize.width);
    NSInteger rowNumPerPage = (NSInteger)floor(actualHeight / self.itemSize.width);
    
    JWLayoutInfo *layouInfo = [[JWLayoutInfo alloc] init];
    layouInfo.itemsNumPerRow = itemsNumPerRow;
    layouInfo.rowNumPerPage = rowNumPerPage;
    
    //校验参数
    if (itemsNumPerRow <= 0 || rowNumPerPage <= 0) {
        NSLog(@"calculate layout info failed.");
        return;
    }
    
    //页数
    NSInteger sectionAmount = [self.collectionView numberOfSections];
    NSInteger numberOfPages = 0;
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionAmount];
    for (NSInteger section = 0; section < sectionAmount; section++) {
        NSInteger sectionItemsNum = [self.collectionView numberOfItemsInSection:section];
        NSInteger sectionPagesNum = (sectionItemsNum + (itemsNumPerRow * rowNumPerPage - 1)) / (itemsNumPerRow * rowNumPerPage);
        
        JWSectionLayouInfo *sectionInfo = [[JWSectionLayouInfo alloc] init];
        sectionInfo.numberOfItems = sectionItemsNum;
        sectionInfo.numberOfPages = sectionPagesNum;
        sectionInfo.startPageIndex = (numberOfPages == 0) ? 0 : (numberOfPages - 1);
        if (sectionInfo) {
            [sections addObject:sectionInfo];
        }
        
        //增加总数
        numberOfPages += sectionPagesNum;
    }
    layouInfo.numberOfPages = numberOfPages;
    layouInfo.sections = sections;
    layouInfo.pageSize = self.collectionView.bounds.size;
    self.layoutInfo = layouInfo;
}

- (void)calculateItemAttributes {
    NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *attributes =
    [NSMutableDictionary dictionary];
    
    //计算gap
    CGFloat interItemSpace = (self.layoutInfo.itemsNumPerRow == 1) ? 0 :
    (self.layoutInfo.pageSize.width - self.itemSize.width * self.layoutInfo.itemsNumPerRow) /
    (self.layoutInfo.itemsNumPerRow - 1);
    CGFloat itemLineSpace = (self.layoutInfo.rowNumPerPage == 1) ? 0 :
    (self.layoutInfo.pageSize.height - self.itemSize.height * self.layoutInfo.rowNumPerPage) /
    (self.layoutInfo.rowNumPerPage - 1);
    
    [self.layoutInfo.sections enumerateObjectsUsingBlock:
     ^(JWSectionLayouInfo * _Nonnull sectionInfo, NSUInteger section, BOOL * _Nonnull stop) {
         for (NSInteger item = 0; item < sectionInfo.numberOfItems; item++) {
             NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
             UICollectionViewLayoutAttributes *itemAttributes =
             [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
             NSInteger columnIndex = [self columnIndexForIndexPath:indexPath];
             CGFloat originX = columnIndex * (interItemSpace + self.itemSize.width);
             CGFloat originY = [self rowIndexForIndexPath:indexPath] * (itemLineSpace + self.itemSize.height);
             itemAttributes.frame = (CGRect){originX, originY, self.itemSize.width, self.itemSize.height};
             
             [attributes setObject:itemAttributes forKey:indexPath];
         }
    }];
    self.layoutAttributes = attributes;
}

- (NSInteger)columnIndexForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    NSParameterAssert(section >= 0 && section < self.layoutInfo.sections.count);
    JWSectionLayouInfo *sectionLayoutInfo = self.layoutInfo.sections[section];
    NSInteger columnBase = sectionLayoutInfo.startPageIndex *
    (self.layoutInfo.rowNumPerPage * self.layoutInfo.itemsNumPerRow);
    NSInteger columnWithinSection = (self.layoutInfo.itemsNumPerRow) *
    (item / (self.layoutInfo.rowNumPerPage * self.layoutInfo.itemsNumPerRow)) +
    item % self.layoutInfo.itemsNumPerRow;
    return (columnBase + columnWithinSection);
}

- (NSInteger)rowIndexForIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = indexPath.item;
    return (item % (self.layoutInfo.itemsNumPerRow * self.layoutInfo.rowNumPerPage))
    / self.layoutInfo.itemsNumPerRow;
}

#pragma mark - Layout APIs
- (void)prepareLayout {
    [super prepareLayout];
    
    //只有collection view具有bounds
    if (CGRectIsEmpty(self.collectionView.bounds)) {
        return;
    }
    
    //计算layout 信息
    [self calculateLayoutInfos];
    
    //计算attributes
    [self calculateItemAttributes];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    [self.layoutAttributes.allValues enumerateObjectsUsingBlock:
     ^(UICollectionViewLayoutAttributes * _Nonnull itemAttrib, NSUInteger idx, BOOL * _Nonnull stop) {
         if (CGRectIntersectsRect(itemAttrib.frame, rect)) {
             [attributes addObject:itemAttrib];
         }
    }];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.layoutAttributes objectForKey:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (CGSize)collectionViewContentSize {
    CGFloat contentHeight = self.layoutInfo.pageSize.height;
    CGFloat contentWidth = self.layoutInfo.pageSize.width * self.layoutInfo.numberOfPages;
    return CGSizeMake(contentWidth, contentHeight);
}

#pragma mark - Accessors
- (UICollectionViewScrollDirection)scrollDirection {
    return UICollectionViewScrollDirectionHorizontal;
}

- (void)setItemSize:(CGSize)itemSize {
    NSParameterAssert(!CGSizeEqualToSize(itemSize, CGSizeZero));
    _itemSize = itemSize;
}

@end
