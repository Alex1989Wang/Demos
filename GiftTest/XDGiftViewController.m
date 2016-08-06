//
//  XDLLTestGiftViewController.m
//  seeYouTime
//
//  Created by 形点网络 on 16/7/27.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDGiftViewController.h"
#import "XDGiftView.h"
#import "XDAniGiftBanner.h"
#import "XDGiftGroup.h"
#import "XDGiftGroupBuffer.h"

#define ANI_VIEW_COUNT 3
#define kTopBannerY ceilf(80 * [XDScreenFitTool screenFitFactor])
#define kBannerVerticalGap ceilf(30 * [XDScreenFitTool screenFitFactor])
#define kAniGiftBannerHeight ceilf(46 * [XDScreenFitTool screenFitFactor])

#define kBannerRepositioningAniDuration 0.5

@interface XDGiftViewController ()<XDAniGiftBannerDelegate>

/* the three animation banner views */
@property (nonatomic, strong) NSMutableArray *aniViews;

/* 用于增长连送count */
@property (nonatomic, assign) NSUInteger buttonClickedTimes;



@end

@implementation XDGiftViewController


- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    self.view.backgroundColor = XDGlobalColor;
    self.navigationController.navigationBar.hidden = YES;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    back.backgroundColor = [UIColor blackColor];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(XDScreenW - 50, 30, 100, 30);
    [self.view addSubview:back];
    
    /*
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [giftBtn setTitle:@"送礼物" forState:UIControlStateNormal];
    giftBtn.backgroundColor = [UIColor blackColor];
    [giftBtn addTarget:self action:@selector(giftClick) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.frame = CGRectMake(XDScreenW * 0.5+30, XDScreenH * 0.5-50, 100, 30);
    [self.view addSubview:giftBtn];
     */
    
    UIButton *notBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [notBtn setTitle:@"接到广播通知" forState:UIControlStateNormal];
    notBtn.backgroundColor = [UIColor blackColor];
    [notBtn addTarget:self action:@selector(giftsFromBroadcast) forControlEvents:UIControlEventTouchUpInside];
    notBtn.frame = CGRectMake(XDScreenW * 0.5 - 150, XDScreenH * 0.5-50, 100, 30);
    [self.view addSubview:notBtn];
    
}

- (XDGiftGroup *)generateGiftGroup:(NSUInteger)groupID {
#warning 仅仅用于模拟递增连送的增值
    NSUInteger increment = (_buttonClickedTimes++) * groupID;
    
    XDGiftGroup *model = [[XDGiftGroup alloc] init];
    model.senderName = [NSString stringWithFormat:@"%ld-送礼人",groupID];
    model.receiverName = [NSString stringWithFormat:@"%ld-收礼人",groupID];;
    model.giftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",groupID]];
    model.serverGroupID = [NSString stringWithFormat:@"%ld",groupID];
    model.receiverType = arc4random_uniform(2) + 2;                                  //randomize the accept type;
    model.count = groupID + increment;
    
    return model;
}

/**
 *  分发来自连送的礼物数据
 *  分发逻辑为：
 *  1、尝试先送出；
 *  2、送不出、尝试合并；
 *  3、不能合并、添加到目前礼物数组中；
 *
 *  @param giftGroup 需要分发的连送group
 */
- (void)dispatchGiftGroup:(XDGiftGroup *)giftGroup {
    /* 尝试先送出: 1.有这个group_id的礼物组正在播放 || 2.有空闲横幅 (若送出成功 - 提前return)*/
    for (XDAniGiftBanner *banner in self.aniViews) {
        if (!banner.isDisappearing && [banner.giftModel.serverGroupID isEqualToString:giftGroup.serverGroupID] && (giftGroup.count > banner.giftModel.count)) {
            [banner resetAniTotalCount:giftGroup];
            return;
        }
    }
    
    if (self.aniViews.count < kAniBannerCount) {
        //1.0 有空闲Banner位
        XDAniGiftBanner *newBanner = [XDAniGiftBanner aniGiftBanner];
        newBanner.delegate = self;
        
        //2.0 确定Banner位置
        [self positionNewlyAddedBanner:newBanner];
        
        //3.0 开始Banner动画
        [newBanner startAnimationWithGiftGroup:giftGroup];
        
        //4.0 数组记录
        [self.aniViews addObject:newBanner];
        
        return;
    }
    
    XDGiftGroup *model3 = [[XDGiftGroup alloc] init];
    model3.sendName = [NSString stringWithFormat:@"%ld-送礼人",gr_id+2];
    model3.acceptName = [NSString stringWithFormat:@"%ld-收礼人",gr_id+2];;
    model3.giftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",gr_id+2]];
    model3.group_id = [NSString stringWithFormat:@"%ld",gr_id];
    model3.acceptType = arc4random_uniform(2) + 2;
    model3.count = 13;
    
    /* 无法送出: 1.尝试合并(有效合并） 2.添加到目前的等待礼物数组中 */
    for (XDGiftGroup *group in self.pendingGiftGroups) {
        if ([group.serverGroupID isEqualToString:giftGroup.serverGroupID] && (giftGroup.count > group.count)) {
            group.count = giftGroup.count;
            return;
        }
    }
    
    [self.pendingGiftGroups addObject:giftGroup];
}

#pragma mark - Banner positionning and repositioning;
/**
 *  当新创建加入一个banner的时候，确定banner的位置；
 *
 */
- (void)positionNewlyAddedBanner:(XDAniGiftBanner *)newBanner {
    //1.0 已有的banner数目
    NSUInteger existedBannerCount = self.aniViews.count;
    
    //2.0
    CGFloat bannerX = 0.f;
    CGFloat bannerY = kTopBannerY + existedBannerCount * (newBanner.bounds.size.height + kBannerVerticalGap);
    CGFloat bannerWidth = newBanner.bounds.size.width;
    CGFloat bannerHeight = newBanner.bounds.size.height;
    CGRect newBannerRect = CGRectMake(bannerX, bannerY, bannerWidth, bannerHeight);
    
    //3.0
    newBanner.frame = newBannerRect;
    
    [self.view addSubview:newBanner];
}

/**
 *  当有banner消失掉时，重置现在所有banner的位置
 */
- (void)repositionAllBanners {

    //1.0 reposition
    [self.aniViews enumerateObjectsUsingBlock:^(XDAniGiftBanner * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //1.1 frame值
        CGRect frameToChange = obj.frame;
        frameToChange.origin.y = idx * (kAniGiftBannerHeight + kBannerVerticalGap) + kTopBannerY;
        
        //1.2 动画移动
       [UIView animateWithDuration:kBannerRepositioningAniDuration animations:^{
           obj.frame = frameToChange;
       }];
    }];
}


#pragma mark - XDAniGiftViewDelegate methods
- (void)giftBannerDidFinishDisappearing:(XDAniGiftBanner *)banner {
    //1.0 清空当前的giftBanner - 重新布局
    [self.aniViews removeObject:banner];
    [banner removeFromSuperview];
    [self repositionAllBanners];
    
    //2.0 查看是否有等待的礼物组
    if (_pendingGiftGroups.count > 0) {
        XDAniGiftBanner *newBanner = [XDAniGiftBanner aniGiftBanner];
        newBanner.delegate = self;
        
        //2.1 确定Banner位置
        [self positionNewlyAddedBanner:newBanner];
        
        //2.2 开始Banner动画
        [newBanner startAnimationWithGiftGroup:_pendingGiftGroups[0]];
        
        //2.3 去掉这个等待的礼物组
        [_pendingGiftGroups removeObjectAtIndex:0];
        
        //2.4 将新banner加入到banner数组中
        [self.aniViews addObject:newBanner];
    }
}

#pragma mark - lazy loading
-(NSMutableArray *)aniViews
{
    if (_aniViews == nil) {
        
        _aniViews = [NSMutableArray array];
    }
    
    return _aniViews;
}

#pragma mark - other test config
- (void)back
{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
