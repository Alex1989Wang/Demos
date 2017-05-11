//
//  LayerTestView.m
//  LayerTest
//
//  Created by JiangWang on 09/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "LayerTestView.h"

@interface LayerTestView()
@property (nonatomic, weak) CALayer *imageLayer;
@property (nonatomic, weak) CALayer *delegateLayer;
@property (nonatomic, weak) CALayer *animationLayer;
@end

@implementation LayerTestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addLayerHierachy];
    }
    return self;
}

- (void)addLayerHierachy {
    [self imageLayer];
    [self animationLayer];
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        self.imageLayer.contents = (__bridge id _Nullable)(image.CGImage);
    }
}

#pragma mark - Delegate
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (layer == self.layer) {
        self.imageLayer.frame = self.layer.bounds;
        self.animationLayer.frame = CGRectInset(self.layer.bounds, 50, 50);
    }
}

- (void)displayLayer:(CALayer *)layer {
    if (layer == self.layer) {
        [super displayLayer:layer];
    }
    else if (layer == self.delegateLayer) {
        if ([self.delegate respondsToSelector:
            @selector(layerTestViewNeedDispalyContent:)]) {
            UIImage *content = [self.delegate layerTestViewNeedDispalyContent:self];
            self.delegateLayer.contents = (__bridge id _Nullable)(content.CGImage);
        }
        else {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"jack" ofType:@"jpg"];
            UIImage *defaultImage = [UIImage imageWithContentsOfFile:imagePath];
            self.delegateLayer.contents = (__bridge id _Nullable)(defaultImage.CGImage);
        }
    }
}

#pragma mark - Lazy Loading;
- (CALayer *)imageLayer {
    if (_imageLayer == nil) {
        CALayer *imageLayer = [[CALayer alloc] init];
        _imageLayer = imageLayer;
        [self.layer addSublayer:imageLayer];
    }
    return _imageLayer;
}

- (CALayer *)delegateLayer {
    if (_delegateLayer == nil) {
        CALayer *delegateLayer = [[CALayer alloc] init];
        delegateLayer.backgroundColor = [UIColor blueColor].CGColor;
        _delegateLayer = delegateLayer;
        [self.layer addSublayer:delegateLayer];
//        delegateLayer.delegate = self;
    }
    return _delegateLayer;
}

- (CALayer *)animationLayer {
    if (_animationLayer == nil) {
        CALayer *layer = [[CALayer alloc] init];
        layer.backgroundColor = [UIColor blueColor].CGColor;
        _animationLayer = layer;
        [self.layer addSublayer:layer];
    }
    return _animationLayer;
}

@end
