//
//  JWRateAppAlertViewController.m
//  
//
//  Created by JiangWang on 21/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import "JWRateAppAlertViewController.h"
#import "JWAlertViewController+JWPrivate.h"

#define kStarStartTagValue (500)
#define kContentLabelMargin (36)

NSString *const kJWAppHasBeenRatedKey = @"kJWAppHasBeenRatedKey";
@interface JWRateAppAlertViewController ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIView *starsContainer;
@end

@implementation JWRateAppAlertViewController

#pragma mark - Initilization
+ (JWRateAppAlertViewController *)rateAppAlertController {
    return [[self alloc] init];
}

- (JWRateAppAlertViewController *)init {
    self = [super initWithCustomContentView:[self contentView]
                          contentMarginType:JWAlertContentMarginTypeNormal
                             preferredStyle:JWAlertViewControllerStyleAlertView
                          alertActionLayout:JWAlertActionLayoutDirectionVertical];
    if (self) {
        [self addTwoActions];
    }
    return self;
}

- (void)alertViewDidAppear {
    [self animateStars];
}

#pragma mark - Public Methods 
+ (BOOL)hasAppBeenRated {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kJWAppHasBeenRatedKey];
}

#pragma mark - Private
- (void)addTwoActions {
    UIFont *fistTitleFont = [UIFont systemFontOfSize:17.f];
    UIColor *firstTitleColor = [UIColor whiteColor];
    NSString *firstImageName = @"btn_dialog_checkin";
    NSDictionary *firstActionAttribs = @{JWAlertActionTitleFontKey : fistTitleFont,
                                         JWAlertActionTitleColorKey : firstTitleColor,
                                         JWAlertActionButtonImageKey : firstImageName};
    NSString *confirmTitle = @"OK";
    JWAlertAction *confirmAction =
    [JWAlertAction actionWithTitle:confirmTitle
            actionButtonAttributes:firstActionAttribs
                           handler:
     ^(JWAlertAction * _Nonnull action) {
         //jump to app store
         
         BOOL rated = YES;
         NSUserDefaults *standartDefaults = [NSUserDefaults standardUserDefaults];
         [standartDefaults setBool:rated forKey:kJWAppHasBeenRatedKey];
     }];
    
    [self addAction:confirmAction];
    
    UIFont *secondTitleFont = [UIFont systemFontOfSize:17.f];
    UIColor *secondTitleColor = [UIColor grayColor];
    NSDictionary *actionAttribs = @{JWAlertActionTitleFontKey : secondTitleFont,
                                    JWAlertActionTitleColorKey : secondTitleColor};
    
    NSString *noThanksTitle = @"Maybe Later";
    JWAlertAction *noThanksAction =
    [JWAlertAction actionWithTitle:noThanksTitle
            actionButtonAttributes:actionAttribs
                           handler:
     ^(JWAlertAction * _Nonnull action) {
         BOOL rated = YES;
         NSUserDefaults *standartDefaults = [NSUserDefaults standardUserDefaults];
         [standartDefaults setBool:rated forKey:kJWAppHasBeenRatedKey];
     }];
    [self addAction:noThanksAction];
}

- (void)animateStars {
    for (NSInteger index = 0; index < 5; index++) {
        UIImageView *startView = [self.starsContainer viewWithTag:(index + kStarStartTagValue)];
        if ([startView isKindOfClass:[UIImageView class]]) {
            CABasicAnimation *starOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            starOpacityAnimation.fromValue = @(0);
            starOpacityAnimation.toValue = @(1);
            starOpacityAnimation.duration = 0.1;
            starOpacityAnimation.beginTime = CACurrentMediaTime() + (0.1 * 2) * index;
            starOpacityAnimation.fillMode = kCAFillModeBoth;
            [startView.layer addAnimation:starOpacityAnimation forKey:nil];
            
            CABasicAnimation *starTransAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            starTransAnimation.fromValue = @(0.7);
            starTransAnimation.toValue = @(1.3);
            starTransAnimation.duration = 0.2;
            starTransAnimation.fillMode = kCAFillModeBoth;
            starTransAnimation.beginTime = CACurrentMediaTime() + (0.1 * 2) * index;
            [startView.layer addAnimation:starTransAnimation forKey:nil];
            
            startView.layer.opacity = 1.f;
            startView.layer.transform = CATransform3DIdentity;
        }
    }
}
            
#pragma mark - Lazy Loaing
- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        _contentView = contentView;
        
        //顶部图标
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"pic_rateus_ribbon"];
        imageView.image = image;
        [contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).with.offset(-29);
            make.centerX.equalTo(contentView);
            make.width.mas_equalTo(215.f);
            make.height.mas_equalTo(77.f);
        }];
        
        //文字标签
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:23.f];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.text = @"Rate Us";
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView).with.offset(18.f);
            make.left.right.equalTo(imageView);
        }];
        
        //星星
        UIView *starsContainer = [[UIView alloc] init];
        _starsContainer = starsContainer;
        for (NSInteger index = 0; index < 5; index++) {
            UIImageView *starView = [[UIImageView alloc] init];
            UIImage *starImage = [UIImage imageNamed:@"pic_rateus_star"];
            starView.image = starImage;
            starView.tag = (index + kStarStartTagValue);
            starView.layer.opacity = 0;
            [starsContainer addSubview:starView];
            
            UIImageView *previousStar = [starsContainer viewWithTag:(starView.tag -1)];
            if (!previousStar) {
                [starView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(starsContainer);
                    make.width.height.mas_equalTo(28.f);
                }];
            }
            else {
                [starView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(starsContainer);
                    make.left.equalTo(previousStar.mas_right).with.offset(18.f);
                    make.width.height.mas_equalTo(28.f);
                }];
            }
           
            if (index == 4) {
                [starView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(starsContainer);
                }];
            }
        }
        [contentView addSubview:starsContainer];
        [starsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).with.offset(10.f);
            make.centerX.equalTo(contentView);
        }];
        
        //内容标签
        UILabel *contentsLabel = [[UILabel alloc] init];
        [contentView addSubview:contentsLabel];
        contentsLabel.font = [UIFont systemFontOfSize:15.f];
        contentsLabel.textColor = [UIColor grayColor];
        
        contentsLabel.text = @"Give us 5-star rating if you like us!";
        contentsLabel.numberOfLines = 0;
        contentsLabel.textAlignment = NSTextAlignmentCenter;
        [contentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(starsContainer.mas_bottom).with.offset(12.f);
            make.left.equalTo(contentView).with.offset(kContentLabelMargin);
            make.right.equalTo(contentView).with.offset(-kContentLabelMargin);
            make.bottom.equalTo(contentView).with.offset(-4.f);
        }];
    }
    return _contentView;
}

@end
