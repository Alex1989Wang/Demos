//
//  NotiTestViewController.m
//  RegisterNotificationMultipleTimes
//
//  Created by JiangWang on 8/1/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "NotiTestViewController.h"

@interface NotiTestViewController ()

@property (nonatomic, assign, getter=isRegistered) BOOL registerStatus;

@end

@implementation NotiTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self registerNotificationTest];
    
    [self registerNotificationTest];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 50, 50)];
    [addButton setTitle:@"send notification" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(sendNoti) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotificationTest];
}

- (void)registerNotificationTest {
    
    if (!self.isRegistered) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNiti:) name:@"ahahhahah" object:nil];
        
        self.registerStatus = !self.isRegistered;
    }
}

- (void)handleNiti:(NSNotification *)noti {
    NSLog(@"notification user info:%@", noti.userInfo);
}

- (void)dealloc {
    if (self.isRegistered) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)sendNoti {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ahahhahah" object:nil];
}


@end
