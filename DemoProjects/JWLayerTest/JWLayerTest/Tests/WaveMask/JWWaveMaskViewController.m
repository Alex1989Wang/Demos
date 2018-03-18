//
//  JWWaveEffectTestViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 18/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWWaveEffectTestViewController.h"

@interface JWWaveEffectTestViewController ()
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) CAShapeLayer *sinLayer;
@property (nonatomic, strong) CADisplayLink *waveTimer;
@property (nonatomic, assign) CGFloat currentWaveShift;
@end

@implementation JWWaveEffectTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    //add a avatar view
    self.avatarView.frame = (CGRect){80, 200, 100, 100};
    self.avatarView.image = [UIImage imageNamed:@"ic_broadcast_receive"];
    self.avatarView.layer.cornerRadius = 100 * 0.5;
    self.avatarView.layer.masksToBounds = YES;
    [self.view addSubview:self.avatarView];

    //add sinpath layer
    _currentWaveShift = 0;
    self.sinLayer.strokeColor = [UIColor blueColor].CGColor;
    self.sinLayer.fillColor = [UIColor blueColor].CGColor;
    CGRect avatarRect = self.avatarView.bounds;
    CGRect layerRect = (CGRect){0, CGRectGetMidY(avatarRect),
        CGRectGetWidth(avatarRect), CGRectGetHeight(avatarRect) * 0.5};
    self.sinLayer.frame = layerRect;
    [self.avatarView.layer addSublayer:self.sinLayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //start wave effect if needed;
    [self startWavingIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //pause waving if needed;
    [self pauseWavingIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect avatarRect = self.avatarView.bounds;
    CGRect layerRect = (CGRect){0, CGRectGetMidY(avatarRect),
        CGRectGetWidth(avatarRect), CGRectGetHeight(avatarRect) * 0.5};
    self.sinLayer.frame = layerRect;
    [self setupSinPathIfNeededWithShift:0.f];
}

#pragma mark - Private
- (void)startWavingIfNeeded {
    if (self.waveTimer && !self.waveTimer.paused) {
        return;
    }
    
    [self.waveTimer invalidate];
    self.waveTimer =
    [CADisplayLink displayLinkWithTarget:self
                                selector:@selector(incrementSinPathShift)];
    NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
    [self.waveTimer addToRunLoop:mainRunLoop
                         forMode:NSRunLoopCommonModes];
}

- (void)pauseWavingIfNeeded {
    [self.waveTimer invalidate];
    self.waveTimer = nil;
}

- (void)incrementSinPathShift {
    self.currentWaveShift += 0.2;
    [self setupSinPathIfNeededWithShift:self.currentWaveShift];
}

- (void)setupSinPathIfNeededWithShift:(CGFloat)pathShift {
    CGRect sinPathCanvasRect = self.sinLayer.bounds;
    sinPathCanvasRect = CGRectIntegral(sinPathCanvasRect);
    if (CGRectIsEmpty(sinPathCanvasRect)) {
        return;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGFloat canvasWidth = sinPathCanvasRect.size.width;
    CGFloat canvasHeight = sinPathCanvasRect.size.height;
    CGFloat canvasMidY = CGRectGetMidY(sinPathCanvasRect);
    UIBezierPath *sinPath = [UIBezierPath bezierPath];
    sinPath.lineWidth = 1.f;
    CGFloat yPos = 0;
    for (CGFloat xPos = 0.f; xPos <= canvasWidth; xPos += 1.f) {
        yPos = canvasMidY + sin((xPos + pathShift)/canvasWidth * M_PI * 2) * canvasHeight / 8; //one-eighth
        if (fpclassify(xPos) == FP_ZERO) {
            [sinPath moveToPoint:(CGPoint){xPos, yPos}];
        }
        else {
            [sinPath addLineToPoint:(CGPoint){xPos, yPos}];
        }
    }
    
    //close path
    [sinPath addLineToPoint:(CGPoint){canvasWidth, canvasHeight}];
    [sinPath addLineToPoint:(CGPoint){0, canvasHeight}];
    [sinPath closePath];
    self.sinLayer.path = sinPath.CGPath;
    [CATransaction commit];
}

#pragma mark - Lazy Loading 
- (CAShapeLayer *)sinLayer {
    if (!_sinLayer) {
        _sinLayer = [CAShapeLayer layer];
    }
    return _sinLayer;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
    }
    return _avatarView;
}

@end
