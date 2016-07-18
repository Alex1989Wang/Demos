//
//  QQFootBanner.m
//  QQUI
//
//  Created by JiangWang on 16/5/7.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "QQFootBanner.h"
#define kScreenSize ([UIScreen mainScreen].bounds.size)
#define kTextFeildHeight (30)
#define marginForAll (10)

@implementation QQFootBanner

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //imageView
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.image = [UIImage imageNamed:@"chat_bottom_bg"];
        [self addSubview:backgroundImageView];
        
        //voice button
        CGFloat voiceButtonHeightWidth = kTextFeildHeight;
        UIButton *voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(marginForAll, marginForAll, voiceButtonHeightWidth, voiceButtonHeightWidth)];
        [voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
        [voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateHighlighted];
        [self addSubview:voiceButton];
        
        //textField
        CGFloat textFieldX = CGRectGetMaxX(voiceButton.frame) + marginForAll;
        CGFloat textFieldY = CGRectGetMinY(voiceButton.frame);
        CGFloat textFieldWidth = kScreenSize.width - 3 * voiceButtonHeightWidth - 5 * marginForAll;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, 30)];
        [textField setBackground:[UIImage imageNamed:@"chat_bottom_textfield"]];
        [textField setPlaceholder:@"click me"];
        [self addSubview:textField];
        
        //emojo button
        CGFloat emojoButtonX = CGRectGetMaxX(textField.frame);
        CGFloat emojoButtonY = CGRectGetMinY(textField.frame);
        UIButton *emojoButton = [[UIButton alloc] initWithFrame:CGRectMake(emojoButtonX, emojoButtonY, voiceButtonHeightWidth, voiceButtonHeightWidth)];
        [emojoButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
        [self addSubview:emojoButton];
        
        //add button
        CGFloat addButtonX = CGRectGetMaxX(emojoButton.frame);
        CGFloat addButtonY = CGRectGetMinY(emojoButton.frame);
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(addButtonX, addButtonY, voiceButtonHeightWidth, voiceButtonHeightWidth)];
        [addButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
        [self addSubview:addButton];
    }
    return  self;
}

+ (instancetype)QqFootBanner {
    return [[QQFootBanner alloc] init];
}

@end
