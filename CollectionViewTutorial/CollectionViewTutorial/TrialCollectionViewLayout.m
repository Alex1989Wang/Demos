//
//  TrialCollectionViewLayout.m
//  CollectionViewTutorial
//
//  Created by JiangWang on 9/2/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TrialCollectionViewLayout.h"
#import "TrialDecorationView.h"


static NSUInteger const kRotationCount = 32;
static NSUInteger const kRotationStride = 3;
static NSUInteger const cellBaseZIndex = 100;

@interface TrialCollectionViewLayout()

@property (nonatomic, strong) NSDictionary *layoutInfo;

@property (nonatomic, strong) NSArray<NSValue *> *rotations;

@end

@implementation TrialCollectionViewLayout

/**
 *  Rewrite Init Methods
 */
- (instancetype)init {
    self = [super init];
    
    if (self) {
        //Initial Values
        [self setupInitialValues];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //Initial Values
        [self setupInitialValues];
    }
    
    return self;
}

- (void)setupInitialValues {
    _itemEdgeInsets = UIEdgeInsetsMake(22.f, 22.f, 13.f, 22.f);
    _interItemYSpacing = 12.f;
    _itemSize = CGSizeMake(125.f, 125.f);
    _numOfColumns = 2;
    _titleHeight = 26.f;
    
    
    NSMutableArray *rotations = [NSMutableArray arrayWithCapacity: kRotationCount];
    
    CGFloat percentage = 0.0f;
    for (NSInteger i = 0; i < kRotationCount; i++) {
        // ensure that each angle is different enough to be seen
        CGFloat newPercentage = 0.0f;
        do {
            newPercentage = ((CGFloat)(arc4random() % 220) - 110) * 0.0001f;
        } while (fabs(percentage - newPercentage) < 0.006);
        percentage = newPercentage;
        
        CGFloat angle = 2 * M_PI * (1.0f + percentage);
        CATransform3D transform = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
        
        [rotations addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    self.rotations = rotations;
    
    [self registerClass:[TrialDecorationView class] forDecorationViewOfKind:TrialCollectionDecorationKindID];
}


/**
 *  Prepare Layout
 */
- (void)prepareLayout {
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfo = [NSMutableDictionary dictionary];
    
    NSUInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSUInteger section  = 0; section < sectionCount; section++) {
        NSUInteger itemsCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSUInteger item = 0; item < itemsCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attribs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attribs.frame = [self frameForItemAtIndexPath:indexPath];
            attribs.transform3D = [self rotationTransformForItemAtIndexPath:indexPath];
            attribs.zIndex = cellBaseZIndex + itemsCount - item;
            
            cellLayoutInfo[indexPath] = attribs;
            
            //Title Attribs
            if (item == 0) { //The first item
                UICollectionViewLayoutAttributes *titleAttribs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:TrialCollectionTitleKindID withIndexPath:indexPath];
                titleAttribs.frame = [self frameForTitleAtIndexPath:indexPath];
                titleLayoutInfo[indexPath] = titleAttribs;
            }
        }
    }
    
    //Decoration Attribs
    UICollectionViewLayoutAttributes *decorationAttribs = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:TrialCollectionDecorationKindID withIndexPath:indexPath];
    decorationAttribs.frame = [self frameFroEmblem];
    newLayoutInfo[TrialCollectionDecorationKindID] = @{indexPath : decorationAttribs};
    
    
    newLayoutInfo[TrialCollectionCellKindID] = cellLayoutInfo;
    newLayoutInfo[TrialCollectionTitleKindID] = titleLayoutInfo;
    _layoutInfo = newLayoutInfo;
}

/**
 *  Calculate Frame For Item At IndexPath
 *  This examples assumes that in every section there is a number of item on top of each other;
 *  Sectioin number == album numbers;
 */
- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
#warning Rethink about this.
    NSUInteger row = indexPath.section / _numOfColumns;
    NSUInteger column = indexPath.section % _numOfColumns;
    
    CGFloat spacingXTotal = self.collectionView.frame.size.width - (_itemEdgeInsets.left + _itemEdgeInsets.right) - _numOfColumns * _itemSize.width;
    CGFloat spacingX = (_numOfColumns > 2) ? (spacingXTotal / (_numOfColumns - 1)) : spacingXTotal;
    CGFloat originX = floorf(_itemEdgeInsets.left + (_itemSize.width + spacingX) * column);
    CGFloat originY = floorf(_itemEdgeInsets.top + (_itemSize.height + _interItemYSpacing + _titleHeight) * row);
    
    return CGRectMake(originX, originY, _itemSize.width, _itemSize.height);
}

- (CGRect)frameForTitleAtIndexPath:(NSIndexPath *)indexPath {
    CGRect frame = [self frameForItemAtIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = _titleHeight;
    return frame;
}

- (CGRect)frameFroEmblem {
    CGSize size = [TrialDecorationView defaultSize];
    CGFloat originX = floorf((self.collectionView.frame.size.width - size.width) * 0.5);
    CGFloat originY = -size.height - 30.f;
    
    return CGRectMake(originX, originY, size.width, size.height);
}


/**
 *  Transform For Item At IndexPath
 */
- (CATransform3D)rotationTransformForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger offset = indexPath.section * kRotationStride + indexPath.item;
    return [_rotations[offset % kRotationCount] CATransform3DValue];
}

/**
 *  Collection Needs Layout Attribs in Rect
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attribsToReturn = [NSMutableArray arrayWithCapacity:_layoutInfo.count];
    
    [_layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *layoutKind, NSDictionary *layouts, BOOL * _Nonnull stop) {

        [layouts enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribs, BOOL * _Nonnull stop) {
            if (CGRectIntersectsRect(attribs.frame, rect)) {
                [attribsToReturn addObject:attribs];
            }
        }];

    }];
    
    return attribsToReturn;
}


/**
 *  Collection View Needs Layout Attribs
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _layoutInfo[TrialCollectionCellKindID][indexPath];
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return _layoutInfo[TrialCollectionTitleKindID][indexPath];
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return _layoutInfo[TrialCollectionDecorationKindID][indexPath];
}


/**
 *  Collection View Asking For Content Size
 */
- (CGSize)collectionViewContentSize {
    NSUInteger rowCount = [self.collectionView numberOfSections] / _numOfColumns;
    if ([self.collectionView numberOfSections] % _numOfColumns) {rowCount++; }
    
    CGFloat height = _itemEdgeInsets.top + rowCount * (_itemSize.height + _titleHeight) + (rowCount - 1) * _interItemYSpacing;
    return CGSizeMake(self.collectionView.frame.size.width, height);
}


/**
 *  Explict Setters To Invalidate the Layout
 */
- (void)setInterItemYSpacing:(CGFloat)interItemYSpacing {
    if (_interItemYSpacing == interItemYSpacing) return;
    
    _interItemYSpacing = interItemYSpacing;
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize {
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;
    
    _itemSize = itemSize;
    [self invalidateLayout];
}

- (void)setNumOfColumns:(NSUInteger)numOfColumns {
    if (_numOfColumns == numOfColumns) return;
    
    _numOfColumns = numOfColumns;
    [self invalidateLayout];
}

- (void)setItemEdgeInsets:(UIEdgeInsets)itemEdgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_itemEdgeInsets, itemEdgeInsets)) return;
    
    _itemEdgeInsets = itemEdgeInsets;
    [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight {
    if (_titleHeight == titleHeight) return;
    
    _titleHeight = titleHeight;
    [self invalidateLayout];
}

@end
