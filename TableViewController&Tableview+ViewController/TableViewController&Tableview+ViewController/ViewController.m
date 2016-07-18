//
//  ViewController.m
//  TableViewController&Tableview+ViewController
//
//  Created by JiangWang on 7/14/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

#define kNumItems 30

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我是UIViewController+UITableView";
    [self.view setBackgroundColor:[UIColor orangeColor]];

    
    //add a table view
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //register
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.tableView setBackgroundColor:[UIColor blueColor]];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    NSLog(@"%@", NSStringFromCGSize(self.tableView.contentSize));
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:30 -1  inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark - srollview delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"content offset: %@", NSStringFromCGPoint(scrollView.contentOffset));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumItems;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    
    //configure cell
    cell.textLabel.text = @"Jiang is awsome!";
    
    return cell;
}

#pragma mark - table view delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *plainVC = [[ViewController alloc] init];
    [self.navigationController pushViewController:plainVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

@end
