//
//  BSVCustomScrollViewController.m
//  BuildScorllView
//
//  Created by JiangWang on 06/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "BSVCustomScrollViewController.h"
#import "BSVCustomeScrollView.h"

@interface BSVCustomScrollViewController ()

@end

@implementation BSVCustomScrollViewController

- (void)loadView {
    [super loadView];
   
    BSVCustomeScrollView *customScrollView = [[BSVCustomeScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = customScrollView;
    customScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    customScrollView.contentSize = CGSizeMake(500, 900);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
}


- (void)setupSubviews {
    //configure main view
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.view.clipsToBounds = YES;
    
    //subviews
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    redView.backgroundColor = [UIColor colorWithRed:0.85 green:0.007 blue:0.1 alpha:1.0];
    
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(150, 160, 150, 200)];
    greenView.backgroundColor = [UIColor colorWithRed:0.07 green:0.85 blue:0.1 alpha:1.0];
    
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(40, 400, 200, 150)];
    yellowView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.1 alpha:1.0];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(100, 600, 180, 150)];
    blueView.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:1.0];
    
    [self.view addSubview:redView];
    [self.view addSubview:greenView];
    [self.view addSubview:yellowView];
    [self.view addSubview:blueView];
}



@end
