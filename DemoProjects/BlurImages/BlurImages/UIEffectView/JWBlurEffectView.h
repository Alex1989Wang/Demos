//
//  JWBlurEffectView.h
//  BlurImages
//
//  Created by JiangWang on 2018/8/6.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JWBlurEffectView : UIView
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, assign) UIBlurEffectStyle blurStyle;
- (instancetype)initWithFrame:(CGRect)frame
                    blurStyle:(UIBlurEffectStyle)style;
@end
