//
//  PCMainBannerAdView.m
//  SelfieCamera
//
//  Created by dingming on 2017/6/20.
//  Copyright © 2017年 Pinguo. All rights reserved.
//
#import "HCommon.h"
#import <PureLayout.h>
#import "SCMainBannerBottomAdView.h"
#import <pg_sdk_common/pg_sdk_common.h>
#import "PGNetworkGetAdvertList_AdvList_Model.h"


static const  NSInteger kMainBannerAdInset = 6;

@interface PCMainBannerBottomAdView ()
@property (nonatomic, strong) UIImageView *bigAdImgView;

@property (nonatomic, strong) UIImageView *adChoiceImgView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *descLabel;
@property (nonatomic, strong) UIView      *bottomView;

@property (nonatomic, assign) BOOL        hasAddLayer;
@property (nonatomic, strong) CAGradientLayer  *actionLayer;
@property (nonatomic, assign) BOOL    isConstraint;

@end

@implementation PCMainBannerBottomAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.hasAddLayer = NO;
        [self initUI];
    }
    
    return self;
}
- (void)initUI
{
//    self.layer.cornerRadius = 5.0;
//    self.layer.masksToBounds =YES;
     self.backgroundColor = [UIColor whiteColor];
//    self.hidden = YES;
    
//    _bigAdImgView = [UIImageView new];
//    _bigAdImgView.contentMode = UIViewContentModeScaleAspectFit;
//    [_bigAdImgView setUserInteractionEnabled:YES];
//    _bigAdImgView.layer.cornerRadius = 2;
//    _bigAdImgView.layer.masksToBounds = YES;
//    [self addSubview:_bigAdImgView];
    
//    _bottomView = [UIView new];
//    [_bottomView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:_bottomView];
    
//    _adChoiceImgView = [UIImageView new];
//    _adChoiceImgView.clipsToBounds = YES;
//    _adChoiceImgView.contentMode = UIViewContentModeScaleAspectFit;
//    [_bigAdImgView addSubview:_adChoiceImgView];
//    
    _iconImgView = [UIImageView new];
    _iconImgView.layer.cornerRadius = 4.0;
    _iconImgView.clipsToBounds = YES;
    [_iconImgView setUserInteractionEnabled:YES];
    [self addSubview:_iconImgView];
    
    _titleLabel = [UILabel new];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setNumberOfLines:1];
    [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self addSubview:_titleLabel];
    
    _descLabel = [UILabel new];
    [_descLabel setTextAlignment:NSTextAlignmentLeft];
    [_descLabel setFont:[UIFont systemFontOfSize:8]];
    [_descLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_descLabel setNumberOfLines:2];
    [_descLabel setTextColor:[UIColor colorWithHex:0x000000]];
    [self addSubview:_descLabel];
    
    _installBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _installBtn.layer.cornerRadius = 4.0;
    _installBtn.layer.masksToBounds = YES;
    [_installBtn setBackgroundColor:[UIColor colorWithString:@"#FFA9AA"]];
    [self addSubview:_installBtn];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    if (!_isConstraint)
    {
        _isConstraint = YES;
        [_iconImgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:8];
        [_iconImgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_iconImgView autoSetDimensionsToSize:CGSizeMake(32, 32)];
        
        [_titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:5];
        [_titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImgView withOffset:kMainBannerAdInset];
        [_titleLabel autoSetDimensionsToSize:CGSizeMake(179.5, 19)];
        
        [_descLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel];
        [_descLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_titleLabel];
        [_descLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_descLabel autoSetDimension:ALDimensionHeight toSize:20];
        
        [_installBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_installBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_installBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_installBtn autoSetDimension:ALDimensionHeight toSize:28.5];
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGFloat bigAdImageWidth = self.width-kMainBannerAdInset*2;
//    CGFloat bigAdImageHeight = bigAdImageWidth/1.91;
//    CGFloat adChoiceW = PCUIGeometricAdaptation640(80.0);;
//    CGFloat adChoiceH = PCUIGeometricAdaptation1136(28.0);
//
//    [_bigAdImgView autoPinEdge:ALEdgeTop  toEdge:ALEdgeTop ofView:self withOffset:kMainBannerAdInset];
//    [_bigAdImgView autoPinEdge:ALEdgeLeft  toEdge:ALEdgeLeft ofView:self withOffset:kMainBannerAdInset];
//    [_bigAdImgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-kMainBannerAdInset];
//    [_bigAdImgView autoSetDimension:ALDimensionHeight toSize:bigAdImageHeight];
//    
//    [_adChoiceImgView autoPinEdgeToSuperviewEdge:ALEdgeTop];
//    [_adChoiceImgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    [_adChoiceImgView autoSetDimensionsToSize:CGSizeMake(adChoiceW, adChoiceH)];
//    
//    [_bottomView autoPinEdge:ALEdgeLeft  toEdge:ALEdgeLeft ofView:self withOffset:kMainBannerAdInset];
//    [_bottomView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-kMainBannerAdInset];
//    [_bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_bigAdImgView];
//    [_bottomView autoSetDimension:ALDimensionHeight toSize:80];
    
//    [_iconImgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:8];
//    [_iconImgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [_iconImgView autoSetDimensionsToSize:CGSizeMake(32, 32)];
//    
//    [_titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:5];
//    [_titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImgView withOffset:kMainBannerAdInset];
//    [_titleLabel autoSetDimensionsToSize:CGSizeMake(179.5, 19)];
//    
//    [_descLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel];
//    [_descLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_titleLabel];
//    [_descLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    [_descLabel autoSetDimension:ALDimensionHeight toSize:20];
//    
//    [_installBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//    [_installBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [_installBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    [_installBtn autoSetDimension:ALDimensionHeight toSize:28.5];
}

- (CAGradientLayer *)actionLayer
{
    if(!_actionLayer)
    {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = self.installBtn.bounds;
        gradientLayer.position = CGPointMake(self.installBtn.width/2, self.installBtn.height/2);
        gradientLayer.startPoint = CGPointMake(0,0.45);
        gradientLayer.endPoint = CGPointMake(1,0.5);
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithString:@"#FFA9AA"].CGColor,
                                 (__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6].CGColor,
                                 (__bridge id)[UIColor colorWithString:@"#FFA9AA"].CGColor];
        // 颜色分割点
        gradientLayer.locations  = @[@(0.5), @(0.5), @(0.5)];
        
        
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
        basicAnimation.fromValue = @[@0, @0, @0.15];
        basicAnimation.toValue = @[@0.85, @1, @1];
        basicAnimation.duration = 1;
        basicAnimation.repeatCount = HUGE;
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.fillMode = kCAFillModeForwards;
        _actionLayer = gradientLayer;
        [_actionLayer addAnimation:basicAnimation forKey:nil];
        
    }
    return _actionLayer;
}

-(void)configBottomAdWithNativeAd:(PCMainAdvMgr_Model*)nativeAd
{
    _iconImgView.image = nativeAd.mImg_Icon;
    _titleLabel.text = nativeAd.mStr_BannerTitle;
    _descLabel.text = nativeAd.mStr_BannerDesc;
    [_installBtn setTitle:nativeAd.mStr_BannerText forState:UIControlStateNormal];
//    if(self.hasAddLayer == NO)
//    {
//       self.hasAddLayer =YES;
//       [_installBtn.layer addSublayer:self.actionLayer];
//    }
    

}
@end

