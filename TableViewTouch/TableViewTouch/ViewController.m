//
//  ViewController.m
//  TableViewTouch
//
//  Created by JiangWang on 7/12/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

#import "PushViewController.h"

#import "TouchView.h"

@interface ViewController ()


@end

@implementation ViewController

static NSString *cellIndentifier = @"TableTouchCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //disable the table selection
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    

    self.tableView.separatorInset = UIEdgeInsetsMake(10, -20, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    TouchView *touch = [[TouchView alloc] initWithFrame:self.tableView.bounds];
    [touch setBackgroundColor:[UIColor brownColor]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:touch];
    [[UIApplication sharedApplication].keyWindow sendSubviewToBack:touch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button actions

- (IBAction)anotherButton:(UIButton *)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)deleteButton:(UIButton *)sender {
    NSLog(@"%s", __func__);
}
- (IBAction)followButton:(UIButton *)sender {
    NSLog(@"%s", __func__);
}

#pragma mark - table view data source 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    //no configuration
    
    return cell;    
}

#pragma mark - didSelectButton
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PushViewController *pushVC = [[PushViewController alloc] init];
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

#pragma mark - touch began 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
}

#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}

@end
