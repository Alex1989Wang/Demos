//
//  ViewController.m
//  GCD_Semaphore
//
//  Created by JiangWang on 07/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self semaphoreMultiThreadControl];
}

//控制并发
- (void)semaphoreMultiThreadControl {
    dispatch_group_t multiBlockGroup = dispatch_group_create();
    dispatch_semaphore_t tenControlSemaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //一百次的循环
    for (NSInteger start = 0; start < 10; start++) {
        dispatch_group_async(multiBlockGroup, queue, ^{
            NSLog(@"has entered: %@ --- thread infomation: %@",
                  @(start), [NSThread currentThread]);
            sleep(2);
            dispatch_semaphore_signal(tenControlSemaphore);
        });
        dispatch_semaphore_wait(tenControlSemaphore, DISPATCH_TIME_FOREVER);
    }
}


@end
