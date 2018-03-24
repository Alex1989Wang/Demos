//
//  JWInfiniteFlowLayout.h
//  JWInfiniteScroll
//
//  Created by JiangWang on 23/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWInfiniteFlowLayout : UICollectionViewLayout
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat minItemSpacing;

@property (nonatomic, assign, readonly) NSInteger leftPaddedCount;
@property (nonatomic, assign, readonly) NSInteger rightPaddedCount;
@property (nonatomic, assign, readonly) CGFloat minScrollableContentOffsetX;
@property (nonatomic, assign, readonly) CGFloat maxScrollableContentOffsetX;
@property (nonatomic, assign, readonly) CGFloat itemSpan;
@property (nonatomic, copy) NSArray *dataSet;
@end
