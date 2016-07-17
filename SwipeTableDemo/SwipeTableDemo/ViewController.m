//
//  ViewController.m
//  SwipeTableDemo
//
//  Created by JiangWang on 16/7/17.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <MGSwipeButton.h>
#import <MGSwipeTableCell.h>
#import "XDThumbnailMessageCell.h"

static NSString *const cellIdentifier = @"cellIdentifier";

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTableView];
}

- (void)setupTableView {
    [self.tableView setBackgroundColor:[UIColor grayColor]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XDThumbnailMessageCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    
}

#pragma mark - table view data source 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDThumbnailMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"TA的主页" backgroundColor:[UIColor greenColor] insets:UIEdgeInsetsMake(0, 0, 10, 10) callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"进入他的主页");
        return YES;
    }]];
    
    cell.rightButtons = @[
                          [MGSwipeButton buttonWithTitle:@"标记已读" backgroundColor:[UIColor redColor] insets:UIEdgeInsetsZero callback:^BOOL(MGSwipeTableCell *sender) {
                              NSLog(@"tag read or unread;");
                              return YES;
                          }],
                          [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor brownColor] insets:UIEdgeInsetsZero callback:^BOOL(MGSwipeTableCell *sender) {
                              NSLog(@"删除");
                              return NO;
                          }]
                          ];
    
    return cell;
}


@end
