//
//  ViewController.m
//  textShare
//
//  Created by 形点网络 on 16/6/29.
//  Copyright © 2016年 形点网络. All rights reserved.
//  wx9b64ff39631009d9

#import "ViewController.h"
#import "XDShareView.h"
#import "XDShareController.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface ViewController ()
@property (nonatomic, weak) UIView *shareView;
@property (nonatomic, weak) XDShareController *shareController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}





- (IBAction)shareClick:(id)sender {
    
    // 创建分享按钮
    XDShareController *shareController = [[XDShareController alloc] init];
    self.shareView = shareController.view;
    self.shareController = shareController;
    
    [self addChildViewController:shareController];
    [self.view addSubview:shareController.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.shareView removeFromSuperview];
    [self.shareController removeFromParentViewController];
}

@end
