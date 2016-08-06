//
//  XDAniGiftView.m
//  testGift
//
//  Created by 形点网络 on 16/7/1.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDAniGiftBanner.h"
#import "XDGiftGroup.h"
#import "XDGiftGroupBuffer.h"

#define kAniGiftViewHeight ceilf(46 * [XDScreenFitTool screenFitFactor])
#define kUserImageWidth ceilf(30 * [XDScreenFitTool screenFitFactor])
#define kMarginTen ceilf(10 * [XDScreenFitTool screenFitFactor])
#define kMarginSeven ceilf(7 * [XDScreenFitTool screenFitFactor])
#define kGiftImageWidth ceilf(50 * [XDScreenFitTool screenFitFactor])
#define kMarginFive ceilf(5 * [XDScreenFitTool screenFitFactor])
#define kBannerVerticalGap ceilf(30 * [XDScreenFitTool screenFitFactor])

/* 消失动画时间 */
#define kNormalWaitingDuration 2.0
#define kShortWaitingDuration 0.8
#define kDisappearingDuration 0.5
#define kNumAnimationTimeGap 0.3

@interface XDAniGiftBanner ()
@property (weak, nonatomic) UIImageView *firstNumImageView;
@property (weak, nonatomic) UIImageView *secondNumImageView;
@property (nonatomic, weak) UIImageView *baiImageView;
@property (nonatomic, weak) UIImageView *qianImageView;
@property (nonatomic, weak) UIImageView *wanImageView;

@property (weak, nonatomic) UIView *animationView;

/* autolayout constraints */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageWidth;        // 30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLeftMagin;         // 10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftMagin;         // 15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendAndAcceptMagin;    // 7
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *acceptAndBottomMagin;  // 5
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftWidth;             // 50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftLeftMagin;         // 5


/* view outlets */
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;      // 礼物的图片
@property (weak, nonatomic) IBOutlet UIImageView *sendUserImageView;  // 送礼物人 头像
@property (weak, nonatomic) IBOutlet UILabel *sendUserNameLabel;      // 送礼物人的名字
@property (weak, nonatomic) IBOutlet UILabel *acceptUserNameLabel;   // 收礼物人的名字
@property (nonatomic, assign) NSInteger acceptType;           // 1 主持人 2 男嘉宾 3 女嘉宾


@property (nonatomic, weak) NSTimer *timerGift;


// keep track of the previous animation count
@property (nonatomic, assign) NSUInteger aniNum;                // 正在显示的数字


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
    //1.0 屏幕适配
    [self screenFitting];
    
    //add number image views;
    [self addNumberAniView];
    
    //configure appearance;
    self.backgroundColor = [UIColor colorWithHexString:@"#f8e408" alpha:0.3];
    
    //register as observer;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftDisappearingCurveAnimation) name:@"xianshen" object:nil];
}

- (void)addNumberAniView
{
    UIView *animationView = [[UIView alloc] init];
    self.animationView = animationView;
    self.animationView.hidden = YES;
    [self addSubview:animationView];
    
    UIImageView *crossImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x_icon"]];
    crossImageView.x = 0;
    crossImageView.y = 0;
    crossImageView.width = 16;
    crossImageView.height = 24;
    [animationView addSubview:crossImageView];
    
    UIImageView *firstNumberImageView = [[UIImageView alloc] init];
    firstNumberImageView.x = 16;
    firstNumberImageView.y = 0;
    firstNumberImageView.width = 16;
    firstNumberImageView.height = 24;
    self.firstNumImageView = firstNumberImageView;
    [animationView addSubview:firstNumberImageView];
    
    UIImageView *secondNumImageView = [[UIImageView alloc] init];
    secondNumImageView.x = 32;
    secondNumImageView.y = 0;
    secondNumImageView.width = 16;
    secondNumImageView.height = 24;
    self.secondNumImageView =secondNumImageView;
    [animationView addSubview:secondNumImageView];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.animationView.width = 3 * 16;
    self.animationView.height = 24;
    self.animationView.x = CGRectGetMaxX(self.giftImageView.frame);
    self.animationView.centerY = CGRectGetMidY(self.giftImageView.frame)+3;
}

- (void)screenFitting
{
    self.height = kAniGiftViewHeight;
    self.userImageWidth.constant = kUserImageWidth;
    self.userLeftMagin.constant = kMarginTen;
    self.nameLeftMagin.constant = kMarginTen;
    self.sendAndAcceptMagin.constant = kMarginSeven;
    self.acceptAndBottomMagin.constant = kMarginSeven;
    self.giftWidth.constant = kGiftImageWidth;
    self.giftLeftMagin.constant = kMarginFive;
    
    self.width = (self.giftImageView.x + self.giftWidth.constant);
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

- (void)setGiftModel:(XDGiftGroup *)giftModel
{
    //1.0 assgin
    _giftModel = giftModel;
    
    self.giftImageView.image = giftModel.giftImage;  // 礼物图片
    self.sendUserImageView.image = giftModel.senderImage;  // 送礼的人头像
    self.sendUserNameLabel.text = giftModel.senderName;  // 送礼的人名
    self.acceptUserNameLabel.text = giftModel.receiverName;  // 收礼的人名
    self.acceptType = giftModel.receiverType; // 接受者类型
}



- (void)aniViewStartAnimation
{
    _aniNum ++;
    
    if (_aniNum <= self.giftModel.count) {
        
        /**
         *  显示当前的动画数字
         */
        [self numberAnimate:_aniNum];
        
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

        //2.0 开始消失 - 标记和动画
        _disappearing = YES;
        [UIView animateWithDuration:kDisappearingDuration animations:^{
            self.alpha = 0.f;
        }];
        
        //2.2 开启完成消失回调
        aniCompletion();
    });
}


- (void)numberAnimate:(NSInteger)count
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.animationView.hidden = NO;  // 这个控件开始是隐藏的，延时出现是为了让 *1 比控件出来晚一点
    
    
    [self layoutIfNeeded];
        if (count < 100) {
            
            NSString *firstDigit = [NSString stringWithFormat:@"%ld_icon",count / 10];
            NSString *secondDigit = [NSString stringWithFormat:@"%ld_icon",count % 10];
            
            self.firstNumImageView.image = [UIImage imageNamed:firstDigit];
            
            self.secondNumImageView.image = [UIImage imageNamed:secondDigit];
        }
        
        if (count >= 10000) {
            
            if (count == 10000) {
                UIImageView *wanImageView = [[UIImageView alloc] init];
                wanImageView.y = 0;
                wanImageView.width =16;
                wanImageView.height = 24;
                wanImageView.x = self.animationView.subviews.count * 16;
                self.wanImageView = wanImageView;
                [self.animationView addSubview:wanImageView];
                self.animationView.frame = CGRectMake(CGRectGetMaxX(self.giftImageView.frame) + 10, CGRectGetMidY(self.giftImageView.frame) - 12, self.animationView.subviews.count * 16, 24);
            }
            NSString *ge = [NSString stringWithFormat:@"%ld_icon",count / 10000 % 10];
            NSString *shi = [NSString stringWithFormat:@"%ld_icon",count /1000 % 10];
            NSString *bai = [NSString stringWithFormat:@"%ld_icon",count /100 % 10];
            NSString *qian = [NSString stringWithFormat:@"%ld_icon",count /10 % 10];
            NSString *wan = [NSString stringWithFormat:@"%ld_icon",count % 10];
            self.firstNumImageView.image = [UIImage imageNamed:ge];
            self.secondNumImageView.image = [UIImage imageNamed:shi];
            self.baiImageView.image = [UIImage imageNamed:bai];
            self.qianImageView.image = [UIImage imageNamed:qian];
            self.wanImageView.image = [UIImage imageNamed:wan];
        }else if (count >= 1000) {
            
            if (count == 1000) {
                UIImageView *qianImageView = [[UIImageView alloc] init];
                qianImageView.y = 0;
                qianImageView.width =16;
                qianImageView.height = 24;
                qianImageView.x = self.animationView.subviews.count * 16;
                self.qianImageView = qianImageView;
                [self.animationView addSubview:qianImageView];
                self.animationView.frame = CGRectMake(CGRectGetMaxX(self.giftImageView.frame) + 10, CGRectGetMidY(self.giftImageView.frame) - 12, self.animationView.subviews.count * 16, 24);
            }
            
            NSString *ge = [NSString stringWithFormat:@"%ld_icon",count / 1000 % 10];
            NSString *shi = [NSString stringWithFormat:@"%ld_icon",count /100 % 10];
            NSString *bai = [NSString stringWithFormat:@"%ld_icon",count /10 % 10];
            NSString *qian = [NSString stringWithFormat:@"%ld_icon",count % 10];
            self.firstNumImageView.image = [UIImage imageNamed:ge];
            self.secondNumImageView.image = [UIImage imageNamed:shi];
            self.baiImageView.image = [UIImage imageNamed:bai];
            self.qianImageView.image = [UIImage imageNamed:qian];
            
        }else if (count >= 100) {
            
            if (!self.baiImageView) {
                UIImageView *baiImageView = [[UIImageView alloc] init];
                baiImageView.y = 0;
                baiImageView.width =16;
                baiImageView.height = 24;
                baiImageView.x = self.animationView.subviews.count * 16;
                self.baiImageView = baiImageView;
                [self.animationView addSubview:baiImageView];
                
                self.animationView.frame = CGRectMake(CGRectGetMaxX(self.giftImageView.frame) + 10, CGRectGetMidY(self.giftImageView.frame) - 12, self.animationView.subviews.count * 16, 24);
            }
            
            NSString *ge = [NSString stringWithFormat:@"%ld_icon",count / 100 % 10];
            NSString *shi = [NSString stringWithFormat:@"%ld_icon",count /10 % 10];
            NSString *bai = [NSString stringWithFormat:@"%ld_icon",count % 10];
            self.firstNumImageView.image = [UIImage imageNamed:ge];
            self.secondNumImageView.image = [UIImage imageNamed:shi];
            self.baiImageView.image = [UIImage imageNamed:bai];
        }
        
        
        self.animationView.layer.position = CGPointMake(self.animationView.x + self.animationView.width, self.animationView.y + self.animationView.height * 0.5);
        self.animationView.layer.anchorPoint = CGPointMake(1, 0.5);
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        
        // 缩放
        CAKeyframeAnimation* anim1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
#warning 动画缩放
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        
        anim1.values = values;
        group.animations = @[anim1];
        group.duration = kNumAnimationTimeGap;
        
        // 告诉在动画结束的时候不要移除
        group.removedOnCompletion = NO;
        
        // 始终保持最新的效果
        group.fillMode = kCAFillModeForwards;
        
        [self.animationView.layer addAnimation:group forKey:nil];
    });
}


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






#warning 暂时不打算使用 - 用GiftViewController来代替它的功能；
/**
 *  用来显示三个不同的XDAniGiftView;同时动态调整三个AniGiftView的位置；
 */
@interface XDAniGiftViewContainer()

@property (nonatomic, strong) NSMutableArray<XDAniGiftBanner *> *giftBanners;

@end

@implementation XDAniGiftViewContainer


/**
 *  类方法返回一个giftBanner的容器
 *
 *  @return 一个gift banner容器；
 */
+ (instancetype)giftBannerContainer {
    return [[XDAniGiftViewContainer alloc] init];
}



/**
 *  用来添加一个动画banner;同时根据动画banner的大小自动适应
 *
 *  @param aniBanner 需要添加的动画banner;
 */
- (void)addGiftBanner:(XDAniGiftBanner *)aniBanner {
    //1.0 添加一个banner到container的数组
    [self.giftBanners addObject:aniBanner];
    
    //2.0 更新
    [self appendSubBannerAndResize:aniBanner];
}

#pragma mark - container resize and reposition
- (void)appendSubBannerAndResize:(XDAniGiftBanner *)banner {
    NSUInteger currentBannerCount = self.giftBanners.count;
    
    CGFloat bannerWidth = banner.bounds.size.width;
    
    [self addSubview:banner];
}


#pragma mark - lazy loading 
- (NSMutableArray<XDAniGiftBanner *> *)giftBanners {
    if (nil == _giftBanners) {
        _giftBanners = [NSMutableArray array];
    }
    return _giftBanners;
}

@end
