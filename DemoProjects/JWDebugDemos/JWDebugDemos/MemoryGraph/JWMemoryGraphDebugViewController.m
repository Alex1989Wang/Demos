//
//  JWMemoryGraphDebugViewController.m
//  JWDebugDemos
//
//  Created by JiangWang on 09/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWMemoryGraphDebugViewController.h"

typedef void(^JWStrongCaptureBlock)(void);

@interface JWMemoryGraphDebugViewController ()

@property (nonatomic, copy) JWStrongCaptureBlock selfCaptureBlock;
@end

@implementation JWMemoryGraphDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selfCaptureBlock = ^{
        NSLog(@"captured self: %@",
              NSStringFromClass([self class]));
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.selfCaptureBlock();
}

@end
