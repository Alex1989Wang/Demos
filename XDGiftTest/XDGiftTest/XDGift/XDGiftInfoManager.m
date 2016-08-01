//
//  XDGiftInfoManager.m
//  seeYouTime
//
//  Created by 形点网络 on 16/7/28.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDGiftInfoManager.h"

@implementation XDGiftInfoManager



- (NSMutableDictionary *)countInfo
{
    if (_countInfo == nil) {
        _countInfo = [NSMutableDictionary dictionary];
    }
    
    return _countInfo;
}

-(NSMutableDictionary *)animateState
{
    if (_animateState == nil) {
        _animateState = [NSMutableDictionary dictionary];
    }
    
    return _animateState;
}

- (NSMutableDictionary *)giftTotalCount
{
    if (_giftTotalCount == nil) {
        
        _giftTotalCount = [NSMutableDictionary dictionary];
    }
    
    return _giftTotalCount;
}

-(NSMutableDictionary *)giftQueue
{
    if (_giftQueue == nil) {
        _giftQueue = [NSMutableDictionary dictionary];
    }
    
    return _giftQueue;
}
@end
