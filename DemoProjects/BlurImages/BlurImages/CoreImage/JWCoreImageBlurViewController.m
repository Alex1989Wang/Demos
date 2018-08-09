//
//  JWCoreImageBlurViewController.m
//  BlurImages
//
//  Created by JiangWang on 2018/8/6.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWCoreImageBlurViewController.h"
#import "UIImage+JWCoreImageBlur.h"

@interface JWCoreImageBlurViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JWCoreImageBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *testImage = [UIImage imageNamed:@"27264289"];
    NSLog(@"test image: %@", testImage);
    [UIImage blurImage:testImage blurRadius:0
             completed:^(UIImage *resultImage) {
                 self.imageView.image = resultImage;
             }];
}


@end
