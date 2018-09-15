//
//  ViewController.m
//  JWDeadLockTest
//
//  Created by JiangWang on 2018/9/15.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWViewController.h"

@interface JWViewController ()
@property (nonatomic, strong) NSTimer *cpuBusyTimer; //give cup some work to do
@property (nonatomic, strong) NSLock *deadLock;
@property (nonatomic, strong) dispatch_queue_t deadlockQueue;
@property (nonatomic, strong) NSMutableSet *completedSubblocks;
@property (nonatomic, strong) NSLock *subblocksLock;
@end

@implementation JWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.cpuBusyTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
//                                                         target:self
//                                                       selector:@selector(timerTicked)
//                                                       userInfo:nil
//                                                        repeats:YES];
    self.deadLock = [[NSLock alloc] init];
    self.deadlockQueue = dispatch_queue_create("com.jiangwang.deadlock", DISPATCH_QUEUE_SERIAL);
}

- (IBAction)clickToDeadlock:(UIButton *)sender {
    [self concurrentQueueDeadlock];
}

- (void)timerTicked {
    //cpu 100%
    for (NSInteger index = 0; index < 100000; index++) {
        UIView *localView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        [self.view addSubview:localView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [localView removeFromSuperview];
        });
    }
}

#pragma mark - Deadlocks
- (void)nslockDeadlock {
    //mutex deadlock
    [self.deadLock lock];
    [self nslockLockAgain];
    [self.deadLock unlock];
}

- (void)dispatchSyncDeadlock {
    //死锁子线程
    dispatch_async(self.deadlockQueue, ^{
        dispatch_sync(self.deadlockQueue, ^{
            NSLog(@"current thread: %@", [NSThread currentThread]);
            dispatch_sync(self.deadlockQueue, ^{
                NSLog(@"current thread: %@", [NSThread currentThread]);
            });
        });
    });
}

- (void)syncToMainThreadDeadlock {
    //死锁主线程
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"current tread is main thread ? %@", [NSThread isMainThread] ? @"true" : @"false");
    });
}

//https://www.cocoawithlove.com/2010/06/avoiding-deadlocks-and-latency-in.html
- (void)concurrentQueueDeadlock {
    self.completedSubblocks = [[NSMutableSet alloc] init];
    self.subblocksLock = [[NSLock alloc] init];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    const int NumConcurrentBlocks = 20;
    for (int i = 0; i < NumConcurrentBlocks; i++)
    {
        dispatch_group_async(group, queue, ^{
            NSLog(@"Starting parent block %d", i);
            
            NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
            while ([(NSDate *)[NSDate date] compare:endDate] == NSOrderedAscending)
            {
                // Busy wait for 1 second to let the queue fill
            }
            
            dispatch_async(queue, ^{
                NSLog(@"Starting child block %d", i);
                
                [self.subblocksLock lock];
                [self.completedSubblocks addObject:[NSNumber numberWithInt:i]];
                [self.subblocksLock unlock];
                
                NSLog(@"Finished child block %d", i);
            });
            
            BOOL complete = NO;
            while (!complete)
            {
                [self.subblocksLock lock];
                if ([self.completedSubblocks containsObject:[NSNumber numberWithInt:i]])
                {
                    complete = YES;
                }
                [self.subblocksLock unlock];
            }
            
            NSLog(@"Finished parent block %d", i);
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

#pragma mark - Helpers
- (void)nslockLockAgain {
    [self.deadLock lock];
    [self.deadLock unlock];
}

@end
