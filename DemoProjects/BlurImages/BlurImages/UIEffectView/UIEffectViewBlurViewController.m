//
//  UIEffectViewBlurViewController.m
//  BlurImages
//
//  Created by JiangWang on 2018/8/6.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "UIEffectViewBlurViewController.h"
#import "JWBlurEffectView.h"

@interface UIEffectViewBlurViewController ()
@property (weak, nonatomic) IBOutlet UIView *extraLightView;
@property (weak, nonatomic) IBOutlet UIView *lightView;
@property (weak, nonatomic) IBOutlet UIView *extraDarkView;
@property (weak, nonatomic) IBOutlet UIView *regularView;
@property (weak, nonatomic) IBOutlet UIView *prominentView;

@property (weak, nonatomic) JWBlurEffectView *jwExtraLightView;
@property (weak, nonatomic) JWBlurEffectView *jwLightView;
@property (weak, nonatomic) JWBlurEffectView *jwExtraDarkView;
@property (weak, nonatomic) JWBlurEffectView *jwRegularView;
@property (weak, nonatomic) JWBlurEffectView *jwProminentView;
@end

@implementation UIEffectViewBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *testImage = [UIImage imageNamed:@"taobao"];
    NSLog(@"test image: %@", testImage);

    JWBlurEffectView *extraLightView = [[JWBlurEffectView alloc] initWithFrame:self.extraLightView.bounds blurStyle:UIBlurEffectStyleExtraLight];
    extraLightView.contentImage = testImage;
    self.jwExtraLightView = extraLightView;
    [self.extraLightView addSubview:extraLightView];
    [self.extraLightView sendSubviewToBack:extraLightView];

    JWBlurEffectView *lightView = [[JWBlurEffectView alloc] initWithFrame:self.lightView.bounds blurStyle:UIBlurEffectStyleLight];
    self.jwLightView = lightView;
    lightView.contentImage = testImage;
    [self.lightView addSubview:lightView];
    [self.lightView sendSubviewToBack:lightView];
    
    JWBlurEffectView *regularView = [[JWBlurEffectView alloc] initWithFrame:self.regularView.bounds blurStyle:UIBlurEffectStyleRegular];
    self.jwRegularView = regularView;
    regularView.contentImage = testImage;
    [self.regularView addSubview:regularView];
    [self.regularView sendSubviewToBack:regularView];
    
    JWBlurEffectView *extraDarkView = [[JWBlurEffectView alloc] initWithFrame:self.extraDarkView.bounds blurStyle:UIBlurEffectStyleDark];
    self.jwExtraDarkView = extraDarkView;
    extraDarkView.contentImage = testImage;
    [self.extraDarkView addSubview:extraDarkView];
    [self.extraDarkView sendSubviewToBack:extraDarkView];
    
    JWBlurEffectView *prominentView = [[JWBlurEffectView alloc] initWithFrame:self.extraDarkView.bounds blurStyle:UIBlurEffectStyleProminent];
    prominentView.contentImage = testImage;
    self.jwProminentView = prominentView;
    [self.prominentView addSubview:prominentView];
    [self.prominentView sendSubviewToBack:prominentView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.jwExtraLightView.frame = self.extraLightView.bounds;
    self.jwLightView.frame = self.lightView.bounds;
    self.jwRegularView.frame = self.regularView.bounds;
    self.jwExtraDarkView.frame = self.extraDarkView.bounds;
    self.jwProminentView.frame = self.prominentView.bounds;
}


@end
