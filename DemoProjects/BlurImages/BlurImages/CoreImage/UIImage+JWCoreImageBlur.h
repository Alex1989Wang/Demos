//
//  UIImage+JWCoreImageBlur.h
//  BlurImages
//
//  Created by JiangWang on 2018/8/6.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JWCoreImageBlur)

+ (void)blurImage:(UIImage *)image
       blurRadius:(CGFloat)radius
        completed:(void(^)(UIImage *resultImage))completion;
@end
