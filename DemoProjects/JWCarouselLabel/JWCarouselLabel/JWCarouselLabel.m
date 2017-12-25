//
//  JWCarouselLabel.m
//  JWCarouselLabel
//
//  Created by JiangWang on 01/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWCarouselLabel.h"

static const NSInteger kCarouselAnimationLineNumber = 1;

@interface JWCarouselLabel()
@property (nonatomic, strong) NSTimer *repeatTimer;
@property (nonatomic, assign, getter=shouldAutoAnimate) BOOL autoAnimate;
@property (nonatomic, assign) CGRect currentTextRect;
@property (nonatomic, assign) NSInteger secondsPerRound;
@property (nonatomic, assign) CGFloat drawInterval;
@property (nonatomic, assign) CGFloat accumulatedMoved;
@end

@implementation JWCarouselLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _secondsPerRound = 1;
        _autoAnimate = NO;
        _drawInterval = 0.1;
        _accumulatedMoved = 0;
    }
    return self;
}


#pragma mark - Private
- (void)autoStartAnimationIfNeeded {
    if (!_autoAnimate) {
        _autoAnimate = YES;
    }
}

- (void)stopCarouselAnimation {
    self.autoAnimate = NO;
}

- (void)animateTextMovement:(NSTimer *)timer {
    CGRect labelBounds = self.bounds;
//    if (labelBounds.size.width < self.currentTextRect.size.width) {
//        //移动
//        NSInteger ticks = ceilf(self.secondsPerRound * 1.0 / self.drawInterval);
//        CGFloat moveInterval = (self.currentTextRect.size.width - labelBounds.size.width) / ticks;
//        self.accumulatedMoved += moveInterval;
//    }
    self.accumulatedMoved += 3;
    if (self.accumulatedMoved + labelBounds.size.width >= self.currentTextRect.size.width) {
        self.accumulatedMoved = 0;
    }
}

#pragma mark - Accessors
- (void)setAccumulatedMoved:(CGFloat)accumulatedMoved {
    if (_accumulatedMoved != accumulatedMoved) {
        _accumulatedMoved = accumulatedMoved;
        [self setNeedsDisplay];
    }
}

- (CGRect)currentTextRect {
    if (CGRectIsEmpty(_currentTextRect)) {
        [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    }
    return _currentTextRect;
}

#pragma mark - Override Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.autoAnimate) {
        self.repeatTimer =
        [NSTimer scheduledTimerWithTimeInterval:self.drawInterval
                                         target:self
                                       selector:@selector(animateTextMovement:)
                                       userInfo:nil
                                        repeats:YES];
    }
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    if (numberOfLines == kCarouselAnimationLineNumber) {
        [self autoStartAnimationIfNeeded];
    }
    else {
        [self stopCarouselAnimation];
    }
}

- (void)drawTextInRect:(CGRect)rect {
    CGRect moveRect = rect;
    moveRect.origin.x -= self.accumulatedMoved;
    moveRect.size.width = self.currentTextRect.size.width;
    [super drawTextInRect:moveRect];
}

- (CGRect)textRectForBounds:(CGRect)bounds
     limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect unlimitedWidthBounds = bounds;
    unlimitedWidthBounds.size.width = CGFLOAT_MAX;
    CGRect textRect = [super textRectForBounds:unlimitedWidthBounds
                        limitedToNumberOfLines:self.numberOfLines];
    self.currentTextRect = textRect;
    return textRect;
}

@end
