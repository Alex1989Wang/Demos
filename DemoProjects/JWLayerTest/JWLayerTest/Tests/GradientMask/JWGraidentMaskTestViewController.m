//
//  JWGraidentMaskTestViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 07/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWGraidentMaskTestViewController.h"

@interface JWGraidentMaskTestViewController ()
@property (nonatomic, strong) CAGradientLayer *gradientMask;
@end

@implementation JWGraidentMaskTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupGradientMaskIfNeeded];
}

- (void)setupGradientMaskIfNeeded {
    //set up a gradient layer as the view's layer's mask
    if (!_gradientMask && !CGRectEqualToRect(CGRectZero, self.view.bounds)) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _gradientMask = [CAGradientLayer layer];
        _gradientMask.shouldRasterize = YES;
        _gradientMask.rasterizationScale = [UIScreen mainScreen].scale;
        _gradientMask.startPoint = (CGPoint){0.5, 0};
        _gradientMask.endPoint = (CGPoint){0.5, 1.0};
        CGColorRef blackColor = [UIColor blackColor].CGColor;
        CGColorRef clearColor = [UIColor clearColor].CGColor;
        _gradientMask.locations = @[@(0), @(0.2), @(0.8), @(1.0)];
        _gradientMask.colors = @[(__bridge id)clearColor, (__bridge id)blackColor, (__bridge id)blackColor, (__bridge id)clearColor];
        _gradientMask.frame = self.view.layer.bounds;
        self.view.layer.mask = _gradientMask;
        [CATransaction commit];
    }
}

@end
