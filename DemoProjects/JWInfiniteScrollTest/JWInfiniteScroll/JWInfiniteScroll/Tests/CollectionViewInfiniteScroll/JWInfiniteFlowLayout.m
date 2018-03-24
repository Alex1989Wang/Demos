//
//  JWInfiniteFlowLayout.m
//  JWInfiniteScroll
//
//  Created by JiangWang on 23/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWInfiniteFlowLayout.h"

@interface JWInfiniteFlowLayout()
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *layoutAttribsMap;
@end

@implementation JWInfiniteFlowLayout

#pragma mark - Initialization 
- (instancetype)init {
    self = [super init];
    if (self) {
        _itemSize = (CGSize){50.f, 50.f};
        _minItemSpacing = 0.f;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    //does collection has size
    if (CGRectIsEmpty(self.collectionView.bounds)) {
        return;
    }
    
    //items count
    //pad extra items both start and end
    [self padExtraItems];
    NSInteger itemsCount = [self itemsCount];
    if (!itemsCount) {
        return;
    }
    
    //calculate item attributes;
    _layoutAttribsMap = [NSMutableDictionary dictionaryWithCapacity:itemsCount];
    for (NSInteger item = 0; item < itemsCount; item++) {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *itemAttrib =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        itemAttrib.frame = [self frameForAttributeAtIndexPath:itemIndexPath];
        if (itemAttrib) {
            [_layoutAttribsMap setObject:itemAttrib forKey:itemIndexPath];
        }
    }
    
    // The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
    //set content offset
    CGFloat startOffsetX = _leftPaddedCount * (self.itemSize.width + self.minItemSpacing);
    self.collectionView.contentOffset = (CGPoint){startOffsetX, 0};
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttribs = self.layoutAttribsMap.allValues;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:layoutAttribs.count];
    for (UICollectionViewLayoutAttributes *itemAttrib in layoutAttribs) {
        if (CGRectIntersectsRect(itemAttrib.frame, rect)) {
            [array addObject:itemAttrib];
        }
    }
    return array;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttribsMap[indexPath];
}

- (CGSize)collectionViewContentSize {
    NSInteger itemsCount = [self itemsCount];
    return (CGSize){itemsCount * (self.itemSize.width + self.minItemSpacing),
        self.collectionView.bounds.size.height};
}

#pragma mark - Private
- (NSInteger)itemsCount {
    NSInteger sectionCount = [self.collectionView numberOfSections];
    if (!sectionCount) {
        return 0;
    }
    NSAssert(sectionCount == 1, @"only one section is allowed.");
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    return itemsCount;
}

- (CGRect)frameForAttributeAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemY = (self.collectionView.bounds.size.height - self.itemSize.height) * 0.5;
    CGFloat itemX = (self.itemSize.width + self.minItemSpacing) * indexPath.item;
    return (CGRect){itemX, itemY, self.itemSize.width, self.itemSize.height};
}

- (void)padExtraItems {
    //if original items can't fit into the bounds
    NSInteger itemsCount = self.dataSet.count;
    if (!itemsCount) {
        return;
    }
    CGFloat itemSpan = itemsCount * (self.minItemSpacing + self.itemSize.width) - self.minItemSpacing;
    _itemSpan = itemSpan;
    CGFloat collectionWidth = self.collectionView.bounds.size.width;
    if (itemSpan > collectionWidth) {
        NSInteger oneScreenItemCount = floor(collectionWidth / (self.minItemSpacing + self.itemSize.width));
        _leftPaddedCount = oneScreenItemCount + 1;
        _rightPaddedCount = _leftPaddedCount;
        _minScrollableContentOffsetX = _leftPaddedCount * (self.itemSize.width + self.minItemSpacing) - collectionWidth;
        _maxScrollableContentOffsetX = (_leftPaddedCount + itemsCount) * (self.itemSize.width + self.minItemSpacing) - self.minItemSpacing;
    }
    else {
        NSInteger itemsTotal =
        floor((3 * collectionWidth - itemSpan)/(self.minItemSpacing + self.itemSize.width)) + 2;
        NSInteger itemsPadded = itemsTotal - itemsCount;
        _leftPaddedCount = floor((1 * collectionWidth)/(self.minItemSpacing + self.itemSize.width)) + 1;
        _rightPaddedCount = itemsPadded - _leftPaddedCount;
        _minScrollableContentOffsetX = _leftPaddedCount * (self.itemSize.width + self.minItemSpacing) - collectionWidth;
        _maxScrollableContentOffsetX = (_leftPaddedCount + itemsCount) * (self.itemSize.width + self.minItemSpacing) - self.minItemSpacing;
    }
}

@end
