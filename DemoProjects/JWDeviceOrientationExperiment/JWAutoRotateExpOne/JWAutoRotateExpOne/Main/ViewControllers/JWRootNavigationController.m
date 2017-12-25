//
//  JWRootNavigationController.m
//  JWAutoRotateExpOne
//
//  Created by JiangWang on 15/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWRootNavigationController.h"

@interface JWRootNavigationController ()

@end

@implementation JWRootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setNavigationBarHidden:YES]; //no animation
}


@end
