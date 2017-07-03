//
//  NewTestViewController.m
//  LayerTest
//
//  Created by JiangWang on 17/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "NewTestViewController.h"

@interface NewTestViewController ()
<CALayerDelegate>

@property (nonatomic, weak) UIView *layerView;
@property (nonatomic, weak) CALayer *testLayer;
@property (nonatomic, weak) UIButton *controlButton;
@end

@implementation NewTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //lazy loading
    [self layerView];
    
    //add test layer
    [self testLayer];
    [self.testLayer setNeedsDisplay];
    
    //add control button
    [self controlButton];
    
    //color action
    [self testLayerAction];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSetLineWidth(ctx, 10.f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)testLayerAction {
    CATransition *colorTrans = [[CATransition alloc] init];
    self.testLayer.actions = @{@"backgroundColor":colorTrans};
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CATransaction begin];
        [CATransaction setAnimationDuration:2.f];
        __strong typeof(weakSelf) strSelf = weakSelf;
        strSelf.testLayer.backgroundColor = [UIColor brownColor].CGColor;
        [CATransaction commit];
    });
}

- (void)startOrPauseAnimation:(UIButton *)controlBtn {
    if (fpclassify(self.testLayer.speed) == FP_ZERO) {
        self.testLayer.speed = 1.0;
    }
    else {
        self.testLayer.speed = 0.0;
        self.testLayer.backgroundColor = self.testLayer.presentationLayer.backgroundColor;
    }
}

#pragma mark - Lazy Loading
- (UIView *)layerView {
    if (nil == _layerView) {
        UIView *layerView = [[UIView alloc] init];
        _layerView = layerView;
        [self.view addSubview:layerView];
        
        CGRect layerViewFrame = CGRectInset(self.view.bounds, 50, 50);
        layerView.frame = layerViewFrame;
    }
    return _layerView;
}

- (CALayer *)testLayer {
    if (_testLayer == nil) {
        CALayer *testLayer = [CALayer layer];
        _testLayer = testLayer;
        [self.layerView.layer addSublayer:testLayer];
        
        testLayer.speed = 0;
        testLayer.delegate = self;
        testLayer.backgroundColor = [UIColor blueColor].CGColor;
        testLayer.frame = CGRectInset(self.layerView.bounds, 20, 20);
    }
    return _testLayer;
}

- (UIButton *)controlButton {
    if (nil == _controlButton) {
        UIButton *controlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _controlButton = controlButton;
        [self.view addSubview:controlButton];
        
        controlButton.frame = (CGRect){100, 50, 80, 40};
        [controlButton addTarget:self
                          action:@selector(startOrPauseAnimation:)
                forControlEvents:UIControlEventTouchUpInside];
        [controlButton setTitle:@"start & pause" forState:UIControlStateNormal];
        [controlButton setBackgroundColor:[UIColor greenColor]];
    }
    return _controlButton;
}

@end
