//
//  drawRectTestView.m
//  drawRect
//
//  Created by JiangWang on 8/7/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDNumberAnimationView.h"

#define kNumAnimationDuration 0.5
#define kAniNumWidth 16.f
#define kAniNumHeight 24.f

@interface XDNumberAnimationView()

/* 正在绘制显示的数值 */
@property (nonatomic, assign) NSUInteger numberToDraw;

/* 数值显示的timer */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation XDNumberAnimationView

- (instancetype)initWithPosition:(CGPoint)position {
    self = [super initWithFrame:CGRectMake(position.x, position.y, 0, kAniNumHeight)];
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
    CGRect crossRect = CGRectMake(0, 0, kAniNumWidth, kAniNumHeight);
    CGContextDrawImage(imageContext, crossRect, crossImage.CGImage);
    for (NSUInteger index = 0; index<numString.length; index++) {
        NSString *digit = [numString substringWithRange:NSMakeRange(index, 1)];
        UIImage *digitImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_icon", digit]];
        
        //3.1 绘制到合适位置
        CGRect drawRect = CGRectMake(kAniNumWidth * (index + 1), 0, kAniNumWidth, kAniNumHeight);
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
    bounds.size.width = (count + 1) * kAniNumWidth;
    bounds.size.height = kAniNumHeight;
    self.frame = bounds;
    
    //3.0 显示
    [self setNeedsDisplay];
}

/**
 *  设置需要显示的总数；
 *
 */
- (void)setNumberTotal:(NSUInteger)numberTotal {
    _numberTotal = numberTotal;
    
    //1.0 检查正在显示的数值和总数差
    NSUInteger diff = _numberTotal - _numberToDraw;
    if (diff > 1) {
        //1.1 重置现有的timer
        [self.timer invalidate];
        self.timer = nil;
        
        //1.2 重新开始一个不同repeat间隔的timer;
        CGFloat averageNumAniTime = kNumAnimationDuration / diff;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:averageNumAniTime target:self selector:@selector(animationWithoutSizeChange) userInfo:nil repeats:YES];
    }else {
        //2.1 重置现有的timer
        [self.timer invalidate];
        self.timer = nil;
        
        //2.2
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kNumAnimationDuration target:self selector:@selector(animationWithSizeChange) userInfo:nil repeats:YES];
    }
    
}

/**
 *  没有数值尺寸变化的动画
 *
 */
- (void)animationWithoutSizeChange {
    //1.0 开始动画
    self.numberToDraw = _numberToDraw;
    
    //2.0 变化动画数值
    _numberToDraw++;
}


/**
 *  有数值尺寸变化的动画
 *
 */
- (void)animationWithSizeChange {
    //1.0 开始动画
    self.numberToDraw = _numberToDraw;
    
    //2.0 变化动画数值
    _numberToDraw++;
    
    //3.0 改变尺寸
    [self animate];
}

/**
 *  改变数值的尺寸
 *
 */
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
