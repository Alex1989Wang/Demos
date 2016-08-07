//
//  drawRectTestView.m
//  drawRect
//
//  Created by JiangWang on 8/7/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "DrawRectTestView.h"

@implementation DrawRectTestView

- (void)drawRect:(CGRect)rect {
    
    //1.0 获取当前图形上下文
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    
    //2.0 需要绘制的数字图片
    UIImage *digitZero = [UIImage imageNamed:@"0_icon"];
    
    //3.0 绘制尺寸
    CGRect drawRect = CGRectMake(0, 0, 20, 20);
    
    //4.0 
    CGContextDrawImage(imageContext, drawRect, digitZero.CGImage);
    
    NSLog(@"passed-in rect: %@ and draw rect: %@", NSStringFromCGRect(rect), NSStringFromCGRect(drawRect));
    
}

- (void)setNumberToDraw:(NSUInteger)numberToDraw {
    _numberToDraw = numberToDraw;
    
    [self setNeedsDisplay];
}

@end
