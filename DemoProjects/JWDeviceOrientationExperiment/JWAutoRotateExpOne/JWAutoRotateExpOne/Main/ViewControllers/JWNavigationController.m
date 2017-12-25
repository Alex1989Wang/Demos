//
//  JWNavigationController.m
//  JWAutoRotateExpOne
//
//  Created by JiangWang on 15/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWNavigationController.h"

@interface JWNavigationController ()

@end

@implementation JWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return [self.childViewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAllButUpsideDown;
    return [self.childViewControllers.lastObject supportedInterfaceOrientations];
//    UIInterfaceOrientationMaskAllButUpsideDown = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
