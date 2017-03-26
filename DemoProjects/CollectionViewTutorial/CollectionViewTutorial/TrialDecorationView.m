//
//  TrialDecorationView.m
//  CollectionViewTutorial
//
//  Created by JiangWang on 9/2/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TrialDecorationView.h"

static NSString *const decorationEmblemImageName = @"emblem";

@implementation TrialDecorationView

+ (CGSize)defaultSize {
    return [UIImage imageNamed:decorationEmblemImageName].size;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImage *emblem = [UIImage imageNamed:decorationEmblemImageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:emblem];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
    }
    
    return self;
}

@end
