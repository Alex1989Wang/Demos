//
//  PCMainAdvMgr.h
//  SelfieCamera
//
//  Created by Cc on 2016/10/27.
//  Copyright © 2016年 Pinguo. All rights reserved.
//
#import "PGNativeAdvModel.h"
#import <Foundation/Foundation.h>
#import <PGS-AdBaseDataSDK/PGNetworkGetAdvertList_AdvList_Model.h>
#import <PGS-AdBaseDataSDK/PGNetworkGetAdvertList_AdvData_Model+Additional.h>

    /* 通知 当 mT_BannerModel 更新了会通知*/
    extern NSString *kPCMainAdvMgr_Update_Model;
typedef NS_ENUM(NSInteger, PGBannerViewType)
{
    PGBannerViewType_SchemeA_C360SelfDefine  = 0,//没有ICon,只有大图,针对YM、Admob、Batmobi需要单独创建View
    PGBannerViewType_SchemeA_Common ,//没有ICon,只有大图,对于除开YM、Admob、Batmobi这几个SDK以外的，使用统一的View
    PGBannerViewType_SchemeB_C360SelfDefine ,//新UI,针对YM、Admob、Batmobi需要单独创建View
    PGBannerViewType_SchemeB_Common,//新UI,对于除开YM、Admob、Batmobi这几个SDK以外的，使用统一的View
};


@interface PCMainAdvMgr_Model : NSObject

    /* 0 = 自平台    1 = 第三方    2 = appnext 3 = 新sdk广告*/
    @property (nonatomic,assign) NSInteger mInt_type;

    /* 当 mInt_type == 1 时，如果是facebook广告的话是YES */
    @property (nonatomic,assign) BOOL mBol_IsFacebook;

    /* 主页广告model */
    @property (nonatomic,strong) PGNetworkGetAdvertList_AdvList_Model *mT_BannerModel;
    /* 新广告model */
    @property (nonatomic,strong) PGNativeAdvModel                     *c360_BannerModel;

    /* Image */
    @property (nonatomic,strong) UIImage *mImg_Banner;

    /* BtnText */
    @property (nonatomic,strong) NSString *mStr_BannerText;
    /* icon */
    @property (nonatomic,strong) UIImage  *mImg_Icon;
    /* 描述信息 */
    @property (nonatomic,strong) NSString *mStr_BannerDesc;
    /* 标题 */
    @property (nonatomic,strong) NSString *mStr_BannerTitle;
@end

@interface PCMainAdvMgr : NSObject

- (instancetype)initWithViewController:(UIViewController*)viewController;

- (UIView*)pGotAppwallWithFrame:(CGRect)frame onShow:(void(^)(void))onShow;

/* 更新BannerModel */
- (void)pUpdateBannerModel;
- (PCMainAdvMgr_Model *)pGotBannerModel;

- (PGBannerViewType) bannerViewType;

-(void)pAdBannerClick;
-(BOOL)showAdBannerNewUI;

// AppsFlyer 统计
+ (void)sAppsFlyerLogEvent:(NSString*)advID imageUrl:(NSString*)imageUrl event:(NSString*)event;

@end

