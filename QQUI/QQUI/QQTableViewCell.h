//
//  QQTableViewCell.h
//  QQUI
//
//  Created by JiangWang on 16/4/29.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQCellFrameModel.h"

@class QQMessageModel;

@interface QQTableViewCell : UITableViewCell

@property (nonatomic) QQCellFrameModel *frameModel;

//rewrite the message model's setter;
- (void)setFrameModel:(QQCellFrameModel *)frameModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
