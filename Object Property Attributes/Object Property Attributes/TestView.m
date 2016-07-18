//
//  TestView.m
//  Object Property Attributes
//
//  Created by JiangWang on 7/16/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TestView.h"
#define kRedViewHeightOrWidth 20

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width * 0.5 - 0.5 * kRedViewHeightOrWidth, frame.size.height * 0.5 - 0.5 * kRedViewHeightOrWidth, kRedViewHeightOrWidth, kRedViewHeightOrWidth)];
        [redView setBackgroundColor:[UIColor redColor]];
        [self addSubview:redView];
        _middleView = redView;
    }
    
    return self;
}

- (void)setMiddleView:(UIView *)middleView {
    _middleView = middleView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 0.5 * kRedViewHeightOrWidth, self.frame.size.height * 0.5 - 0.5 * kRedViewHeightOrWidth, kRedViewHeightOrWidth, kRedViewHeightOrWidth)];
    [orangeView setBackgroundColor:[UIColor orangeColor]];
    self.middleView = orangeView;
}

@end
