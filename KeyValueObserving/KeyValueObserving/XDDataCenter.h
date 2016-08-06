//
//  XDDataCenter.h
//  KeyValueObserving
//
//  Created by JiangWang on 7/31/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XDDataCenter : NSObject

+ (instancetype)sharedDataCenter;



- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options;



- (void)addObserver:(id)observer forKey:(NSString *)key;

@end
