//
//  JWAlertViewController.m
//  
//
//  Created by JiangWang on 21/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import "JWAlertViewController.h"
#import "JWAlertViewController+JWPrivate.h"
#import "UIViewController+JWAlertPresentation.h"
#import "UIView+JWHighlightBorder.h"

NSString *const JWAlertActionButtonImageKey = @"JWAlertActionButtonImageKey";
NSString *const JWAlertActionTitleColorKey = @"JWAlertActionTitleColorKey";
NSString *const JWAlertActionTitleFontKey = @"JWAlertActionTitleFontKey";
//NSString *const JWAlertActionButtonRoundCornerKey = @"JWAlertActionButtonRoundCornerKey";

@interface JWActionButtonInternal : UIButton
@property (nonatomic, strong) JWAlertAction *action;

+ (instancetype)buttonWithAction:(JWAlertAction *)action;
@end

@implementation JWActionButtonInternal
+ (instancetype)buttonWithAction:(JWAlertAction *)action {
    return [[self alloc] initWithAction:action];
}

- (instancetype)initWithAction:(JWAlertAction *)action {
    self = [super init];
    if (self) {
        _action = action;
        //创建按钮
        UIColor *titleColor = _action.actionButtonAttributes[JWAlertActionTitleColorKey]
        ?: [UIColor blackColor];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        UIFont *titleFont = _action.actionButtonAttributes[JWAlertActionTitleFontKey]
        ?: [UIFont systemFontOfSize:17.f];
        self.titleLabel.font = titleFont;
        [self setTitle:action.title forState:UIControlStateNormal];
        NSString *imageName = _action.actionButtonAttributes[JWAlertActionButtonImageKey];
        UIImage *buttonImage = [UIImage imageNamed:imageName];
        if (imageName) {
            [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
        }
    }
    return self;
}
@end

@interface JWAlertAction()
@property (nonatomic, copy) void(^actionHandler)(JWAlertAction * action);
@end

@implementation JWAlertAction
+ (instancetype)actionWithTitle:(NSString *)title
         actionButtonAttributes:(NSDictionary *)attributes
                        handler:(void (^)(JWAlertAction * _Nonnull))handler {
    return [[self alloc] initWithTitle:title
                actionButtonAttributes:attributes
                               handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title
       actionButtonAttributes:(NSDictionary *)attributes
                      handler:(void (^)(JWAlertAction * _Nonnull))handler {
    self = [super init];
    if (self) {
        _title = title;
        _actionButtonAttributes = attributes;
        _actionHandler = handler;
    }
    return self;
}

@end

#define kActionButtonStartTag (1000)

@interface JWAlertViewController ()
@property (nonatomic, assign) JWAlertContentMarginType marginType;
@property (nonatomic, weak) UIView *animationContainer; //动画的container
@property (nonatomic, weak) UIView *alertContainer; //透明的主内容
@property (nonatomic, weak) UIView *alertContainerBackground; //圆角和背景图片都在上面
@property (nonatomic, weak) UIImageView *alertBackgroundView; //背景图片
@property (nonatomic, weak) UIView *contentContainer;
@property (nonatomic, weak) UIView *buttonsContainer;
@property (nonatomic, strong) UIView *customContentView;
@property (nonatomic, strong) NSMutableArray<JWAlertAction *> *actionsInternal;
@end

@implementation JWAlertViewController
@dynamic title;

#pragma mark - Intialization 
+ (instancetype)alertControllerWithCustomContentView:(UIView *)contentView
                                   contentMarginType:(JWAlertContentMarginType)marginType
                                      preferredStyle:(JWAlertViewControllerStyle)preferredStyle
                                   alertActionLayout:(JWAlertActionLayoutDirection)actionsLayout {
    return [[self alloc] initWithCustomContentView:contentView
                                 contentMarginType:marginType
                                    preferredStyle:preferredStyle
                                 alertActionLayout:actionsLayout];
}

- (instancetype)initWithCustomContentView:(UIView *)customContentView
                        contentMarginType:(JWAlertContentMarginType)marginType
                           preferredStyle:(JWAlertViewControllerStyle)preferredStyle
                        alertActionLayout:(JWAlertActionLayoutDirection)actionsLayout {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _customContentView = customContentView;
        _marginType = marginType;
        _preferredStyle = preferredStyle;
        _actionsStyle = actionsLayout;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMainView];
    [self buildViewHierachy];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.alertContainerBackground.layer.cornerRadius = 8.f;
    self.alertContainerBackground.layer.masksToBounds = YES;
    
    if (!self.alertBackgroundView.image &&
        self.backgroundImage) {
        self.alertBackgroundView.image = self.backgroundImage;
    }
}

#pragma mark - Private
- (void)configureMainView {
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
}

- (void)buildViewHierachy {
    [CATransaction begin];
    [self animationContainer];
    [self alertContainerBackground];
    [self alertContainer];
    [self buildContentHierachy];
    [self setupActionsButtons];
    [CATransaction commit];
}

- (void)buildContentHierachy {
    NSAssert(self.customContentView, @"must have custom content view.");
    [self.contentContainer addSubview:self.customContentView];
    [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentContainer);
    }];
}

- (void)setupActionsButtons {
    for (NSInteger index = 0; index < self.actionsInternal.count; index++) {
        [self addActionButtonWithTag:(index + kActionButtonStartTag)
                        buttonAction:self.actionsInternal[index]
                        isLastButton:(index == self.actionsInternal.count -1)];
    }
}

- (void)addActionButtonWithTag:(NSInteger)buttonTag
                  buttonAction:(JWAlertAction *)alertAction
                  isLastButton:(BOOL)isLast {
    
    //创建按钮
    JWActionButtonInternal *button = [JWActionButtonInternal buttonWithAction:alertAction];
    button.tag = buttonTag;
    [self.buttonsContainer addSubview:button];
    [button addTarget:self
               action:@selector(didClickActionButton:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *previousButton = [self.buttonsContainer viewWithTag:buttonTag - 1];
    
    switch (self.actionsStyle) {
        case JWAlertActionLayoutDirectionVertical: {
            //第一button
            if (!previousButton) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.buttonsContainer).with.offset([self contentMargin]);
                    make.right.equalTo(self.buttonsContainer).with.offset(-[self contentMargin]);
                    make.top.equalTo(self.buttonsContainer);
                    make.height.mas_equalTo(floor(72.f));
                }];
            }
            else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(previousButton);
                    make.top.equalTo(previousButton.mas_bottom).with.offset(10);
                    make.height.mas_equalTo(floor(72.f));
                }];
//                [button setBorderLineWithPosition:JWHighligtBorderPositionTop];
            }
            
            if (isLast) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    //离底部有距离
                    make.bottom.equalTo(self.buttonsContainer).with.offset(-16.f);
                }];
            }
            break;
        }
        case JWAlertActionLayoutDirectionHorizontal: {
            //第一button
            if (!previousButton) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.buttonsContainer);
                    make.top.bottom.equalTo(self.buttonsContainer);
                    make.height.mas_equalTo(54.f);
                }];
            }
            else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(previousButton.mas_right);
                    make.top.bottom.equalTo(self.buttonsContainer);
                    make.width.equalTo(previousButton.mas_width);
                    make.height.mas_equalTo(54.f);
                }];
                [button setBorderLineWithPosition:JWHighligtBorderPositionLeft];
            }
            
            if (isLast) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.buttonsContainer);
                }];
                //设置分割线
                [self.buttonsContainer setBorderLineWithPosition:JWHighligtBorderPositionTop];
            }
            break;
        }
        default: {
            NSAssert(NO, @"no such action layout style");
            break;
        }
    }
}

- (void)didClickActionButton:(JWActionButtonInternal *)actionButton {
    if ([actionButton isKindOfClass:[JWActionButtonInternal class]]) {
        JWAlertAction *action = actionButton.action;
        [self dismissAlertController:self animated:YES];
        if (action.actionHandler) {
            action.actionHandler(action);
        }
    }
}

#pragma mark - Public Methods
- (void)addAction:(JWAlertAction *)action {
    if (!action) {
        NSLog(@"JWAlertController tries to add nil action.");
        return;
    }
    [self.actionsInternal addObject:action];
}

#pragma mark - Accessor Methods
- (NSArray<JWAlertAction *> *)actions {
    return [self.actionsInternal copy];
}

- (CGFloat)alertContainerMargin {
    CGFloat margin = 0;
    switch (self.marginType) {
        case JWAlertContentMarginTypeSmall: {
            margin = 15;
            break;
        }
        case JWAlertContentMarginTypeNormal: {
            margin = 28;
            break;
        }
        case JWAlertContentMarginTypeLarge: {
            margin = 45;
            break;
        }
        default:
            break;
    }
    return margin;
}

- (CGFloat)contentMargin {
    return (self.preferredStyle == JWAlertViewControllerStyleAlertView) ?
    36 : 20;
}

#pragma mark - Lazy Loading 
- (NSMutableArray<JWAlertAction *> *)actionsInternal {
    if (!_actionsInternal) {
        _actionsInternal = [NSMutableArray array];
    }
    return _actionsInternal;
}

- (UIView *)animationContainer {
    if (!_animationContainer) {
        UIView *alertContiner = [[UIView alloc] init];
        _animationContainer = alertContiner;
        [self.view addSubview:alertContiner];
        
        alertContiner.backgroundColor = [UIColor clearColor];
        alertContiner.layer.opacity = 0;
        [alertContiner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset([self alertContainerMargin]);
            make.right.equalTo(self.view).with.offset(-[self alertContainerMargin]);
            make.centerY.equalTo(self.view);
        }];
    }
    return _animationContainer;
}

//用于圆角和底色
- (UIView *)alertContainerBackground {
    if (!_alertContainerBackground) {
        UIView *alertContiner = [[UIView alloc] init];
        _alertContainerBackground = alertContiner;
        [self.animationContainer addSubview:alertContiner];
        
        alertContiner.backgroundColor = [UIColor whiteColor];
        [alertContiner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.animationContainer);
        }];
    }
    return _alertContainerBackground;
}

- (UIImageView *)alertBackgroundView {
    if (!_alertBackgroundView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _alertBackgroundView = imageView;
        [self.alertContainerBackground addSubview:imageView];
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.alertContainerBackground);
        }];
    }
    return _alertBackgroundView;
}

//用于装所有alert内容
- (UIView *)alertContainer {
    if (!_alertContainer) {
        UIView *alertContiner = [[UIView alloc] init];
        _alertContainer = alertContiner;
        [self.animationContainer addSubview:alertContiner];
        
        alertContiner.backgroundColor = [UIColor clearColor];
        [alertContiner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.animationContainer);
        }];
    }
    return _alertContainer;
}

- (UIView *)contentContainer {
    if (!_contentContainer) {
        UIView *contentContainer = [[UIView alloc] init];
        _contentContainer = contentContainer;
        [self.alertContainer addSubview:contentContainer];
       
        contentContainer.backgroundColor = [UIColor clearColor];
        [contentContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.alertContainer);
        }];
    }
    return _contentContainer;
}

- (UIView *)buttonsContainer {
    if (!_buttonsContainer) {
        UIView *buttonsContainer = [[UIView alloc] init];
        _buttonsContainer = buttonsContainer;
        [self.alertContainer addSubview:buttonsContainer];
       
        buttonsContainer.backgroundColor = [UIColor clearColor];
        [buttonsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.alertContainer);
            make.top.equalTo(self.contentContainer.mas_bottom).with.offset(10);
            make.bottom.equalTo(self.alertContainer);
        }];
    }
    return _buttonsContainer;
}

@end


@implementation JWAlertViewController (JWPrivate)
- (void)displayAlertViewAnimated:(BOOL)animated
               completed:(void(^)(BOOL completed))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (completion) {
            completion(YES);
        }
        [self alertViewDidAppear];
    }];
    [self.view setNeedsLayout];
    if (animated) {
        [self.animationContainer.layer removeAllAnimations];
        CGFloat duration = 0.2;
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @(0);
        opacityAnimation.toValue = @(1);
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeBoth;
        opacityAnimation.duration = duration;
        [self.animationContainer.layer addAnimation:opacityAnimation forKey:nil];
        
        CABasicAnimation *transAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        transAnimation.fromValue = @(0.1);
        transAnimation.toValue = @(1.0);
        transAnimation.removedOnCompletion = NO;
        transAnimation.fillMode = kCAFillModeBoth;
        transAnimation.duration = duration;
        [self.animationContainer.layer addAnimation:transAnimation forKey:nil];
        self.animationContainer.layer.opacity = 1.f;
        self.animationContainer.layer.transform = CATransform3DIdentity;
    }
    else {
        self.animationContainer.layer.opacity = 1.f;
    }
    [CATransaction commit];
}

- (void)dismissAlertViewAnimated:(BOOL)animated
               completed:(void(^)(BOOL completed))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (completion) {
            completion(YES);
        }
    }];
    if (animated) {
        CGFloat duration = 0.2;
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @(1);
        opacityAnimation.toValue = @(0);
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeBoth;
        opacityAnimation.duration = duration;
        [self.animationContainer.layer addAnimation:opacityAnimation forKey:nil];
        
        CABasicAnimation *transAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        transAnimation.fromValue = @(1.0);
        transAnimation.toValue = @(0.1);
        transAnimation.fillMode = kCAFillModeBoth;
        transAnimation.removedOnCompletion = NO;
        transAnimation.duration = duration;
        [self.animationContainer.layer addAnimation:transAnimation forKey:nil];
    }
    else {
        self.animationContainer.layer.opacity = 1.f;
    }
    [CATransaction commit];
}

/**
 父类为空实现
 */
- (void)alertViewDidAppear {
    
}
@end
