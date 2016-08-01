//
//  XDDataCenter.m
//  DataCenter
//
//  Created by JiangWang on 16/7/31.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "XDDataCenter.h"

@interface XDDataCenter()


@end

@implementation XDDataCenter

+ (instancetype)sharedCenter {
    static XDDataCenter *sharedCenter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[XDDataCenter alloc] init];
    });
    
    return sharedCenter;
}


@end
