//
//  XDGiftView.m
//  testGift
//
//  Created by 形点网络 on 16/6/30.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDGiftView.h"
#import "XDGiftUserView.h"
#import "XDgiftCell.h"
#import "XDAniGiftView.h"
#import "XDLianSongView.h"

// 礼物分三页
#define KPage 3
// 礼物出现的位置
#define KLocation 30

@interface XDGiftView ()<UICollectionViewDataSource, UICollectionViewDelegate, XDLianSongViewDelegate>
// 顶部
@property (nonatomic, weak) UIView *topView;
// 中间
@property (nonatomic, weak) UIView *middleView;
// 底部
@property (nonatomic, weak) UIView *bottomView;
// 上分割线
@property (nonatomic, weak) UIView *oneLine;
// 下分割线
@property (nonatomic, weak) UIView *twoLine;
/** 送给label*/
@property (nonatomic, weak) UILabel *sendLabel;
// gift interface
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flow;
// 分页符
@property (nonatomic, weak) UIPageControl *pageControl;

// 金币视图
@property (nonatomic, weak) UIButton *moneyButton;
// 充值按钮
@property (nonatomic, weak) UIButton *fillButton;
// 赠送按钮
@property (nonatomic, weak) UIButton *sendButton;

@property (nonatomic, weak) XDAniGiftView *aniGiftView; // 送出的礼物视图
@property (nonatomic, weak) XDLianSongView *lianSongView; // 送出的礼物视图
// 上次点击时间
@property (nonatomic, strong) NSDate *time;

// 定时器
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) XDgiftCell *seleCell; // 选中的cell

@end
@implementation XDGiftView

static NSString *ID = @"giftCollection";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpFirst];
    }
    return self;
}

- (void)setUpFirst
{
    // 创建子控制器
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    self.topView = topView;
    [self addSubview:topView];
    
    UIView *oneLine = [[UIView alloc] init];
    self.oneLine = oneLine;
    oneLine.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.2];
    [self addSubview:oneLine];
    
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor clearColor];
    self.middleView = middleView;
    [self addSubview:middleView];
    
    UIView *twoLine = [[UIView alloc] init];
    self.twoLine = twoLine;
    twoLine.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.2];
    [self addSubview:twoLine];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor clearColor];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    
    UILabel *sendLabel = [[UILabel alloc] init];
    sendLabel.text = @"送给";
    sendLabel.font = [UIFont systemFontOfSize:17];
    [sendLabel sizeToFit];
    self.sendLabel = sendLabel;
    sendLabel.textColor  =[UIColor whiteColor];
    [self.topView addSubview:sendLabel];
    
    // 顶部 - 嘉宾、主持人信息视图
    for (NSInteger i = 0; i < 3; i++) {
        
        XDGiftUserView *userV = [[XDGiftUserView alloc] init];
#warning - 拿到传递过来的嘉宾、主持人模型数组后再这个地方赋值
        userV.name = @"啥玩意啥玩意啥玩意啥玩意";
        userV.iconUrl = @"测试头像";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBounds:)];
        if (i == 0) {
            
            userV.big = NO;
        }else{
            userV.big = YES;
        }
        [userV addGestureRecognizer:tap];
        [self.topView addSubview:userV];
    }
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    self.flow = flow;
    
    // 中间礼物视图
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    [self.middleView addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDgiftCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    UIPageControl *page = [[UIPageControl alloc] init];
    self.pageControl = page;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.middleView addSubview:page];
    
    // 底部 - 赠送、充值
    UIButton *moneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moneyButton.userInteractionEnabled = NO;
    [moneyButton setImage:[UIImage imageNamed:@"gold_icon"] forState:UIControlStateNormal];
    [moneyButton setTitle:@"10234999" forState:UIControlStateNormal];
    [moneyButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    moneyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [moneyButton sizeToFit];
    moneyButton.width = moneyButton.width + 5;
    self.moneyButton = moneyButton;
    [self.bottomView addSubview:moneyButton];
    
    UIButton *fillButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fillButton setTitle:@"充值 >" forState:UIControlStateNormal];
    [fillButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    fillButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [fillButton addTarget:self action:@selector(fillMoney) forControlEvents:UIControlEventTouchUpInside];
    [fillButton sizeToFit];
    self.fillButton = fillButton;
    [self.bottomView addSubview:fillButton];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"赠送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendButton.backgroundColor = [UIColor yellowColor];
    sendButton.enabled = NO;
    [sendButton addTarget:self action:@selector(sendGift) forControlEvents:UIControlEventTouchUpInside];
    [sendButton addTarget:self action:@selector(sendGiftClickDown) forControlEvents:UIControlEventTouchDown];
    [sendButton sizeToFit];
    self.sendButton = sendButton;
    [self.bottomView addSubview:sendButton];
    
    
}

- (void)changeBounds:(UITapGestureRecognizer *)tap
{
#warning - 把点击的view对应的用户信息保存起来，知道给谁送礼物
    XDGiftUserView *v = (XDGiftUserView *)tap.view;
    v.big = NO;
    
    for (UIView *subV in self.topView.subviews) {
        
        if ([subV isKindOfClass:[XDGiftUserView class]] && subV != tap.view) {
            
            XDGiftUserView *vv = (XDGiftUserView *)subV;
            vv.big = YES;
        }
    }
    
    [self setNeedsLayout];
}

// layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (iPhone5) [self layoutviews:H5];
    if (iPhone6) [self layoutviews:H6];
    if (iPhone6p) [self layoutviews:H6Plus];
}

// 计算
- (void)layoutviews:(CGFloat)scale
{
    self.width = XDScreenW;
    self.height = 244 * scale;
    self.y = XDScreenH - self.height;
    
    self.topView.x = 0;
    self.topView.y = 0;
    self.topView.width = XDScreenW;
    self.topView.height = 70 * scale;
    
    self.oneLine.y = CGRectGetMaxY(self.topView.frame);
    self.oneLine.width = XDScreenW;
    self.oneLine.height = 1;
    
    self.middleView.x = 0;
    self.middleView.y = CGRectGetMaxY(self.topView.frame) + 1;
    self.middleView.width = XDScreenW;
    self.middleView.height = 127 * scale;
    
    self.twoLine.y = CGRectGetMaxY(self.middleView.frame);
    self.twoLine.width = XDScreenW;
    self.twoLine.height = 1;
    
    self.bottomView.x = 0;
    self.bottomView.y = CGRectGetMaxY(self.middleView.frame) + 1;
    self.bottomView.width = XDScreenW;
    self.bottomView.height = 45 * scale;
    
    self.sendLabel.x = 5 * scale;
    self.sendLabel.y = 70 *scale - 20 * scale - self.sendLabel.height;
    for (NSInteger i = 0; i < self.topView.subviews.count; i++) {
        
        XDGiftUserView *subV = self.topView.subviews[i];
        if ([subV isKindOfClass:[UILabel class]]) continue;
        
        if (i == 1) {
            subV.x = CGRectGetMaxX(self.sendLabel.frame) + 10 * scale;
        }
        
        if (i == 2) {
            XDGiftUserView *subV1 = self.topView.subviews[i - 1];
            subV.x = subV1.big ? CGRectGetMaxX(self.sendLabel.frame) + 10 * scale + (40 + 10) *scale : CGRectGetMaxX([self.topView.subviews[i - 1] frame]) + 10 * scale;
            
        }
        
        if (i == 3) {
            
            subV.x = subV.big ? CGRectGetMaxX([self.topView.subviews[i - 1] frame]) + 10 * scale : CGRectGetMaxX(self.sendLabel.frame) + 10 * scale + (40 * 2 + 10 *2)*scale;
        }
    }
    
    self.collectionView.frame = self.middleView.bounds;
    self.flow.itemSize = CGSizeMake(75 * scale, self.middleView.height);
    self.flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flow.minimumLineSpacing = 0;
    
    self.pageControl.width = XDScreenW;
    self.pageControl.height = 6;
    self.pageControl.centerX = XDScreenW * 0.5;
    self.pageControl.y = self.middleView.height - 6 * scale - 8 * scale;
    
    self.moneyButton.centerY = self.bottomView.height * 0.5;
    self.moneyButton.x = 10 * scale;
//    self.moneyButton.width = self.moneyButton.width + 5;
    
    self.fillButton.centerY = self.bottomView.height * 0.5;
    self.fillButton.x = CGRectGetMaxX(self.moneyButton.frame) + 20 * scale;
    
    self.sendButton.height = self.bottomView.height * 0.7;
    self.sendButton.centerY = self.bottomView.height * 0.5;
    self.sendButton.width = [self.sendButton.currentTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}].width + 30;
    self.sendButton.x = XDScreenW - 10 * scale - self.sendButton.width;
    self.sendButton.layer.cornerRadius = 5;
    
    
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.numberOfPages = self.collectionView.contentSize.width / XDScreenW;  // 确定页码指示器的页数
    XDgiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",arc4random_uniform(5) + 1]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / XDScreenW;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取选择的cell
    XDgiftCell *cell = (XDgiftCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.seleCell = cell;
    self.sendButton.enabled = YES;
}

#pragma mark - 底部按钮操作
- (void)fillMoney
{
    
    NSLog(@"点击了充值按钮");
}

static NSInteger number = 1;

- (void)sendGift
{
    NSLog(@"点击了赠送按钮");
    
#warning - 赠送礼物
    // 0 定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenView) userInfo:nil repeats:NO];
    
    self.timer = timer;
    
    self.hidden  = YES;  // 点击赠送那么隐藏礼物界面，显示连送界面
}

- (void)sendGiftClickDown
{
#warning - 时间判断 要求5秒内连击
    // 1 创建礼物视图

    self.lianSongView.giftImageView.image = self.seleCell.image;
    self.lianSongView.delegate = self;
    // 2 判断用户连击时间
    NSDate *date = [NSDate date];
    XDLog(@"送礼个数-%ld",number);
    XDLog(@"获取时间355-%f",[date timeIntervalSinceDate:self.time]);
    
    number ++;
    
    if ([date timeIntervalSinceDate:self.time] < 2.0) {
        
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    self.time = date;
}

#warning - 礼物界面 ==================
- (void)hiddenView
{
    [self.aniGiftView removeFromSuperview];
    number = 1;
    NSLog(@"yinshen");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xianshen" object:nil];
}

// lazy
-(XDAniGiftView *)aniGiftView
{
    if (_aniGiftView == nil) {
        
        XDAniGiftBanner *aniGift = [XDAniGiftBanner aniGiftBanner];
        self.aniGiftView = aniGift;
        self.aniGiftView.y = KLocation;
        self.aniGiftView.x = -aniGift.width + 30;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.aniGiftView.x = 0;
        }];
        aniGift.backgroundColor = [UIColor colorWithHexString:@"#f8e408" alpha:0.3];
        [[UIApplication sharedApplication].keyWindow addSubview:aniGift];
    }
    
    return _aniGiftView;
}

- (XDLianSongView *)lianSongView
{
    if (_lianSongView == nil) {
        
        XDLianSongView *lianSong = [[XDLianSongView alloc] init];
        self.lianSongView = lianSong;
        [[UIApplication sharedApplication].keyWindow addSubview:lianSong];
    }
    
    return _lianSongView;
}

// 连送的代理 -  实现点击送礼物
-(void)lianSongGiftTouchDown:(XDLianSongView *)view
{

    
    NSDate *date = [NSDate date];
    
    
    number ++;
    
    if ([date timeIntervalSinceDate:self.time] < 2.0) {
        
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    self.time = date;
}

-(void)lianSongGiftTouchUp:(XDLianSongView *)view
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenView) userInfo:nil repeats:NO];
    
    self.timer = timer;
}
@end
