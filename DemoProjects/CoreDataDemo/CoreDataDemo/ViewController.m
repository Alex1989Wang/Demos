//
//  ViewController.m
//  CoreDataDemo
//
//  Created by JiangWang on 10/07/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "DemoDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[DemoDataManager sharedManager] testEmployeeInsertion];
    [[DemoDataManager sharedManager] testEmployeeRequest];
}


@end
