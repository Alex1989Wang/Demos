//
//  ViewController.m
//  TransparentViewTouchEvents
//
//  Created by JiangWang on 7/7/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor redColor]];
    
    UIView *orangeView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [orangeView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:orangeView];
    
    
    NSLog(@"%@", orangeView);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@", touches);
    
    NSLog(@"touch - drag --");
}

@end
