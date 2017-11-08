//
//  JWAlertViewController.h
//  
//
//  Created by JiangWang on 21/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 整个controller应该是什么样的类型

 - JWAlertViewControllerStyleActionSheet: 底部弹出的类型
 - JWAlertViewControllerStyleAlertView: 中间弹出类型
 */
typedef NS_ENUM(NSInteger, JWAlertViewControllerStyle) {
    JWAlertViewControllerStyleActionSheet = 0,
    JWAlertViewControllerStyleAlertView,
};

/**
 所有action按钮的展布状态

 - JWAlertActionLayoutDirectionHorizontal: 水平展布所有action按钮
 - JWAlertActionLayoutDirectionVertical: 垂直展布所有action按钮
 */
typedef NS_ENUM(NSInteger, JWAlertActionLayoutDirection) {
    JWAlertActionLayoutDirectionHorizontal = 1, //水平展布所有action按钮
    JWAlertActionLayoutDirectionVertical, //垂直展布所有action按钮
};


/**
 弹窗离屏幕的边界
 */
typedef NS_ENUM(NSUInteger, JWAlertContentMarginType) {
    JWAlertContentMarginTypeSmall, //15
    JWAlertContentMarginTypeNormal, //28
    JWAlertContentMarginTypeLarge, //45
};

extern NSString *const JWAlertActionButtonImageKey;
extern NSString *const JWAlertActionTitleColorKey;
extern NSString *const JWAlertActionTitleFontKey;
//extern NSString *const JWAlertActionButtonRoundCornerKey;

@interface JWAlertAction : NSObject 
@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSDictionary *actionButtonAttributes;

/**
 构建action的模型

 @param title action的标题
 @param attributes 按钮的特征
 @param handler 点击行为
 @return action
 */
+ (instancetype)actionWithTitle:(NSString *)title
         actionButtonAttributes:(NSDictionary *)attributes
                        handler:(void (^ __nullable)(JWAlertAction *action))handler;
@end


@interface JWAlertViewController : UIViewController
@property (nonatomic, readonly) NSArray<JWAlertAction *> *actions; //该controller所有的action
@property (nullable, nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, readonly) JWAlertViewControllerStyle preferredStyle;
@property (nonatomic, readonly) JWAlertActionLayoutDirection actionsStyle;

/**
 直接传入构建的好的contentView

 @param contentView 内容视图(用于显示在按钮之上）
 @param marginType 边距的大小
 @param preferredStyle 底部还是中间弹出的类型
 @param actionsLayout 横向还是垂直展布按钮
 @return alert controller实例
 */
+ (instancetype)alertControllerWithCustomContentView:(UIView *)contentView
                                   contentMarginType:(JWAlertContentMarginType)marginType
                                      preferredStyle:(JWAlertViewControllerStyle)preferredStyle
                                   alertActionLayout:(JWAlertActionLayoutDirection)actionsLayout;


/**
 实例方法

 @param customContentView 内容视图
 @param marginType 边距的大小
 @param preferredStyle 底部还是中间弹出的类型
 @param actionsLayout 横向还是垂直展布按钮
 @return alert controller实例
 */
- (instancetype)initWithCustomContentView:(UIView *)customContentView
                        contentMarginType:(JWAlertContentMarginType)marginType
                           preferredStyle:(JWAlertViewControllerStyle)preferredStyle
                        alertActionLayout:(JWAlertActionLayoutDirection)actionsLayout;

/**
 添加Alert的行为model

 @param action alert按钮点击行为model
 */
- (void)addAction:(JWAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
