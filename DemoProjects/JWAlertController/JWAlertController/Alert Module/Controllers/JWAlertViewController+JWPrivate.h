//
//  JWAlertViewController+JWPrivate.h
//  
//
//  Created by JiangWang on 22/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import "JWAlertViewController.h"

/**
 不需要外界知道的方法
 */
@interface JWAlertViewController (JWPrivate)

/**
 alertView动画呈现出来
 
 @param animated 是否动画
 @param completion 动画结束
 */
- (void)displayAlertViewAnimated:(BOOL)animated
               completed:(void(^)(BOOL completed))completion;

/**
 去掉alert

 @param animated 是否动画
 @param completion 动画结束
 */
- (void)dismissAlertViewAnimated:(BOOL)animated
               completed:(void(^)(BOOL completed))completion;

/**
 当alertView的确出现到屏幕的时候
 这个方法只会调用一次
 */
- (void)alertViewDidAppear;
@end
