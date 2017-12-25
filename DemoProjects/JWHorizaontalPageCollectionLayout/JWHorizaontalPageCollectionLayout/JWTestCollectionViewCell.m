//
//  JWTestCollectionViewCell.m
//  JWHorizaontalPageCollectionLayout
//
//  Created by JiangWang on 04/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWTestCollectionViewCell.h"
@interface JWTestCollectionViewCell()
@property (nonatomic, weak) UILabel *contentLabel;
@end

@implementation JWTestCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor brownColor];
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
        _contentLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentLabel.frame = self.contentView.bounds;
}
@end
