//
//  XDTopView.m
//  testGift
//
//  Created by 形点网络 on 16/6/30.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDGigtUserView.h"

@interface XDGigtUserView ()

// 头像按钮
@property (nonatomic, weak) UIButton *iconButton;
// 标题Label
@property (nonatomic, weak) UILabel *markLabel;
// 名称Label
@property (nonatomic, weak) UILabel *nameLabel;
@end
@implementation XDGigtUserView

// lazy
- (UIButton *)iconButton
{
    if (_iconButton == nil) {
        
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton = iconButton;
        iconButton.userInteractionEnabled = NO;
        [iconButton addTarget:self action:@selector(changeBounds:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iconButton];
    }
    
    return _iconButton;
}

- (UILabel *)markLabel
{
    if (_markLabel == nil) {
        UILabel *markLabel = [[UILabel alloc] init];
        _markLabel = markLabel;
        markLabel.text = @"主持人";
        [markLabel sizeToFit];
        if (iPhone6p) {
            
            markLabel.font = [UIFont systemFontOfSize:14];
        }else{
            markLabel.font = [UIFont systemFontOfSize:10];
        }
        markLabel.textColor = [UIColor whiteColor];
        [self addSubview:markLabel];
    }
    return _markLabel;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
//        nameLabel.text = @"奔波霸儿加奔波霸儿";
        [nameLabel sizeToFit];
        if (iPhone6p) {
            
            nameLabel.font = [UIFont systemFontOfSize:17];
        }else{
            nameLabel.font = [UIFont systemFontOfSize:14];
        }
        nameLabel.textColor = [UIColor colorWithHexString:@"#fff32c"];
        [self addSubview:nameLabel];
    }
    
    return _nameLabel;
}


// layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (iPhone5) {
        
        [self layoutViews:H5];
    }
    if (iPhone6) {
        
        [self layoutViews:H6];
    }
    if (iPhone6p) {
        
        [self layoutViews:H6Plus];
    }
}

// 计算子控件尺寸
- (void)layoutViews:(CGFloat)scale
{
    self.height = 70 * scale;
    
    self.iconButton.width = self.isBig ? 40 * scale : 60 * scale;
    self.iconButton.height = self.iconButton.width;
    self.iconButton.x = 0;
    self.iconButton.y = self.isBig ? self.height - 5 * scale - self.iconButton.height : 5 * scale;
    
    self.markLabel.x = CGRectGetMaxX(self.iconButton.frame) + 10 * scale;
    self.markLabel.y = self.height - self.markLabel.height - self.nameLabel.height - 13 * scale;
    self.nameLabel.x = self.markLabel.x;
    self.nameLabel.y = CGRectGetMaxY(self.markLabel.frame);
    
    self.width = self.isBig ? 40 * scale : CGRectGetMaxX(self.nameLabel.frame);
}

-(void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;
    
    if (name.length > 9) {
        name = @"奔波霸儿加奔波霸儿";
        CGSize size = [name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        self.nameLabel.width = size.width;
        self.nameLabel.height = size.height;
    }else{
    
        [self.nameLabel sizeToFit];
    }
}

- (void)setMarkName:(NSString *)markName
{
    _markName = markName;
    
    self.markLabel.text = markName;
}

- (void)changeBounds:(UIButton *)btn
{
    btn.selected =!btn.selected;
    self.clipsToBounds = YES;
    [self setNeedsLayout];
}

- (void)setBig:(BOOL)big
{
    _big = big;
    self.clipsToBounds = YES;
    
    if (iPhone5) {
        
        [self layoutViews:H5];
    }
    if (iPhone6) {
        
        [self layoutViews:H6];
    }
    if (iPhone6p) {
        
        [self layoutViews:H6Plus];
    }
    
}

-(void)setIconUrl:(NSString *)iconUrl
{
    _iconUrl = iconUrl;
    UIImage *image = [UIImage imageNamed:@"nv"];
    [self.iconButton setImage:[image clipImage] forState:UIControlStateNormal];
}
@end
