//
//  PCMainVC.m
//  SelfieCamera
//
//  Created by Cc on 2016/10/25.
//  Copyright © 2016年 Pinguo. All rights reserved.
//

#import <PGL-Core/PGL-Core.h>
#import "UIViewController+UserComments.h"
#import "SCMainVC.h"
#import "SCUIGlobalDefine.h"
#import <pg_sdk_common/pg_sdk_common.h>
#import "SCSettingPageVC.h"
#import "SCSelfieCameraVC.h"
#import "SCAdvertTypDefine.h"
#import "SCAlbumAdapter.h"
#import "SCStoreManager.h"
#import "SCMainAdvMgr.h"
#import "BIZPushServiceManager.h"
#import "SCMainDownCameraView.h"
#import "AppDelegate.h"
#import "SCMainDiscoveryMgr.h"
#import "GrowingIOAdapter.h"
#import "UIView+ext.h"
#import "UIColor+ext.h"
#import "UIImage+ext.h"
#import "SCLocalizationMgr.h"
#import "UIApplication+BestieAdd.h"
#import <PTL_StoreUI/PTL_StoreUI.h>
#import <YYImage/YYFrameImage.h>
#import <YYImage/YYImage.h>
#import <HDevice/HAppInfo.h>
#import <HDevice/HDevice.h>
#import <HDevice/HSystem.h>
#import "PCAdHelp.h"
#import "NSDictionary+BestieAdd.h"

#import "SCMainBannerBottomAdView.h"
#import "SCNewBannerUIDefines.h"
#import "SCAdvertSDKMgr.h"
#import "PGSAdvertSDKLogicContract.h"
#import <PureLayout.h>
#import <PGS-AdBaseDataSDK/PGSAdvertSDK.h>
#import "PGAdvertStatisticApi.h"
#import "PinguoBigDataAdapter.h"
#import "PPStats.h"
#import "HDevice+SCLaunchInfo.h"
#import "PGAdStatisticDefine.h"
#import "PinguoBigDataAdapter.h"

//pinca首页修改
#import "SCMainActionsView.h"

//滤镜商店页
#import <PTL_StoreData/PTL_StoreDataPdsOrPdEntity.h>

//UpArpuSDK
#import <UpArpuSDK/UpArpuSDK.h>
#import <UpArpuNative/UpArpuNative.h>
#import "SCUparpuAdvertDefines.h"
#import "SCHomeVCAdBanner.h"
#import <MTGSDKAppWall/MTGWallAdManager.h>

#import "SCUparpuAdvertManager.h"
#import "SCUparpuAdvertManager+SCInterstitialFrequence.h"

//Auto layout
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, ePCMainVC_Style) {
    ePCMainVC_Style_NoAds,
    ePCMainVC_Style_Ads,
};

#define kPCMainVC_animationTime  0.2
#define kPCMainVC_animationTime2 0.5

//Pinca上部背景和下部比例-15.5f的重叠区域
CGFloat kPCMainBottomHalfHeightRatio = (290.5/667.0);
CGFloat kPCMainUpperHalfHeightRatio = (392.0/667.0);

@interface PCMainVC ()
<
UIGestureRecognizerDelegate,
PTL_SUIFilterDelegate,
PCMainActionsViewDelegate
>
/* 是否有广告 */
@property (nonatomic,assign) ePCMainVC_Style mE_Style;

/* 设置按钮 */
@property (nonatomic,strong) UIButton *mV_Setting;

/* 广告相关的帮助类 */
@property (nonatomic,strong) PCMainAdvMgr *mMgr_Adv;

/* appWall广告控件 */
@property (nonatomic, weak) UIView *viewAppwall;   ///< APPwall

/* 中间的view */
@property (nonatomic,strong) UIButton *mV_MiddleBanner;

/* 真正的广告button */
//    @property (nonatomic,strong) UIView *mV_SmallBanner;
//    @property (nonatomic,strong) UIView *mV_SmallBanner_adView;
//    @property (nonatomic,strong) PCMainBannerBottomAdView *mV_SmallBanner_bottomAdView;

@property (nonatomic,strong) UIView *mV_DownloadContext;
@property (nonatomic,strong) UILabel *mV_Download;

/* 顶部向下箭头 */
@property (nonatomic,strong) PCMainDownCameraView *mV_TopDownArrow;

@property (nonatomic,strong) PCMainDiscoveryMgr *mMgr_Discovert;

/** 透明下拉箭头 */
@property (nonatomic,strong) UIButton *mV_TouMingXiaLaJianTou;
/**banner的几种view类型 */
@property (nonatomic,assign) PGBannerViewType  bannerViewType;
/** A／B测试  banner广告UI,YES则用新的广告UI */
@property (nonatomic,assign) BOOL  isNewAdUI;

//Pinca首页修改
@property (nonatomic, strong) UIButton *discoveryButton;
@property (nonatomic, strong) PCMainActionsView *actionsView;

//广告
@property (nonatomic, strong) PCHomeVCAdBanner *adBanner;
@property (nonatomic, assign, getter=isUparpuReady) BOOL uparpuReady; //uparpu的native广告准备好了
@property (nonatomic, assign) BOOL isDisappearByAd;   ///< 是否因为进入广告导致当前页面不可见，在回来的要控制再次出发广告展示
@property (nonatomic, assign) BOOL isFirstLoad;   ///< 是否第一次加载
@property (nonatomic, strong) MTGWallAdManager *appwallManager;
@end

@implementation PCMainVC

#pragma mark - Initialization
+ (void)pEnterHomePage
{
    ((AppDelegate*)[UIApplication sharedApplication].delegate).rootViewController.viewControllers = @[[[PCMainVC alloc] init]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isFirstLoad = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    //冷开屏广告
    if ([PCAdHelp shareInstance].currentNoIntro)
    {
        //展示出来-冷启动第二次基本都有-可能内部有缓存
        @WS
        [PCUparpuAdvertManager loadADWithPlacementID:kPCAparpuInterstitialStartupID
                                            callback:
         ^(NSString * _Nonnull plID, NSError * _Nullable err) {
             @SS
             [PCUparpuAdvertManager showInterstitialWithPlacementID:kPCAparpuInterstitialStartupID
                                                   inViewController:self];
             if (!err) {
                 self.isDisappearByAd = YES;
             }
         }];
    }
    
    //将推送通知的注册延迟到首页加载完成后
    [[BIZPushServiceManager sharedPushManager] registerSystemPushNotificationService];
    
    // 所有版本都是有广告版
    self.mE_Style = ePCMainVC_Style_Ads;
    // 这里才开始加载事件
    self.mMgr_Adv = [[PCMainAdvMgr alloc] initWithViewController:self];
    self.isNewAdUI = [self.mMgr_Adv showAdBannerNewUI];
    self.bannerViewType = [self.mMgr_Adv bannerViewType];
    
    //创建上半部背景
    CGFloat upperHeight = ceil((kPCMainUpperHalfHeightRatio) * self.view.bounds.size.height);
    CGRect upperRect = CGRectMake(0, 0, self.view.bounds.size.width, upperHeight);
    UIView *upperBackground = [[UIView alloc] initWithFrame:upperRect];
    CAGradientLayer *upperGradient = [CAGradientLayer layer];
    upperGradient.startPoint = CGPointMake(0, 0);
    upperGradient.endPoint = CGPointMake(1, 1);
    UIColor *startColor = [UIColor colorWithHex:0xfec8ff];
    UIColor *endColor = [UIColor colorWithHex:0xa8cbff];
    upperGradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    upperGradient.frame = upperBackground.bounds;
    [upperBackground.layer addSublayer:upperGradient];
    [self.view addSubview:upperBackground];
    [upperBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(self.view.mas_height).multipliedBy(kPCMainUpperHalfHeightRatio);
    }];
    
    //创建底部背景
    CGFloat bottomHeight = ceil(kPCMainBottomHalfHeightRatio * self.view.bounds.size.height);
    CGRect btmRect = CGRectMake(0, 0, self.view.bounds.size.width, bottomHeight);
    UIImageView *btmBackground = [[UIImageView alloc] initWithFrame:btmRect];
    btmBackground.image = [UIImage imageNamed:@"scmain_btm_bg"];
    [self.view addSubview:btmBackground];
    [btmBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(self.view.mas_height).multipliedBy(kPCMainBottomHalfHeightRatio);
    }];
    
    UIImage *discoveryImage = [UIImage imageNamed:@"iconHomeMore"];
    self.discoveryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.discoveryButton setImage:discoveryImage forState:UIControlStateNormal];
    [self.discoveryButton setTitle:LS(@"main_bottom_button_discovery_fase", @"Discovery")
                          forState:UIControlStateNormal];
    [self.discoveryButton addTarget:self action:@selector(onClick_Store:)
                   forControlEvents:UIControlEventTouchUpInside];
    self.discoveryButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.discoveryButton setTitleColor:[UIColor colorWithHex:0x666666]
                               forState:UIControlStateNormal];
    [self.view addSubview:self.discoveryButton];
    [self.discoveryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btmBackground.mas_top).with.offset(10);
        make.centerX.equalTo(btmBackground.mas_centerX);
    }];
    
    //Pinca新的UI
    PCMainActionsView *actionsView = [[PCMainActionsView alloc] init];
    [self.view addSubview:actionsView];
    self.actionsView = actionsView;
    [actionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottomMargin).with.offset(-50);
        make.centerX.equalTo(self.view);
    }];
    self.actionsView.storeHidden = [PCUparpuAdvertManager homeAppwallIsOn];
    self.actionsView.delegate = self;

    //创建ui
    [self createViewHierachy];
    
    //将所有的async-update更换为主线程操作
    [self updateViewHierachy];

    UIPanGestureRecognizer *gg = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanForm:)];
    gg.maximumNumberOfTouches = 1;
    gg.delegate = self;
    [self.view addGestureRecognizer:gg];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGlobalFullAdShow:) name:kNotificationKey_ActiveOrForgroundAdOnshow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFilterStoreRewardVideoDisplayed:) name:kUparpuAdv_Notification_FilterDisplayEnd object:nil];
    
    [PCUparpuAdvertManager loadADWithPlacementID:kPCAparpuRewardVideoPlacementID];
    [PCUparpuAdvertManager loadADWithPlacementID:kPCAparpuInterstitialStickerDownloadID];
    //appwall
    self.appwallManager = [[MTGWallAdManager alloc] initWithUnitID:kPCMitegralAppwallPlacementID presentingViewController:self];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mMgr_Adv pUpdateBannerModel];
    
    //appwall展示打点
    [self appwallDispaly];
    
    //尝试加载首页native广告-聚合mintegral&&facebook
    NSString *homeNative = kPCAparpuNativeHomePlacementID;
    [self showUparpuAdWithID:homeNative];
    
    //是否appwall打开
    BOOL storeHidden = ![PCUparpuAdvertManager homeAppwallIsOn];
    self.actionsView.storeHidden = storeHidden;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self processNewUserCommentsLogic];
    
    //回到首页的插屏interstitial2-需要控制它的展示-先load-保证成功才show
    if (!self.isFirstLoad) {
        if (!self.isDisappearByAd) {
            NSString *homeBackId = kPCAparpuInterstitialHomeID;
            @WS
            [PCUparpuAdvertManager loadADWithPlacementID:homeBackId
                                                callback:
             ^(NSString * _Nonnull plID, NSError * _Nullable err) {
                 @SS
                 if (!err && [plID isEqualToString:homeBackId]) {
                     [PCUparpuAdvertManager showInterstitialWithPlacementID:homeBackId
                                                           inViewController:self];
                     self.isDisappearByAd = YES;
                 }
             }];
        }
        else {
            self.isDisappearByAd = NO;
        }
    }
    self.isFirstLoad = NO;

    [PCUparpuAdvertManager loadADWithPlacementID:kPCAparpuInterstitialStickerDownloadID];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //discovery button
    CGSize imageSize = self.discoveryButton.imageView.frame.size;
    CGSize titleSize = self.discoveryButton.titleLabel.frame.size;
    CGFloat padding = 10.f;
    CGFloat totalHeight = (imageSize.height + titleSize.height + padding);//10 padding
    
    self.discoveryButton.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height - 2 * padding),
                                                            0.0f,
                                                            0.0f,
                                                            - titleSize.width);
    
    self.discoveryButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - imageSize.width,
                                            - (totalHeight - titleSize.height) - 2 * padding,
                                            0.0f);
    
    self.discoveryButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f,
                                              0.0f,
                                              titleSize.height,
                                              0.0f);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_mV_Setting removeTarget:nil action:NULL forControlEvents:(UIControlEventAllEvents)];
    [_mV_MiddleBanner removeTarget:nil action:NULL forControlEvents:(UIControlEventAllEvents)];
    [_mV_TouMingXiaLaJianTou removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}


+ (void)sGotoCameraOnMainVCWithParam:(NSDictionary *)param withCompletion:(void(^)(NSError *error))completion
{
    PCMainVC *mainVC = nil;
    PCSelfieCameraVC *selfieCamVC = nil;
    NSArray *arrVC = appDelegate.rootViewController.childViewControllers;
    if (arrVC.count > 0) {
        
        mainVC = [appDelegate.rootViewController.childViewControllers.firstObject c_common_convertToClass:[PCMainVC class]];
    }
    if (mainVC && arrVC.count > 1) {
        
        selfieCamVC = [appDelegate.rootViewController.childViewControllers[1] c_common_convertToClass:[PCSelfieCameraVC class]];
    }
    
    NSUInteger startIndex = 0;
    if (selfieCamVC) {
        startIndex = 2;
    }
    else {
        if (mainVC) {
            startIndex = 1;
        }
    }
    
    if (appDelegate.rootViewController.presentedViewController) {
        [appDelegate.rootViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    switch (startIndex ) {
        case 0:
        {
            [appDelegate.rootViewController setViewControllers:@[
                                                                 [[PCMainVC alloc] init],
                                                                 [[PCSelfieCameraVC alloc] initWithParams:param]
                                                                 ]];
        }
            break;
        case 1:
        {
            [appDelegate.rootViewController popToViewController:mainVC animated:NO];
            [PCSelfieCameraVC showCameraOnViewController:mainVC param:param completion:^(NSError *error) {
                
                if (completion) {
                    
                    completion(error);
                }
            }];
            
        }
            break;
        case 2:
        {
            [appDelegate.rootViewController popToViewController:selfieCamVC animated:YES];
        }
            break;
            
        default:
            SDKAssert;
            break;
    }
}

#pragma mark - Uparpu
//Upparpu
- (void)showUparpuAdWithID:(NSString *)placementID {
    NSString *homeNative = kPCAparpuNativeHomePlacementID;
    CGFloat image_x_offet = 70;
    CGFloat image_y_offet = 50;
    CGFloat scale = kAdvertMainImageWHRatio;
    CGFloat image_w_fix = 400;
    //设置image的位置
    CGFloat image_x = PCUIGeometricAdaptation640(image_x_offet)-PCUIOffset(self.isNewAdUI, kSmallBanner_OffsetX);
    CGFloat image_y = PCUIGeometricAdaptation1136(image_y_offet)-PCUIOffset(self.isNewAdUI, kSmallBanner_OffsetY);
    CGFloat image_w = PCUIGeometricAdaptation640(image_w_fix)+PCUIOffset(self.isNewAdUI, kSmallBanner_OffsetW);
    CGFloat image_h = image_w/scale;
    CGRect adFrame = CGRectMake(image_x, image_y, image_w, image_h+kAdvertBottomContentHeight);
    
    @WS
    [PCUparpuAdvertManager retriveAdViewWithPlacementID:homeNative
                                                    cls:[PCHomeVCAdBanner class]
                                                  frame:adFrame
                                               callback:
     ^(UIView * _Nonnull view, NSError * _Nonnull error) {
         @SS
         //没有能够创建视图
         if (!view || ![view isKindOfClass:[PCHomeVCAdBanner class]]) {
             return;
         }
         
         self.uparpuReady = YES;
         PCHomeVCAdBanner *adView = (PCHomeVCAdBanner *)view;
         [self.adBanner removeFromSuperview];
         self.adBanner = adView;
         
         [self commonInitView]; //初始化广告其他背景||视图
         [self pUpdate_mV_MiddleBanner];
         [self pUpdate_mV_Download];
         
         [self.mV_MiddleBanner addSubview:adView];
     }];
}

#pragma mark - Private
- (UIButton *)pGotDefaultButton:(CGRect)frame withClickSEL:(SEL)sel
{
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.frame = frame;
    view.hidden = YES;
    view.alpha = 0;
    view.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (sel) {
        
        [view addTarget:self action:sel forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return view;
}

- (void)pAnimationShowButton:(UIButton *)btn withImages:(NSArray<UIImage *> *)arrImages
{
    UIImage *imageNor = [arrImages c_common_gotObjectAtIndex:0];
    UIImage *imagePre = [arrImages c_common_gotObjectAtIndex:1];
    
    // 测试反馈遇到异步导致显示延迟问题，去掉异步
    //    dispatch_async(dispatch_get_main_queue(), ^{
    if (imageNor) {
        
        if ([imageNor isKindOfClass:[UIImage class]]) {
            
            [btn setBackgroundImage:imageNor forState:(UIControlStateNormal)];
        }
        SDKAssertElseLog(@"");
    }
    
    if (imagePre) {
        
        if ([imagePre isKindOfClass:[UIImage class]]) {
            
            [btn setBackgroundImage:imagePre forState:(UIControlStateHighlighted)];
        }
        SDKAssertElseLog(@"");
    }
    
    btn.hidden = NO;
    [UIView animateWithDuration:kPCMainVC_animationTime animations:^{
        
        btn.alpha = 1;
    }];
    //    });
}

- (BOOL)isExpired:(NSString *)expireDateStr
{
    NSDate *currentDate = [NSDate date];
    //    NSString *expireDateStr = @"2017-06-23 00:00:00";
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    [dateFmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expireDate = [dateFmt dateFromString:expireDateStr];
    return [[currentDate earlierDate:expireDate] isEqualToDate:expireDate];
}

- (void)handleGlobalFullAdShow:(NSNotification*)sender {
    // 这里不使用self.navigationController.visibleViewController是因为，全屏广告已展示才会通知出来，如果自己成为vc队列最前端一个，那present就是那个全屏广告，所以只需要检查自己是否在最前面
    if([self.navigationController.topViewController isEqual:self]){
        // 自己在vc tree的最前面
        self.isDisappearByAd = YES; // 避免广告关闭弹出自己的插屏，导致连续插屏问题
    }
}

- (void)handleFilterStoreRewardVideoDisplayed:(NSNotification *)notification {
    //如果是rewardVideo播放结束-跳转到相机拍照页面-使用某个滤镜
    NSDictionary *cameraConfigs = notification.object;
    if ([cameraConfigs isKindOfClass:[NSDictionary class]] &&
        cameraConfigs[kPCFilterPackageKey] &&
        cameraConfigs[kPCFilterEffectKey]) {
        [[self class] sGotoCameraOnMainVCWithParam:cameraConfigs withCompletion:nil];
    }
}

#pragma mark - 控制下拉拍照的手势
- (void)handlePanForm:(UIPanGestureRecognizer *)recognizer
{
    static CGPoint sBeganPoint;
    
    if (!recognizer.enabled) {
        // 正在动画，不响应事件
        return;
    }
    // 加速度大于这个，并且手指抬起
    CGFloat velocity = 500;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [recognizer translationInView:self.view];
        sBeganPoint = point;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [recognizer translationInView:self.view];
        CGPoint newPoint = CGPointMake(point.x - sBeganPoint.x, point.y - sBeganPoint.y);
        [self.mV_TopDownArrow pMovePoint:newPoint];
    }
    else {
        
        CGPoint po = [recognizer velocityInView:self.view];
        if (po.y > velocity) {
            //            SDKLog(@"po.y = %@", @(po.y));
            recognizer.enabled = NO;
            SDKWS
            [self.mV_TopDownArrow pSetupStatus:1 withAnimation:YES withCompletion:^(BOOL finished) {
                SDKSS
                [self.class sGotoCameraOnMainVCWithParam:nil withCompletion:^(NSError *error) {
                    
                    recognizer.enabled = YES;
                    if (!error) {
                        
                        [self.mV_TopDownArrow pSetupStatus:0 withAnimation:NO withCompletion:nil];
                    }
                    else {
                        
                        [self.mV_TopDownArrow pSetupStatus:0 withAnimation:YES withCompletion:nil];
                    }
                }];
                [GIOAdapter logEvent:@"home_pull_down_camera"];
                //预加载
                //                [[PGAdvInterstitialManager shareInstance] preloadInterstitial:@"Bestie_014"];
            }];
        }
        else {
            
            [self.mV_TopDownArrow pSetupStatus:0 withAnimation:YES withCompletion:nil];
        }
    }
}

#pragma mark - AdvMgr
- (void)kPCMainAdvMgr_Update_Model:(NSNotification *)noti
{
    SDKWS
    dispatch_async(dispatch_get_main_queue(), ^{
        SDKSS
        self.isNewAdUI = [self.mMgr_Adv showAdBannerNewUI];
        self.bannerViewType = [self.mMgr_Adv bannerViewType];
        if (self.mV_MiddleBanner) {
//            self.mV_AdvModel = [self.mMgr_Adv pGotBannerModel];
            
            [self commonInitView];
            
            //更新广告
            [self pUpdate_AdModel];
        }
    });
}
- (void)commonInitView
{
    [self pInit_mV_MiddleBanner];
    [self pInit_mV_Download];

}
- (void)pInitBanner
{
    if (self.mE_Style == ePCMainVC_Style_Ads) {
        [self commonInitView];
        //需在UI线程操作 admob的sdk会使用webkit
        //请看bugly #498526 SIGTRAP
        [self.mMgr_Adv pUpdateBannerModel];
    }
}

- (void)pUpdate_AdModel
{
    if (![NSThread isMainThread]) {
        SDKAssert;
        return;
    }
    
    [self pUpdate_mV_MiddleBanner];
    //    [self pUpdate_mV_SmallBanner];
    //    [self pUpdate_mV_AdChoiceView];
    [self pUpdate_mV_Download];
}

#pragma mark - 注册View
- (void)onClick_MiddleBanner:(id)sender
{
//    PCMainAdvMgr_Model *mModel = self.mV_AdvModel;
    PCMainAdvMgr_Model *mModel = nil;
    if (mModel) {
        if (mModel.mInt_type == 0) {
            [self.mMgr_Adv pAdBannerClick];
        }
    }
}

#pragma mark - Target Action
- (void)onClick_Camera:(id)sender
{
    [self.class sGotoCameraOnMainVCWithParam:nil withCompletion:nil];
}

- (void)onClick_Edit:(id)sender {
    [PCAlbumAdapter pushSystemAlbumFromVC:self albumUsageType:emAlbumPhotoUsageTypeEdit andEditType:emPCImageEditTypeNone];
}

- (void)onClick_Store:(id)sender
{
    [PCStoreManager sInstance].mStoreMgr_Delegate = self;
    UIViewController *shopVC = [[PCStoreManager sInstance].mStoreUIController iSUI_GotStoreViewController];
    [self.navigationController pushViewController:shopVC animated:YES];
}

//点击拼图酱推荐按钮
- (void)onClick_Puzzle {
    //暂时屏蔽拼图酱跳转
    /*
    NSURL *puzzleUrlScheme = [NSURL URLWithString:@"newpuzzle://"];
    UIApplication *sharedApp = [UIApplication sharedApplication];
    if ([sharedApp canOpenURL:puzzleUrlScheme]) {
        [sharedApp openURL:puzzleUrlScheme];
    }
    else {
        //appstore
        NSURL *puzzleUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1121943475?mt=8"];
        [sharedApp openURL:puzzleUrl];
    }
     */
    //如果appwall没有打开-直接return
    if (![PCUparpuAdvertManager homeAppwallIsOn]) {
        return;
    }
    
    //sdk也没有初始化
    if (![PCUparpuAdvertManager shouldInitSDK]) {
        return;
    }

    [self.appwallManager showAppWall];
    self.isDisappearByAd = YES; //appwall也是广告
}

- (void)onClick_Setting:(id)sender
{
    [PCSettingPageVC present];
    //#ifdef DEBUG
    //    PCVipStablePhotograph *viewTT = [[PCVipStablePhotograph alloc] initWithFrame:self.view.bounds];
    //    [self.view addSubview:viewTT];
    //#endif
}

//Pinca将discover换成了store
- (void)onClick_Discovery:(id)sender
{
    // http://10.1.7.227:9090
    //    NSTimeInterval tie = [[NSDate date] timeIntervalSince1970];
    //@"http://activity-test.camera360.com/discovery/index.html"
    
    //    NSDate *currentDate = [NSDate date];
    //
    //    NSString *expireDateStr = @"2017-06-23 00:00:00";
    //    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    //    [dateFmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate *expireDate = [dateFmt dateFromString:expireDateStr];
    
    NSString *httpStr = nil;
    NSString *curLang = [HSystemMgr curLanguage];
    if (([self isExpired:@"2017-06-23 00:00:00"]) || (![curLang isEqualToString:@"zh-Hans"])) {
        //过期了，那么恢复显示以前的发现页
        httpStr = [self.mMgr_Discovert pGotDiscovertLink];
        //        httpStr = @"http://activity-test.camera360.com/discovery/index.html";
        //        httpStr= @"https://activity.camera360.com/discovery/index.html";
        if (httpStr.length > 0) {
            NSString *c_labelText = LS(@"main_bottom_button_discovery_fase", @"发现");
            [UIApplication b_openURLInApp:httpStr title:c_labelText isOpenNewVC:YES];
        }
        else {
            NSString *appPath = [[NSBundle mainBundle] pathForResource:@"defaultH5" ofType:nil];
            appPath = [appPath stringByAppendingPathComponent:@"hot_default/index.html"];
            [UIApplication b_openURLInApp:appPath title:LS(@"homepage_Advert_title", nil)];
        }
    }
    else
    {
        //没有过期，那么就显示打印H5
        NSString *httpFormat = @"https://mopsd.cmall.com/page/activity/camera/index.html?userId=%@&goodsId=2079&mchCode=36051&clientId=580c0235-db4e-4e27-992e-2fa91c3e3ae6&clientSecret=4301388c-4f08-4d20-88c6-7335af11bcd4";
        httpStr = [NSString stringWithFormat:httpFormat,[HDeviceMgr identifierForVendor]];
        HDeviceModel model = [HDeviceMgr model];
        NSString *dBrandStr = @"other";
        switch (model)
        {
            case HDeviceModel_iPad:
            case HDeviceModel_iPadMini:
            {
                dBrandStr = @"iPad";
            }
                break;
            case HDeviceModel_iPhone:
            {
                dBrandStr = @"iPhone";
            }
                break;
            case HDeviceModel_iPodTouch:
            {
                dBrandStr = @"iPodTouch";
            }
                break;
            default:
                break;
        }
        
        NSDictionary *commonParam = @{@"clientVersion":kPCAppVersion,
                                      @"dBrand":dBrandStr,
                                      @"dModel":[HDeviceMgr localizedModelString],
                                      @"imagePHeight":@(PCREEN_HEIGHT),
                                      @"imagePixels":@(PCREEN_WIDTH),
                                      @"osVersion":[HSystemMgr systemVersion],
                                      @"udid":[HDeviceMgr identifierForVendor]};
        NSString *commonParamStr = [commonParam requestParamStr];
        NSString *urlStr = [httpStr stringByAppendingString:commonParamStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

- (void)onClick_TouMingXiaLaJianTou:(id)sender
{
    if (self.mV_TouMingXiaLaJianTou.tag != 0) {
        // 正在动画中
        return;
    }
    
    self.mV_TouMingXiaLaJianTou.tag = 1;
    SDKWS
    [UIView animateWithDuration:0.2 animations:^{
        SDKSS
        [self.mV_TopDownArrow pMovePoint:(CGPointMake(0, 20))];
        
    } completion:^(BOOL finished) {
        SDKSS
        SDKWS
        [self.mV_TopDownArrow pSetupStatus:0 withAnimation:YES withCompletion:^(BOOL finished2) {
            SDKSS
            self.mV_TouMingXiaLaJianTou.tag = 0;
        }];
    }];
}


#pragma mark - VIP
/*- (void)kPCVipMgr_mBol_isVip:(NSNotification *)notif
 {
 if ([PCVipMgr sInstance].mBol_isVip) {
 
 self.mE_Style = ePCMainVC_Style_NoAds;
 }
 else {
 
 self.mE_Style = ePCMainVC_Style_Ads;
 }
 
 SDKWS
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 SDKSS
 [self pUpdate_AdModel];
 
 [self pUpdate_mV_AppWall];
 });
 }*/

-(void)appwallDispaly
{
    if (![PGSAdvertSDKLogicContract displayResultPageAppWallShow]) {
        
        return ;
    }
    
    PGNetworkGetAdvertList_AdvList_Model *advListModel = [PGSAdvertSDKLogicContract getFirstValidData:PCServerConfigAppWallEntryID];
    PGNetworkGetAdvertList_ImageData_Model *imgModel = advListModel.advData.imageData.firstObject;
    
    [PCMainAdvMgr sAppsFlyerLogEvent:advListModel.advId imageUrl:imgModel.imageUrl event:@"bestie_appwall_display"];
    
    [PGAdvertStatisticApi advertStatistic:advListModel
                                     page:PGAdvertPage_Home
                                      pos:PGAdvertPosition_UpRight
                                 clickObj:PGAdvertClickPos_None
                                mediaType:PGAdvertMediaType_Multi
                                   action:PGAdvertAction_Show
                                   format:PGAdvertDisplayFormat_Appwall
                                     rank:-1
                                   unitId:kBestieUnitID_003
                            logEventBlock:^(NSString *eventId, NSString *statisticValues) {
                                [PPStats logEvent:eventId label:statisticValues withClasses:@[[PinguoBigDataAdapter class]]];
                            }];
    
}

#pragma mark - UI Creation && UPdating
- (void)createViewHierachy {
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    [self pInit_mV_Setting];
    [self pInit_mV_AppWall];
    [self pInit_mV_TopDownArrow];
}

- (void)updateViewHierachy {
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    [self pUpdate_mV_Setting];
    [self pUpdate_mV_AppWall];
    [self pUpdate_mV_TopDownArrow];
}

#pragma mark - mV_MiddleBanner
- (void)pInit_mV_MiddleBanner
{
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    CGFloat x = PCUIGeometricAdaptation640(50.0);
    CGFloat y = PCUIGeometricAdaptation1136(88.0);
    CGFloat w = PCUIGeometricAdaptation640(540.0);
    //根据ad banner设置大小
    CGFloat scale = kAdvertMainImageWHRatio;
    CGFloat image_w_fix = 400;
    CGFloat image_w = PCUIGeometricAdaptation640(image_w_fix)+PCUIOffset(self.isNewAdUI, kSmallBanner_OffsetW);
    CGFloat image_h = image_w/scale;
    CGFloat h = image_h+kAdvertBottomContentHeight + 10;
    
    if (self.mV_MiddleBanner != nil)
    {
        [self.mV_MiddleBanner removeFromSuperview];
    }
    
    self.mV_MiddleBanner = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.mV_MiddleBanner.alpha = 0;
    self.mV_MiddleBanner.hidden = YES;
    self.mV_MiddleBanner.layer.cornerRadius = PCUIGeometricAdaptation640(4.0);
    
    CGFloat rrr = PCUIGeometricAdaptation640(9.0);
    self.mV_MiddleBanner.layer.shadowColor = [UIColor c_common_gotColorByHex:0xFF958F withAlpha:1].CGColor;
    self.mV_MiddleBanner.layer.shadowOffset = CGSizeMake(0, rrr);
    self.mV_MiddleBanner.layer.shadowRadius = rrr;
    self.mV_MiddleBanner.layer.shadowOpacity = 0.5;
    self.mV_MiddleBanner.layer.shouldRasterize = YES;
    self.mV_MiddleBanner.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [self.view insertSubview:self.mV_MiddleBanner atIndex:1];
}

- (void)pUpdate_mV_MiddleBanner
{
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    if (!self.mV_MiddleBanner || !self.isUparpuReady) {
        
        return;
    }
    
    UIImage *image = [UIImage imageNamed:@"SCA_Main_Ads_Middle_Banner"];
    if (image) {
        
        self.mV_MiddleBanner.layer.contentsGravity = self.isNewAdUI?kCAGravityResize:kCAGravityResizeAspectFill;
        
        if (!self.isNewAdUI)
        {
            self.mV_MiddleBanner.layer.contents = (id)image.CGImage;
        }
        else
        {
            self.mV_MiddleBanner.backgroundColor = [UIColor whiteColor];
        }
        self.mV_MiddleBanner.hidden = NO;
        SDKWS
        [UIView animateWithDuration:kPCMainVC_animationTime2 animations:^{
            SDKSS
            self.mV_MiddleBanner.alpha = 1;
        }];
        
        
        //        [self.mMgr_Adv pUnregisterView:self.mV_MiddleBanner];
        [self.mV_MiddleBanner removeTarget:nil action:NULL forControlEvents:(UIControlEventAllEvents)];
        
        [self.mV_DownloadContext setUserInteractionEnabled:NO];
        //        [self.mV_SmallBanner setUserInteractionEnabled:NO];
        
//        if (model.mInt_type == 0) {
            [self.mV_MiddleBanner addTarget:self action:@selector(onClick_MiddleBanner:) forControlEvents:(UIControlEventTouchUpInside)];
//        }
        //        else if (model.mInt_type == 1 || model.mInt_type == 3) {
        //
        //            [self regiseterView];
        //        }
        //        else if (model.mInt_type == 2) {
        //            [self.mV_MiddleBanner addTarget:self action:@selector(onClick_MiddleBanner:) forControlEvents:(UIControlEventTouchUpInside)];
        //            [self registerAllControl:self.mV_SmallBanner_bottomAdView];
        //        }
        //        SDKAssertElseLog(@"");
    }
    SDKAssertElseLog(@"");
}


#pragma mark - mV_Download
- (void)pInit_mV_Download
{
    if(self.isNewAdUI)
    {
        return;
    }
    
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    CGFloat x = 0;
    CGFloat y = PCUIGeometricAdaptation1136(292.0);
    CGFloat w = PCUIGeometricAdaptation640(640.0);
    CGFloat h = PCUIGeometricAdaptation1136(50.0);
    
    if (self.mV_DownloadContext != nil)
    {
        [self.mV_DownloadContext removeFromSuperview];
    }
    
    self.mV_DownloadContext = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.mV_DownloadContext.hidden = YES;
    self.mV_DownloadContext.alpha = 0;
    self.mV_DownloadContext.backgroundColor = [UIColor whiteColor];
    
    CGFloat rrr = PCUIGeometricAdaptation640(9.0);
    self.mV_DownloadContext.layer.cornerRadius = h / 2.0;
    self.mV_DownloadContext.layer.shadowColor = [UIColor c_common_gotColorByHex:0xFFAAAA withAlpha:1].CGColor;
    self.mV_DownloadContext.layer.shadowOffset = CGSizeMake(0, rrr);
    self.mV_DownloadContext.layer.shadowRadius = rrr;
    self.mV_DownloadContext.layer.shadowOpacity = 0.5;
    self.mV_DownloadContext.layer.shouldRasterize = YES;
    self.mV_DownloadContext.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.mV_Download = [[UILabel alloc] init];
    self.mV_Download.font = [UIFont systemFontOfSize:h / 2.0];
    self.mV_Download.textColor = [UIColor colorWithHex:0xFFAAAA];
    self.mV_Download.textAlignment = NSTextAlignmentCenter;
    
    [self.mV_DownloadContext addSubview:self.mV_Download];
    [self.mV_MiddleBanner addSubview:self.mV_DownloadContext];
}

- (void)pUpdate_mV_Download
{
    if (self.isNewAdUI) {
        return;
    }
    
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    if (!self.mV_DownloadContext || !self.isUparpuReady) {
        
        return;
    }
    
    self.mV_DownloadContext.hidden = NO;
}
    
#pragma mark - mV_Setting
- (void)pInit_mV_Setting
{
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    CGFloat x = PCUIGeometricAdaptation640(16.0);
    CGFloat y = PCUIGeometricAdaptation1136(14.0);
    CGFloat w = PCUIGeometricAdaptation640(50.0);
    
    self.mV_Setting = [self pGotDefaultButton:CGRectMake(x, y, w, w) withClickSEL:@selector(onClick_Setting:)];
    [self.view addSubview:self.mV_Setting];
}

- (void)pUpdate_mV_Setting
{
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    if (self.mV_Setting) {
        
        NSString *strNormalImageName = @"SCA_Main_Ads_Setting_Normal";
        NSString *strPressImageName = @"SCA_Main_Ads_Setting_Press";
        UIImage *imageNor = [UIImage imageNamed:strNormalImageName];
        UIImage *imagePre = [UIImage imageNamed:strPressImageName];
        
        [self pAnimationShowButton:self.mV_Setting withImages:@[imageNor, imagePre]];
    }
}

#pragma mark - mV_TopDownArrow 下拉拍照
- (void)pInit_mV_TopDownArrow
{
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    CGRect frr = self.view.bounds;
    frr.origin.y = - self.view.bounds.size.height;
    self.mV_TopDownArrow = [[PCMainDownCameraView alloc] initWithFrame:frr];
    self.mV_TopDownArrow.hidden = YES;
    self.mV_TopDownArrow.alpha = 0;
    [self.view addSubview:self.mV_TopDownArrow];
    
    CGFloat offSet = 10;
    CGFloat x = PCUIGeometricAdaptation640(306.0) - offSet;
    CGFloat y = PCUIGeometricAdaptation1136(32.0) - offSet;
    CGFloat w = PCUIGeometricAdaptation640(27.0) + offSet * 2;
    CGFloat h = PCUIGeometricAdaptation1136(14.0) + offSet * 2;
    CGRect rrff = CGRectMake(x, y, w, h);
    self.mV_TouMingXiaLaJianTou = [[UIButton alloc] initWithFrame:rrff];
    [self.mV_TouMingXiaLaJianTou addTarget:self action:@selector(onClick_TouMingXiaLaJianTou:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.mV_TouMingXiaLaJianTou];
}

- (void)pUpdate_mV_TopDownArrow
{
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    [self.mV_TopDownArrow pAsyncUpdate];
    
    self.mV_TopDownArrow.hidden = NO;
    [UIView animateWithDuration:kPCMainVC_animationTime animations:^{
        self.mV_TopDownArrow.alpha = 1;
    }];
}

#pragma mark - mV_AppWall
- (void)pInit_mV_AppWall
{
    //Pinca本身是用来做H5的游戏入口-取消掉
    return;
    
    /*
    if (![NSThread isMainThread]) {
        SDKAssert;
        return;
    }
    
    if (self.viewAppwall) {
        return;
    }
    
    //    CGFloat w = PCUIGeometricAdaptation640(50.0);
    CGFloat cx = PCUIGeometricAdaptation640(595.0);
    CGFloat cy = PCUIGeometricAdaptation1136(40.0);
    CGRect appWallFrame = CGRectMake(0, 0, 40, 40);
    
    @ADVWS
    UIView *view = [self.mMgr_Adv pGotAppwallWithFrame:appWallFrame onShow:^{
        @ADVSS
        self.isDisappearByAd = YES;
    }];
    view.center = CGPointMake(cx, cy);
    view.alpha = 0;
    [self.view addSubview:view];
    self.viewAppwall = view;
     */
}

- (void)pUpdate_mV_AppWall
{
    //Pinca本身是用来做H5的游戏入口-取消掉
    return;
    /*
    if (![NSThread isMainThread]) {
        SDKAssert
        return;
    }
    
    if (self.viewAppwall) {
        [UIView animateWithDuration:kPCMainVC_animationTime animations:^{
            if (self.mE_Style == ePCMainVC_Style_Ads) {
                self.viewAppwall.alpha = 1;
            }
            else {
                self.viewAppwall.alpha = 0;
            }
        }];
    }
     */
}

#pragma mark - PTL_SUIFilterDelegate
- (void)dgSDFTUI_ClickUseButton:(PTL_StoreDataPdsOrPdEntity *)sender
{
    NSString *package = sender.mJsn_pid;
    NSString *effectKey = [sender.mJsn_nodes firstObject].mJsn_node.mJsn_key;
    NSMutableDictionary *cameraConfigs = [NSMutableDictionary dictionary];
    if (package) {
        [cameraConfigs setObject:package forKey:kPCFilterPackageKey];
    }
    if (effectKey) {
        [cameraConfigs setObject:effectKey forKey:kPCFilterEffectKey];
        [cameraConfigs setObject:[effectKey copy] forKey:@"key"];
    }
    if ([PCUparpuAdvertManager cameraFilterEffectDownloadCheck:effectKey]) {
        [PCUparpuAdvertManager showRewardedVideoWithPlacementID:kPCAparpuRewardVideoPlacementID inViewController:self withConfig:cameraConfigs];
    }
    else {
        [[self class] sGotoCameraOnMainVCWithParam:cameraConfigs withCompletion:nil];
    }
}

#pragma mark - PCMainActionsViewDelegate
- (void)mainActionView:(PCMainActionsView *)actionView didSendAction:(PCMainActionType)type {
    switch (type) {
        case PCMainActionTypeShoot: {
            [self onClick_Camera:nil];
            break;
        }
        case PCMainActionTypeEdit: {
            [self onClick_Edit:nil];
            break;
        }
        case PCMainActionTypeStore: {
            [self onClick_Puzzle];
            break;
        }
        default:
            PGAssert(NO, @"invalid type.");
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //    if (self.mV_mengban) {
    //
    //        return NO;
    //    }
    
    return YES;
}

@end

