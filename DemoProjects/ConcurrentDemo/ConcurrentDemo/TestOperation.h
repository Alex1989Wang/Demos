//
//  TestOperation.h
//  ConcurrentDemo
//
//  Created by JiangWang on 26/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestOperation : NSOperation
@property (nonatomic, readonly, getter=isReady) BOOL ready;
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;
@property (nonatomic, readonly, getter=isFinished) BOOL finished;
@property (nonatomic, readonly, getter=isAsynchronous) BOOL asynchronous;


- (void)finish;
@end
