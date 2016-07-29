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

#define kAnimationDuration 0.25f

#define KScreenW [[UIScreen mainScreen] bounds].size.width
#define KScreenH [[UIScreen mainScreen] bounds].size.height


/* screen fitting */
#define kButtonWidth ceilf(40.f )
#define kButtonHeight ceilf(55.f )
#define kMarginTweenty ceilf(20.f )
#define kMarginFiftyEight ceilf(58.f )
#define kMarginFive ceilf(5.f )
#define kMarginTen ceilf(10.f )

#define kShareViewHeight ceilf(140.f )

/* screen fitting */

@implementation XDShareView


#pragma mark - initialization
+ (instancetype)shareView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    // the share view should always be 140 points high for iPhone 6;
    self = [super initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - kShareViewHeight, [UIScreen mainScreen].bounds.size.width, kShareViewHeight)];
    
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"朋友圈",@"微信",@"QQ好友",@"新浪微博",@"QQ空间",@"更多"];

    CGFloat btnX = 0;
    CGFloat btnY = kShareViewHeight; // won't be seen before the animation;
    CGFloat buttonGap = (KScreenW - 2 * kMarginTweenty - 4 * kButtonWidth) / 3;
    
    for (NSInteger i = 0;  i < 6; i++) {
        
        XDVerticalButton *btn = [[XDVerticalButton alloc] init];
        
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:arr[i]]forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        btnX = kMarginTweenty + (kButtonWidth + buttonGap) * (i % 4);
        CGFloat btnY1 = kMarginTen + (kButtonHeight + kMarginTen) * (i / 4);
        btn.frame = CGRectMake(btnX, btnY, kButtonWidth, kButtonHeight);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.1 * (i%4)) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
            [UIView animateWithDuration:kAnimationDuration animations:^{
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
