//
//  XDGiftModel.h
//  seeYouTime
//
//  Created by 形点网络 on 16/7/27.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDGiftModel : NSObject
    @property (nonatomic, strong) UIImage *giftImage; // 礼物图片
    @property (nonatomic, strong) UIImage *giftName;  // 礼物名称
    @property (nonatomic, strong) NSString *sendName; // 送礼人名称
    @property (nonatomic, strong) UIImage *sendImage; // 送礼人头像
    @property (nonatomic, strong) NSString *acceptName; // 接受者
    @property (nonatomic, assign) NSInteger acceptType; // 接受者类型   // 1 主持人 2 男嘉宾 3 女嘉宾
    @property (nonatomic, assign) NSInteger count; // 礼物个数
    @property (nonatomic, strong) NSString *group_id; // 一个连送礼物的标示
    @property (nonatomic, strong) NSString *sendUser_id; // 送礼物的人的uid
@end