//
//  XDAniGiftView.h
//  testGift
//
//  Created by 形点网络 on 16/7/1.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XDGiftModel;

typedef void(^completeBlock)();  // 执行动画完成后
typedef void(^waitBlock)();  // 执行动画完成后

@protocol XDAniGiftViewDelegate <NSObject>

@optional
/** 横幅等待的时候*/
- (void)aniGiftViewWaiting;

/** 横幅完成的时候*/
- (void)aniGiftViewFinished;

- (void)aniGiftViewShouldStopAnimation:(BOOL *)should;

@end

@interface XDAniGiftView : UIView

+ (instancetype)aniGiftView;


@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;      // 礼物的图片
@property (weak, nonatomic) IBOutlet UIImageView *sendUserImageView;  // 送礼物人 头像
@property (weak, nonatomic) IBOutlet UILabel *sendUserNameLabel;      // 送礼物人的名字
@property (weak, nonatomic) IBOutlet UILabel *acceptUserNameLabel;   // 收礼物人的名字
@property (nonatomic, assign) NSInteger acceptType;           // 1 主持人 2 男嘉宾 3 女嘉宾



@property (nonatomic,assign,getter=isFinished) BOOL finished; //是否完成
@property (nonatomic, strong) NSMutableArray *giftCountArray; // 礼物个数数组
@property (nonatomic, assign) NSInteger columNum; // 礼物横幅的行数
- (void)giftQueueAnimation:(completeBlock)complete;

@property (nonatomic, assign) NSInteger aniCount;                // 正在显示的数字
@property (nonatomic, assign) NSInteger fromCount;                // 从几开始显示的数字

@property (nonatomic, strong) completeBlock finishBlock;  // 横幅完成状态
@property (nonatomic, assign, getter=isAllowFinish) BOOL allowFinish;     // 横幅是否执行完成操作
@property (nonatomic, strong) waitBlock waitedBlock;     // 横幅等待状态
@property (nonatomic, assign, getter=isContinueFinish) BOOL continueFinish;     // 横幅是否执行完成操作

@property (nonatomic, strong) XDGiftModel *giftModel;    // 需要执行动画的礼物
@property (nonatomic, strong) NSString *animateGroup_id;  // 动画的group_id
@property (nonatomic, assign, getter=isRunning) BOOL running;  // 该View是否在动画

@property (nonatomic, weak) id <XDAniGiftViewDelegate> delegate;

- (void)beginAnimate:(NSInteger)from andTo:(NSInteger)to;  // 执行动画的接口

- (void)beginAnimation;

@end
