//
//  GCDTester.m
//  GCDDemo
//
//  Created by JiangWang on 20/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "GCDTester.h"

static const NSString *kConcurrentQueueID = @"com.jiangwang.kConcurrentQueueID";
static const NSString *kSerialQueueID = @"com.jiangwang.kSerialQueueID";

@interface GCDTester()
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
        
@end

@implementation GCDTester
#pragma mark - Serial Test
- (void)serialTest {
    //10 async tasks
    for (NSInteger index = 0; index < 5; index++) {
        dispatch_async(self.serialQueue, ^{
            sleep(0.5);
            dispatch_async(self.serialQueue, ^{
                NSLog(@"serial async -> async test: %ld", index);
            });
            NSLog(@"serial task no.%ld", index);
        });
    }
    
    //can sync
    dispatch_sync(self.serialQueue, ^{
        NSLog(@"serial sync task");
    });
    
    //another 10 async tasks
    for (NSInteger index = 5; index < 10; index++) {
        dispatch_async(self.concurrentQueue, ^{
            sleep(0.5);
            NSLog(@"serial task no.%ld", index);
        });
    }
}

#pragma mark - Barrier Test
- (void)barrierTest {
    //10 concurrent tasks
    for (NSInteger index = 0; index < 5; index++) {
        dispatch_async(self.concurrentQueue, ^{
            sleep(0.5);
            NSLog(@"concurrent task no.%ld", index);
        });
    }
    
    //submmit a barrier - task 10
    dispatch_barrier_async(self.concurrentQueue, ^{
        NSLog(@"barrier async task");
    });
    
    //another 10 concurrent tasks
    for (NSInteger index = 5; index < 10; index++) {
        dispatch_async(self.concurrentQueue, ^{
            sleep(0.5);
            NSLog(@"concurrent task no.%ld", index);
        });
    }
    
    //sync
    dispatch_barrier_sync(self.concurrentQueue, ^{
        NSLog(@"barrier sync");
    });
    
    //another 10 concurrent tasks
    for (NSInteger index = 11; index < 15; index++) {
        dispatch_async(self.concurrentQueue, ^{
            sleep(0.5);
            NSLog(@"concurrent task no.%ld", index);
        });
    }
}


#pragma mark - Lazy Loading 
- (dispatch_queue_t)concurrentQueue {
    if (_concurrentQueue == nil) {
        const char *queueID = [kConcurrentQueueID cStringUsingEncoding:NSASCIIStringEncoding];
        _concurrentQueue = dispatch_queue_create(queueID, DISPATCH_QUEUE_CONCURRENT);
    }
    return _concurrentQueue;
}

- (dispatch_queue_t)serialQueue {
    if (_serialQueue == nil) {
        const char *queueID = [kSerialQueueID cStringUsingEncoding:NSASCIIStringEncoding];
        _serialQueue = dispatch_queue_create(queueID, DISPATCH_QUEUE_SERIAL);
    }
    return _serialQueue;
}

@end
