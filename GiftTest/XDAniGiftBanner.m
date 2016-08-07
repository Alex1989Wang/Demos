//
//  XDAniGiftView.m
//  testGift
//
//  Created by 形点网络 on 16/7/1.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#warning 无需做屏幕适配

#import "XDAniGiftBanner.h"
#import "XDGiftGroup.h"
#import "XDNumberAnimationView.h"

#define kBannerHeight 50.f
#define kBannerOriginalWidth 205.f
#define kDefaultDigitImageViewCount 2
#define kAniNumWidth 16.f
#define kAniNumHeight 24.f

/* 消失动画时间 */
#define kNormalWaitingDuration 2.0
#define kShortWaitingDuration 0.8
#define kDisappearingDuration 0.5
#define kNumAnimationTimeGap 0.3

@interface XDAniGiftBanner ()
@property (weak, nonatomic) UIImageView *firstNumImageView;
@property (weak, nonatomic) UIImageView *secondNumImageView;
@property (nonatomic, weak) UIImageView *thirdNumImageView;
@property (nonatomic, weak) UIImageView *forthNumImageView;
@property (nonatomic, weak) UIImageView *fifthNumImageView;

@property (weak, nonatomic) UIView *animationView;


/* view outlets */
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;      // 礼物的图片
@property (weak, nonatomic) IBOutlet UIImageView *sendUserImageView;  // 送礼物人头像
@property (weak, nonatomic) IBOutlet UILabel *sendUserNameLabel;      // 送礼物人的名字
@property (weak, nonatomic) IBOutlet UILabel *acceptUserNameLabel;   // 收礼物人的名字
/* 礼物的接受者 */
// 1 主持人 2 男嘉宾 3 女嘉宾
@property (nonatomic, assign) XDGiftReceiverType acceptType;

/* 用于展示数字缩放动画的view */
@property (weak, nonatomic) IBOutlet UIView *numAniView;

/* 缩放数字的第一个数字 */
@property (weak, nonatomic) IBOutlet UIImageView *firstDigitImageView;

/* 缩放数字的第二个数字 */
@property (weak, nonatomic) IBOutlet UIImageView *secondDigitImageView;

/* 数字动画计时器 */
@property (nonatomic, weak) NSTimer *timerGift;

/* 动画数字的位数 */
@property (nonatomic, assign) NSUInteger aniNumDigitsCount;

/* 正在动画的数字 */
@property (nonatomic, assign) NSUInteger aniNum;

@end


@implementation XDAniGiftBanner

#pragma mark - Initialization and UI-related;

/**
 *  Return the git view to display animation;
 *
 *  @return The gift view;
 */
+ (instancetype)aniGiftBanner
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XDAniGiftBanner" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    //设置banner的尺寸
    [self configureBannerSize];
    
    //register as observer;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftDisappearingCurveAnimation) name:@"xianshen" object:nil];
}

- (void)configureBannerSize {
    //1.0 设置banner高度和初始宽度
    CGRect bannerBounds = self.bounds;
    bannerBounds.size.height = kBannerHeight;
    bannerBounds.size.width = kBannerOriginalWidth;
    self.bounds = bannerBounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //1.0 根据动画number的位数来调整numAniView的宽度 - 只对大于两位数的banner重新调整宽度;
    //banner 重新调整会自动加宽aniNumView;
    if (self.aniNumDigitsCount > kDefaultDigitImageViewCount) {
        CGRect newBounds = CGRectMake(0, 0, kBannerOriginalWidth + (self.aniNumDigitsCount - kDefaultDigitImageViewCount) * kAniNumWidth, kBannerHeight);
        self.bounds = newBounds;
    }
}

- (void)setGiftModel:(XDGiftGroup *)giftModel
{
    //1.0 赋值和显示
    _giftModel = giftModel;
    
    self.giftImageView.image = giftModel.giftImage;  // 礼物图片
    self.sendUserImageView.image = giftModel.senderImage;  // 送礼的人头像
    self.sendUserNameLabel.text = giftModel.senderName;  // 送礼的人名
    self.acceptUserNameLabel.text = giftModel.receiverName;  // 收礼的人名
    self.acceptType = giftModel.receiverType; // 接受者类型
    
    //2.0 调整大小添加数值动画View
    CGPoint position = CGPointMake(CGRectGetMaxX(self.giftImageView.frame) + 10.f, 0.5 * (self.bounds.size.height - kAniNumHeight));
    XDNumberAnimationView *numAniView = [[XDNumberAnimationView alloc] initWithPosition:position];
    [self addSubview:numAniView];
    
    //3.0 赋值开始动画 - 总数值
    numAniView.numberTotal = giftModel.count;
}


#pragma mark - Animation related;

/**
 *  重置现在正在动画的gift group的总数
 *
 */
- (void)resetAniTotalCount:(XDGiftGroup *)group {
    self.giftModel.count = group.count;
    
#warning 是否再次开启动画
//    [self startAnimationWithGiftGroup:self.giftModel];
}


/**
 *  赋值gift group,开始动画
 *
 */
- (void)startAnimationWithGiftGroup:(XDGiftGroup *)group {
    //0.0 赋值显示礼物信息
    self.giftModel = group;
    
    //1.0 设置banner状态；
    _disappearing = NO;
    
    //2.0 start animation
    self.timerGift = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(aniViewStartAnimation) userInfo:nil repeats:YES];
}





- (void)aniViewStartAnimation
{
    _aniNum ++;
    
    if (_aniNum <= self.giftModel.count) {
        
        /**
         *  显示当前的动画数字
         */
//        [self numberAnimate:_aniNum];
        
    }else {
        
        /**
         *  已经完成了该组动画的显示 - 判断要使用什么类型的消失动画；
         *  消失动画结束之后告知controller，让controller继续派发后面等待的礼物；如果有的话
         */
        [self launchDisappearAnimation:^() {
            if ([self.delegate respondsToSelector:@selector(giftBannerDidFinishDisappearing:)]) {
                [self.delegate giftBannerDidFinishDisappearing:self];
            }
        }];
    }
}

- (void)launchDisappearAnimation:(completion)aniCompletion {
#warning 先设计为全部淡出消失 统一时间为2s
    //1.0 开始等待消失动画 - 统一等待时间为2s
    CGFloat disappearDelayDuration = kNormalWaitingDuration;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disappearDelayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        //2.0 开始消失 - 标记消失；取消数字动画timer；开始消失动画；
        [self.timerGift invalidate];
        self.timerGift = nil;
        _disappearing = YES;
        [UIView animateWithDuration:kDisappearingDuration animations:^{
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            
            //2.2 开启完成消失回调
            aniCompletion();
        }];
    });
}

/**
 *  显示数字的动画 - 0.5 秒内播完所有数字动画
 *
 */
- (void)animateNumber:(NSUInteger)num {
    //1.0 计算该数字有几位数
    NSString *numberString = [NSString stringWithFormat:@"%lu", num];
    NSUInteger digitCount = numberString.length;
    self.aniNumDigitsCount = digitCount;
    
    //2.0 显示数字
    [self dispalyNumber:num];
}

/**
 *  若数值小于100；使用xib中的已有的imageView显示-提高效率
 *  若大于100；动态创建多个ImageView - 那么第一个imageView开始显示第三个数字，前面还有一个不变的“x_icon”图标
 */
- (void)dispalyNumber:(NSUInteger)num {
    if (num < 100) {
        NSString *firstDigit = [NSString stringWithFormat:@"%lu_icon", num / 10];
        NSString *secondDigit = [NSString stringWithFormat:@"%lu_icon", num % 10];
        self.firstDigitImageView.image = [UIImage imageNamed:firstDigit];
        self.secondDigitImageView.image = [UIImage imageNamed:secondDigit];
    }else {
        for (NSUInteger index = 0; index < (self.aniNumDigitsCount - kDefaultDigitImageViewCount); index++) {
            CGFloat imageX = (kDefaultDigitImageViewCount + 1 + index) * kAniNumWidth;
        }
    }
}

#warning 还需要修改的宏亮代码



- (void)giftDisappearingCurveAnimation   // 抛物线动画
{
    if (self.acceptType == 1) return;   // No animation for the host;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.image = self.giftImageView.image;
    imageView.width = self.giftImageView.width;
    imageView.height = self.giftImageView.height;
    imageView.x = self.giftImageView.x;
    imageView.y = self.y;
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    
    // 执行动画
    
    if (self.acceptType == 3) {   // The female guest is at the right side;
        
        CAKeyframeAnimation *ani = [CAKeyframeAnimation animation];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:imageView.center];
        [path addQuadCurveToPoint:CGPointMake(XDScreenW * 0.75, XDScreenH  * 0.7) controlPoint:CGPointMake(XDScreenW,imageView.y)];
        ani.keyPath=@"position";
        ani.path = path.CGPath;
        ani.duration = 1;
        ani.repeatCount = 1;
        ani.removedOnCompletion=NO;
        ani.fillMode=kCAFillModeForwards;
        [imageView.layer addAnimation:ani forKey:nil];
    }
    
    if (self.acceptType == 2) {   // 男贫道靠左
        
        CAKeyframeAnimation *ani1 = [CAKeyframeAnimation animation];
        
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:imageView.center];
        [path1 addQuadCurveToPoint:CGPointMake(XDScreenW * 0.25, XDScreenH  * 0.7) controlPoint:CGPointMake(0,imageView.y)];
        ani1.keyPath=@"position";
        ani1.path = path1.CGPath;
        ani1.duration = 1;
        ani1.repeatCount = 1;
        ani1.removedOnCompletion=NO;
        ani1.fillMode=kCAFillModeForwards;
        [imageView.layer addAnimation:ani1 forKey:nil];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
    });
    
}


@end


