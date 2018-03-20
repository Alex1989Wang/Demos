//
//  JWTimerWaveView.m
//  JWLayerTest
//
//  Created by JiangWang on 18/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWTimerWaveView.h"

@interface JWTimerWaveView ()
@property (nonatomic, strong) CADisplayLink *waveTimer;
@property (nonatomic, assign) CGFloat currentWaveShift;
@end

@implementation JWTimerWaveView

#pragma mark - Public
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

- (void)setWaveColor:(UIColor *)waveColor {
    [self shapeLayer].fillColor = waveColor.CGColor;
    [self shapeLayer].strokeColor = waveColor.CGColor;
}

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    self.shapeLayer.fillColor = [UIColor blueColor].CGColor;
}

#pragma mark - Override
+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self pauseWavingIfNeeded];
    }
    
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - Private
- (void)incrementSinPathShift {
    self.currentWaveShift += 0.2;
    [self setupSinPathIfNeededWithShift:self.currentWaveShift];
}

- (void)setupSinPathIfNeededWithShift:(CGFloat)pathShift {
    CGRect sinPathCanvasRect = self.shapeLayer.bounds;
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
    self.shapeLayer.path = sinPath.CGPath;
    [CATransaction commit];
}

@end
