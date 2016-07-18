//
//  QQCellFrameModel.h
//  QQUI
//
//  Created by JiangWang on 16/5/6.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQMessageModel.h"
#import <UIKit/UIKit.h>

#define kDelta (40) //enlarge the button's size, so that the text could be shown in the button completely;

@interface QQCellFrameModel : NSObject

@property (nonatomic) QQMessageModel *messageData;

@property (nonatomic) CGRect timeLabelFrame;
@property (nonatomic) CGRect textButtonFrame;
@property (nonatomic) CGRect iconViewFrame;

@property (nonatomic) CGFloat cellHeight;
@property (nonatomic, getter=isTimeLabelHidden) BOOL hiddenTimeLabel;

//MARK: rewrite the setMessageData method;
//when you set the data; you should calculate the cell's subViews' frames

- (void)setMessageData:(QQMessageModel *)messageData;

@end
