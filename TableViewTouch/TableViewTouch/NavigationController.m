//
//  NavigationController.m
//  TableViewTouch
//
//  Created by JiangWang on 7/12/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "NavigationController.h"
#import "TouchView.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationBar setBackgroundColor:[UIColor orangeColor]];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
}

@end
