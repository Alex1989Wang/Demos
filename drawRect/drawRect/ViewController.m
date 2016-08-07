//
//  ViewController.m
//  drawRect
//
//  Created by JiangWang on 8/7/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "DrawRectTestView.h"

@interface ViewController ()

@property (nonatomic, weak) DrawRectTestView *drawView;
@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) NSUInteger numberToDisplay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DrawRectTestView *test = [[DrawRectTestView alloc] init];
    self.drawView = test;
    [test setBackgroundColor:[UIColor brownColor]];
    
    [self.view addSubview:test];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeNum) userInfo:nil repeats:YES];
}


- (void)changeNum {
    _numberToDisplay++;
    
    self.drawView.numberToDraw = _numberToDisplay;
}

@end
