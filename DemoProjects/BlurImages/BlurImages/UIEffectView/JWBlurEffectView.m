//
//  JWBlurEffectView.m
//  BlurImages
//
//  Created by JiangWang on 2018/8/6.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWBlurEffectView.h"

@interface JWBlurEffectView()
@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation JWBlurEffectView

- (instancetype)initWithFrame:(CGRect)frame
                    blurStyle:(UIBlurEffectStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        _blurStyle = style;
        
        //添加视图
        [self addSubview:self.blurImageView];
        [self addSubview:self.effectView];
//        [self.effectView.contentView addSubview:self.blurImageView];
        
        //约束
        self.effectView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *effectLeft = [NSLayoutConstraint constraintWithItem:self.effectView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0 constant:0];
        NSLayoutConstraint *effectRight = [NSLayoutConstraint constraintWithItem:self.effectView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0 constant:0];
        NSLayoutConstraint *effectTop = [NSLayoutConstraint constraintWithItem:self.effectView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0 constant:0];
        NSLayoutConstraint *effectBottom = [NSLayoutConstraint constraintWithItem:self.effectView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0 constant:0];
        [self addConstraints:@[effectTop, effectLeft, effectBottom, effectRight]];
        
        self.blurImageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *imageLeft = [NSLayoutConstraint constraintWithItem:self.blurImageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0 constant:0];
        NSLayoutConstraint *imageRight = [NSLayoutConstraint constraintWithItem:self.blurImageView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0 constant:0];
        NSLayoutConstraint *imageTop = [NSLayoutConstraint constraintWithItem:self.blurImageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0 constant:0];
        NSLayoutConstraint *imageBottom = [NSLayoutConstraint constraintWithItem:self.blurImageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0 constant:0];
        [self addConstraints:@[imageTop, imageLeft, imageBottom, imageRight]];
    }
    return self;
}

- (void)setContentImage:(UIImage *)contentImage {
    self.blurImageView.image = contentImage;
}

#pragma mark - Lazy Loading
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurStyle];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    return _effectView;
}

- (UIImageView *)blurImageView {
    if (!_blurImageView) {
        _blurImageView = [[UIImageView alloc] init];
        _blurImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _blurImageView;
}

@end
