//
//  PushViewController.m
//  TableViewTouch
//
//  Created by JiangWang on 7/12/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "PushViewController.h"

@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //red background
    [self.view setBackgroundColor:[UIColor redColor]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
}

@end
