//
//  DraggableBackgroundView.m
//  DraggableViewDemo
//
//  Created by JiangWang on 06/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "DraggableBackgroundView.h"
#import "DraggableCardView.h"

#import <Masonry.h>

@interface DraggableBackgroundView()

@property (nonatomic, weak) DraggableCardView *cardView;

@end

@implementation DraggableBackgroundView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self loadCustomDraggableView];
    }
    return self;
}

- (void)loadCustomDraggableView
{
    DraggableCardView *cardView = [[DraggableCardView alloc] init];
    self.cardView = cardView;
    [self addSubview:cardView];
    
    [cardView mas_makeConstraints:
    ^(MASConstraintMaker *make)
    {
        make.top.left.equalTo(self).with.offset(60);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(260);
    }];
}

@end
