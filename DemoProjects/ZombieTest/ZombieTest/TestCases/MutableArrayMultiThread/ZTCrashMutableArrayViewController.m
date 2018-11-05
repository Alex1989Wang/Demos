//
//  ZTCrashMutableArrayViewController.m
//  ZombieTest
//
//  Created by JiangWang on 2018/11/5.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "ZTCrashMutableArrayViewController.h"
#import "ZTDummyObject.h"

@interface ZTCrashMutableArrayViewController ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, ZTDummyObject *> *cache;
@end

@implementation ZTCrashMutableArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cache = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickToCrash {
    uint32_t max = 1000;
    for (uint32_t index = 0; index < max; index++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *idString = [NSString stringWithFormat:@"%u", index];
            self.cache[idString] = [[ZTDummyObject alloc] init];
        });
        
        uint32_t random = arc4random_uniform(max);
        NSString *randomId = [NSString stringWithFormat:@"%u", random];
        ZTDummyObject *dummy = self.cache[randomId];
        [dummy dummyMethod];
    }
}


@end
