//
//  XDgiftCell.m
//  testGift
//
//  Created by 形点网络 on 16/7/1.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDgiftCell.h"

@interface XDgiftCell ()
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIButton *goldView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lightImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goldTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lightHeight;
@end
@implementation XDgiftCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpFirst];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUpFirst];
    if (iPhone5) {
        
        self.topMagin.constant = self.topMagin.constant * H5;
        self.leftMagin.constant = self.leftMagin.constant * H5;
        self.rightMagin.constant = self.rightMagin.constant * H5;
        self.goldTop.constant = self.goldTop.constant * H5;
        self.nameTop.constant = self.nameTop.constant * H5;
        self.lightHeight.constant = self.lightHeight.constant * H5;
    }
    
    if (iPhone6) {
        
        self.topMagin.constant = self.topMagin.constant * H6;
        self.leftMagin.constant = self.leftMagin.constant * H6;
        self.rightMagin.constant = self.rightMagin.constant * H6;
        self.goldTop.constant = self.goldTop.constant * H6;
        self.nameTop.constant = self.nameTop.constant * H6;
        self.lightHeight.constant = self.lightHeight.constant * H6;
        
    }
    
    if (iPhone6p) {
        
        self.topMagin.constant = self.topMagin.constant * H6Plus;
        self.leftMagin.constant = self.leftMagin.constant * H6Plus;
        self.rightMagin.constant = self.rightMagin.constant * H6Plus;
        self.goldTop.constant = self.goldTop.constant * H6Plus;
        self.nameTop.constant = self.nameTop.constant * H6Plus;
        self.lightHeight.constant = self.lightHeight.constant * H6Plus;
    }
}
- (void)setUpFirst
{
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#fff32c"];
    
    self.lightImageView.hidden = YES;
    self.nameLabel.hidden = YES;
    self.lineView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.lightImageView.hidden = NO;
        self.nameLabel.hidden = NO;
        self.lineView.hidden = NO;
    }else{
        self.lightImageView.hidden = YES;
        self.nameLabel.hidden = YES;
        self.lineView.hidden = YES;
    }
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    
    self.giftImageView.image = image;
}

@end
