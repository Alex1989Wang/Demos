//
//  XDShareView.h
//  textShare
//
//  Created by 形点网络 on 16/6/29.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDShareView;
@protocol XDShareViewDelegate <NSObject>

@optional
- (void)shareView:(XDShareView *)view clickButton:(UIButton *)btn;

@end



@interface XDShareView : UIView

@property (nonatomic, weak) id <XDShareViewDelegate> delegate;

/* fast instantiation */
+ (instancetype)shareView;

@end
