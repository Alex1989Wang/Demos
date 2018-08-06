//
//  SCWebAdLoadView.h
//  SelfieCamera
//
//  Created by zyf on 17/3/22.
//  Copyright © 2017年 Pinguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Blur)

+ (UIImage *)pgs_BlurImage:(UIImage *)sourceImage blurLevel:(CGFloat)blurLevel shouldRevertRgb:(BOOL)revert;

@end
