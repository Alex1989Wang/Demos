//
//  JWHorizontalPageCollectionLayout.h
//  JWHorizaontalPageCollectionLayout
//
//  Created by JiangWang on 04/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWHorizontalPageCollectionLayout : UICollectionViewLayout
@property (nonatomic, assign) CGSize itemSize;
//@property (nonatomic, assign) CGFloat minInterItemSpacing;
//@property (nonatomic, assign) CGFloat minItemLineSpacing;
//@property (nonatomic, assign) UIEdgeInsets sectionInset;

// only horizontal is allowed;
@property (nonatomic, assign, readonly) UICollectionViewScrollDirection scrollDirection;

@end
