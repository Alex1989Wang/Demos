//
//  QQTableViewCell.m
//  QQUI
//
//  Created by JiangWang on 16/4/29.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "QQTableViewCell.h"
#define kScreenSize ([UIScreen mainScreen].bounds.size)
#define kScreenWidth kScreenSize.width

@interface QQTableViewCell()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIButton *textButton;

@end

@implementation QQTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//MARK: rewrithe the setter
- (void)setFrameModel:(QQCellFrameModel *)frameModel {
    _frameModel = frameModel;

    //set the frames;
    _iconView.frame = self.frameModel.iconViewFrame;
    _timeLabel.frame = self.frameModel.timeLabelFrame;
    _textButton.frame = self.frameModel.textButtonFrame;
    
    //timeLabel
    self.timeLabel.text = frameModel.messageData.time;
    self.timeLabel.hidden = frameModel.isTimeLabelHidden;
    
    //iconView
    if (frameModel.messageData.type == QQUserTypeMe) {
        self.iconView.image = [UIImage imageNamed:@"me"];
    }else {
        self.iconView.image = [UIImage imageNamed:@"other"];
    }
    
    //textButton
    [self.textButton setTitle:frameModel.messageData.text forState:UIControlStateNormal];
    if (frameModel.messageData.type == QQUserTypeMe) {
        [self.textButton setBackgroundImage:[self stretchImageToFill:@"chat_send_nor"] forState:UIControlStateNormal];

    }else {
        [self.textButton setBackgroundImage:[self stretchImageToFill:@"chat_recive_press_pic"] forState:UIControlStateNormal];
    }
}

//MARK: rewrite the init method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

//MARK: setup the UI of the cell
- (void)setupUI {
        
    //setup the timeLabel
    UILabel *timeLabel = [[UILabel alloc] init];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setTextColor:[UIColor lightGrayColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //setup the iconImageView
    UIImageView *iconView = [[UIImageView alloc] init];
    [self addSubview:iconView];
    self.iconView = iconView;
    
    //setup textButton;
    UIButton *textButton = [[UIButton alloc] init];
    [textButton setContentEdgeInsets:UIEdgeInsetsMake(kDelta/2, kDelta/3, kDelta/2, kDelta/3)];
//    [textButton.titleLabel setBackgroundColor:[UIColor brownColor]];
    
    [textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [textButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [textButton.titleLabel setNumberOfLines:0];
    [self addSubview:textButton];
    self.textButton = textButton;
}

- (UIImage *)stretchImageToFill: (NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageWidthHalf = image.size.width /2;
    CGFloat imageHeightHalf = image.size.height / 2;
    UIEdgeInsets capInsets = UIEdgeInsetsMake(imageHeightHalf, imageWidthHalf, imageHeightHalf, imageWidthHalf);
    UIImage *stretchedImage = [image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    
    return stretchedImage;
}


@end
