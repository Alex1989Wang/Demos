//
//  XDAniGiftView.m
//  testGift
//
//  Created by 形点网络 on 16/7/1.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDAniGiftView.h"
#import "XDGiftModel.h"
#import "XDGiftInfoManager.h"

@interface XDAniGiftView ()
@property (weak, nonatomic) UIImageView *geWeiImageView;
@property (weak, nonatomic) UIImageView *shiWeiImageView;
@property (weak, nonatomic) UIView *animationView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageWidth;// 30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLeftMagin;// 10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftMagin; // 15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendAndAcceptMagin; // 7
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *acceptAndBottomMagin; // 5
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftWidth; // 50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftLeftMagin; // 5
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLeftMagin;// 10


@property (nonatomic, weak) UIImageView *baiImageView;
@property (nonatomic, weak) UIImageView *qianImageView;
@property (nonatomic, weak) UIImageView *wanImageView;


@property (nonatomic, weak) NSTimer *timerGift;

@property (nonatomic, strong) NSMutableArray *totalArray; // 礼物模型数组

@property (nonatomic, strong) XDGiftModel *frontModel; // 上一个礼物模型
@property (nonatomic, strong) XDGiftModel *lastModel; // 下一个礼物模型

// 该种礼物的一次的总个数
@property (nonatomic, strong) NSMutableDictionary *totalCountInfo;



@end

static BOOL shouldContinueAnimation;

@implementation XDAniGiftView

-(NSMutableDictionary *)totalCountInfo
{
    if (_totalCountInfo == nil) {
        _totalCountInfo = [NSMutableDictionary dictionary];
    }
    
    return _totalCountInfo;
}

- (NSMutableArray *)totalArray
{
    if (_totalArray == nil) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}


+ (instancetype)aniGiftView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XDAniGiftView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    
    [self setUpFirst];
    [self addAniView];
    self.backgroundColor = [UIColor colorWithHexString:@"#f8e408" alpha:0.3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xianShen) name:@"xianshen" object:nil];
    
    
}



- (void)xianShen   // 抛物线动画
{
    if (self.acceptType == 1) return;   // 方丈没有动画
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.image = self.giftImageView.image;
    imageView.width = self.giftImageView.width;
    imageView.height = self.giftImageView.height;
    imageView.x = self.giftImageView.x;
    imageView.y = self.y;
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    
    // 执行动画
    
    if (self.acceptType == 3) {   // 女施主靠右
        
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

- (void)addAniView
{
    UIView *animationView = [[UIView alloc] init];
    self.animationView = animationView;
    self.animationView.hidden = YES;
    [self addSubview:animationView];
    
    UIImageView *chengImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x_icon"]];
    chengImageView.x = 0;
    chengImageView.y = 0;
    chengImageView.width = 16;
    chengImageView.height = 24;
    [animationView addSubview:chengImageView];
    
    UIImageView *geWeiImageView = [[UIImageView alloc] init];
    geWeiImageView.x = 16;
    geWeiImageView.y = 0;
    geWeiImageView.width = 16;
    geWeiImageView.height = 24;
    self.geWeiImageView = geWeiImageView;
    [animationView addSubview:geWeiImageView];
    
    UIImageView *shiWeiImageView = [[UIImageView alloc] init];
    shiWeiImageView.x = 32;
    shiWeiImageView.y = 0;
    shiWeiImageView.width = 16;
    shiWeiImageView.height = 24;
    self.shiWeiImageView =shiWeiImageView;
    [animationView addSubview:shiWeiImageView];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.animationView.width = 3 * 16;
    self.animationView.height = 24;
    self.animationView.x = CGRectGetMaxX(self.giftImageView.frame);
    self.animationView.centerY = CGRectGetMidY(self.giftImageView.frame)+3;
}

- (void)setUpFirst
{
//    if (iPhone5) {
    
        self.height = self.height * H6;
        self.userImageWidth.constant = 30 * H6;
        self.userLeftMagin.constant = 10 * H6;
        self.nameLeftMagin.constant = 10;
        self.sendAndAcceptMagin.constant = 7 * H6;
        self.acceptAndBottomMagin.constant = 7 * H6;
        self.giftWidth.constant = 50 * H6;
        self.giftLeftMagin.constant = 5 * H6;
        self.numberLeftMagin.constant = 10 * H6;
    
        self.width = (self.giftImageView.x + self.giftWidth.constant * 0.5);
//    }
//    if (iPhone6) {
//        
//        self.height = self.height * H6;
//        self.userImageWidth.constant = 30 * H6;
//        self.userLeftMagin.constant = 10 * H6;
//        self.nameLeftMagin.constant = 10;
//        self.sendAndAcceptMagin.constant = 7 * H6;
//        self.acceptAndBottomMagin.constant = 7 * H6;
//        self.giftWidth.constant = 50 * H6;
//        self.giftLeftMagin.constant = 5 * H6;
//        self.numberLeftMagin.constant = 10 * H6;
//        self.width = (self.giftImageView.x + self.giftWidth.constant * 0.5);
//    }
//    if (iPhone6p) {
//        
//        self.height = self.height * H6;
//        self.userImageWidth.constant = 30 * H6;
//        self.userLeftMagin.constant = 10 * H6;
//        self.nameLeftMagin.constant = 10;
//        self.sendAndAcceptMagin.constant = 7 * H6;
//        self.acceptAndBottomMagin.constant = 7 * H6;
//        self.giftWidth.constant = 50 * H6;
//        self.giftLeftMagin.constant = 5 * H6;
//        self.numberLeftMagin.constant = 10 * H6;
//        self.width = (self.giftImageView.x + self.giftWidth.constant * 0.5);
//    }
    
}



//-(void)setGiftCountArray:(NSMutableArray *)giftCountArray
//{
//    _giftCountArray = giftCountArray;
//    
//    [self.totalArray addObjectsFromArray:giftCountArray];
//    
//    [self giftQueueAnimation:nil];
//    
//}

//// 根据个数来执行动画
//- (void)giftQueueAnimation:(completeBlock)complete
//{
//    if (self.timerGift) return;
//    self.timerGift = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(donghua) userInfo:nil repeats:YES];
//    
//    XDGiftModel *model = [self.totalArray firstObject];
//    // 每次动画的时候 标志一下该种礼物正在动画
////    [XDGiftInfoManager sharedXDGiftInfoManager].animateState[model.group_id] = @1;  // 这种礼物开始送
//    
//    NSInteger frontCount = [[XDGiftInfoManager sharedXDGiftInfoManager].countInfo[model.group_id] integerValue];  // 获取这种礼物已经送了多少了
//    
//    _aniCount = frontCount;
//    
//    self.giftImageView.image = model.giftImage;  // 礼物图片
//    self.sendUserImageView.image = model.sendImage;  // 送礼的人头像
//    self.sendUserNameLabel.text = model.sendName;  // 送礼的人名
//    self.acceptUserNameLabel.text = model.acceptName;  // 收礼的人名
//    
//    self.acceptType = model.acceptType; // 接受者类型
//    
//    self.animationView.hidden = YES;
//    
//    if (self.hangShu == 1) {
//    
//        self.y = 30;
//        self.x = -self.width + 30;
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            self.x = 0;
//        }];
//    }else if (self.hangShu == 2) {
//        
//        self.y = 90;
//        self.x = -self.width + 30;
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            self.x = 0;
//        }];
//    }else if (self.hangShu == 3) {
//        
//        self.y = 150;
//        self.x = -self.width + 30;
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            self.x = 0;
//        }];
//    }
//    
//}

- (void)setGiftModel:(XDGiftModel *)giftModel
{
    _giftModel = giftModel;
    
    self.giftImageView.image = giftModel.giftImage;  // 礼物图片
    self.sendUserImageView.image = giftModel.sendImage;  // 送礼的人头像
    self.sendUserNameLabel.text = giftModel.sendName;  // 送礼的人名
    self.acceptUserNameLabel.text = giftModel.acceptName;  // 收礼的人名
    
    
}

// 开始数字动画的接口
- (void)beginAnimate:(NSInteger)from andTo:(NSInteger)to
{
    self.hidden = NO;
    // 1 开启定时器 开始计数
    if (self.timerGift) return;
    
    self.animationView.hidden = YES;
    
    if (self.hangShu == 1) {
        self.y = 30;
        self.x = -self.width + 30;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.x = 0;
        }];
    }
    if (self.hangShu == 2) {
        self.y = 90;
        self.x = -self.width + 30;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.x = 0;
        }];
    }
    if (self.hangShu == 3) {
        self.y = 150;
        self.x = -self.width + 30;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.x = 0;
        }];
    }

    self.timerGift = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(donghua) userInfo:nil repeats:YES];
    
    _aniCount = from;
    _fromCount = from;
}

- (void)donghua
{
    _aniCount ++;
    
    self.animationView.hidden = NO;
    
    self.giftImageView.image = self.giftModel.giftImage;  // 礼物图片
    self.sendUserImageView.image = self.giftModel.sendImage;  // 送礼的人头像
    self.sendUserNameLabel.text = self.giftModel.sendName;  // 送礼的人名
    self.acceptUserNameLabel.text = self.giftModel.acceptName;  // 收礼的人名
    self.acceptType = self.giftModel.acceptType; // 接受者类型
    
    if (_aniCount - _fromCount <= self.giftModel.count) {
        [self numberAnimate:_aniCount];
    }
    
    if (_aniCount - _fromCount > self.giftModel.count) {   // 当这组礼物执行到制定次数的时候
        
        [XDGiftInfoManager sharedXDGiftInfoManager].giftTotalCount[self.animateGroup_id] = @(_aniCount); // 保存这种礼物送了几个了
        
        
        if ([self.delegate respondsToSelector:@selector(aniGiftViewShouldStopAnimation:)]) {
            [self.delegate aniGiftViewShouldStopAnimation:&shouldContinueAnimation];
        }
        
        if (!shouldContinueAnimation) {
            [self.timerGift invalidate];
            self.timerGift = nil;
        }
        
        // 1 告诉外界横幅正在等待 -- 横幅等待的时候该做什么
//        
//            [self.timerGift invalidate];  // 停止定时器
//            self.timerGift = nil;
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self xianShen];
                
                self.hidden = YES;
                
                [XDGiftInfoManager sharedXDGiftInfoManager].giftTotalCount[self.animateGroup_id] = @0;
                
                // 2 告诉外界横幅消失了 -- 横幅消失的时候该做什么
//                if ([self.delegate respondsToSelector:@selector(aniGiftViewFinished)]) {
//                    
//                    [self.delegate aniGiftViewFinished];
//                }
                
                
                
                
            });
       
        
    }
    

    
    
}


- (void)numberAnimate:(NSInteger)count
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.animationView.hidden = NO;  // 这个控件开始是隐藏的，延时出现是为了让 *1 比控件出来晚一点
    
    
    [self layoutIfNeeded];
        if (count < 100) {
            
            NSString *ge = [NSString stringWithFormat:@"%ld_icon",count / 10];
            NSString *shi = [NSString stringWithFormat:@"%ld_icon",count % 10];
            
            self.geWeiImageView.image = [UIImage imageNamed:ge];
            
            self.shiWeiImageView.image = [UIImage imageNamed:shi];
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
            self.geWeiImageView.image = [UIImage imageNamed:ge];
            self.shiWeiImageView.image = [UIImage imageNamed:shi];
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
            self.geWeiImageView.image = [UIImage imageNamed:ge];
            self.shiWeiImageView.image = [UIImage imageNamed:shi];
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
            self.geWeiImageView.image = [UIImage imageNamed:ge];
            self.shiWeiImageView.image = [UIImage imageNamed:shi];
            self.baiImageView.image = [UIImage imageNamed:bai];
        }
        
    
    self.animationView.layer.position = CGPointMake(self.animationView.x + self.animationView.width, self.animationView.y + self.animationView.height * 0.5);
    self.animationView.layer.anchorPoint = CGPointMake(1, 0.5);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    // 缩放
    CAKeyframeAnimation* anim1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    
    anim1.values = values;
    group.animations = @[anim1];
    group.duration = 0.5;
        // 取消反弹
    // 告诉在动画结束的时候不要移除
    group.removedOnCompletion = NO;
    // 始终保持最新的效果
    group.fillMode = kCAFillModeForwards;
    
    [self.animationView.layer addAnimation:group forKey:nil];
    
        });
}


@end
