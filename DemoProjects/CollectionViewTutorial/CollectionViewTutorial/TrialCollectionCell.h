//
//  TrialCollectionCell.h
//  CollectionViewTutorial
//
//  Created by JiangWang on 9/2/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrialCollectionCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

/**
 *  Override initWithFrame:
 */
- (instancetype)initWithFrame:(CGRect)frame;

@end
