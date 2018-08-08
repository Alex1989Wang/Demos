//
//  PGTapView.m
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/8.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "PGTapView.h"

@implementation PGTapView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGest =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
        tapGest.numberOfTapsRequired = 1;
        tapGest.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGest];
    }
    return self;
}

#pragma mark - Actions
- (void)didTapView:(UITapGestureRecognizer *)tapGest {
    NSLog(@"tap view's tap gesture selector called.");
}

@end
