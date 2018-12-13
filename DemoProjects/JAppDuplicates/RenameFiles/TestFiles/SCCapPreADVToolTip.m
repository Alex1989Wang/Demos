//
//  PCCapPreADVToolTip.m
//  SelfieCamera
//
//  Created by 权欣权忆 on 2016/8/30.
//  Copyright © 2016年 Pinguo. All rights reserved.
//

#import "PCCapPreADVToolTip.h"
#import "SCLocalizationMgr.h"

@interface PCCapPreADVToolTip ()

@property (nonatomic, strong) IBOutlet UILabel *mTipView;

@end

@implementation PCCapPreADVToolTip

+ (instancetype)ADVToolTipFromXIB
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return [views firstObject];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [PCCapPreADVToolTip ADVToolTipFromXIB];
        [self setFrame:frame];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.mTipView setNumberOfLines:0];
    [self.mTipView setLineBreakMode:NSLineBreakByWordWrapping];
    [self.mTipView setText:LS(@"PC_CapPre_ADVSetting_Tip", @"")];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

