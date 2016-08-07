//
//  XDGiftModel.m
//  seeYouTime
//
//  Created by 形点网络 on 16/7/27.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDGiftGroup.h"

@implementation XDGiftGroup



+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             
             @"senderName" : @"send_uinfo.nick",
             @"senderLogoURL" : @"send_uinfo.logo_url",
             @"receiverName" : @"to_uinfo.nick",
             @"receiverLogoURL" : @"to_uinfo.logo_url",
             @"giftID" : @"gift_id",
             @"serverGroupID" : @"server_group_id",
             @"clientGroupID" : @"client_group_id"

             };
}

@end
