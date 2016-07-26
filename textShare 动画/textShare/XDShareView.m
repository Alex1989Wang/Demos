//
//  XDShareView.m
//  textShare
//
//  Created by 形点网络 on 16/6/29.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDShareView.h"
#import "XDVerticalButton.h"

#import "UIView+Frame.h"

#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1]
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.25f

#define KScreenW [[UIScreen mainScreen] bounds].size.width
#define KScreenH [[UIScreen mainScreen] bounds].size.height
@implementation XDShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"朋友圈",@"微信",@"QQ好友",@"新浪微博",@"QQ空间",@"更多"];
    
    CGFloat leftMagin = 20;
    CGFloat upMagin = 10;
    CGFloat btnW = 50;
    CGFloat btnH = 70;
    CGFloat btnX = 0;
    CGFloat btnY = 200;
    CGFloat magin = (KScreenW - 2 * leftMagin - 4 * btnW) / 3;
    
    for (NSInteger i = 0;  i < 6; i++) {
        
        XDVerticalButton *btn = [[XDVerticalButton alloc] init];
        
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:arr[i]]forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+100;
        
        btnX = leftMagin + (btnW + magin) * (i % 4);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
       CGFloat btnY1 = upMagin + (btnH + upMagin) * (i / 4);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.1 * (i%4)) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [UIView animateWithDuration:.5 animations:^{
                btn.y = btnY1;
                
            }];
            [self addSubview:btn];
            
        });
    }
}

- (void)click:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shareView:clickButton:)]) {
        
        [self.delegate shareView:self clickButton:btn];
    }
}
@end
