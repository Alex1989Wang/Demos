//
//  XDLianSongView.m
//  testGift
//
//  Created by 形点网络 on 16/7/24.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDLianSongView.h"

@interface XDLianSongView ()

@property (nonatomic, weak) UIView *bottomView;
//已送给按钮
@property (nonatomic, weak) UILabel *hasSendLabel;
// 连送按钮
@property (nonatomic, weak) UIView *lianSongView;
// 动画图片
@property (nonatomic, weak) UIImageView *aniImageView;
// 倒计时label
@property (nonatomic, weak) UILabel *daoJiShiLabel;
// 连送
@property (nonatomic, weak) UILabel *liansongLabel;
// 连送按钮
@property (nonatomic, weak) UIButton *lianSongButton;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger number;

@end
@implementation XDLianSongView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpFirst];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daoJiShi) userInfo:nil repeats:YES];
        self.number = 4;
    }
    return self;
}

- (void)setUpFirst
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.8];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    
    UILabel *hasSendLabel = [[UILabel alloc] init];
    hasSendLabel.text = @"已送给";
    hasSendLabel.textColor = [UIColor whiteColor];
    hasSendLabel.font = [UIFont systemFontOfSize:14];
    self.hasSendLabel = hasSendLabel;
    [bottomView addSubview:hasSendLabel];
    
    UILabel *acceptLabel = [[UILabel alloc] init];
    acceptLabel.textColor = [UIColor colorWithHexString:@"fff32c"];
    acceptLabel.font = [UIFont systemFontOfSize:14];
    self.acceptLabel = acceptLabel;
    [bottomView addSubview:acceptLabel];
    
    UIImageView *giftImageView = [[UIImageView alloc] init];
    self.giftImageView = giftImageView;
    [bottomView addSubview:giftImageView];
    
    UILabel *giftCountLabel = [[UILabel alloc] init];
    giftCountLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    giftCountLabel.font = [UIFont systemFontOfSize:14];
    
    UIView *lianSongView = [[UIView alloc] init];
    lianSongView.backgroundColor = [UIColor clearColor];
    self.lianSongView = lianSongView;
    [self addSubview:lianSongView];
    
    UIImageView *aniImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gift_btn_icon_00"]];
    self.aniImageView = aniImageView;
    [lianSongView addSubview:aniImageView];
    
    UILabel *daoJiShiLabel = [[UILabel alloc] init];
    daoJiShiLabel.text = @"5";
    daoJiShiLabel.textColor = [UIColor colorWithHexString:@"633206"];
    daoJiShiLabel.font = [UIFont systemFontOfSize:50];
    self.daoJiShiLabel = daoJiShiLabel;
    [lianSongView addSubview:daoJiShiLabel];
    
    UILabel *liansongLabel = [[UILabel alloc] init];
    liansongLabel.text = @"连送";
    liansongLabel.textColor = [UIColor colorWithHexString:@"633206"];
    liansongLabel.font = [UIFont systemFontOfSize:14];
    self.liansongLabel = liansongLabel;
    [lianSongView addSubview:liansongLabel];
    
    UIButton *lianSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lianSongButton = lianSongButton;
    lianSongButton.backgroundColor = [UIColor clearColor];
    [lianSongButton addTarget:self action:@selector(clickUp) forControlEvents:UIControlEventTouchUpInside];
    [lianSongButton addTarget:self action:@selector(clickDown) forControlEvents:UIControlEventTouchDown];
    [lianSongView addSubview:lianSongButton];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (iPhone5) [self jisuan:H5];
    if (iPhone6) [self jisuan:H6];
    if (iPhone6p) [self jisuan:H6Plus];
}

- (void)jisuan:(CGFloat)scale
{
    self.width = XDScreenW;
    self.height = 105;
    self.y = XDScreenH - self.height;
    
    self.bottomView.x = 0;
    self.bottomView.height = 45;
    self.bottomView.width = self.width;
    self.bottomView.y = self.height - self.bottomView.height;
    
    self.hasSendLabel.x = 10.5;
    [self.hasSendLabel sizeToFit];
    self.hasSendLabel.centerY = self.bottomView.height * 0.5;
    
    self.acceptLabel.x = CGRectGetMaxX(self.hasSendLabel.frame) + 10;
    [self.acceptLabel sizeToFit];
    self.acceptLabel.preferredMaxLayoutWidth = [@"名字最长就是九个字" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}].width;
    self.acceptLabel.centerY = self.hasSendLabel.centerY;
    
    self.giftImageView.x = CGRectGetMaxX(self.acceptLabel.frame) + 5;
    self.giftImageView.width = 15;
    self.giftImageView.height = self.giftImageView.width;
    self.giftImageView.centerY = self.hasSendLabel.centerY;
    
    self.giftCountLabel.x = CGRectGetMaxX(self.giftImageView.frame) + 5;
    [self.giftCountLabel sizeToFit];
    self.giftCountLabel.centerY = self.hasSendLabel.centerY;
    
    self.lianSongView.width = 105;
    self.lianSongView.height = self.lianSongView.width;
    self.lianSongView.x = self.width - self.lianSongView.width;
    self.lianSongView.y = 0;
    
    self.aniImageView.frame = self.lianSongView. bounds;
    
    [self.liansongLabel sizeToFit];
    self.liansongLabel.height = 14;
    self.liansongLabel.y = self.lianSongView.height - self.liansongLabel.height - 10;
    self.liansongLabel.x = self.lianSongView.width - self.liansongLabel.width - 20;
    
    [self.daoJiShiLabel sizeToFit];
    self.daoJiShiLabel.height = 45;
    self.daoJiShiLabel.centerX = self.liansongLabel.centerX;
    self.daoJiShiLabel.y = self.liansongLabel.y - self.daoJiShiLabel.height;
    
    self.lianSongButton.frame = self.lianSongView.bounds;
}

- (void)clickDown
{
        
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10; i++) {
        NSString *name = [NSString stringWithFormat:@"gift_btn_icon_%02ld",i];
        UIImage *image = [UIImage imageNamed:name];
        [arr addObject:image];
    }
    
    self.aniImageView.animationImages = arr;
    self.aniImageView.animationDuration = 0.5;
    self.aniImageView.animationRepeatCount = 1;
    
    [self.aniImageView startAnimating];
    [self.timer invalidate];
    self.timer = nil;
    self.number = 5;
    self.daoJiShiLabel.text = [NSString stringWithFormat:@"%ld",self.number];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daoJiShi) userInfo:nil repeats:YES];
    
    if ([self.delegate respondsToSelector:@selector(lianSongGiftTouchDown:)]) {   // 代理方法
        
        [self.delegate lianSongGiftTouchDown:self];
    }
    
}

- (void)clickUp
{
    
    if ([self.delegate respondsToSelector:@selector(lianSongGiftTouchUp:)]) {   // 代理方法
        
        [self.delegate lianSongGiftTouchUp:self];
    }
}

- (void)daoJiShi
{
    self.daoJiShiLabel.text = [NSString stringWithFormat:@"%ld",self.number - 1];
    
    if (self.number == 0) {
        
        [self.timer invalidate];
        self.timer = nil;
        
        [self removeFromSuperview];
    }
    self.number--;
}
@end
