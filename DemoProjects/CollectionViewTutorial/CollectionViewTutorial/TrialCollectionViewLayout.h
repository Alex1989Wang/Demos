//
//  TrialCollectionViewLayout.h
//  CollectionViewTutorial
//
//  Created by JiangWang on 9/2/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const TrialCollectionCellKindID = @"TrialCollectionCellKindID";
static NSString *const TrialCollectionTitleKindID = @"TrialCollectionTitleKindID";
static NSString *const TrialCollectionDecorationKindID = @"TrialCollectionDecorationKindID";

@interface TrialCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) UIEdgeInsets itemEdgeInsets;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGFloat interItemYSpacing;

@property (nonatomic, assign) NSUInteger numOfColumns;

@property (nonatomic, assign) CGFloat titleHeight;

@end
