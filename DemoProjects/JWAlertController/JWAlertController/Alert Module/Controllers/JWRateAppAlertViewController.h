//
//  JWRateAppAlertViewController.h
//  
//
//  Created by JiangWang on 21/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import "JWAlertViewController.h"

extern NSString *const kJWAppHasBeenRatedKey;

@interface JWRateAppAlertViewController : JWAlertViewController

/**
 给我们评分的提示窗

 @return alert controller;
 */
+ (JWRateAppAlertViewController *)rateAppAlertController;

/**
 查询app是否已经被评分过了

 @return 是否已经给我评分
 */
+ (BOOL)hasAppBeenRated;

@end
