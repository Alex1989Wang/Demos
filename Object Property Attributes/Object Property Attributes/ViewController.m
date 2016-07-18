//
//  ViewController.m
//  Object Property Attributes
//
//  Created by JiangWang on 7/16/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"



@interface ViewController ()

@property (nonatomic, weak) TestView *test;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    TestView *test = [[TestView alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
    [test setBackgroundColor:[UIColor blueColor]];
    
    self.test = test;
    
    [self.view addSubview:test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"can we use the red view: %@", NSStringFromCGRect(self.test.middleView.frame));

}

@end
