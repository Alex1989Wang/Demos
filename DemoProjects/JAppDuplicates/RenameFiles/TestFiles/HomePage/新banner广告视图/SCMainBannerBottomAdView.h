//
//  PCMainBannerAdView.h
//  SelfieCamera
//
//  Created by dingming on 2017/6/20.
//  Copyright © 2017年 Pinguo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMainAdvMgr.h"

@interface PCMainBannerBottomAdView : UIView

@property (nonatomic, strong) UIButton    *installBtn;
@property (nonatomic, strong) UIImageView *iconImgView;

-(void)configBottomAdWithNativeAd:(PCMainAdvMgr_Model*)nativeAd;
@end

