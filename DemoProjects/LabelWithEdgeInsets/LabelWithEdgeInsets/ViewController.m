//
//  ViewController.m
//  LabelWithEdgeInsets
//
//  Created by JiangWang on 7/11/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "EdgeInsetsLabel.h"

@interface ViewController ()

@property (weak, nonatomic) EdgeInsetsLabel *labelHasEdgeInsets;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    EdgeInsetsLabel *label = [[EdgeInsetsLabel alloc] init];
    [self.view addSubview:label];
    self.labelHasEdgeInsets = label;


    self.labelHasEdgeInsets.text = @"有insets的label";
    [self.labelHasEdgeInsets setFont:[UIFont systemFontOfSize:16.f]];
    
    
    
    self.labelHasEdgeInsets.labelEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    [self.labelHasEdgeInsets setTextAlignment:NSTextAlignmentCenter];
    [self.labelHasEdgeInsets.layer setCornerRadius:5];
    [self.labelHasEdgeInsets.layer setMasksToBounds:YES];
    
    [self.labelHasEdgeInsets sizeToFit];
    self.labelHasEdgeInsets.center = CGPointMake(0.5 * [UIScreen mainScreen].bounds.size.width, 0.5 * self.labelHasEdgeInsets.bounds.size.height);
    
    NSLog(@"label after sizt to fit:%@", NSStringFromCGRect(self.labelHasEdgeInsets.frame));
    
    [self.labelHasEdgeInsets setBackgroundColor:[UIColor orangeColor]];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    UILabel *redComLabel = [[UILabel alloc] initWithFrame:CGRectMake(187.5, 40, 129.5, 29.5)];
    [self.view addSubview:redComLabel];
    
    [redComLabel setBackgroundColor:[UIColor redColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
