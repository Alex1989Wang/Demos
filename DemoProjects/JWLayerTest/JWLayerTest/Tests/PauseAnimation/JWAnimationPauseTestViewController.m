//
//  JWAnimationPauseTestViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 08/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWAnimationPauseTestViewController.h"

@interface JWAnimationPauseTestViewController ()
@property (nonatomic, strong) CALayer *animationLayer;
@property (nonatomic, strong) UIButton *controlButton;
@property (nonatomic, assign, getter=isLayerAnimating) BOOL layerAnimating;
@end

@implementation JWAnimationPauseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _layerAnimating = NO;
    
    //setup the layer used for testing animation
    self.animationLayer.frame = (CGRect){100, 100, 200, 200};
    [self.view.layer addSublayer:self.animationLayer];
    
    //pause and restart button
    UIButton *controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _controlButton = controlBtn;
    [controlBtn setTitle:@"Start Animation" forState:UIControlStateNormal];
    [controlBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [controlBtn addTarget:self
                   action:@selector(didClickAnimationControlButton:)
         forControlEvents:UIControlEventTouchUpInside];
    controlBtn.frame = (CGRect){150, 400, 80, 30};
    controlBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:controlBtn];
}

- (void)didClickAnimationControlButton:(UIButton *)controlBtn {
    if (!self.isLayerAnimating) {
        NSString *animationKey = @"com.jiangwang.sizeAnimation";
        if (![self.animationLayer animationForKey:animationKey]) {
            CABasicAnimation *sizeAnimation = [CABasicAnimation animation];
            sizeAnimation.keyPath = @"bounds.size";
            CGSize currentSize = self.animationLayer.bounds.size;
            sizeAnimation.fromValue = [NSValue valueWithCGSize:currentSize];
            CGSize smallerSize = (CGSize){currentSize.width * 0.5, currentSize.height * 0.5};
            sizeAnimation.toValue = [NSValue valueWithCGSize:smallerSize];
            sizeAnimation.removedOnCompletion = NO;
            sizeAnimation.repeatCount = CGFLOAT_MAX;
            sizeAnimation.duration = 1.5f;
            sizeAnimation.autoreverses = YES;
            [self.animationLayer addAnimation:sizeAnimation forKey:animationKey];
        }
        else {
            self.animationLayer.speed = 1.0;
            CFTimeInterval pausedTimeOffset = self.animationLayer.timeOffset;
            self.animationLayer.timeOffset = 0;
            self.animationLayer.beginTime = 0;
            //set the speed to 1.0 and beginTime to 0; before getting the time
            CFTimeInterval currentTime = CACurrentMediaTime();
            CFTimeInterval timeSincePaused =
            [self.animationLayer convertTime:currentTime fromLayer:nil] - pausedTimeOffset;
            self.animationLayer.beginTime = timeSincePaused;
        }
        self.layerAnimating = YES;
    }
    else {
        //get time first before setting the 'speed' to 0;
        CFTimeInterval currentTime = CACurrentMediaTime();
        CFTimeInterval pausedTime = [self.animationLayer convertTime:currentTime fromLayer:nil];
        self.animationLayer.speed = 0;
        self.animationLayer.timeOffset = pausedTime;
        self.layerAnimating = NO;
    }
}

- (void)setLayerAnimating:(BOOL)layerAnimating {
    if (_layerAnimating != layerAnimating) {
        _layerAnimating = layerAnimating;
        NSString *animationCtrBtnTitle = (layerAnimating) ?
        @"Pause Animation" : @"Start Animation";
        [self.controlButton setTitle:animationCtrBtnTitle forState:UIControlStateNormal];
    }
}

#pragma mark - Lazy Loading 
- (CALayer *)animationLayer {
    if (!_animationLayer) {
        _animationLayer = [CALayer layer];
        _animationLayer.backgroundColor = [UIColor brownColor].CGColor;
    }
    return _animationLayer;
}

@end
