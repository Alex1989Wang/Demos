//
//  BareTableViewController.m
//  TableViewController&Tableview+ViewController
//
//  Created by JiangWang on 7/14/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "BareTableViewController.h"
#import "MyTableViewCell.h"
#define kNumItems 30

@interface BareTableViewController ()

@end

@implementation BareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我是TableViewController";
    [self.tableView setBackgroundColor:[UIColor brownColor]];
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.tableView setEstimatedRowHeight:60.f];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"table view content size:%@", NSStringFromCGSize(self.tableView.contentSize));
    
//    [self.tableView reloadData];
//    NSLog(@"table view content size:%@", NSStringFromCGSize(self.tableView.contentSize));
    [self.tableView setContentOffset:CGPointMake(0, 300)];
   
}

#pragma mark - srollview delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
}

//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
//    return NO;
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumItems;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    
    //configure cell
    cell.textLabel.text = @"Jiang is awsome!";
    
    return cell;
}

#pragma mark - table view delete methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BareTableViewController *tableVC = [[BareTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:tableVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}


@end
