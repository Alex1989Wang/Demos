//
//  TestOperationQueueManager.h
//  ConcurrentDemo
//
//  Created by JiangWang on 26/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "TestOperation.h"

@interface TestOperationQueueManager : TestOperation

+ (TestOperationQueueManager *)sharedManager;

- (void)addOperation:(NSOperation *)operation;
@end
