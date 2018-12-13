//
//  ViewController.m
//  JAppDuplicates
//
//  Created by JiangWang on 2018/12/11.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JViewController.h"
#import "JClassOne.h"
#import "JClassTwo.h"

@interface JViewController ()
@property (nonatomic, strong) JClassOne *objOne;
@property (nonatomic, strong) JClassTwoThree *objTwo;
@end

@implementation JViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.objOne = [[JClassOne alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.objTwo = [[JClassTwoThree alloc] init];
}

@end
