//
//  XDNumberAnimationView.m
//  drawRect
//
//  Created by JiangWang on 8/7/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDNumberAnimationView.h"

#define kNumAnimationDuration 0.5
#define kAniNumWidth 16.f
#define kAniNumHeight 24.f
#define kAniNumViewPositionX (180.f + 25.f + 5.f)

@interface XDNumberAnimationView()

/* 正在绘制显示的数值 */
@property (nonatomic, assign) NSString *numberToDraw;

/* 数值显示的timer */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation XDNumberAnimationView

/**
 *  初始化一个数字动画view
 *
 */
- (instancetype)initWithPosition:(CGPoint)position {
    self = [super initWithFrame:CGRectMake(position.x, position.y, 0, kAniNumHeight)];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

/**
 *  绘制数字代码
 *
 */
- (void)drawRect:(CGRect)rect {
    
    //1.0 获取当前图形上下文
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    
    //2.0 从传入的数值获得字符串和翻转图形上下文
    NSString *numString = self.numberToDraw;
    if (numString.length < 2) //前面加“0”
    {
        numString = [@"0" stringByAppendingString:numString];
    }
    CGContextTranslateCTM(imageContext, 0, rect.size.height);
    CGContextScaleCTM(imageContext, 1.0, -1.0);
    
    //3 绘制数值 - 先绘制X
    UIImage *crossImage = [UIImage imageNamed:@"x_icon"];
    CGRect crossRect = CGRectMake(0, 0, kAniNumWidth, kAniNumHeight);
    CGContextDrawImage(imageContext, crossRect, crossImage.CGImage);
    
    for (NSUInteger index = 0; index<numString.length; index++)
    {
        NSString *digit = [numString substringWithRange:NSMakeRange(index, 1)];
        UIImage *digitImage =
        [UIImage imageNamed: [NSString stringWithFormat:@"%@_icon", digit]];
        
        //3.1 绘制到合适位置
        CGRect drawRect =
        CGRectMake(kAniNumWidth * (index + 1), 0, kAniNumWidth, kAniNumHeight);
        CGContextDrawImage(imageContext, drawRect, digitImage.CGImage);
    }
    NSLog(@"draw number string: %@", numString);
}

/**
 *  要绘制哪个数字
 *
 */
- (void)drawNum:(NSString *)numStr {
    _numberToDraw = numStr;
    
    //1.0 多少位的数值
    NSUInteger count = numStr.length;
    
    //2.0 根据位数计算显示宽度 - 前面还有一个X(如果小于10,前面补0）
    CGRect frame = self.frame;
    frame.size.width = (count < 2) ?
    (count + 2) * kAniNumWidth :
    (count + 1) * kAniNumWidth;
    frame.size.height = kAniNumHeight;
    self.frame = frame;
    
    //3.0 显示
    //[self setNeedsDisplay];
    [self prepareImageViewsAndDispalyNumImages];
}

- (void)prepareImageViewsAndDispalyNumImages
{
    NSString *numStr = self.numberToDraw;
    if (numStr.length < 2)
    {
        numStr = [@"0" stringByAppendingString:numStr];
    }
    //暴力移除子控件
    for (UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
    
    UIImage *crossImage = [UIImage imageNamed:@"x_icon"];
    CGRect crossRect = CGRectMake(0, 0, kAniNumWidth, kAniNumHeight);
    UIImageView *crossView = [[UIImageView alloc] initWithFrame:crossRect];
    crossView.image = crossImage;
    [self addSubview:crossView];
    for (NSUInteger index = 0; index<numStr.length; index++)
    {
        NSString *digit = [numStr substringWithRange:NSMakeRange(index, 1)];
        UIImage *digitImage =
        [UIImage imageNamed: [NSString stringWithFormat:@"%@_icon", digit]];
        
        //3.1 绘制到合适位置
        CGRect drawRect =
        CGRectMake(kAniNumWidth * (index + 1), 0, kAniNumWidth, kAniNumHeight);
        UIImageView *digitView = [[UIImageView alloc] initWithFrame:drawRect];
        digitView.image = digitImage;
        [self addSubview:digitView];
    }
}

- (void)drawNum:(NSString *)num withSizeChange:(BOOL)change {
    //1.0 绘制数字
    [self drawNum:num];
    
    //2.0 要缩放
    if (change) {
        [self animate];
    }
}

/**
 *  改变数值的尺寸
 *
 */
- (void)animate {
    
    //1.0 设置动画的layer的锚点和position
    self.layer.anchorPoint = CGPointMake(1, 0.5);
    CGPoint oldPosition = self.layer.position;
    self.layer.position =
    CGPointMake(kAniNumViewPositionX + self.frame.size.width, oldPosition.y);
    
    //2.0 先变大 - 再缩小
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeScale(3, 3);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

@end
