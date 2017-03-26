//
//  TestViewController.m
//  ViewControllerProgrammingGuideDemo
//
//  Created by JiangWang on 25/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

static NSString *const kTableCellID = @"kTableCellID";
@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kTableCellID];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellID];
    cell.textLabel.text = [indexPath description];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

@end
