//
//  XDLLTestGiftViewController.m
//  seeYouTime
//
//  Created by 形点网络 on 16/7/27.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDGiftViewController.h"
#import "XDGiftView.h"
#import "XDAniGiftView.h"
#import "XDGiftModel.h"
#import "XDAniGiftView.h"
#import "XDGiftInfoManager.h"

#define ANI_VIEW_COUNT 3

@interface XDGiftViewController ()<XDAniGiftViewDelegate>

@property (nonatomic, assign) NSInteger gr_id;   // 模拟group_id

@property (nonatomic, weak) NSTimer *timer;


@property (nonatomic, strong) NSMutableArray *aniViews;

@property (nonatomic, strong) NSMutableArray *broadcastGiftsArray;



@end

@implementation XDGiftViewController

- (NSMutableArray *)broadcastGiftsArray
{
    if (_broadcastGiftsArray == nil) {
        _broadcastGiftsArray = [NSMutableArray array];
    }
    
    return _broadcastGiftsArray;
}

-(NSMutableArray *)aniViews
{
    if (_aniViews == nil) {
        
        _aniViews = [NSMutableArray array];
    }
    
    return _aniViews;
}


- (void)back
{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    int i;
    
    [super viewDidLoad];
    self.view.backgroundColor = XDGlobalColor;
    self.navigationController.navigationBar.hidden = YES;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    back.backgroundColor = [UIColor blackColor];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(XDScreenW - 50, 30, 100, 30);
    [self.view addSubview:back];
    
    
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [giftBtn setTitle:@"送礼物" forState:UIControlStateNormal];
    giftBtn.backgroundColor = [UIColor blackColor];
//    [giftBtn addTarget:self action:@selector(giftClick) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.frame = CGRectMake(XDScreenW * 0.5+30, XDScreenH * 0.5-50, 100, 30);
    [self.view addSubview:giftBtn];
    
    UIButton *notBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [notBtn setTitle:@"接到广播通知" forState:UIControlStateNormal];
    notBtn.backgroundColor = [UIColor blackColor];
    [notBtn addTarget:self action:@selector(prepareAnimation) forControlEvents:UIControlEventTouchUpInside];
    notBtn.frame = CGRectMake(XDScreenW * 0.5 - 150, XDScreenH * 0.5-50, 100, 30);
    [self.view addSubview:notBtn];
    
    
    
    /*************************有效代码**********************************/
    
    // 请求礼物信息
    
    for (i = 0; i < ANI_VIEW_COUNT; i++) {
        XDAniGiftView *aniView = [XDAniGiftView aniGiftView];
        aniView.columNum = i+1;
        aniView.delegate = self;
        [self.aniViews addObject:aniView];
        [self.view addSubview: aniView];
    }
    
    //initialize gifts from broadcast;
    [self giftsFromBroadcast];
}

- (void)giftsFromBroadcast    // 模拟收到礼物通知      ---  接到礼物通知的时候还要记录在哪个总队列中   **************
{
    NSMutableArray *arr;

    NSInteger gr_id = 0;
    
    gr_id += 1;
    
    XDGiftModel *model1 = [[XDGiftModel alloc] init];
    model1.sendName = [NSString stringWithFormat:@"%ld-送礼人",gr_id];
    model1.acceptName = [NSString stringWithFormat:@"%ld-收礼人",gr_id];;
    model1.giftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",gr_id]];
    model1.group_id = [NSString stringWithFormat:@"%ld",gr_id];
    model1.acceptType = arc4random_uniform(2) + 2;
    model1.count = 5;
    
    XDGiftModel *model2 = [[XDGiftModel alloc] init];
    model2.sendName = [NSString stringWithFormat:@"%ld-送礼人",gr_id+1];
    model2.acceptName = [NSString stringWithFormat:@"%ld-收礼人",gr_id+1];;
    model2.giftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",gr_id+1]];
    model2.group_id = [NSString stringWithFormat:@"%ld",gr_id+1];
    model2.acceptType = arc4random_uniform(2) + 2;
    model2.count = 10;
    
    XDGiftModel *model3 = [[XDGiftModel alloc] init];
    model3.sendName = [NSString stringWithFormat:@"%ld-送礼人",gr_id+2];
    model3.acceptName = [NSString stringWithFormat:@"%ld-收礼人",gr_id+2];;
    model3.giftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",gr_id+2]];
    model3.group_id = [NSString stringWithFormat:@"%ld",gr_id];
    model3.acceptType = arc4random_uniform(2) + 2;
    model3.count = 13;
    
    arr = self.broadcastGiftsArray;

    [arr addObject:model1];   // 加入到广播消息队列中
    [arr addObject:model2];   // 加入到广播消息队列中
    [arr addObject:model3];   // 加入到广播消息队列中
}

- (void)prepareAnimation {
    // 1 从队列取值
    XDGiftModel *model = [self.broadcastGiftsArray firstObject];
    
    // 1.1 把这个对象从总数组中移除
    XDAniGiftView *giftView = [self getGiftViewSlot:model.group_id];
    
    if (giftView != nil) {
        
        [self.broadcastGiftsArray removeObject: model];
        
        // 2 给动画横幅赋值
        giftView.giftModel = model;
        
        // tag the giftView
        giftView.running = YES;
        giftView.hidden = NO;
        giftView.animateGroup_id = model.group_id;
        
        // 3 开始动画
//        [giftView beginAnimate:0 andTo:0];
        [giftView beginAnimation];
    }
    

}

// 获取适合的view
- (XDAniGiftView *)getGiftViewSlot:(NSString *)grp_id
{
    for (NSUInteger index = 0; index < ANI_VIEW_COUNT; index++) {
        XDAniGiftView *ani = self.aniViews[index];
        if (!ani.isRunning || [ani.animateGroup_id isEqualToString:grp_id])
            return ani;
        
//        if (!ani.isRunning) {
//            return ani;
//        }else if ([ani.animateGroup_id isEqualToString:grp_id]) {
//            return ani;
//        }
    }
    
    return nil;
}

- (void)aniGiftViewShouldStopAnimation:(BOOL *)should {
    if (self.broadcastGiftsArray.count == 0) {
        //
        *should = YES;
        return;
    }
    
    //still has other gift groups in the array
    XDGiftModel *model = [self.broadcastGiftsArray firstObject];
    
    XDAniGiftView *giftView;
    giftView = [self getGiftViewSlot:model.group_id];
    
    if (giftView != nil) {
        [self.broadcastGiftsArray removeObject: model];
        
        // 2 给动画横幅赋值
        giftView.running = YES;
        giftView.giftModel = model;
        giftView.hidden = NO;
        giftView.animateGroup_id = model.group_id;
        
        // 3 开始动画
        [giftView beginAnimation];
    }

}




@end
