//
//  XDVerticalButton.m
//  
//
//  Created by 形点网络 on 16/6/29.
//
//

#import "XDVerticalButton.h"
#import "UIView+Frame.h"
#import "UIColor+Hex.h"

@implementation XDVerticalButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:[UIColor colorWithHexString:@"#2f3c46"] forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = 0;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.width * 0.5;
    self.titleLabel.y = self.imageView.height + 5;
    
}

//取消按钮的高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
