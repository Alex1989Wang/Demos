//
//  AGDSplashViewController.m
//  AgoraDemo
//
//  Created by apple on 15/10/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AGDSplashViewController.h"

@interface AGDSplashViewController ()

@end

@implementation AGDSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"Splash" sender:self];
    });
}

@end
