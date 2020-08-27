//
//  ViewController.m
//  CGContextDrawImageEXC_BAD_ACCESS
//
//  Created by JiangWang on 2020/5/21.
//  Copyright © 2020 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ExchangeChannel.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView = imageView;
    self.imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    UIButton *pickButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 80, 35)];
    [pickButton setTitle:@"选择照片" forState:UIControlStateNormal];
    [pickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:pickButton];
    [pickButton addTarget:self action:@selector(didClickPick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    if (![image isKindOfClass: [UIImage class]]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(weakSelf) strSelf = weakSelf;
        NSData *rgbData = [image RGBA];
        if (rgbData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *rgbImage = [UIImage imageWithData:rgbData];
                strSelf.imageView.image = rgbImage;
            });
        }
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickPick {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

@end
