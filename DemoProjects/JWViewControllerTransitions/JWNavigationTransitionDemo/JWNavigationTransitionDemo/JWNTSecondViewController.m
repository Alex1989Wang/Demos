//
//  JWNTSecondViewController.m
//  JWNavigationTransitionDemo
//
//  Created by JiangWang on 30/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWNTSecondViewController.h"

@interface JWNTSecondViewController ()

@end

@implementation JWNTSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Second View Controller";
    self.view.backgroundColor = [UIColor brownColor];
}

- (IBAction)clickToPop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
