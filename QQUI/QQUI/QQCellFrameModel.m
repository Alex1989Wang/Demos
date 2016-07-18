//
//  QQCellFrameModel.m
//  QQUI
//
//  Created by JiangWang on 16/5/6.
//  Copyright © 2016年 JiangWang. All rights reserved.
//  This cell frame model should not only contain the data to populate the cell.
//  but also, it should tell us where the cell is; and how the cell subViews should be positioned.

#import "QQCellFrameModel.h"
#import <UIKit/UIKit.h>

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)


@implementation QQCellFrameModel

-(void)setMessageData:(QQMessageModel *)messageData {
    _messageData = messageData;
    
    [self calculateTheFramesWithMessageData: messageData];
    

}

- (void)calculateTheFramesWithMessageData: (QQMessageModel *)messageData {
    
    //setup the margin
    CGFloat marginForAll = 5;
    
    //setup the timeLabel
    CGFloat timeLabelX = 0;
    CGFloat timeLabelY = 0;
    CGFloat timeLabelWidth = kScreenWidth;
    CGFloat timeLabelHeight = 20;
    CGRect timeLabelRect = CGRectMake(timeLabelX, timeLabelY, timeLabelWidth, timeLabelHeight);
    _timeLabelFrame = timeLabelRect;
    
    
    //setup the iconImageView
    CGRect iconFrame = CGRectZero;
    CGFloat iconWidthAndHeight = 40;
    if (self.messageData.type == QQUserTypeMe) { //type == 1 means me;
        iconFrame = CGRectMake(kScreenWidth - iconWidthAndHeight - marginForAll, CGRectGetMaxY(timeLabelRect) + marginForAll, iconWidthAndHeight, iconWidthAndHeight);
    }else {
        iconFrame = CGRectMake(marginForAll, CGRectGetMaxY(timeLabelRect) + marginForAll, iconWidthAndHeight, iconWidthAndHeight);
    }
    _iconViewFrame = iconFrame;
    
    //setup textButtonFrame according to the contents of it;
    CGRect buttonFrame = CGRectZero;
    CGFloat buttonFrameY = CGRectGetMaxY(timeLabelRect) + marginForAll;
    CGFloat buttonFrameWidth = kScreenWidth - iconFrame.size.width - 3 * marginForAll - kDelta;
    CGSize buttonFrameMaxumum = CGSizeMake(buttonFrameWidth, MAXFLOAT);
    if (self.messageData.type == QQUserTypeMe) {
        buttonFrame = [self calculateTheSizeOfButtonWithText:self.messageData.text withinSize:buttonFrameMaxumum];
        
        //calculate the buttonFrameX
        CGFloat buttonFrameWidth = buttonFrame.size.width + kDelta;
        CGFloat buttonFrameHeight = buttonFrame.size.height + kDelta;
        CGFloat buttonFrameX = kScreenWidth - buttonFrameWidth - iconFrame.size.width - 2 * marginForAll;
        
        buttonFrame.origin.x = buttonFrameX;
        buttonFrame.origin.y = buttonFrameY;
        buttonFrame.size.width = buttonFrameWidth;
        buttonFrame.size.height = buttonFrameHeight;
    }else {
        buttonFrame = [self calculateTheSizeOfButtonWithText:self.messageData.text withinSize:buttonFrameMaxumum];
        
        //calculate the buttonFrameX
        CGFloat buttonFrameX = iconFrame.size.width + 2 * marginForAll;
        
        buttonFrame.size.width += kDelta;
        buttonFrame.size.height += kDelta;
        buttonFrame.origin.x = buttonFrameX;
        buttonFrame.origin.y = buttonFrameY;
    }
    _textButtonFrame = buttonFrame;
    
    //calculate the cellheight;
    if (CGRectGetMaxY(buttonFrame) > CGRectGetMaxY(iconFrame)) {
        _cellHeight = marginForAll + CGRectGetMaxY(buttonFrame);
    }else {
        _cellHeight = marginForAll + CGRectGetMaxY(iconFrame);
    }
    
}

- (CGRect)calculateTheSizeOfButtonWithText: (NSString *)textMessage withinSize: (CGSize)maximumSize {
    //MARK: using the textMessage to calculate the bounding rect of the button;
    
    NSDictionary *messageDrawingAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 17], NSParagraphStyleAttributeName: [NSParagraphStyle defaultParagraphStyle]};
    CGRect boundingButtonRect = [textMessage boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin attributes:messageDrawingAttributes context:nil];
    return boundingButtonRect;
}

@end
