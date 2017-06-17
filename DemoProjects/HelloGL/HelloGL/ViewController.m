//
//  ViewController.m
//  HelloGL
//
//  Created by JiangWang on 07/06/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "DemoGLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CATransaction setDisableActions:YES];
    DemoGLView *glView = [[DemoGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:glView];
    [CATransaction setDisableActions:NO];
}


@end
