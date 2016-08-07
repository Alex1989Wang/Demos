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

#define kAniBannerCount 3
#define kTopBannerY ceilf(80 * [XDScreenFitTool screenFitFactor])
#define kBannerVerticalGap ceilf(30 * [XDScreenFitTool screenFitFactor])
#define kAniGiftBannerHeight ceilf(46 * [XDScreenFitTool screenFitFactor])

#define kBannerRepositioningAniDuration 0.5

@interface XDGiftViewController ()<XDAniGiftBannerDelegate>

/* the three animation banner views */
@property (nonatomic, strong) NSMutableArray *aniViews;

/* 用于管理等待礼物组 */
@property (nonatomic, strong) NSMutableArray *pendingGiftGroups;

/* 用于增加四种连送count */
@property (nonatomic, assign) NSUInteger oneButtonClickedTimes;
@property (nonatomic, assign) NSUInteger twoButtonClickedTimes;
@property (nonatomic, assign) NSUInteger threeButtonClickedTimes;
@property (nonatomic, assign) NSUInteger fourButtonClickedTimes;



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
    
    /*添加连送测试View*/
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, XDScreenH - 100, XDScreenW, 80)];
    [testView setBackgroundColor:XDGlobalGray];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XDScreenW, 30)];
    tipLabel.text = @"连送测试";
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [testView addSubview:tipLabel];
    
    /* buttons */
    for (NSUInteger index = 0; index < 4; index ++) {
        
        CGFloat btnWidth = XDScreenW / 4.0;
        CGFloat btnX = btnWidth * index;
        CGFloat btnY = CGRectGetMaxY(tipLabel.frame);
        CGFloat btnHeight = 40;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight)];
        [testView addSubview:btn];
        [btn setBackgroundColor:[UIColor brownColor]];
        [btn setTitle:[NSString stringWithFormat:@"连送%lu", index+1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(giftGroupSendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:testView];
}

- (void)giftGroupSendButtonClicked:(UIButton *)btn {
    
    XDGiftGroup *groupToDispatch;
    
    if ([btn.currentTitle isEqualToString:@"连送1"]) {
        groupToDispatch = [self generateGiftGroup:1];
    }
    
    if ([btn.currentTitle isEqualToString:@"连送2"]) {
        groupToDispatch = [self generateGiftGroup:2];
    }
    
    if ([btn.currentTitle isEqualToString:@"连送3"]) {
        groupToDispatch = [self generateGiftGroup:3];
    }
    
    if ([btn.currentTitle isEqualToString:@"连送4"]) {
        groupToDispatch = [self generateGiftGroup:4];
    }
    
    [self dispatchGiftGroup:groupToDispatch];
    
}

- (XDGiftGroup *)generateGiftGroup:(NSUInteger)groupID {
#warning 仅仅用于模拟递增连送的增值
    NSUInteger buttonClicked = 0;
    
    switch (groupID) {
        case 1:
            _oneButtonClickedTimes ++;
            buttonClicked = _oneButtonClickedTimes;
            break;
            
        case 2:
            _twoButtonClickedTimes ++;
            buttonClicked = _twoButtonClickedTimes;
            break;
            
        case 3:
            _threeButtonClickedTimes ++;
            buttonClicked = _threeButtonClickedTimes;
            break;
            
        case 4:
            _fourButtonClickedTimes ++;
            buttonClicked = _fourButtonClickedTimes;
            break;
            
        default:
            break;
    }
    
    NSUInteger increment = (buttonClicked - 1) * groupID;
    
    XDGiftGroup *model = [[XDGiftGroup alloc] init];
    model.senderName = [NSString stringWithFormat:@"%ld-送礼人",groupID];
    model.receiverName = [NSString stringWithFormat:@"%ld-收礼人",groupID];;
    model.giftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",groupID]];
    model.serverGroupID = [NSString stringWithFormat:@"%lu",groupID];
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
    
#warning 重置banner是groupID对应的点击次数
    switch ([banner.giftModel.serverGroupID integerValue]) {
            
        case 1:
            _oneButtonClickedTimes = 0;
            break;
            
        case 2:
            _twoButtonClickedTimes = 0;
            
        case 3:
            _threeButtonClickedTimes = 0;
            
        case 4:
            _fourButtonClickedTimes = 0;
            
        default:
            break;
    }
    
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
