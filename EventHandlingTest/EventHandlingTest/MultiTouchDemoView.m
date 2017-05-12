//
//  MultiTouchDemoView.m
//  EventHandlingTest
//
//  Created by JiangWang on 12/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "MultiTouchDemoView.h"

@interface TouchIndicatorView : UIView
@property (nonatomic, strong) id userInfo;
@end

@implementation TouchIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds {
    if (!CGRectEqualToRect(self.bounds, bounds)) {
        [super setBounds:bounds];
        self.layer.cornerRadius = 0.5 * bounds.size.height;
    }
}

@end


@interface MultiTouchDemoView()
@property (nonatomic, strong) NSMutableArray<TouchIndicatorView *> *touchViews;
@end

@implementation MultiTouchDemoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = YES;
    }
    return self;
}

/*
 UIView is a subclass of UIResponder;
 After hit-testing, UIView objects are giving a chance to handle touch
 events; 
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self generateTouchViewIfNeededWithTouch:touch];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self generateTouchViewIfNeededWithTouch:touch];
        [self moveTouchViewWithTouch:touch];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self removeTouchViewWithTouch:touch];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches
               withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self removeTouchViewWithTouch:touch];
    }
}

#pragma mark - Private
- (void)generateTouchViewIfNeededWithTouch:(UITouch *)touch {
    __block BOOL newTouch = YES;
    [self.touchViews enumerateObjectsUsingBlock:
     ^(TouchIndicatorView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if ((UITouch *)obj.userInfo == touch) {
             newTouch = NO;
             *stop = YES;
         }
    }];
    
    if (newTouch) {
        //新的touch
        TouchIndicatorView *touchView = [[TouchIndicatorView alloc] init];
        CGFloat touchX = [touch locationInView:self].x;
        CGFloat touchY = [touch locationInView:self].y;
        touchView.frame = CGRectMake(touchX, touchY, 1.f, 1.f);
        [self addSubview:touchView];
        touchView.userInfo = touch;
        [self.touchViews addObject:touchView];
        
        [CATransaction begin];
        CAMediaTimingFunction *timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [CATransaction setAnimationTimingFunction:timingFunction];
        [UIView animateWithDuration:0.5f
                         animations:
         ^{
             touchView.bounds = CGRectMake(0, 0, 100, 100);
         }];
        [CATransaction commit];
    }
}

- (void)moveTouchViewWithTouch:(UITouch *)touch {
    __block TouchIndicatorView *touchView = nil;
    [self.touchViews enumerateObjectsUsingBlock:
     ^(TouchIndicatorView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.userInfo == touch) {
             touchView = obj;
             *stop = YES;
         }
    }];
    
    if (touchView) {
        touchView.center = [touch locationInView:self];
    }
}


-(void)removeTouchViewWithTouch:(UITouch *)touch {
    __block TouchIndicatorView *touchView = nil;
    [self.touchViews enumerateObjectsUsingBlock:
     ^(TouchIndicatorView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.userInfo == touch) {
             touchView = obj;
             *stop = YES;
         }
    }];
    if (touchView) {
        [touchView removeFromSuperview];
    }
}

#pragma mark - Lazy Loading 
- (NSMutableArray<TouchIndicatorView *> *)touchViews {
    if (nil == _touchViews) {
        _touchViews = [NSMutableArray array];
    }
    return _touchViews;
}
@end
