//
//  CarouselReuseView.m
//  iCarouselDemo
//
//  Created by JiangWang on 06/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "CarouselReuseView.h"
#import <Masonry.h>

@interface CarouselReuseView()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation CarouselReuseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor orangeColor];
        _imageView = imageView;
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self addSubview:imageView];
        [imageView mas_makeConstraints:
        ^(MASConstraintMaker *make)
        {
            make.edges.equalTo(self).with.insets(insets);
        }];
        [self addSubview:_imageView];
    }
    return self;
}


- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        self.imageView.image = image;
    }
}

@end
