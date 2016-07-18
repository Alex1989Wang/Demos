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

@interface ViewController ()<MGSwipeTableCellDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTableView];
}

- (void)setupTableView {
    [self.tableView setBackgroundColor:[UIColor grayColor]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XDThumbnailMessageCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    [self.tableView setRowHeight:70.f];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - table view data source 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDThumbnailMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - MGSwipeTableCellDelegate
- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings {
    if (direction == MGSwipeDirectionLeftToRight) {
        NSArray *leftButtonsArray = @[[MGSwipeButton buttonWithTitle:@" TA的主页 " backgroundColor:[UIColor grayColor] insets:UIEdgeInsetsMake(0, 10, 0, 10) callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(@"进入他的主页");
            return YES;
        }]];
    
        
        //configure the cell's expansion settings
        cell.leftExpansion.buttonIndex = 0;
        cell.leftExpansion.fillOnTrigger = NO;
        cell.leftExpansion.threshold = 2.f;
        cell.leftExpansion.expansionColor = [UIColor blueColor];
        
        return leftButtonsArray;
    }else {
        NSArray *rightButtonsArray = @[
                                       [MGSwipeButton buttonWithTitle:@"标记已读" backgroundColor:[UIColor redColor] insets:UIEdgeInsetsZero callback:^BOOL(MGSwipeTableCell *sender) {
                                           NSLog(@"tag read or unread;");
                                           return YES;
                                       }],
                                       [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor brownColor] insets:UIEdgeInsetsZero callback:^BOOL(MGSwipeTableCell *sender) {
                                           NSLog(@"删除");
                                           return NO;
                                       }]
                                       ];
        return rightButtonsArray;
    }
    
}

- (void)swipeTableCell:(MGSwipeTableCell *)cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive {
    
    MGSwipeButton *leftOnlyButton = [cell.leftButtons firstObject];
    if (state == MGSwipeStateExpandingLeftToRight) {
        [leftOnlyButton setButtonWidth:leftOnlyButton.bounds.size.width + 32];
    }

    
    if (state == MGSwipeStateExpandingLeftToRight) {
        [leftOnlyButton setBackgroundColor:[UIColor redColor]];
        [leftOnlyButton setTitle:@"进入TA的主页" forState:UIControlStateNormal];
//        [leftOnlyButton setButtonWidth:leftOnlyButton.bounds.size.width + 32];
        [cell.contentView bringSubviewToFront:leftOnlyButton];

        CGRect leftButtonFrame = leftOnlyButton.frame;

        
        leftOnlyButton.frame = leftButtonFrame;
        
    }else {

        MGSwipeButton *leftOnlyButton = [cell.leftButtons firstObject];
        
        [leftOnlyButton setTitle:@"TA的主页" forState:UIControlStateNormal];

    }
}


@end
