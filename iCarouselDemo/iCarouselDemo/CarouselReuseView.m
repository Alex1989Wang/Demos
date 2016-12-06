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
@property (nonatomic, weak) UILabel *label;

@end

@implementation CarouselReuseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor greenColor];
        
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
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor redColor];
        _label = label;
        [self addSubview:label];
        [label mas_makeConstraints:
        ^(MASConstraintMaker *make)
        {
            make.edges.equalTo(self);
        }];
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

- (void)setText:(NSString *)text
{
    if (text != _text)
    {
        self.label.text = text;
    }
}

@end
