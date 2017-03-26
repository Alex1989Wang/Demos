//
//  ViewController.m
//  DraggableViewDemo
//
//  Created by JiangWang on 06/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "DraggableBackgroundView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView
{
    self.view = [[DraggableBackgroundView alloc] init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
