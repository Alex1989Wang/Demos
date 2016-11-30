//
//  TestTableController.m
//  UIViewProgrammingGuide
//
//  Created by JiangWang on 18/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TestTableController.h"
#import <MJRefresh/MJRefresh.h>

@interface TestTableController ()

@end

@implementation TestTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header =
    [MJRefreshHeader headerWithRefreshingBlock:
     ^{
         NSLog(@"header refreshing...");
         __strong typeof(weakSelf) strSelf = weakSelf;
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                        dispatch_get_main_queue(),
                        ^{
                            [strSelf.tableView.mj_header endRefreshing];
                        });
     }];
    
    self.tableView.mj_footer =
    [MJRefreshBackFooter footerWithRefreshingBlock:
     ^{
         NSLog(@"footer refreshing...");
         __strong typeof(weakSelf) strSelf = weakSelf;
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                        dispatch_get_main_queue(),
                        ^{
                            [strSelf.tableView.mj_footer endRefreshing];
                        });
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"
                                    forIndexPath:indexPath];
    cell.textLabel.text = @"Jiang";
    return cell;
    
    
}



@end
