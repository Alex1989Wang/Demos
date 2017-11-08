
//  JWMainViewController.m
//  JWAlertController
//
//  Created by JiangWang on 08/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWMainViewController.h"
#import "JWRateAppAlertViewController.h"
#import "JWGeneralMiddleAlertController.h"
#import "UIViewController+JWAlertPresentation.h"

@interface JWMainViewController ()
@property (nonatomic, weak) UIButton *rateUsButton;
@property (nonatomic, weak) UIButton *horizontalAlertButtons;
@property (nonatomic, weak) UIButton *verticalAlertButtons;
@property (nonatomic, weak) UIButton *multiPresentationButton;
@end

@implementation JWMainViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self rateUsButton];
    [self horizontalAlertButtons];
    [self verticalAlertButtons];
    [self multiPresentationButton];
}

#pragma mark - Actions
- (void)clickToRateUs:(UIButton *)rateUsButton {
    JWRateAppAlertViewController *rateUsCon = [JWRateAppAlertViewController rateAppAlertController];
    [self presentAlertController:rateUsCon animated:YES];
}

- (void)clickToShowAlertWithHorizontalButton:(UIButton *)button {
    NSString *title = @"Alert";
    NSString *content = @"Alert controller with horizontal action buttons";
    NSString *okButton = @"OK";
    NSString *cancelTitle = @"Cancel";
    [JWGeneralMiddleAlertController alertWithController:self
                                              withTitle:title
                                           alertMessage:content
                                               okButton:okButton
                                           cancelButton:cancelTitle
                                     buttonsLayoutStyle:JWAlertActionLayoutDirectionHorizontal
                                             clickBlock:
     ^(JWMiddleAlertButtonActionType actionType) {
         if (actionType == JWMiddleAlertButtonActionTypeConfirm) {
             NSLog(@"did click confirm button.");
         }
     }];
}

- (void)clickToShowAlertWithVerticalButton:(UIButton *)button {
    NSString *title = @"Alert";
    NSString *content = @"Alert controller with vertical action buttons";
    NSString *okButton = @"OK";
    NSString *cancelTitle = @"Cancel";
    [JWGeneralMiddleAlertController alertWithController:self
                                              withTitle:title
                                           alertMessage:content
                                               okButton:okButton
                                           cancelButton:cancelTitle
                                     buttonsLayoutStyle:JWAlertActionLayoutDirectionVertical
                                             clickBlock:
     ^(JWMiddleAlertButtonActionType actionType) {
         if (actionType == JWMiddleAlertButtonActionTypeConfirm) {
             NSLog(@"did click confirm button.");
         }
     }];
}

- (void)clickToPresentMultipleAlerts {
    NSString *content = @"Alert controller with horizontal action buttons";
    NSString *okButton = @"OK";
    NSString *cancelTitle = @"Cancel";
    //alert one
    [JWGeneralMiddleAlertController alertWithController:self
                                              withTitle:@"Alert One"
                                           alertMessage:content
                                               okButton:okButton
                                           cancelButton:cancelTitle
                                     buttonsLayoutStyle:JWAlertActionLayoutDirectionHorizontal
                                             clickBlock:
     ^(JWMiddleAlertButtonActionType actionType) {
         if (actionType == JWMiddleAlertButtonActionTypeConfirm) {
             NSLog(@"did click confirm button.");
         }
     }];
    
    //alert two
    [JWGeneralMiddleAlertController alertWithController:self
                                              withTitle:@"Alert Two"
                                           alertMessage:content
                                               okButton:okButton
                                           cancelButton:cancelTitle
                                     buttonsLayoutStyle:JWAlertActionLayoutDirectionVertical
                                             clickBlock:
     ^(JWMiddleAlertButtonActionType actionType) {
         if (actionType == JWMiddleAlertButtonActionTypeConfirm) {
             NSLog(@"did click confirm button.");
         }
     }];
}

#pragma mark - Lazy Loading
- (UIButton *)rateUsButton {
    if (nil == _rateUsButton) {
        UIButton *rateUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rateUsButton = rateUsButton;
        [self.view addSubview:rateUsButton];
        
        [rateUsButton setTitle:@"Rate Us" forState:UIControlStateNormal];
        rateUsButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        rateUsButton.layer.cornerRadius = 8.0;
        rateUsButton.layer.masksToBounds = YES;
        [rateUsButton addTarget:self
                         action:@selector(clickToRateUs:)
               forControlEvents:UIControlEventTouchUpInside];
        [rateUsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).with.mas_offset(-150);
        }];
    }
    return _rateUsButton;
}

- (UIButton *)horizontalAlertButtons {
    if (nil == _horizontalAlertButtons) {
        UIButton *horizontalAlertButtons = [UIButton buttonWithType:UIButtonTypeCustom];
        _horizontalAlertButtons = horizontalAlertButtons;
        [self.view addSubview:horizontalAlertButtons];
        
        [horizontalAlertButtons setTitle:@"Alert With Horizontal Buttons"
                                forState:UIControlStateNormal];
        horizontalAlertButtons.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        horizontalAlertButtons.layer.cornerRadius = 8.0;
        horizontalAlertButtons.layer.masksToBounds = YES;
        [horizontalAlertButtons addTarget:self
                         action:@selector(clickToShowAlertWithHorizontalButton:)
               forControlEvents:UIControlEventTouchUpInside];
        [horizontalAlertButtons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).with.mas_offset(-50);
        }];
    }
    return _horizontalAlertButtons;
}

- (UIButton *)verticalAlertButtons {
    if (nil == _verticalAlertButtons) {
        UIButton *verticalAlertButtons = [UIButton buttonWithType:UIButtonTypeCustom];
        _verticalAlertButtons = verticalAlertButtons;
        [self.view addSubview:verticalAlertButtons];
        
        [verticalAlertButtons setTitle:@"Alert With Vertical Buttons" forState:UIControlStateNormal];
        verticalAlertButtons.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        verticalAlertButtons.layer.cornerRadius = 8.0;
        verticalAlertButtons.layer.masksToBounds = YES;
        [verticalAlertButtons addTarget:self
                         action:@selector(clickToShowAlertWithVerticalButton:)
               forControlEvents:UIControlEventTouchUpInside];
        [verticalAlertButtons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).with.mas_offset(50);
        }];
    }
    return _verticalAlertButtons;
}

- (UIButton *)multiPresentationButton {
    if (nil == _multiPresentationButton) {
        UIButton *multiPresentationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _multiPresentationButton = multiPresentationButton;
        [self.view addSubview:multiPresentationButton];
        
        [multiPresentationButton setTitle:@"Multiple Presentation" forState:UIControlStateNormal];
        multiPresentationButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        multiPresentationButton.layer.cornerRadius = 8.0;
        multiPresentationButton.layer.masksToBounds = YES;
        [multiPresentationButton addTarget:self
                         action:@selector(clickToPresentMultipleAlerts)
               forControlEvents:UIControlEventTouchUpInside];
        [multiPresentationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).with.mas_offset(150);
        }];
    }
    return _multiPresentationButton;
}

@end
