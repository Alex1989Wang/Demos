//
//  PTHomeTopTabBar.m
//  Partner
//
//  Created by JiangWang on 13/08/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "PTHomeTopTabBar.h"

@implementation PTHomeTopTabBar
#pragma mark - Initialization 
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView.bounces = NO;
    }
    return self;
}

@end


@interface PTHomeTopTabBarCell()
@property (nonatomic, strong) UIImageView *cellImageView;
@end

@implementation PTHomeTopTabBarCell

#pragma mark - Initialization 
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self cellImageView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self cellImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cellImageView.frame = self.contentView.bounds;
}

#pragma mark - TYTabPagerBarCellProtocol
//不需要
- (UILabel *)titleLabel {
    return nil;
}

#pragma mark - Lazy Loading 
- (UIImageView *)cellImageView {
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_cellImageView];
    }
    return _cellImageView;
}

@end
