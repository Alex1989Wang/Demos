//
//  XDMessageCell.m
//  seeYouTime
//
//  Created by JiangWang on 7/18/16.
//  Copyright © 2016 形点网络. All rights reserved.
//

#import "XDMessageCell.h"
#import "XDLabelWithEdgeInsets.h"
#import "XDMessage.h"

/* UI ojects */
@interface XDMessageCell()
// message sent time label
@property (nonatomic, weak) XDLabelWithEdgeInsets *messageSentTimeLabel;
// user icon image view
@property (nonatomic, weak) UIImageView *userIconView;
// message view - use a button for this purpose
@property (nonatomic, weak) UIButton *messageButton;

/* screen fitting constants */
#define kUserIconWidthHeight ceilf(40.f * [XDScreenFitTool screenFitFactor])
#define kMarginConstFive ceilf(5.0f * [XDScreenFitTool screenFitFactor])
#define kMarginConstTen ceilf(10.f * [XDScreenFitTool screenFitFactor])
#define kMarginConstThirteen ceilf(13.f * [XDScreenFitTool screenFitFactor])
#define kMessageLabelToTimeLabel ceilf(20.f * [XDScreenFitTool screenFitFactor])
#define kContentFrame self.contentView.frame
#define kChatBackgroundImageArrowTip 4.f

@end

@implementation XDMessageCell

#pragma mark - initialzation
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        /* message time label */
        XDLabelWithEdgeInsets *messageSentTimeLabel = [[XDLabelWithEdgeInsets alloc] init];
        self.messageSentTimeLabel = messageSentTimeLabel;
        messageSentTimeLabel.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [messageSentTimeLabel setFont:[UIFont boldSystemFontOfSize:10.f]];
        [messageSentTimeLabel setTextColor:[UIColor whiteColor]];
        [messageSentTimeLabel setBackgroundColor:[UIColor colorWithHexString:@"#b1b4c2"]];
        messageSentTimeLabel.layer.cornerRadius = 5.f;
        messageSentTimeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:messageSentTimeLabel];
    
        /* user icon */
        UIImageView *userIconView = [[UIImageView alloc] init];
        self.userIconView = userIconView;
        [self.contentView addSubview:userIconView];
        
        /* message button */
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        messageButton.enabled = NO;
        messageButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [messageButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        self.messageButton = messageButton;
        [self.contentView addSubview:messageButton];
        
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        
    }
    
    return self;
}

#pragma mark - screen fitting and layout subviews;
- (void)layoutSubviews {
    [super layoutSubviews];
    
    XDLog_Func;
    
    NSLog(@"message button title label: %@", NSStringFromCGRect(self.messageButton.titleLabel.frame));
    XDLog(@"message: %@", self.message);
    
    if (self.message == nil) {
        return;
    }
    
    //screen fitting - message time label
    CGRect messageTimeLabelFrame = self.messageSentTimeLabel.frame;
    messageTimeLabelFrame.origin.x = 0.5 * (kContentFrame.size.width - messageTimeLabelFrame.size.width);
    messageTimeLabelFrame.origin.y = 0;
    self.messageSentTimeLabel.frame = (self.message.isTimeLabelHidden) ? CGRectZero : messageTimeLabelFrame;
    
    //user icon
    if (self.message.userType == XDMessageUserTypeMe) {
        self.userIconView.frame = CGRectMake(self.contentView.frame.size.width - kUserIconWidthHeight - kMarginConstTen, CGRectGetMaxY(self.messageSentTimeLabel.frame) + kMessageLabelToTimeLabel, kUserIconWidthHeight, kUserIconWidthHeight);
    }else {
        self.userIconView.frame = CGRectMake(kMarginConstTen, CGRectGetMaxY(self.messageSentTimeLabel.frame) + kMessageLabelToTimeLabel, kUserIconWidthHeight, kUserIconWidthHeight);
    }
    
    //message button
    CGFloat messageButtonHeight = 0.f;
    messageButtonHeight = (self.message.textRect.size.height < kUserIconWidthHeight) ? kUserIconWidthHeight : self.message.textRect.size.height;
    CGFloat messageButtonMaxWidth = self.contentView.frame.size.width - 2.0 * (kUserIconWidthHeight + kMarginConstTen * 2.0);
    CGFloat messageButtonWidth = (self.message.textRect.size.width + kMarginConstThirteen * 2.0 < messageButtonMaxWidth) ? self.message.textRect.size.width : messageButtonMaxWidth;
    if (self.message.userType == XDMessageUserTypeMe) {
        CGFloat messageButtonX = self.contentView.frame.size.width - messageButtonWidth - 2.0 * kMarginConstTen - kUserIconWidthHeight;
        
        self.messageButton.titleEdgeInsets = UIEdgeInsetsMake(kMarginConstThirteen, kMarginConstTen, kMarginConstThirteen, kMarginConstTen + kChatBackgroundImageArrowTip);
        self.messageButton.frame = CGRectMake(messageButtonX, CGRectGetMinY(self.userIconView.frame), messageButtonWidth, messageButtonHeight);
        
    }else {
        self.messageButton.titleEdgeInsets = UIEdgeInsetsMake(kMarginConstThirteen, kMarginConstTen + kChatBackgroundImageArrowTip, kMarginConstThirteen, kMarginConstTen);
        self.messageButton.frame = CGRectMake(kMarginConstTen + CGRectGetMaxX(self.userIconView.frame), CGRectGetMinY(self.userIconView.frame), messageButtonWidth, messageButtonHeight);
    }
}

#pragma mark - set message 
- (void)setMessage:(XDMessage *)message {
    _message = message;
    
    if (!message.isTimeLabelHidden) {
        self.messageSentTimeLabel.text = message.processedTime;
        [self.messageSentTimeLabel sizeToFit];
    }
    self.messageSentTimeLabel.hidden = message.isTimeLabelHidden;
    
    if (message.userType == XDMessageUserTypeMe) {
        self.userIconView.image = [UIImage imageNamed:@"test_icon_image"];
        [self.messageButton setBackgroundImage:[UIImage imageNamed:@"msg_yellow_bg"] forState:UIControlStateNormal];
        [self.messageButton setTitleColor:[UIColor colorWithHexString:@"#633206"] forState:UIControlStateNormal];
    }else {
        self.userIconView.image = [UIImage imageNamed:@"test_other_icon"];
        [self.messageButton setBackgroundImage:[UIImage imageNamed:@"msg_white_bg"] forState:UIControlStateNormal];
        [self.messageButton setTitleColor:[UIColor colorWithHexString:@"#2f3c46"] forState:UIControlStateNormal];
    }
    
    [self.messageButton setTitle:message.messageContent forState:UIControlStateNormal];
    [self.messageButton sizeToFit];
    
}

@end
