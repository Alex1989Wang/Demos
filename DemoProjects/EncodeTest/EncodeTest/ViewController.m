//
//  ViewController.m
//  EncodeTest
//
//  Created by JiangWang on 28/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) CALayer *greenLayer;
@property (nonatomic, weak) UIButton *aniButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self greenLayer];
    [self aniButton];
}

- (void)didClickAnimationButton:(UIButton *)aniButton {
    if (_greenLayer) {
        [_greenLayer removeFromSuperlayer];
        _greenLayer = nil;
    }
   
    [self greenLayer];
    self.greenLayer.hidden = YES;
    CAKeyframeAnimation *hiddenAni = [CAKeyframeAnimation animation];
    hiddenAni.duration = 0.1f;
    NSArray *keys = @[@(1), @(0), @(1)];
    NSArray *keyTimes = @[@(0), @(0.9), @(1.0)];
    hiddenAni.keyTimes = keyTimes;
    hiddenAni.values = keys;
    hiddenAni.keyPath = @"hidden";
    [self.greenLayer addAnimation:hiddenAni forKey:@"in_out"];
}

#pragma mark - Lazy Loading 
- (CALayer *)greenLayer {
    if (nil == _greenLayer) {
        CALayer *greenLayer = [[CALayer alloc] init];
        _greenLayer = greenLayer;
        [self.view.layer addSublayer:greenLayer];
        
        greenLayer.frame = self.view.layer.bounds;
        greenLayer.backgroundColor = [UIColor clearColor].CGColor;
        UIImage *sunset = [UIImage imageNamed:@"sunset"];
        greenLayer.contents = (__bridge id _Nullable)(sunset.CGImage);
    }
    return _greenLayer;
}

- (UIButton *)aniButton {
    if (nil == _aniButton) {
        UIButton *animationBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
        _aniButton = animationBtn;
        [self.view addSubview:animationBtn];
        
        animationBtn.frame = CGRectMake(200, 200, 80, 40);
        animationBtn.backgroundColor = [UIColor brownColor];
        [animationBtn addTarget:self
                         action:@selector(didClickAnimationButton:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _aniButton;
}

@end
