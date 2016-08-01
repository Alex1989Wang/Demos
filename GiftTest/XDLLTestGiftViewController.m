//
//  XDLLTestGiftViewController.m
//  seeYouTime
//
//  Created by 形点网络 on 16/7/27.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDLLTestGiftViewController.h"
#import "XDGiftView.h"
#import "XDAniGiftView.h"
#import "XDGiftModel.h"
#import "XDAniGiftView.h"
#import "XDGiftInfoManager.h"

#define ANI_VIEW_COUNT 3

@interface XDLLTestGiftViewController ()<XDAniGiftViewDelegate>

@property (nonatomic, assign) NSInteger gr_id;   // 模拟group_id

@property (nonatomic, weak) NSTimer *timer;


@property (nonatomic, strong) NSMutableArray *aniViews;

@property (nonatomic, strong) NSMutableArray *guangBoGiftTotalArray;



@end

@implementation XDLLTestGiftViewController

- (NSMutableArray *)guangBoGiftTotalArray
{
    if (_guangBoGiftTotalArray == nil) {
        _guangBoGiftTotalArray = [NSMutableArray array];
    }
    
    return _guangBoGiftTotalArray;
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
    [notBtn addTarget:self action:@selector(guangboClick) forControlEvents:UIControlEventTouchUpInside];
    notBtn.frame = CGRectMake(XDScreenW * 0.5 - 150, XDScreenH * 0.5-50, 100, 30);
    [self.view addSubview:notBtn];
    
    
    
    /*************************有效代码**********************************/
    
    // 请求礼物信息
    
    for (i = 0; i < ANI_VIEW_COUNT; i++) {
        XDAniGiftView *aniView = [XDAniGiftView aniGiftView];
        aniView.columNum = i+1;
        aniView.hidden = YES;
        aniView.delegate = self;
        [self.aniViews addObject:aniView];
        [self.view addSubview: aniView];
    }
}


// 获取适合的view
- (XDAniGiftView *)getGiftViewSlot: (NSString *)grp_id
{
    int i;
    for (i = 0; i < ANI_VIEW_COUNT; i++) {
        XDAniGiftView *ani = self.aniViews[i];
        if (!ani.isRunning || [ani.animateGroup_id isEqualToString: grp_id])
            return ani;
    }

    return nil;
}
- (void)guangboClick    // 模拟收到礼物通知      ---  接到礼物通知的时候还要记录在哪个总队列中   **************
{
    NSMutableArray *arr;
    XDAniGiftView *giftView;
    
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
    
    arr = self.guangBoGiftTotalArray;
    if (arr == nil) {
        NSLog(@"Failed to create the mutable array!");
        return;
    }
    
    [arr addObject:model1];   // 加入到广播消息队列中
    [arr addObject:model2];   // 加入到广播消息队列中
    [arr addObject:model3];   // 加入到广播消息队列中
    
    // 1 从队列取值
    XDGiftModel *model = [self.guangBoGiftTotalArray firstObject];
    
    // 1.1 把这个对象从总数组中移除
    
    giftView = [self getGiftViewSlot: model.group_id];
    
    if (giftView != nil) {
        
        [self.guangBoGiftTotalArray removeObject: model];
        giftView.running = YES;
        // 2 给动画横幅赋值
        giftView.giftModel = model;
        giftView.hidden = NO;
        giftView.animateGroup_id = model.group_id;
        
        // 3 开始动画
        [giftView beginAnimate:0 andTo:0];
    }
    
    
   }


//-(void)aniGiftViewWaiting
//{
//    if (!self.guangBoGiftTotalArray.count)
//        return;
//    
//    for (XDGiftModel *model in self.guangBoGiftTotalArray) {
//        
//        
//    }
//}

- (void)aniGiftViewFinished
{
    if (self.guangBoGiftTotalArray.count == 0) {
        //
        return;
    }
    
    for (XDGiftModel *model in self.guangBoGiftTotalArray) {
        
        XDAniGiftView *giftView;
        giftView = [self getGiftViewSlot:model.group_id];
        
        if (giftView != nil) {
            
            [self.guangBoGiftTotalArray removeObject: model];
            giftView.running = YES;
            // 2 给动画横幅赋值
            giftView.giftModel = model;
            giftView.hidden = NO;
            giftView.animateGroup_id = model.group_id;
            
            NSInteger count = [[XDGiftInfoManager sharedXDGiftInfoManager].giftTotalCount[model.group_id] integerValue];
            
            // 3 开始动画
            [giftView beginAnimate:count andTo:0];
        }
    }
}

- (void)aniGiftViewShouldStopAnimation:(BOOL *)should {
    if (self.guangBoGiftTotalArray.count == 0) {
        //
        *should = NO;
        return;
    }
    
    for (XDGiftModel *model in self.guangBoGiftTotalArray) {
        
        XDAniGiftView *giftView;
        giftView = [self getGiftViewSlot:model.group_id];
        
        if (giftView != nil) {
            
            [self.guangBoGiftTotalArray removeObject: model];
            giftView.running = YES;
            // 2 给动画横幅赋值
            giftView.giftModel = model;
            giftView.hidden = NO;
            giftView.animateGroup_id = model.group_id;
            
            NSInteger count = [[XDGiftInfoManager sharedXDGiftInfoManager].giftTotalCount[model.group_id] integerValue];
            
            // 3 开始动画
            [giftView beginAnimate:count andTo:0];
        }
    }


}




@end
