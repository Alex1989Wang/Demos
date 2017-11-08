//
//  JWGeneralMiddleAlertController.h
//  
//
//  Created by JiangWang on 28/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import "JWAlertViewController.h"

NS_ASSUME_NONNULL_BEGIN
/**
 该类对应UI规范中->居中提示弹窗样式
 请查看该样式需要传入的参数
 1. 横向展布按钮(一个或者多个)
 2. 居中显示
 3. 可以带标题或者不带标题
 4. 使用父类的addAction添加按钮
 */
@interface JWGeneralMiddleAlertController : JWAlertViewController


/**
 默认的两个按钮类型

 - JWMiddleAlertButtonActionTypeConfirm: 确认按钮类型
 - JWMiddleAlertButtonActionTypeCancel: 取消按钮类型
 */
typedef NS_ENUM(NSUInteger, JWMiddleAlertButtonActionType) {
    JWMiddleAlertButtonActionTypeConfirm = 1,
    JWMiddleAlertButtonActionTypeCancel,
};

typedef void (^JWMiddleAlertButtonActionBlock)(JWMiddleAlertButtonActionType actionType);
@property (nonatomic, copy, readonly, nullable) NSString *alertTitle;
@property (nonatomic, copy, readonly) NSString *alertContent;
@property (nonatomic, assign) NSTextAlignment contentAlignment; //默认值为center

/**
 直接弹出一个Alert Controller
 
 @param controller 需要弹窗的控制器
 @param title 弹窗的控制器的标题
 @param message 弹窗内容信息
 @param okTitle 弹窗的ok按钮标题
 @param cancelTitle 弹窗的取消按钮标题
 @param layoutDirection 按钮的展布方向
 @param clickBlock 按钮行为（根据YES/NO)分别为confirm和cancel行为
 */
+ (instancetype)alertWithController:(UIViewController *)controller
                          withTitle:(NSString *)title
                       alertMessage:(NSString *_Nullable)message
                           okButton:(NSString *_Nullable)okTitle
                       cancelButton:(NSString *_Nullable)cancelTitle
                 buttonsLayoutStyle:(JWAlertActionLayoutDirection)layoutDirection
                         clickBlock:(JWMiddleAlertButtonActionBlock _Nullable)clickBlock;

/**
 类方法构建一个普通的中间弹窗控制器

 @param title 弹窗标题
 @param message 弹窗消息内容
 @return 构建好的弹窗控制器对象
 */
+ (instancetype)alertControllerWithTitle:(NSString *__nullable)title
                            alertMessage:(NSString *)message;

/**
 构建一个普通的中间弹窗控制器

 @param title 弹窗标题
 @param message 弹窗消息内容
 @return 构建好的弹窗控制器对象
 */
- (instancetype)initWithTitle:(NSString *__nullable)title
                 alertMessage:(NSString *)message;

/* 
 使用范例
 
 NSString *title = NSLocalizedString(@"glive_alert_title_prompt", nil);
 NSString *content = NSLocalizedString(@"glive_alert_content_top_up_gold", nil);
 JWGeneralMiddleAlertController *topUpAlert =
 [[JWGeneralMiddleAlertController alloc] initWithTitle:title
 alertMessage:content];
 NSDictionary *notNowAttribs = @{JWAlertActionTitleFontKey : [UIFont systemFontOfSize:15.f],
 JWAlertActionTitleColorKey : XXX,};
 JWAlertAction *notNowAction = [JWAlertAction actionWithTitle:@"Not Now"
 actionButtonAttributes:notNowAttribs
 handler:nil];
 NSDictionary *rechargeAttribs = @{JWAlertActionTitleFontKey : [UIFont systemFontOfSize:15.f],
 JWAlertActionTitleColorKey : XXX,};
 JWAlertAction *rechargeAction = [JWAlertAction actionWithTitle:@"Recharge"
 actionButtonAttributes:rechargeAttribs
 handler:nil];
 [topUpAlert addAction:notNowAction];
 [topUpAlert addAction:rechargeAction];
 [self presentAlertController:topUpAlert animated:YES];
 
 */
@end

NS_ASSUME_NONNULL_END
