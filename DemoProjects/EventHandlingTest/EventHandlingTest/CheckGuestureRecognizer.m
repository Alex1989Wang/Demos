//
//  CheckGuestureRecognizer.m
//  EventHandlingTest
//
//  Created by JiangWang on 12/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "CheckGuestureRecognizer.h"

typedef NS_ENUM(NSUInteger, CheckGuestureState) {
    CheckGuestureStateInitial = 1,
    CheckGuestureStateMovingDown,
    CheckGuestureStateMovingUp,
    CheckGuestureStateRecognized,
};

@interface CheckGuestureRecognizer()
@property (nonatomic, assign) CGPoint initialTouchPoint;
@property (nonatomic, assign) CheckGuestureState checkState;
@property (nonatomic, strong) UITouch *trackedTouch;
@end

@implementation CheckGuestureRecognizer
#pragma mark - Private Methods
- (void)restoreInitialValues {
    self.trackedTouch = nil;
    self.checkState = CheckGuestureStateInitial;
    self.initialTouchPoint = CGPointZero;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (touches.count != 1) {
        //single touch
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    if (!self.trackedTouch) {
        UITouch *firstTouch = [touches anyObject];
        self.trackedTouch = firstTouch;
        self.initialTouchPoint = [firstTouch locationInView:self.view];
        self.checkState = CheckGuestureStateInitial;
    }
    else {
        for (UITouch *touch in touches) {
            if (touch != self.trackedTouch) {
                [self ignoreTouch:touch forEvent:event];
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    __block UITouch *originalTouch = nil;
    [touches enumerateObjectsUsingBlock:
     ^(UITouch * _Nonnull obj, BOOL * _Nonnull stop) {
         if (self.trackedTouch == obj) {
             originalTouch = obj;
             *stop = YES;
         }
    }];
    
    if (originalTouch) {
        [self maintainCheckStateWithMovedTouch:originalTouch];
    }
    else {
        [self restoreInitialValues];
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)maintainCheckStateWithMovedTouch:(UITouch *)movedTouch {
    CGPoint previousPoint = [movedTouch previousLocationInView:movedTouch.view];
    CGPoint currentPoint = [movedTouch locationInView:movedTouch.view];
    switch (self.checkState) {
        case CheckGuestureStateInitial: {
            //只能往下
            if ((currentPoint.x >= previousPoint.x &&
                 currentPoint.y >= previousPoint.y)) {
                self.checkState = CheckGuestureStateMovingDown;
            }
            else {
                [self restoreInitialValues];
                self.state = UIGestureRecognizerStateFailed;
            }
            break;
        }
        case CheckGuestureStateMovingDown: {
            //往下或往上
            if ((currentPoint.x >= previousPoint.x &&
                 currentPoint.y >= previousPoint.y) ||
                (currentPoint.x >= previousPoint.x &&
                 currentPoint.y <= previousPoint.y)) {
                    if (currentPoint.x >= previousPoint.x &&
                        currentPoint.y <= previousPoint.y) {
                        self.checkState = CheckGuestureStateMovingUp;
                    }
            }
            else {
                [self restoreInitialValues];
                self.state = UIGestureRecognizerStateFailed;
            }
            break;
        }
        case CheckGuestureStateMovingUp: {
            //只能往上
            if (currentPoint.x >= previousPoint.x &&
                currentPoint.y <= previousPoint.y) {
                self.checkState = CheckGuestureStateMovingUp;
            }
            else {
                [self restoreInitialValues];
                self.state = UIGestureRecognizerStateFailed;
            }
            break;
        }
            
        default:
            NSAssert(NO, @"should not be handled.");
            break;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    __block UITouch *originalTouch = nil;
    [touches enumerateObjectsUsingBlock:
     ^(UITouch * _Nonnull obj, BOOL * _Nonnull stop) {
         if (self.trackedTouch == obj) {
             originalTouch = obj;
             *stop = YES;
         }
    }];
    
    //last point
    if (!originalTouch) {
        [self restoreInitialValues];
        return;
    }
    
    CGPoint lastPoint = [originalTouch locationInView:originalTouch.view];
    if (self.checkState == CheckGuestureStateMovingUp &&
        (lastPoint.x > self.initialTouchPoint.x &&
         lastPoint.y < self.initialTouchPoint.y)) {
            self.checkState = CheckGuestureStateRecognized;
            self.state = UIGestureRecognizerStateRecognized;
        }
    else {
        [self restoreInitialValues];
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches
               withEvent:(UIEvent *)event {
    [self restoreInitialValues];
    self.state = UIGestureRecognizerStateFailed;
}

#pragma mark - Override 
- (void)reset {
    [super reset];
    //additional cleanup
    [self restoreInitialValues];
}

@end
