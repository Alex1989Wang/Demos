//
//  ZTCrashNonatomicViewController.m
//  ZombieTest
//
//  Created by JiangWang on 2018/11/5.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "ZTCrashNonatomicViewController.h"
#import "ZTDummyObject.h"

@interface ZTCrashNonatomicViewController ()
@property (nonatomic, strong) ZTDummyObject *dummy;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation ZTCrashNonatomicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = dispatch_queue_create("com.jiangwang.zombieQueue", DISPATCH_QUEUE_CONCURRENT);
}

- (IBAction)clickToCrash {

    //multi-thread zombie
    /*
    for (NSInteger loop = 0; loop < 1000; loop++) {
        __weak typeof(self) wSelf = self;
        dispatch_async(self.queue, ^{
            __strong typeof(wSelf) sSelf = wSelf;
            sleep(0.8);
            sSelf.dummy = [[ZTDummyObject alloc] init];
        });
        
        //main
        [self.dummy dummyMethod];
    }
     */
    
    for (NSInteger loop = 0; loop < 100000; loop++) {
        dispatch_async(self.queue, ^{
            _dummy = [[ZTDummyObject alloc] init];
        });
        [self.dummy dummyMethod];
    }
}


@end
