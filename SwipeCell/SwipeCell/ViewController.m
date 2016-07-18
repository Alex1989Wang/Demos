//
//  ViewController.m
//  SwipeCell
//
//  Created by JiangWang on 7/14/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "MCSwipeTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[MCSwipeTableViewCell class] forCellReuseIdentifier:@"jiangwang"];
    
    [self.tableView setBackgroundColor:[UIColor grayColor]];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
}

#pragma mark - table view date source 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiangwang"];
    
    //configure
    cell.textLabel.text = @"jiang";
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"TA的主页" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 100);
    cell.shouldAnimateIcons = NO;
    
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    [cell setSwipeGestureWithView:button color:tableView.backgroundView.backgroundColor  mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"hahahha");
    }];
    
    return cell;
}

#pragma mark - delagate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


@end
