//
//  ViewController.m
//  NilArrary
//
//  Created by JiangWang on 8/29/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *nilArray;
    
    NSLog(@"nil array: %@ and its count: %lu", nilArray, nilArray.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
