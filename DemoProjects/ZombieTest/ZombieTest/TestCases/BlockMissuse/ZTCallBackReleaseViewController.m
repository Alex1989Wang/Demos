//
//  ZTCallBackReleaseViewController.m
//  ZombieTest
//
//  Created by JiangWang on 2018/11/5.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "ZTCallBackReleaseViewController.h"

@interface ZombieObj : NSObject
- (void)callBack:(void(^)(void))callback;
- (void)stubMethod;
@end
@implementation ZombieObj
- (void)stubMethod {
    NSLog(@"stub method.");
}
- (void)callBack:(void (^)(void))callback {
    if (callback) {
        callback();
    }
    
    [self stubMethod];
}
@end


@interface ZTCallBackReleaseViewController ()
@property (nonatomic, strong) ZombieObj *blockMissUse;
@end

@implementation ZTCallBackReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickToCrash {
    for (NSInteger index = 0; index < 10000; index++) {
        self.blockMissUse = [[ZombieObj alloc] init];
        __weak typeof(self) weakSelf = self;
        [_blockMissUse callBack:^{
            __strong typeof(weakSelf) strSelf = weakSelf;
            strSelf.blockMissUse = nil;
            strSelf.blockMissUse = [[ZombieObj alloc] init];
        }];
    }
}

@end
