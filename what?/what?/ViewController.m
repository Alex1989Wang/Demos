//
//  ViewController.m
//  what?
//
//  Created by JiangWang on 7/14/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwitch *switchMine = [[UISwitch alloc] init];
    
    UIImage *switchImage = [self imageWithView:switchMine];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:switchImage];
    imageView.frame = CGRectMake(0, 0, imageView.bounds.size.width, imageView.bounds.size.height);
    
    [self.view addSubview:imageView];
}

- (UIImage *)imageWithView:(UIView *)view {
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
