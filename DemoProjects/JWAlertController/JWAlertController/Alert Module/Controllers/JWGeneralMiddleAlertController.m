//
//  JWGeneralMiddleAlertController.m
//  
//
//  Created by JiangWang on 28/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import "JWGeneralMiddleAlertController.h"
#import "UIViewController+JWAlertPresentation.h"

#define kContentMargin (20)

@interface JWGeneralMiddleAlertController ()
@property (nonatomic, copy, nullable) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertContent;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@end

@implementation JWGeneralMiddleAlertController

#pragma mark - Initialization 
+ (instancetype)alertControllerWithTitle:(NSString *)title
                            alertMessage:(NSString *)message {
    return [[self alloc] initWithTitle:title alertMessage:message];
}

+ (instancetype)alertWithController:(UIViewController *)controller
                          withTitle:(NSString *)title
                       alertMessage:(NSString *_Nullable)message
                           okButton:(NSString *_Nullable)okTitle
                       cancelButton:(NSString *_Nullable)cancelTitle
                 buttonsLayoutStyle:(JWAlertActionLayoutDirection)layoutDirection
                         clickBlock:(JWMiddleAlertButtonActionBlock _Nullable)clickBlock {
    JWGeneralMiddleAlertController *alertController =
    [[JWGeneralMiddleAlertController alloc] initWithTitle:title
                                             alertMessage:message
                                       buttonsLayoutStyle:layoutDirection];
    NSDictionary *cancelAttribs = @{JWAlertActionTitleFontKey : [UIFont systemFontOfSize:15.f],
                                    JWAlertActionTitleColorKey : [UIColor blackColor],};
    JWAlertAction *cancelAction = nil;
    if(cancelTitle) {
        cancelAction = [JWAlertAction actionWithTitle:cancelTitle
                               actionButtonAttributes:cancelAttribs
                                              handler:
                        ^(JWAlertAction *action) {
                            if(clickBlock) {
                                clickBlock(JWMiddleAlertButtonActionTypeCancel);
                            }
                        }];
    }
    
    NSDictionary *confirmAttribs = @{JWAlertActionTitleFontKey: [UIFont systemFontOfSize:15.f],
                                     JWAlertActionTitleColorKey: [UIColor blackColor],};
    JWAlertAction *confirmAction = nil;
    if (okTitle) {
        confirmAction =
        [JWAlertAction actionWithTitle:okTitle
                actionButtonAttributes:confirmAttribs
                               handler:
         ^(JWAlertAction *_Nonnull action) {
             if(clickBlock) {
                 clickBlock(JWMiddleAlertButtonActionTypeConfirm);
             }
         }];
    }
    if(cancelAction) {
        [alertController addAction:cancelAction];
    }
    if(confirmAction) {
        [alertController addAction:confirmAction];
    }
    [controller presentAlertController:alertController animated:YES];
    return alertController;
}


- (instancetype)initWithTitle:(NSString *)title
                 alertMessage:(NSString *)message
           buttonsLayoutStyle:(JWAlertActionLayoutDirection)layoutDirection {
    _alertTitle = title;
    _alertContent = message;
    self = [super initWithCustomContentView:[self contentView]
                          contentMarginType:JWAlertContentMarginTypeLarge
                             preferredStyle:JWAlertViewControllerStyleAlertView
                          alertActionLayout:layoutDirection];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Accessor Methods
- (void)setContentAlignment:(NSTextAlignment)contentAlignment {
    if (_contentLabel.textAlignment != contentAlignment) {
        _contentLabel.textAlignment = contentAlignment;
        [_contentLabel layoutIfNeeded];
    }
}

#pragma mark - Lazy Loading
- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        _contentView = contentView;
        
        //添加标题
        UILabel *titleLabel = nil;
        if (self.alertTitle.length) {
            titleLabel = [[UILabel alloc] init];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
            titleLabel.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = self.alertTitle;
            _titleLabel = titleLabel;
            [contentView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(contentView).with.offset(kContentMargin);
                make.right.equalTo(contentView).with.offset(-kContentMargin);
            }];
        }
        
        //添加内容
        UILabel *contentLabel = [[UILabel alloc] init];
        _contentLabel = contentLabel;
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:15.f];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = self.alertContent;
        [contentView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).with.offset(kContentMargin);
            make.right.equalTo(contentView).with.offset(-kContentMargin);
            if (titleLabel) {
                make.top.equalTo(titleLabel.mas_bottom).with.offset(10.f);
            }
            else {
                make.top.equalTo(contentView.mas_bottom).with.offset(kContentMargin);
            }
            make.bottom.equalTo(contentView).with.offset(-kContentMargin);
        }];
    }
    return _contentView;
}

@end
