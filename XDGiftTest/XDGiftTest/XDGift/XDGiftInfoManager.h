//
//  XDGiftInfoManager.h
//  seeYouTime
//
//  Created by 形点网络 on 16/7/28.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDGiftInfoManager : NSObject



@property (nonatomic, strong) NSMutableDictionary *giftTotalCount;  // 该种礼物一次一共多少个
@property (nonatomic, strong) NSMutableDictionary *countInfo;  // 一种礼物一共送了多少个了
@property (nonatomic, strong) NSMutableDictionary *animateState;  // 该种礼物是否送完
@property (nonatomic, strong) NSMutableDictionary *giftQueue;  // 该种礼物在哪个队列中

/** 保存礼物信息*/

/** 展示礼物队列的数组*/

@end
