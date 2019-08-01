//
//  PTFocusAndBlurView.h
//  Camera360
//
//  Created by ZhongXiaoLong on 17/3/11.
//  Copyright © 2017年 Pinguo. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 当前view操作的状态 */
typedef NS_ENUM(NSInteger, PTFocusViewState)
{
    kPTFocusViewState_Auto = 0,
    kPTFocusViewState_Manual = 1,
    kPTFocusViewState_Lock = 2,
    kPTFocusViewState_Blur = 4,
    kPTFocusViewState_Manul_Blur = kPTFocusViewState_Manual | kPTFocusViewState_Blur,
    kPTFocusViewState_Lock_Blur = kPTFocusViewState_Lock | kPTFocusViewState_Blur
};

/**
 对焦框
 */
@interface PTFocusAndBlurView : UIView

@property (nonatomic, readonly) CGFloat innerCircleRadius;
@property (nonatomic, readonly) CGFloat halfSqureWidth;
@property (nonatomic) CGFloat outerCircleRadius;
@property (nonatomic) CGFloat lensValue;
@property (nonatomic) CGFloat blurValue;
@property (nonatomic) BOOL blurState;
@property (nonatomic, readonly) CGFloat lensLength;
@property (nonatomic) CGPoint thumbLocation;
@property (nonatomic) PTFocusViewState state;
@property (nonatomic, copy) void (^stateChangeBlock)(PTFocusViewState state);

/** 显示虚化视图 */
- (void)showBlurView;

/** 显示虚化圈 */
- (void)addBlurCircle;

/** 隐藏虚化圈 */
- (void)removeBlurCircle;

/** 自动对焦动画 */
- (void)autoFocusAnimation;

/** 开始手动对焦动画 */
- (void)manualFocusAnimation;

/** 长按操作动画 */
- (void)longPressAnimation;

/** 锁定聚焦动画 */
- (void)lockFocusAnimationWithLens:(BOOL)lens withBlur:(BOOL)blur completion:(void (^)(void))completion;

/** 拖动时的缩小动画 */
- (void)animateSmall;

/** 拖动结束后恢复正常大小 */
- (void)animateNormal;

/** 还原视图为手动聚焦模式 */
- (void)resetViews;

@end
