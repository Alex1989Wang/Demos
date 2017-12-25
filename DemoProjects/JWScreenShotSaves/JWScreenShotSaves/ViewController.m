//
//  ViewController.m
//  JWScreenShotSaves
//
//  Created by JiangWang on 09/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <Photos/PHPhotoLibrary.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions
- (IBAction)clickToSaveScreenShots:(UIButton *)sender {
//    [self versionOneScreenSnapshot];
    [self versionTwoScreenSnapshot];
}

- (void)versionTwoScreenSnapshot {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = UIInterfaceOrientationIsPortrait(orientation) ?
    screenSize : CGSizeMake(screenSize.height, screenSize.width);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, keyWindow.center.x, keyWindow.center.y);
    CGContextConcatCTM(context, keyWindow.transform);
    CGContextTranslateCTM(context, -keyWindow.bounds.size.width * keyWindow.layer.anchorPoint.x,
                          -keyWindow.bounds.size.height * keyWindow.layer.anchorPoint.y);
    
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft: {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
            break;
        }
        case UIInterfaceOrientationLandscapeRight: {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            break;
        }
        default:
            break;
    }
    
    [keyWindow drawViewHierarchyInRect:keyWindow.bounds afterScreenUpdates:YES]; //iOS 7.0
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//     UIImageWriteToSavedPhotosAlbum(image, self, @selector(screenShotImage:didFinishSavingWithError:contextInfo:), nil);
    //存储照片
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    switch (authorStatus) {
        case PHAuthorizationStatusNotDetermined: {
            //用户未该应用的照片库权限选择过
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(screenShotImage:didFinishSavingWithError:contextInfo:), nil);
                }
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized: {
            //已授权
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(screenShotImage:didFinishSavingWithError:contextInfo:), nil);
            break;
        }
            
            //用户明确拒绝过||系统不允许该应用使用
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
        default:
            break;
    }
}

- (void)versionOneScreenSnapshot {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize imageSize = rect.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextConcatCTM(ctx, [self.view.layer affineTransform]);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES]; //ios 7.0
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(ctx);
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(screenShot, self, @selector(screenShotImage:didFinishSavingWithError:contextInfo:), nil);
}

- (void)screenShotImage:(UIImage *)screenShotImage
didFinishSavingWithError:(NSError *)error
            contextInfo:(void *)contextInfo {
    NSLog(@"saving error: %@", error.localizedDescription);
    [self showScreenShotImage:screenShotImage];
}

- (void)showScreenShotImage:(UIImage *)screenShotImage {
    if (!screenShotImage) {
        NSLog(@"no screen shot image.");
    }
    
    UIImageView *previousView = [self.view viewWithTag:10000];
    if (previousView) {
        [previousView removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:screenShotImage];
    CGRect imageViewRect = CGRectInset([UIScreen mainScreen].bounds, 20, 50);
    imageView.frame = imageViewRect;
    imageView.tag = 10000;
    imageView.alpha = 0;
    [self.view addSubview:imageView];
    [UIView animateWithDuration:0.5
                     animations:
     ^{
         imageView.alpha = 1;
     }
                     completion:
     ^(BOOL finished) {
         [UIView animateWithDuration:0.5
                          animations:
          ^{
              imageView.alpha = 0;
          }
                          completion:
          ^(BOOL finished) {
              [imageView removeFromSuperview];
          }];
     }];
}

@end
