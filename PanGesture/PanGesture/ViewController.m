//
//  ViewController.m
//  PanGesture
//
//  Created by JiangWang on 16/7/14.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "XDThumbnailMessageCell.h"

static NSString *const cellID = @"cellID";

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"table VC";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDThumbnailMessageCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - data source 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDThumbnailMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //configure
    
    return cell;
}




@end
