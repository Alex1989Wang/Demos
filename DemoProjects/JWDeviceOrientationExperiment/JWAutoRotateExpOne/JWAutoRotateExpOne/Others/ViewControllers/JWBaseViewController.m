//
//  JWBaseViewController.m
//  JWAutoRotateExpOne
//
//  Created by JiangWang on 16/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWBaseViewController.h"

@interface JWBaseViewController ()

@end

@implementation JWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
