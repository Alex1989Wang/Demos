//
//  PCMainAdvMgr.m
//  SelfieCamera
//
//  Created by Cc on 2016/10/27.
//  Copyright © 2016年 Pinguo. All rights reserved.
//

#import "SCMainAdvMgr.h"
#import <pg_sdk_common/pg_sdk_common.h>
#import <PGS-AdBaseDataSDK/PGSAdvertSDKLogicContract.h>
#import "SCAdvertTypDefine.h"
#import "SCAdvertSDKMgr.h"
#import <PPStatsKit/PPStats.h>
#import <PPStatsKit/PinguoBigDataAdapter.h>
#import "SCFeedBackMgr.h"
#import "NSString+ext.h"
#import "UIApplication+BestieAdd.h"
#import <PGL-Core/PGL-Core.h>
#import "PGAdvertStatisticApi.h"
#import "PGAdvEntity.h"
#import "PCAdHelp.h"

#import <PGAdvExperiment.h>
#import <PGAdvParametersModel.h>
#import <PGAdvExperimentModel.h>
#import <PGAdStatisticDefine.h>
#import "PGNetworkGetAdvertList_ImageData_Model.h"

#import "PGAdvDisplayManager.h"
#import "PGAdvViewAppwallEntrance.h"

    #define kBannerCenterUpdate_Notification [NSString stringWithFormat:@"PGSAdvertSDK_Area_%@_Update_Notification", PCServerConfigHomeBannerID]

    NSString *kPCMainAdvMgr_Update_Model = @"kPCMainAdvMgr_Update_Model";


@implementation PCMainAdvMgr_Model

@end

@interface PCMainAdvMgr ()

    /* 主页广告model */
    @property (nonatomic,strong) PCMainAdvMgr_Model *mT_AdvModel;

    @property (nonatomic,strong) PGNativeAdvModel *c360NativeAd;

    @property (nonatomic,weak) UIViewController *viewController;

    @property (nonatomic,strong) NSString *currentAdvType;

@property (nonatomic, copy) void(^onShow)(void);   ///< 展示APPwall通知

@end
@implementation PCMainAdvMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
        
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AdvertSDK_Area_Update_Noti:) name:kBannerCenterUpdate_Notification object:nil];
    }
    
    return self;
}

- (instancetype)initWithViewController:(UIViewController*)viewController
{
    self = [super init];
    
    if (self)
    {
        _viewController = viewController;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AdvertSDK_Area_Update_Noti:) name:kBannerCenterUpdate_Notification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)AdvertSDK_Area_Update_Noti:(NSNotification *)noti
{
    [self pUpdateBannerModel];
}

- (UIView*)pGotAppwallWithFrame:(CGRect)frame onShow:(void(^)(void))onShow {
    
    if (![PGSAdvertSDKLogicContract displayFirstPageAppWallShow]) {
        return nil;
    }
    
    self.onShow = onShow;
    
    PGNetworkGetAdvertList_AdvList_Model *advListModel = [PGSAdvertSDKLogicContract getFirstValidData:PCServerConfigAppWallEntryID];
    if(!advListModel)
    {
        advListModel = [[PGNetworkGetAdvertList_AdvList_Model alloc] init];
        advListModel.advData = [[PGNetworkGetAdvertList_AdvData_Model alloc] init];
        advListModel.advId = PCServerConfigAppWallEntryID;
    }
    
    //使用默认的数据
    if (advListModel.advData.fbId.length==0) {
        advListModel.advData.fbId = kAdv_BestieResultAppwallFbPlacementID;
        advListModel.advData.mvId = kAdv_BestieResultAppwallId;
    }
    
    PGAdvViewAppwallEntrance *entrance = [[PGAdvViewAppwallEntrance alloc] initWithFrame:frame fileName:advListModel.advData.localPath unitId:kAdv_BestieUnitID_009 placementId:advListModel.advData.mvId];
    
    [entrance handleUserTap:^(BOOL isEnterGiftBox) {
        if(self.onShow)
            self.onShow();
        
        if(!isEnterGiftBox){
            PGNetworkGetAdvertList_ImageData_Model *imgModel = advListModel.advData.imageData.firstObject;
            
            [PCMainAdvMgr sAppsFlyerLogEvent:advListModel.advId
                                    imageUrl:imgModel.imageUrl
                                       event:@"Enter_Mv_Appwall"];
            
            [PGAdvertStatisticApi advertStatistic:advListModel
                                             page:PGAdvertPage_Home
                                              pos:PGAdvertPosition_UpRight
                                         clickObj:PGAdvertClickPos_Body
                                        mediaType:PGAdvertMediaType_Multi
                                           action:PGAdvertAction_Click
                                           format:PGAdvertDisplayFormat_Appwall
                                             rank:-1
                                           unitId:kBestieUnitID_003
                                    logEventBlock:^(NSString *eventId, NSString *statisticValues) {
                                        [PPStats logEvent:eventId label:statisticValues withClasses:@[[PinguoBigDataAdapter class]]];
                                    }];
        }
    }];
    
    return entrance;
}

- (void)pUpdateBannerModel
{
    @synchronized (self) {
        
        self.mT_AdvModel = nil;
        
        PGNetworkGetAdvertList_AdvList_Model *model = [PCAdvertSDKMgr getActiveConfigModelWith:PCServerConfigHomeBannerID];
        _currentAdvType = model.advType;
        
        // 因为现在的主页只需要这个
        if ([model.advType isEqualToString:PGC360AdvType])
        {
            [PGAdvDisplayManager getAdWithUnitId:kAdv_BestieUnitID_000 fullScreen:NO cache:YES ignoreCache:YES callback:^(PGNativeAdvModel * _Nullable nativeModel, NSError * _Nullable error) {
                if(nativeModel){
                    nativeModel.isCleanManual = YES;
                    self.c360NativeAd = nativeModel;
                    // 图片
                    UIImage *image = self.c360NativeAd.imgCache;
                    NSString *strInstall = self.c360NativeAd.action;
                    if (strInstall.length == 0) {
                        
                        strInstall = @"learn more";
                    }
                    
//                    if (image || self.c360NativeAd.source == PGAdvInMobiType) {
                    
                        self.mT_AdvModel = [[PCMainAdvMgr_Model alloc] init];
                        self.mT_AdvModel.mInt_type = 3;
                        self.mT_AdvModel.mT_BannerModel = model;
                        self.mT_AdvModel.mBol_IsFacebook = (self.c360NativeAd.source == PGAdvFacebookType);
                        self.mT_AdvModel.mImg_Banner = image;
                        self.mT_AdvModel.c360_BannerModel = self.c360NativeAd;
                        self.mT_AdvModel.mStr_BannerText = strInstall;
                        self.mT_AdvModel.mImg_Icon = self.c360NativeAd.imgCacheIcon;
                        self.mT_AdvModel.mStr_BannerDesc = self.c360NativeAd.desc;
                        self.mT_AdvModel.mStr_BannerTitle = self.c360NativeAd.title;
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kPCMainAdvMgr_Update_Model object:nil];
                        
                        [PCFeedBackMgr logEvent:@"fisrtPage_fbAd_display"];
//                    }
                }
            }];
        }
        else {
            
            NSString *strImagePath = [model.advData localPath];
            if (strImagePath) {
                
                UIImage *image = [UIImage imageWithContentsOfFile:strImagePath];
                if (image) {
                    
                    NSString *strButtonText = model.advData.btnText;
                    if (strButtonText.length == 0) {
                        
                        strButtonText = @"Download";
                    }
                    self.mT_AdvModel = [[PCMainAdvMgr_Model alloc] init];
                    self.mT_AdvModel.mInt_type = 0;
                    self.mT_AdvModel.mT_BannerModel = model;
                    self.mT_AdvModel.mStr_BannerText = strButtonText;
                    self.mT_AdvModel.mImg_Banner = image;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPCMainAdvMgr_Update_Model object:nil];
                    PGNetworkGetAdvertList_AdvList_Model *advListModel = self.mT_AdvModel.mT_BannerModel;
                    [PGAdvertStatisticApi advertStatistic:advListModel
                                                     page:PGAdvertPage_Home
                                                      pos:PGAdvertPosition_TopBanner
                                                 clickObj:PGAdvertClickPos_None
                                                mediaType:PGAdvertMediaType_Single
                                                   action:PGAdvertAction_Show
                                                   format:PGAdvertDisplayFormat_largeCard
                                                     rank:-1
                                                   unitId:kBestieUnitID_000
                                            logEventBlock:^(NSString *eventId, NSString *statisticValues) {
                                                [PPStats logEvent:eventId label:statisticValues withClasses:@[[PinguoBigDataAdapter class]]];
                                            }];
                    [PCFeedBackMgr logEvent:@"fisrtPage_topBanner_display"];
                }
            }
        }
    }
}

- (PCMainAdvMgr_Model *)pGotBannerModel
{
    @synchronized (self) {
        
        return self.mT_AdvModel;
    }
}

- (BOOL)showAdBannerNewUI
{
    // 不需要广告系统exp控制
    return YES;
}

- (PGBannerViewType)bannerViewType
{
    // 不需要广告系统exp控制
    return PGBannerViewType_SchemeA_C360SelfDefine;
}

-(void)pAdBannerClick
{
    if (self.mT_AdvModel.mInt_type == 0) {
        
        PGNetworkGetAdvertList_AdvList_Model *_currentAdvListModel = self.mT_AdvModel.mT_BannerModel;
        NSURL *linkURL = [NSURL URLWithString:[_currentAdvListModel.advData.clickUrl trim]];
        switch (_currentAdvListModel.advData.clickTypeEnum)
        {
            case PGSAdvertDataClickTypeAppLink:
            {
                NSURL *schemaURL = [NSURL URLWithString:[_currentAdvListModel.advData.clickPackage trim]];
                if ([[UIApplication sharedApplication] openURL:schemaURL] == NO)
                {
                    [[UIApplication sharedApplication] openURL:linkURL];
                }
            } break;
            case PGSAdvertDataClickTypePrdLink:
            {
                [UIApplication b_openInnerModel:linkURL.absoluteString];
            } break;
            case PGSAdvertDataClickTypeUrlLink:
            {
                if (_currentAdvListModel.isForceInnerBrowser)
                {
                    [UIApplication b_openURLInApp:linkURL.absoluteString title:_currentAdvListModel.title];
                }
                else
                {
                    [[UIApplication sharedApplication] openURL:linkURL];
                }
            } break;
            default:
                [[UIApplication sharedApplication] openURL:linkURL];
                break;
        }

        [PGAdvertStatisticApi advertStatistic:_currentAdvListModel
                                         page:PGAdvertPage_Home
                                          pos:PGAdvertPosition_TopBanner
                                     clickObj:PGAdvertClickPos_Body
                                    mediaType:PGAdvertMediaType_Single
                                       action:PGAdvertAction_Click
                                       format:PGAdvertDisplayFormat_largeCard
                                         rank:-1
                                       unitId:kBestieUnitID_000
                                logEventBlock:^(NSString *eventId, NSString *statisticValues) {
                                    [PPStats logEvent:eventId label:statisticValues withClasses:@[[PinguoBigDataAdapter class]]];
                                }];


        [PCFeedBackMgr logEvent:@"fisrtPage_topBanner_click"];
    }
}

+ (void)sAppsFlyerLogEvent:(NSString*)advID imageUrl:(NSString*)imageUrl event:(NSString*)event
{
    if (advID == nil && imageUrl != nil)
    {
        [PPStats logEvent:event label:[NSString stringWithFormat:@"+%@", imageUrl]];
    }
    else if (advID != nil && imageUrl == nil)
    {
        [PPStats logEvent:event label:[NSString stringWithFormat:@"%@+", advID]];
    }
    else if (advID == nil && imageUrl == nil)
    {
        [PPStats logEvent:event label:@"+"];
    }
    else
    {
        [PPStats logEvent:event label:[NSString stringWithFormat:@"%@+%@", advID, imageUrl]];
    }
}

@end

