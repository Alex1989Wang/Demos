//
//  XDMessageViewController.m
//  InputTextViewAndTable
//
//  Created by JiangWang on 16/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDMessageViewController.h"

@interface XDMessageViewController ()

/* chat table */
@property (nonatomic, weak) UITableView *chatTable;

@end

@implementation XDMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";

    [self setupTable];
}

- (void)setupTable {
    UITableView *chatTable = [[UITableView alloc] init];
    _chatTable = chatTable;
    [self.view addSubview:chatTable];
    
    chatTable.backgroundColor = [UIColor greenColor];
}

@end
