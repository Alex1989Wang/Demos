//
//  PGTouchHandlingView.m
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/21.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "PGTouchHandlingView.h"

@interface PGTouchHandlingView()
@end

@implementation PGTouchHandlingView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *anyTouch = touches.anyObject;
    NSLog(@"touch view - touch began: %@", anyTouch);
    CGPoint touchLocation = [anyTouch locationInView:self.superview];
    [UIView animateWithDuration:0.5
                     animations:
     ^{
         self.center = touchLocation;
     }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *anyTouch = touches.anyObject;
    NSLog(@"touch view - touch moved: %@", anyTouch);
    CGPoint touchLocation = [anyTouch locationInView:self.superview];
    self.center = touchLocation;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *anyTouch = touches.anyObject;
    NSLog(@"touch view - touch cancelled: %@", anyTouch);
    CGPoint touchLocation = [anyTouch locationInView:self.superview];
    self.center = touchLocation;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *anyTouch = touches.anyObject;
    NSLog(@"touch view - touch ended: %@", anyTouch);
    CGPoint touchLocation = [anyTouch locationInView:self.superview];
    [UIView animateWithDuration:0.5
                     animations:
     ^{
         self.center = touchLocation;
     }];
}

@end
