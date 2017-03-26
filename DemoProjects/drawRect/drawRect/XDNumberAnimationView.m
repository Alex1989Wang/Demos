//
//  drawRectTestView.m
//  drawRect
//
//  Created by JiangWang on 8/7/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDNumberAnimationView.h"

@implementation XDNumberAnimationView

- (instancetype)initWithPosition:(CGPoint)position {
    self = [super initWithFrame:CGRectMake(position.x, position.y, 0, 24)];
    if (self) {
        [self setBackgroundColor:[UIColor brownColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    //1.0 获取当前图形上下文
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    
    //2.0 从传入的数值和翻转图形上下文
    NSString *numString = [NSString stringWithFormat:@"%lu", self.numberToDraw];
    CGContextTranslateCTM(imageContext, 0, rect.size.height);
    CGContextScaleCTM(imageContext, 1.0, -1.0);
    
    //3 绘制数值 - 先绘制X
    UIImage *crossImage = [UIImage imageNamed:@"x_icon"];
    CGRect crossRect = CGRectMake(0, 0, 16, 24);
    CGContextDrawImage(imageContext, crossRect, crossImage.CGImage);
    for (NSUInteger index = 0; index<numString.length; index++) {
        NSString *digit = [numString substringWithRange:NSMakeRange(index, 1)];
        UIImage *digitImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_icon", digit]];
        
        //3.1 绘制到合适位置
        CGRect drawRect = CGRectMake(16 * (index + 1), 0, 16, 24);
        CGContextDrawImage(imageContext, drawRect, digitImage.CGImage);
        NSLog(@"passed-in rect: %@ and draw rect: %@", NSStringFromCGRect(rect), NSStringFromCGRect(drawRect));
    }
    
    
}

- (void)setNumberToDraw:(NSUInteger)numberToDraw {
    _numberToDraw = numberToDraw;
    
    //1.0 多少位的数值
    NSString *numString = [NSString stringWithFormat:@"%lu", numberToDraw];
    NSUInteger count = numString.length;
    
    //2.0 根据位数计算显示宽度 - 前面还有一个X
    CGRect bounds = self.frame;
    bounds.size.width = (count + 1) * 16.f;
    bounds.size.height = 24.f;
    self.frame = bounds;
    
    //3.0 显示
    [self setNeedsDisplay];
    
    //4.0 缩放动画 - 判断缩放动画的条件
    [self animate];
}

- (void)animate {
    
    //1.0 设置动画的layer的锚点
    self.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //2.0 先变大 - 再缩小
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeScale(2, 2);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

@end
