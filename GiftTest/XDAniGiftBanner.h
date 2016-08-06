//
//  XDAniGiftView.h
//  testGift
//
//  Created by 形点网络 on 16/7/1.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDGiftGroup;
@class XDAniGiftBanner;

typedef void(^completion)();

@protocol XDAniGiftBannerDelegate <NSObject>

@optional
- (void)giftBannerDidFinishDisappearing:(XDAniGiftBanner *)banner;

@end

@interface XDAniGiftBanner : UIView

/* 需要执行动画的礼物组 */
@property (nonatomic, strong) XDGiftGroup *giftModel;

/* banner 是否正在消失：1.淡出消失 + 2.礼物掉落 */
@property (nonatomic, assign, readonly, getter=isDisappearing) BOOL disappearing;

/* banner 的代理属性 */
@property (nonatomic, weak) id <XDAniGiftBannerDelegate> delegate;

/**
 *  返回一个Banner
 *
 *  @return 礼物动画Banner
 */
+ (instancetype)aniGiftBanner;

/**
 *  重置正在动画过程中的动画Banner的最大动画数字
 *
 *  @param group 传入的新的礼物连送组
 */
- (void)resetAniTotalCount:(XDGiftGroup *)group;

/**
 *  传入一个新的gift group来播放动画
 *
 *  @param newGroup 新的连送礼物组
 */
- (void)startAnimationWithGiftGroup:(XDGiftGroup *)newGroup;
@end










/**
 *  用来显示三个不同的XDAniGiftView;同时动态调整三个AniGiftView的位置；
 *
 */
@interface XDAniGiftViewContainer : UIView

#pragma mark - properties 类的开放属性；


#pragma mark - methods 类的开放方法；

/**
 *  类方法返回一个giftBanner的容器
 *
 *  @return 一个git banner容器；
 */
+ (instancetype)giftBannerContainer;

/**
 *  用来添加一个动画banner;
 *
 *  @param aniBanner 需要添加的动画banner;
 */
- (void)addGiftBanner:(XDAniGiftBanner *)aniBanner;

@end
