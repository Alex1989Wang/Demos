//
//  PCNewBannerUIDefines.h
//  SelfieCamera
//
//  Created by dingming on 2017/6/21.
//  Copyright © 2017年 Pinguo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUIGlobalDefine.h"
//bigbanner背景图高度偏移量
#define kBigBanner_OffsetH  PCUIGeometricAdaptation1136(568.0)+PCUIGeometricAdaptation640(230.0)/2+44-[UIScreen mainScreen].bounds.size.width*(770/750)
//MIdbanner 整个广告内容的高度偏移量
#define kMidBanner_OffsetH  ([UIScreen mainScreen].bounds.size.width-2*PCUIGeometricAdaptation640(50.0)-2*6)/1.91+80+2*6-PCUIGeometricAdaptation1136(370.0)
//smallbanner 广告大图的X偏移量
#define kSmallBanner_OffsetX   PCUIGeometricAdaptation640(70.0)-6
//smallbanner 广告大图的Y偏移量
#define kSmallBanner_OffsetY  PCUIGeometricAdaptation1136(50.0)-6
//smallbanner 广告大图的宽度W偏移量
#define kSmallBanner_OffsetW  PCUIGeometricAdaptation640(540.0)-PCUIGeometricAdaptation640(400.0)-12
//smallbanner 广告大图的inset
#define kSmallBanner_Inset  12
//中间相机Y偏移
#define kMidCamera_OffsetY  PCUIGeometricAdaptation1136(568.0)-PCUIGeometricAdaptation1136(480.0)
//编辑按钮 商店按钮的Y偏移量
#define kMidStore_OffsetY   PCUIGeometricAdaptation1136(44.0)

#define PCUIOffset(isNewAdUI,offsetValue) (isNewAdUI == YES ?offsetValue:0)

