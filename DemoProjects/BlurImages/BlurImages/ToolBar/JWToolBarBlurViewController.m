//
//  JWToolBarBlurViewController.m
//  BlurImages
//
//  Created by JiangWang on 2018/8/9.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWToolBarBlurViewController.h"

@interface JWToolBarBlurViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *blurToolBar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation JWToolBarBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *testImage = [UIImage imageNamed:@"27264289"];
    NSLog(@"test image: %@", testImage);
    self.imageView.image = testImage;
}

@end
