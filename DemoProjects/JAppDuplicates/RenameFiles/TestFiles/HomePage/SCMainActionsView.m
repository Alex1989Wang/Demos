//
//  PCMainActionsView.m
//  SelfieCamera
//
//  Created by JiangWang on 2018/11/14.
//  Copyright © 2018 Pinguo. All rights reserved.
//

#import "SCMainActionsView.h"
#import <Hodor/UIColor+ext.h>
#import <Masonry/Masonry.h>
#import "SCLocalizationMgr.h"

CGFloat kPCMainPageButtonSize = 65.f;

@interface PCMainPageButton : UIView
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CAGradientLayer *buttonGradient;
@end

@implementation PCMainPageButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.button];
        [self addSubview:self.titleLabel];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.width.equalTo(self.button.mas_height);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.button.mas_bottom).with.offset(25);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.buttonGradient.frame = self.button.bounds;
    [self.button.layer insertSublayer:self.buttonGradient atIndex:0];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.buttonGradient.frame = self.button.bounds;
    [self.button.layer insertSublayer:self.buttonGradient atIndex:0];
}

#pragma mark - Lazy
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.cornerRadius = 10.f;
        _button.layer.masksToBounds = YES;
        _button.backgroundColor = [UIColor blackColor];
        
        //添加渐变色
        _buttonGradient = [CAGradientLayer layer];
        _buttonGradient.startPoint = CGPointMake(0, 0);
        _buttonGradient.endPoint = CGPointMake(1, 1);
        _buttonGradient.frame = self.button.bounds;
        [_button.layer addSublayer:_buttonGradient];
    }
    return _button;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHex:0x666666];
    }
    return _titleLabel;
}

@end

@interface PCMainActionsView()
@property (nonatomic, strong) PCMainPageButton *shootButton;
@property (nonatomic, strong) PCMainPageButton *editButton;
@property (nonatomic, strong) PCMainPageButton *storeButton;
@end

@implementation PCMainActionsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shootButton];
        [self addSubview:self.editButton];
        [self addSubview:self.storeButton];
        _storeHidden = NO;
        
        [self.shootButton mas_makeConstraints:
         ^(MASConstraintMaker *make) {
             make.left.top.bottom.equalTo(self);
             make.width.mas_equalTo(kPCMainPageButtonSize);
        }];
        
        [self.editButton mas_makeConstraints:
         ^(MASConstraintMaker *make) {
             make.bottom.top.equalTo(self.shootButton);
             make.left.equalTo(self.shootButton.mas_right).with.offset(36.f);
             make.width.mas_equalTo(kPCMainPageButtonSize);
        }];
        
        self.storeButton.hidden = _storeHidden;
        [self.storeButton mas_makeConstraints:
         ^(MASConstraintMaker *make) {
             make.bottom.top.equalTo(self.shootButton);
             make.left.equalTo(self.editButton.mas_right).with.offset(36.f);
             make.right.equalTo(self);
             make.width.mas_equalTo(kPCMainPageButtonSize);
         }];
    }
    return self;
}

- (void)setStoreHidden:(BOOL)storeHidden {
    if (_storeHidden != storeHidden) {
        _storeHidden = storeHidden;
        
        self.storeButton.hidden = storeHidden;
        [self.storeButton mas_remakeConstraints:
         ^(MASConstraintMaker *make) {
             make.bottom.top.equalTo(self.shootButton);
             CGFloat gap = storeHidden ? 0 : 36.f;
             make.left.equalTo(self.editButton.mas_right).with.offset(gap);
             make.right.equalTo(self);
             CGFloat width = storeHidden ? 0 : kPCMainPageButtonSize;
             make.width.mas_equalTo(width);
         }];
    }
}

#pragma mark - Private
- (void)didInitiateActionWithType:(PCMainActionType)type {
    NSAssert(isValidActionType(type), @"invalid action type.");
    if ([self.delegate respondsToSelector:
         @selector(mainActionView:didSendAction:)]) {
        [self.delegate mainActionView:self didSendAction:type];
    }
}

#pragma mark - Actions
- (void)didClickShootButton {
    [self didInitiateActionWithType:PCMainActionTypeShoot];
}

- (void)didClickEditButton {
    [self didInitiateActionWithType:PCMainActionTypeEdit];
}

- (void)didClickStoreButton {
    [self didInitiateActionWithType:PCMainActionTypeStore];
}

#pragma mark - Lazy
- (PCMainPageButton *)shootButton {
    if (!_shootButton) {
        _shootButton = [[PCMainPageButton alloc] init];
        UIImage *shoot = [UIImage imageNamed:@"iconHomeCamera"];
        [_shootButton.button setImage:shoot forState:UIControlStateNormal];
        [_shootButton.button addTarget:self
                                action:@selector(didClickShootButton)
                      forControlEvents:UIControlEventTouchUpInside];
        NSString *title = [[PCLocalizationMgr defaultMgr] localizedStringForKey:@"home_button_camera" nilValue:@"Camera"];
        _shootButton.titleLabel.text = title;
        UIColor *startColor = [UIColor colorWithHex:0xc1dafd];
        UIColor *endColor = [UIColor colorWithHex:0xa6ccfc];
        _shootButton.buttonGradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    }
    return _shootButton;
}

- (PCMainPageButton *)editButton {
    if (!_editButton) {
        _editButton = [[PCMainPageButton alloc] init];
        UIImage *edit = [UIImage imageNamed:@"iconHomeEdit"];
        [_editButton.button setImage:edit forState:UIControlStateNormal];
        [_editButton.button addTarget:self
                                action:@selector(didClickEditButton)
                      forControlEvents:UIControlEventTouchUpInside];
        NSString *title = [[PCLocalizationMgr defaultMgr] localizedStringForKey:@"home_button_edit" nilValue:@"Edit"];
        _editButton.titleLabel.text = title;
        
        UIColor *startColor = [UIColor colorWithHex:0xfdc8ff];
        UIColor *endColor = [UIColor colorWithHex:0xc5caff];
        _editButton.buttonGradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    }
    return _editButton;
}

- (PCMainPageButton *)storeButton {
    if (!_storeButton) {
        _storeButton = [[PCMainPageButton alloc] init];
        UIImage *store = [UIImage imageNamed:@"iconHomeShop"];
        [_storeButton.button setImage:store forState:UIControlStateNormal];
        [_storeButton.button addTarget:self
                                action:@selector(didClickStoreButton)
                      forControlEvents:UIControlEventTouchUpInside];
        NSString *title = [[PCLocalizationMgr defaultMgr] localizedStringForKey:@"home_button_store" nilValue:@"Store"];
        _storeButton.titleLabel.text = title;
        
        UIColor *startColor = [UIColor colorWithHex:0xfec6fe];
        UIColor *endColor = [UIColor colorWithHex:0xfeacfb];
        _storeButton.buttonGradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    }
    return _storeButton;
}
@end

