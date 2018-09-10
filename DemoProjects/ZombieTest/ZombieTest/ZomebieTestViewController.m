//
//  ZomebieTestViewController.m
//  ZombieTest
//
//  Created by JiangWang on 2018/8/27.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "ZomebieTestViewController.h"

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

@interface ZomebieTestViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) UIGestureRecognizer *tapGest; //dangling pointer
@property (nonatomic, strong) ZombieObj *multiThreadNonatomicZombie;
@end

@implementation ZomebieTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"Message To Assign Pointer" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(clickToMessageAssignPointer:) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button sizeToFit];
    self.button.center = self.view.center;
    [self.view addSubview:self.button];
    
    UIGestureRecognizer *tapGest = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture)];
    [self.view addGestureRecognizer:tapGest];
    self.tapGest = tapGest;
    
    self.multiThreadNonatomicZombie = [[ZombieObj alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view removeGestureRecognizer:self.tapGest];
}


- (void)clickToMessageAssignPointer:(UIButton *)button {
    [self callBackReleaseCrash];
}

- (void)danglingPointerCrash {
    //assign zombie
    NSLog(@"tap gesture: %@", self.tapGest);
    [self.tapGest removeTarget:self action:@selector(didTapGesture)];
}

- (void)nonatomicMultiThreadAccessCrash {
    //multi-thread zombie
    dispatch_queue_t concurrentQ = dispatch_queue_create("com.zombie.queue", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger loop = 0; loop < 1000; loop++) {
        dispatch_async(concurrentQ, ^{
            self.multiThreadNonatomicZombie = [[ZombieObj alloc] init];
            sleep(0.8);
        });
        
        //main
        [self.multiThreadNonatomicZombie stubMethod];
    }
}

- (void)callBackReleaseCrash {
    self.multiThreadNonatomicZombie = [[ZombieObj alloc] init];
    __weak typeof(self) weakSelf = self;
    [_multiThreadNonatomicZombie callBack:^{
        __strong typeof(weakSelf) strSelf = weakSelf;
        strSelf.multiThreadNonatomicZombie = nil;
        strSelf.multiThreadNonatomicZombie = [[ZombieObj alloc] init];
    }];
}
#pragma mark - Stub Actions
- (void)didTapGesture {
    
}

@end
