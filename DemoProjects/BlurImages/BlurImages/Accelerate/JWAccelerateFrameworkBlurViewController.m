//
//  JWAccelerateFrameworkBlurViewController.m
//  BlurImages
//
//  Created by JiangWang on 2018/8/6.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWAccelerateFrameworkBlurViewController.h"
#import "UIImage+Blur.h"

@interface JWAccelerateFrameworkBlurViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JWAccelerateFrameworkBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *testImage = [UIImage imageNamed:@"taobao"];
    NSLog(@"test image: %@", testImage);
    self.imageView.image = [UIImage pgs_BlurImage:testImage blurLevel:2 shouldRevertRgb:NO];
}


@end
