//
//  DrawingTestView.m
//  UIViewProgrammingGuide
//
//  Created by JiangWang on 17/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "DrawingTestView.h"

@implementation DrawingTestView

- (void)drawRect:(CGRect)rect {
   
    CGContextRef ctxRef = UIGraphicsGetCurrentContext();
    CGRect bounds = CGRectInset(rect, 75, 75);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    CGContextRotateCTM(ctxRef, M_PI/4);
    CGContextAddPath(ctxRef, path.CGPath);
    CGContextDrawPath(ctxRef, kCGPathStroke);
    CGContextRelease(ctxRef);
}


@end
