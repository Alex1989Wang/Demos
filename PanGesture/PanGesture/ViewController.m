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
    
    [self.tableView setRowHeight:70];
    
    [self.tableView canCancelContentTouches];
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

#pragma mark - scroll view delegate 
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIPanGestureRecognizer *scrollPan = scrollView.panGestureRecognizer;
    
    CGPoint locationInView = [scrollPan locationInView:self.tableView];
    
    XDThumbnailMessageCell *cellUnderTouch = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:locationInView]];
    
//    [cellUnderTouch.pan requireGestureRecognizerToFail:scrollPan];
    

    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UIPanGestureRecognizer *scrollPan = scrollView.panGestureRecognizer;
    
    CGPoint locationInView = [scrollPan locationInView:self.tableView];
    
    XDThumbnailMessageCell *cellUnderTouch = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:locationInView]];
    
}



@end
