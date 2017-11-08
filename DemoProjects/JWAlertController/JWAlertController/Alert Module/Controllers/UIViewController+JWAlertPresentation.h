//
//  UIViewController+JWAlertPresentation.h
//  
//
//  Created by JiangWang on 22/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWAlertViewController;
@interface UIViewController (JWAlertPresentation)
/**
 弹出一个提示控制器

 @param alertController JWAlertViewController类型的自定义弹窗
 @param animated 是否需要弹出的时候动画
 */
- (void)presentAlertController:(JWAlertViewController *)alertController
                      animated:(BOOL)animated;

/**
 取消弹窗控制器

 @param alertController JWAlertViewController类型的自定义弹窗
 @param animated 是否需要淡出动画
 @note 点击按钮时已经自动调用
 */
- (void)dismissAlertController:(JWAlertViewController *)alertController
                      animated:(BOOL)animated;
@end
