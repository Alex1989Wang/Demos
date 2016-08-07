//
//  XDGiftModel.h
//  seeYouTime
//
//  Created by 形点网络 on 16/7/27.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XDGiftReceiverType) {
    XDGiftReceiverTypeHost = 1,
    XDGiftReceiverTypeMaleGuest = 2,
    XDGiftReceiverTypeFemaleGuest = 3,
};

@interface XDGiftGroup : NSObject

#warning 用于测试的多余model属性；
@property (nonatomic, strong) UIImage *giftImage; // 礼物图片
@property (nonatomic, strong) UIImage *senderImage; // 送礼人头像

/* 送礼物的人名字 */
@property (nonatomic, copy) NSString *senderName;

/* 送礼物的人头像 */
@property (nonatomic, copy) NSString *senderLogoURL;

/* 接受者名字 */
@property (nonatomic, copy) NSString *receiverName;

/* 接受者头像 */
@property (nonatomic, copy) NSString *receiverLogoURL;

/* 礼物id */
@property (nonatomic, assign) NSUInteger giftID;

/* 连送server group id */
@property (nonatomic, assign) NSString *serverGroupID;

/* 连送client group id */
@property (nonatomic, assign) NSString *clientGroupID;

/* 连送礼物组数量 */
@property (nonatomic, assign) NSInteger count;

/* 礼物接受者类型 */
@property (nonatomic, assign) XDGiftReceiverType receiverType;

@end