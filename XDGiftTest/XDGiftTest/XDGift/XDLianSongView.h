//
//  XDLianSongView.h
//  testGift
//
//  Created by 形点网络 on 16/7/24.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDLianSongView;
@protocol XDLianSongViewDelegate <NSObject>

@optional
- (void)lianSongGiftTouchDown:(XDLianSongView *)view;
- (void)lianSongGiftTouchUp:(XDLianSongView *)view;

@end
@interface XDLianSongView : UIView
/**  接受对象*/
@property (nonatomic, weak) UILabel *acceptLabel;
/** 送出的 礼物*/ 
@property (nonatomic, weak) UIImageView *giftImageView;
/** 礼物个数*/
@property (nonatomic, weak) UILabel *giftCountLabel;
@property (nonatomic, weak) id <XDLianSongViewDelegate> delegate;
@end
