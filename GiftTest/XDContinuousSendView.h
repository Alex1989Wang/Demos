//
//  XDLianSongView.h
//  testGift
//
//  Created by 形点网络 on 16/7/24.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDContinuousSendView;
@protocol XDContinuousSendViewDelegate <NSObject>

@optional
- (void)lianSongGiftTouchDown:(XDContinuousSendView *)view;
- (void)lianSongGiftTouchUp:(XDContinuousSendView *)view;

@end
@interface XDContinuousSendView : UIView
/**  接受对象*/
@property (nonatomic, weak) UILabel *acceptLabel;
/** 送出的 礼物*/ 
@property (nonatomic, weak) UIImageView *giftImageView;
/** 礼物个数*/
@property (nonatomic, weak) UILabel *giftCountLabel;
@property (nonatomic, weak) id <XDContinuousSendViewDelegate> delegate;
@end
