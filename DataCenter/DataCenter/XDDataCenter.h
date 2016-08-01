//
//  XDDataCenter.h
//  DataCenter
//
//  Created by JiangWang on 16/7/31.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDDataCenter : NSObject

/**
 *  Instantiate a singleton which manages all the room-related data.
 *
 *  @return the singleton
 */
+ (instancetype)sharedCenter;


- (void)addObserver:(NSObject *)observer forKey:(NSString *)key options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
