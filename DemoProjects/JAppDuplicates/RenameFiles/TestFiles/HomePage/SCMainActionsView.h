//
//  PCMainActionsView.h
//  SelfieCamera
//
//  Created by JiangWang on 2018/11/14.
//  Copyright © 2018 Pinguo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PCMainActionType) {
    PCMainActionTypeShoot,
    PCMainActionTypeEdit,
    PCMainActionTypeStore, //实际是appwall的入口
};
static inline BOOL isValidActionType(PCMainActionType type) {
    return (type == PCMainActionTypeShoot ||
            type == PCMainActionTypeEdit ||
            type == PCMainActionTypeStore);
}

@class PCMainActionsView;

NS_ASSUME_NONNULL_BEGIN

@protocol PCMainActionsViewDelegate <NSObject>

/**
 main的按钮视图-横向展布所有的按钮

 @param actionView action视图
 @param type 视图回调的行为类型
 */
- (void)mainActionView:(PCMainActionsView *)actionView didSendAction:(PCMainActionType)type;

@end

/**
 main的按钮视图-横向展布所有的按钮
 现在固定展示这三个控件
 */
@interface PCMainActionsView : UIView
@property (nonatomic, weak) id<PCMainActionsViewDelegate> delegate;
@property (nonatomic, assign, getter=isStoreHidden) BOOL storeHidden;
@end

NS_ASSUME_NONNULL_END

