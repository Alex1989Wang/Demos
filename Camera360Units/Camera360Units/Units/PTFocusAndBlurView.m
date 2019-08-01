//
//  PTFocusAndBlurView.m
//  Camera360
//
//  Created by ZhongXiaoLong on 17/3/11.
//  Copyright © 2017年 Pinguo. All rights reserved.
//

#import "PTFocusAndBlurView.h"

#define kFocusCircleRadius (40*self.mRatio)
#define kFocusFrameSize (kFocusCircleRadius*2 + 4)
#define kCacaHalfWidth (4*self.mRatio)
#define kCacaWidth (14*self.mRatio)
#define kCacaHeight (10*self.mRatio)
#define kDotLength (5*self.mRatio)
#define kSqureWidth (90*self.mRatio)
#define kLensLength (kSqureWidth*0.9)
#define kThumbWidth (4*self.mRatio)
#define kThumbHeight (12*self.mRatio)

@interface PTFocusAndBlurView ()

@property (nonatomic) CGFloat mRatio;
@property (nonatomic) CGPoint mCenterPoint;
@property (nonatomic) CAShapeLayer *mFocusCircleLayer;
@property (nonatomic) CAShapeLayer *mCacaLayer;
@property (nonatomic) CAShapeLayer *mFourDotLayer;

@property (nonatomic) CAShapeLayer *mLeftLayer;
@property (nonatomic) CAShapeLayer *mRightLayer;
@property (nonatomic) CAShapeLayer *mLensLayer;
@property (nonatomic) CAShapeLayer *mThumbLayer;
@property (nonatomic) CAShapeLayer *mBlurLayer;

@property (nonatomic) UIBezierPath *mCirclePath;
@property (nonatomic) UIBezierPath *mSqurePath;
@property (atomic) NSMutableArray *mRunningAnimations;

@end

@implementation PTFocusAndBlurView

@synthesize lensValue = _lensValue;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.mRatio = [UIScreen mainScreen].bounds.size.width/320.0f;
//        self.frame = CGRectMake(0, 0, kFocusFrameSize, kFocusFrameSize);
        self.frame = CGRectMake(50, 80, kFocusFrameSize, kFocusFrameSize);
        self.mCenterPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        self.backgroundColor = [UIColor clearColor];
        self.state = kPTFocusViewState_Manual;
        _mRunningAnimations = [NSMutableArray arrayWithCapacity:3];
        [self initBindings];
        self.lensValue = 0.5;
        self.blurValue = 2;

        //FocusCircleLayer
        self.mCirclePath = [UIBezierPath bezierPathWithArcCenter:self.mCenterPoint radius:kFocusCircleRadius
                                                      startAngle:0 endAngle:M_PI*2 clockwise:0];
        self.mSqurePath = [UIBezierPath bezierPathWithRect:CGRectMake(self.mCenterPoint.x-kSqureWidth/2,
                                                                      self.mCenterPoint.y-kSqureWidth/2, kSqureWidth, kSqureWidth)];
        self.mFocusCircleLayer = [CAShapeLayer layer];
        self.mFocusCircleLayer.path = self.mCirclePath.CGPath;
        self.mFocusCircleLayer.strokeColor = [UIColor yellowColor].CGColor;
        self.mFocusCircleLayer.fillColor = [UIColor clearColor].CGColor;
        self.mFocusCircleLayer.lineWidth = 1.5;
        self.mFocusCircleLayer.frame = self.bounds;
        [self.layer addSublayer:self.mFocusCircleLayer];

        //LensLayer
        UIBezierPath *lensPath = [UIBezierPath bezierPath];
        [lensPath moveToPoint:CGPointMake(self.mCenterPoint.x-kSqureWidth/2, self.mCenterPoint.y+kSqureWidth/4)];
        [lensPath addLineToPoint:CGPointMake(self.mCenterPoint.x+kSqureWidth/2, self.mCenterPoint.y+kSqureWidth/4)];
        self.mLensLayer = [CAShapeLayer layer];
        self.mLensLayer.path = lensPath.CGPath;
        self.mLensLayer.strokeColor = [UIColor yellowColor].CGColor;
        self.mLensLayer.fillColor = [UIColor clearColor].CGColor;
        self.mLensLayer.lineWidth = 0.5;
        self.mLensLayer.frame = self.bounds;
        [self.layer addSublayer:self.mLensLayer];
        [self.mLensLayer removeFromSuperlayer];

        //ThumbLayer
        UIBezierPath *thumbPath = [UIBezierPath bezierPath];
        [thumbPath moveToPoint:CGPointMake(self.mCenterPoint.x-kLensLength/2+kLensLength*self.lensValue,
                                           self.mCenterPoint.y+kSqureWidth/4-kThumbHeight/2)];
        [thumbPath addLineToPoint:CGPointMake(self.mCenterPoint.x-kLensLength/2+kLensLength*self.lensValue,
                                              self.mCenterPoint.y+kSqureWidth/4+kThumbHeight/2)];
        self.mThumbLayer = [CAShapeLayer layer];
        self.mThumbLayer.frame = self.bounds;
        self.mThumbLayer.path = thumbPath.CGPath;
        self.mThumbLayer.lineWidth = kThumbWidth;
        self.mThumbLayer.strokeColor = [UIColor yellowColor].CGColor;
        self.mThumbLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.mThumbLayer];
        [self.mThumbLayer removeFromSuperlayer];

        //CacaLayer
        UIBezierPath *cacaPath = [UIBezierPath bezierPath];
        [cacaPath moveToPoint:CGPointMake(CGRectGetMidX(self.bounds)-(kCacaWidth-kCacaHalfWidth)/2,
                                          CGRectGetMidY(self.bounds)-kCacaHeight/2)];
        [cacaPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds)-kCacaWidth/2,
                                             CGRectGetMidY(self.bounds)-kCacaHeight/2)];
        [cacaPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds)-kCacaWidth/2,
                                             CGRectGetMidY(self.bounds)+kCacaHeight/2)];
        [cacaPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds)-(kCacaWidth-kCacaHalfWidth)/2,
                                             CGRectGetMidY(self.bounds)+kCacaHeight/2)];

        [cacaPath moveToPoint:CGPointMake(CGRectGetMidX(self.bounds)+(kCacaWidth-kCacaHalfWidth)/2,
                                          CGRectGetMidY(self.bounds)-kCacaHeight/2)];
        [cacaPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds)+kCacaWidth/2,
                                             CGRectGetMidY(self.bounds)-kCacaHeight/2)];
        [cacaPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds)+kCacaWidth/2,
                                             CGRectGetMidY(self.bounds)+kCacaHeight/2)];
        [cacaPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds)+(kCacaWidth-kCacaHalfWidth)/2,
                                             CGRectGetMidY(self.bounds)+kCacaHeight/2)];
        self.mCacaLayer = [CAShapeLayer layer];
        self.mCacaLayer.path = cacaPath.CGPath;
        self.mCacaLayer.strokeColor = [UIColor yellowColor].CGColor;
        self.mCacaLayer.fillColor = [UIColor clearColor].CGColor;
        self.mCacaLayer.lineWidth = 1;
        self.mCacaLayer.frame = self.bounds;
        self.mCacaLayer.opacity = 0.8;
        [self.layer addSublayer:self.mCacaLayer];

        //FourDotLayer
        UIBezierPath *fourPath = [UIBezierPath bezierPath];
        [fourPath moveToPoint:CGPointMake(self.mCenterPoint.x, self.mCenterPoint.y-kFocusCircleRadius)];
        [fourPath addLineToPoint:CGPointMake(self.mCenterPoint.x, self.mCenterPoint.y-kFocusCircleRadius+kDotLength)];
        [fourPath moveToPoint:CGPointMake(self.mCenterPoint.x-kFocusCircleRadius, self.mCenterPoint.y)];
        [fourPath addLineToPoint:CGPointMake(self.mCenterPoint.x-kFocusCircleRadius+kDotLength, self.mCenterPoint.y)];
        [fourPath moveToPoint:CGPointMake(self.mCenterPoint.x, self.mCenterPoint.y+kFocusCircleRadius)];
        [fourPath addLineToPoint:CGPointMake(self.mCenterPoint.x, self.mCenterPoint.y+kFocusCircleRadius-kDotLength)];
        [fourPath moveToPoint:CGPointMake(self.mCenterPoint.x+kFocusCircleRadius, self.mCenterPoint.y)];
        [fourPath addLineToPoint:CGPointMake(self.mCenterPoint.x+kFocusCircleRadius-kDotLength, self.mCenterPoint.y)];
        self.mFourDotLayer = [CAShapeLayer layer];
        self.mFourDotLayer.path = fourPath.CGPath;
        self.mFourDotLayer.strokeColor = [UIColor yellowColor].CGColor;
        self.mFourDotLayer.fillColor = [UIColor clearColor].CGColor;
        self.mFourDotLayer.lineWidth = 1;
        self.mFourDotLayer.frame = self.bounds;
        [self.layer addSublayer:self.mFourDotLayer];

        //leftLayer
        UIBezierPath *leftPath = [UIBezierPath bezierPathWithArcCenter:self.mCenterPoint radius:kFocusCircleRadius
                                                            startAngle:1.5*M_PI endAngle:M_PI_2 clockwise:YES];
        self.mLeftLayer = [CAShapeLayer layer];
        self.mLeftLayer.path = leftPath.CGPath;
        self.mLeftLayer.strokeColor = [UIColor yellowColor].CGColor;
        self.mLeftLayer.fillColor = [UIColor clearColor].CGColor;
        self.mLeftLayer.lineWidth = 1.5;
        [self.layer addSublayer:self.mLeftLayer];

        //rightLayer
        UIBezierPath *rightPath = [UIBezierPath bezierPathWithArcCenter:self.mCenterPoint radius:kFocusCircleRadius
                                                             startAngle:M_PI_2 endAngle:1.5*M_PI clockwise:YES];
        self.mRightLayer = [CAShapeLayer layer];
        self.mRightLayer.path = rightPath.CGPath;
        self.mRightLayer.strokeColor = [UIColor yellowColor].CGColor;
        self.mRightLayer.fillColor = [UIColor clearColor].CGColor;
        self.mRightLayer.lineWidth = 1.5;
        [self.layer addSublayer:self.mRightLayer];

        //blurLayer
        UIBezierPath *blurPath = [UIBezierPath bezierPathWithArcCenter:self.mCenterPoint
                                                                radius:kFocusCircleRadius*self.blurValue startAngle:0 endAngle:M_PI*2 clockwise:0];
        self.mBlurLayer = [CAShapeLayer layer];
        self.mBlurLayer.path = blurPath.CGPath;
        self.mBlurLayer.strokeColor = [UIColor yellowColor].CGColor;
        self.mBlurLayer.fillColor = [UIColor clearColor].CGColor;
        self.mBlurLayer.lineWidth = 0.8;
        self.mBlurLayer.lineDashPattern = @[@10, @10];
    }
    return self;
}


- (void)initBindings
{
//    @WS
//    RACSignal *racSignal = RACObserve(self, blurValue);
//    RAC(self, outerCircleRadius) = [RACSafeOnce(racSignal) map:^id(id value) {
//        @SS
//        return [NSNumber numberWithDouble:kFocusCircleRadius * self.blurValue];
//    }];
}

#pragma mark - getter and setter

- (CGFloat)lensLength
{
    return kLensLength;
}

- (CGFloat)lensValue
{
    return _lensValue;
}

- (void)setLensValue:(CGFloat)lensValue
{
    lensValue = MAX(0, lensValue);
    lensValue = MIN(lensValue, 1);
    _lensValue = lensValue;
//    PGLogDebug(@"lensValue = %f", lensValue);
    [self updateThumbPosition];
}

- (void)setBlurValue:(CGFloat)blurValue
{
    blurValue = MAX(2, blurValue);
    blurValue = MIN(blurValue, 5.5);
    _blurValue = blurValue;
    [self updateBlur];
}

- (void)setState:(PTFocusViewState)state
{
    _state = state;

    if (self.stateChangeBlock)
    {
        self.stateChangeBlock(state);
    }
}

#pragma mark - help method

- (void)updateThumbPosition
{
    self.thumbLocation = CGPointMake(self.mCenterPoint.x-kLensLength/2+kLensLength*self.lensValue,
                                     self.mCenterPoint.y+kLensLength/4);
    UIBezierPath *thumbPath = [UIBezierPath bezierPath];

    [thumbPath moveToPoint:CGPointMake(self.mCenterPoint.x-kLensLength/2+kLensLength*self.lensValue,
                                       self.mCenterPoint.y+kSqureWidth/4-kThumbHeight/2)];
    [thumbPath addLineToPoint:CGPointMake(self.mCenterPoint.x-kLensLength/2+kLensLength*self.lensValue,
                                          self.mCenterPoint.y+kSqureWidth/4+kThumbHeight/2)];
    self.mThumbLayer.path = thumbPath.CGPath;
}

- (void)updateBlur
{
    UIBezierPath *blurPath = [UIBezierPath bezierPathWithArcCenter:self.mCenterPoint
                                                            radius:kFocusCircleRadius*self.blurValue startAngle:0 endAngle:M_PI*2 clockwise:0];
    self.mBlurLayer.path = blurPath.CGPath;
}


#pragma mark - animation method

- (void)resetViews
{
    self.state = kPTFocusViewState_Manual;
    [self.mLensLayer removeFromSuperlayer];
    [self.mThumbLayer removeFromSuperlayer];
    [self.mLeftLayer removeFromSuperlayer];
    [self.mRightLayer removeFromSuperlayer];
    [self.mBlurLayer removeFromSuperlayer];
    self.mFocusCircleLayer.path = self.mCirclePath.CGPath;
    [self.layer addSublayer:self.mFocusCircleLayer];
    [self.layer addSublayer:self.mFourDotLayer];
    [self.layer addSublayer:self.mCacaLayer];
}

- (void)manualFocusAnimation
{
    [self.mRunningAnimations removeAllObjects];
    [self.mFocusCircleLayer removeAllAnimations];
    [self.mCacaLayer removeAllAnimations];
    [self.mFourDotLayer removeAllAnimations];
    [self.layer removeAllAnimations];
    self.state = kPTFocusViewState_Manual;
    self.mFocusCircleLayer.path = self.mCirclePath.CGPath;
    [self.mLensLayer removeFromSuperlayer];
    [self.mThumbLayer removeFromSuperlayer];
    [self.mLeftLayer removeFromSuperlayer];
    [self.mRightLayer removeFromSuperlayer];
    [self.mBlurLayer removeFromSuperlayer];
    [self.layer addSublayer:self.mFocusCircleLayer];
    [self.layer addSublayer:self.mFourDotLayer];
    [self.layer addSublayer:self.mCacaLayer];

    [CATransaction begin];

    //Animation for cacaLayer
    CAKeyframeAnimation *cacaOpacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    cacaOpacity.values = @[@1, @1, @1, @0.4];
    cacaOpacity.keyTimes = @[@0, @(2.0/7), @(3.0/7), @1];
    cacaOpacity.duration = 7.0/20;
    [self.mCacaLayer addAnimation:cacaOpacity forKey:@"caca"];

    //Animation for focusCircle
    CAKeyframeAnimation *focusCircleScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    focusCircleScale.values = @[@1.5, @1];
    focusCircleScale.keyTimes = @[@0, @1];
    
    CAKeyframeAnimation *focusCircleOpacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    focusCircleOpacity.values = @[@0.3, @1];
    focusCircleOpacity.keyTimes = @[@0, @1];

    CAAnimationGroup *outerGroup = [CAAnimationGroup animation];
    outerGroup.animations = @[focusCircleScale, focusCircleOpacity];
    outerGroup.duration = 2.0/20;

    [self.mFocusCircleLayer addAnimation:outerGroup forKey:@"beginToFocus"];

    CAKeyframeAnimation *fourDotAinmation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fourDotAinmation.values = @[@0, @0, @0.1, @1];
    fourDotAinmation.keyTimes = @[@0, @(2.0/7), @(3.0/7), @1];
    fourDotAinmation.duration = 7.0/20 ;
    [self.mFourDotLayer addAnimation:fourDotAinmation forKey:@"fourDot"];

    [CATransaction commit];
}

- (void)autoFocusAnimation
{
    [self.mRunningAnimations removeAllObjects];
    [self.mCacaLayer removeAllAnimations];
    self.state = kPTFocusViewState_Auto;
    [self.mLensLayer removeFromSuperlayer];
    [self.mThumbLayer removeFromSuperlayer];
    [self.mLeftLayer removeFromSuperlayer];
    [self.mRightLayer removeFromSuperlayer];
    [self.mFourDotLayer removeFromSuperlayer];
    [self.mBlurLayer removeFromSuperlayer];
    [self.layer addSublayer:self.mFocusCircleLayer];
    [self.layer addSublayer:self.mFourDotLayer];
    [self.layer addSublayer:self.mCacaLayer];
    self.mFocusCircleLayer.path = self.mCirclePath.CGPath;
    [CATransaction begin];

    CAKeyframeAnimation *cacaOpacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    cacaOpacity.values = @[@0, @1, @1, @0.4];
    cacaOpacity.keyTimes = @[@0, @(5.0/10), @(8.0/10), @1];
    cacaOpacity.duration = 0.5;
    [self.mCacaLayer addAnimation:cacaOpacity forKey:@"cacao"];

    CAKeyframeAnimation *circleScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    circleScale.values = @[@2, @0.9, @1.05, @1];
    circleScale.keyTimes = @[@0, @(5.0/10), @(8.0/10), @1];

    CAKeyframeAnimation *circleLineWidth = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    circleLineWidth.values = @[@0.5, @1.5, @1, @1.5];
    circleLineWidth.keyTimes = @[@0, @(5.0/10), @(8.0/10), @1];

    CAKeyframeAnimation *circleOpacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    circleOpacity.values = @[@0, @1, @1, @1];
    circleOpacity.keyTimes = @[@0, @(5.0/10), @(8.0/10), @1];

    CAAnimationGroup *circleGroup = [CAAnimationGroup animation];
    circleGroup.animations = @[circleScale, circleLineWidth, circleOpacity];
    circleGroup.duration = 0.5;
    [self.mFocusCircleLayer addAnimation:circleGroup forKey:@"AutoFocus"];

    CAKeyframeAnimation *fourDotAinmation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fourDotAinmation.values = @[@0, @0, @0.1, @1];
    fourDotAinmation.keyTimes = @[@0, @(5.0/10), @(8.0/10), @1];
    fourDotAinmation.duration = 0.5 ;
    [self.mFourDotLayer addAnimation:fourDotAinmation forKey:@"fourDoto"];


    [CATransaction commit];
}

- (void)longPressAnimation
{
    [self.mRunningAnimations removeAllObjects];
    [self.mFocusCircleLayer removeFromSuperlayer];
    [self.mFourDotLayer removeFromSuperlayer];
    [self.mLensLayer removeFromSuperlayer];
    [self.mThumbLayer removeFromSuperlayer];
    [self.mBlurLayer removeFromSuperlayer];
    [self.layer addSublayer:self.mCacaLayer];
    [self.layer addSublayer:self.mLeftLayer];
    [self.layer addSublayer:self.mRightLayer];
    CABasicAnimation *leftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    leftAnimation.duration = 0.5;
    leftAnimation.fromValue = @0;
    leftAnimation.toValue = @1;
    [self.mLeftLayer addAnimation:leftAnimation forKey:@"strokeEnd"];

    //    CABasicAnimation *leftScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    leftScale.duration = 0.5;
    //    leftScale.fromValue = @1.2;
    //    leftScale.toValue = @1;
    //    [self.mLeftLayer addAnimation:leftScale forKey:@"leftScale"];

    CABasicAnimation *leftWidth = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    leftWidth.duration = 0.5;
    leftWidth.fromValue = @0.5;
    leftWidth.toValue = @1.5;
    [self.mLeftLayer addAnimation:leftWidth forKey:@"leftWidth"];

    CABasicAnimation *rightAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rightAnimation.duration = 0.5;
    rightAnimation.fromValue = @0;
    rightAnimation.toValue = @1;
    [self.mRightLayer addAnimation:rightAnimation forKey:@"strokeEnd"];

    //    CABasicAnimation *rightScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    rightScale.duration = 0.5;
    //    rightScale.fromValue = @1.2;
    //    rightScale.toValue = @1;
    //    [self.mRightLayer addAnimation:rightScale forKey:@"rightScale"];

    CABasicAnimation *rightWidth = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    rightWidth.duration = 0.5;
    rightWidth.fromValue = @0.5;
    rightWidth.toValue = @1.5;
    [self.mRightLayer addAnimation:rightWidth forKey:@"rightWidth"];
}

- (void)lockFocusAnimationWithLens:(BOOL)lens withBlur:(BOOL)blur completion:(void (^)(void))completion
{
    
    NSLog(@"lens: %@ -- blur: %@", @(lens), @(blur));

    [self.mRunningAnimations removeAllObjects];
    if (blur)
    {
        self.state = kPTFocusViewState_Lock_Blur;
    }
    else
    {
        self.state = kPTFocusViewState_Lock;
    }
    self.mFocusCircleLayer.path = self.mCirclePath.CGPath;
    [self.mLeftLayer removeFromSuperlayer];
    [self.mRightLayer removeFromSuperlayer];
    [self.mFourDotLayer removeFromSuperlayer];
    [self.mLensLayer removeFromSuperlayer];
    [self.mThumbLayer removeFromSuperlayer];

    [self.layer addSublayer:self.mCacaLayer];
    [self.layer addSublayer:self.mFocusCircleLayer];


    //本动画由3组动画串行顺次执行
    [CATransaction begin];
    //第一组动画结束，开始播放第二组动画
    [CATransaction setCompletionBlock:^{
        if (![self.mRunningAnimations containsObject:@"lockBreath"])
        {
            return ;
        }
        else
        {
            [self.mRunningAnimations removeObject:@"lockBreath"];
        }
        [self.mCacaLayer removeFromSuperlayer];
        self.mFocusCircleLayer.path = self.mSqurePath.CGPath;

        [CATransaction begin];
        //第二组动画结束，开始播放第三组动画
        [CATransaction setCompletionBlock:^{
            if (![self.mRunningAnimations containsObject:@"changeToSqure"])
            {
                return ;
            }
            else
            {
                [self.mRunningAnimations removeObject:@"changeToSqure"];
            }


            [CATransaction begin];
            //第三组动画结束
            [CATransaction setCompletionBlock:^{
                

                if (completion) {
                    completion();
                }
                if (![self.mRunningAnimations containsObject:@"lockSqureBreath"])
                {
                    return ;
                }
                else
                {
                    [self.mRunningAnimations removeObject:@"lockSqureBreath"];
                }

                //                if (lens)
                //                {
                //                    [self.layer addSublayer:self.mLensLayer];
                //                    [self.layer addSublayer:self.mThumbLayer];
                //                }
                //
                //                if (blur)
                //                {
                //                    [self.layer addSublayer:self.mBlurLayer];
                //                }
            }];

            //定义第三组动画
            //            CAKeyframeAnimation *squreScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            //            squreScale.values = @[@1.2, @0.9, @1];
            //            squreScale.keyTimes = @[@0, @(6/10.0), @1];
            //            CAKeyframeAnimation *squreLineWidth = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
            //            squreLineWidth.values = @[@0.25, @0.7, @1];
            //            squreLineWidth.keyTimes = @[@0, @(6/10.0), @1];
            //            CAAnimationGroup *squreGroup = [CAAnimationGroup animation];
            //            squreGroup.animations = @[squreScale, squreLineWidth];
            //            squreGroup.duration = 10/24.0;
            //            [self.mFocusCircleLayer addAnimation:squreGroup forKey:@"lockSqureBreath"];
            //            [self.mRunningAnimations addObject:@"lockSqureBreath"];
            [CATransaction commit];
        }];

        //定义第二组动画
        CABasicAnimation *toSqure = [CABasicAnimation animationWithKeyPath:@"path"];
        CGFloat width = kSqureWidth;
        CGFloat width2 = kSqureWidth;
        UIBezierPath *circlePath = [UIBezierPath
                                    bezierPathWithRoundedRect:CGRectMake(self.mCenterPoint.x-width/2,
                                                                         self.mCenterPoint.y-width/2, width, width) cornerRadius:width/2];
        UIBezierPath *squrePath = [UIBezierPath
                                   bezierPathWithRoundedRect:CGRectMake(self.mCenterPoint.x-width2/2,
                                                                        self.mCenterPoint.y-width2/2, width2, width2) cornerRadius:1];
        toSqure.fromValue = (__bridge id)circlePath.CGPath;
        toSqure.toValue = (__bridge id)squrePath.CGPath;
        toSqure.duration = 0.15;
        toSqure.fillMode = kCAFillModeForwards;
        [self.mFocusCircleLayer addAnimation:toSqure forKey:@"changeToSqure"];
        [self.mRunningAnimations addObject:@"changeToSqure"];

        if (lens)
        {
            [self.layer addSublayer:self.mLensLayer];
            [self.layer addSublayer:self.mThumbLayer];

            CABasicAnimation *thumbScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            thumbScale.duration = 0.15;
            thumbScale.fromValue = @0;
            thumbScale.toValue = @1;
            [self.mThumbLayer addAnimation:thumbScale forKey:@"thumbScale"];

            CABasicAnimation *thumbOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            thumbOpacity.duration = 0.15;
            thumbOpacity.fromValue = @0;
            thumbOpacity.toValue = @1;
            [self.mThumbLayer addAnimation:thumbOpacity forKey:@"thumbOpacity"];

            CABasicAnimation *lensScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            lensScale.duration = 0.15;
            lensScale.fromValue = @0;
            lensScale.toValue = @1;
            [self.mLensLayer addAnimation:lensScale forKey:@"lensScale"];

            CABasicAnimation *lensOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            lensOpacity.duration = 0.15;
            lensOpacity.fromValue = @0;
            lensOpacity.toValue = @1;
            [self.mLensLayer addAnimation:lensOpacity forKey:@"lensOpacity"];
        }

        if (blur)
        {
            [self.layer addSublayer:self.mBlurLayer];
        }
        [CATransaction commit];
    }];

    //定义第一组动画
    CAKeyframeAnimation *circleScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    circleScale.values = @[@1, @1];
    circleScale.keyTimes = @[@0, @1];
    CAKeyframeAnimation *circleLineWidth = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    circleLineWidth.values = @[@1.5, @2];
    circleLineWidth.keyTimes = @[@0, @1];
    CAAnimationGroup *circleGroup = [CAAnimationGroup animation];
    circleGroup.animations = @[circleScale, circleLineWidth];
    circleGroup.duration = 0.15;
    [self.mFocusCircleLayer addAnimation:circleGroup forKey:@"lockBreath"];
    [self.mRunningAnimations addObject:@"lockBreath"];
    [CATransaction commit];
}

- (void)showBlurView
{
    //    self.state = kPGFocusViewState_Blur;
    //    self.blurState = YES;
    self.mFocusCircleLayer.path = self.mCirclePath.CGPath;
    [self.mLensLayer removeFromSuperlayer];
    [self.mThumbLayer removeFromSuperlayer];
    [self.mFourDotLayer removeFromSuperlayer];
    [self.mLeftLayer removeFromSuperlayer];
    [self.mRightLayer removeFromSuperlayer];
    [self addBlurCircle];
//    [self.layer addSublayer:self.mFocusCircleLayer];
//    [self.layer addSublayer:self.mCacaLayer];
    
    
}

- (void)animateSmall
{
    [self.mFocusCircleLayer removeAllAnimations];
    [self.mCacaLayer removeAllAnimations];
    [self.mFourDotLayer removeAllAnimations];
    [self.layer removeAllAnimations];
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeScale(0.65, 0.65);
    }];
}

- (void)animateNormal
{
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)setBlurState:(BOOL)blurState
{
    _blurState = blurState;
    if (!blurState)
    {
        [self.mBlurLayer removeFromSuperlayer];
    }
}

- (void)addBlurCircle
{
    if (![self.layer.sublayers containsObject:self.mBlurLayer])
    {
        [self.layer addSublayer:self.mBlurLayer];
    }
}

- (void)removeBlurCircle
{
    if ([self.layer.sublayers containsObject:self.mBlurLayer])
    {
        [self.mBlurLayer removeFromSuperlayer];
    }
}

- (CGFloat)innerCircleRadius
{
    return kFocusCircleRadius;
}

- (CGFloat)halfSqureWidth
{
    return kSqureWidth/2.0;
}


@end
