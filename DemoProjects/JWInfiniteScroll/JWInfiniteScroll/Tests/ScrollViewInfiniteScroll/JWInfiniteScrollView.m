//
//  JWInfiniteScrollView.m
//  JWInfiniteScroll
//
//  Created by JiangWang on 23/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWInfiniteScrollView.h"

#define kLargeScrollContentWidth (1000)
#define kImageViewIndexBase (10000)
#define kImageWidhtHeight (50.f)

@interface JWInfiniteScrollView()
@property (nonatomic, strong) UIView *imageContainer;
@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *visibleImageViews;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViewPool;
@end

@implementation JWInfiniteScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = (CGSize){kLargeScrollContentWidth,
            CGRectGetHeight(frame)};
        self.backgroundColor = [UIColor blueColor];
        
        //add image view container
        self.imageContainer.frame = (CGRect){0, 0, self.contentSize.width,
            self.contentSize.height};
        [self addSubview:self.imageContainer];
        
        // hide horizontal scroll indicator so our recentering trick is not revealed
        [self setShowsHorizontalScrollIndicator:NO];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentSize = (CGSize){kLargeScrollContentWidth,
        CGRectGetHeight(self.bounds)};
    [self recenterIfNecessary];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.imageContainer];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tileImagesFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}

#pragma mark - Private
- (void)recenterIfNecessary {
    CGPoint contentOffset = self.contentOffset;
    CGFloat centerOffsetX = (self.contentSize.width - self.bounds.size.width) * 0.5;
    CGFloat offsetDif = fabs(contentOffset.x - centerOffsetX);
    if (offsetDif > 100) {
        self.contentOffset = (CGPoint){centerOffsetX, contentOffset.y};
        
        // move content by the same amount so it appears to stay still
        for (UIImageView *imageView in self.visibleImageViews) {
            CGPoint center = [self.imageContainer convertPoint:imageView.center toView:self];
            center.x += (centerOffsetX - contentOffset.x);
            imageView.center = [self convertPoint:center toView:self.imageContainer];
        }
    }
}

- (NSInteger)imageViewIndexWithImageIndex:(NSInteger)imageIndex {
    return (imageIndex + kImageViewIndexBase);
}

- (NSInteger)imageIndexWithImageViewIndex:(NSInteger)imageViewIndex {
    return (imageViewIndex - kImageViewIndexBase);
}

#pragma mark - Image Tiling
- (UIImageView *)imageViewWithImageIndex:(NSInteger)imageIndex {
    if (imageIndex >= self.images.count) {
        return nil;
    }
    
    UIImage *image = [self.images objectAtIndex:imageIndex];
    UIImageView *imageView = nil;
    if (self.imageViewPool.count) {
        imageView = [self.imageViewPool firstObject];
        imageView.image = image;
        [self.imageViewPool removeObject:imageView];
    }
    else {
        imageView = [[UIImageView alloc] initWithImage:image];
    }
    imageView.tag = [self imageViewIndexWithImageIndex:imageIndex];
    return imageView;
}

- (CGFloat)appendNewImageOnRight:(CGFloat)originX {
    UIImageView *lastImageView = self.visibleImageViews.lastObject;
    NSInteger imageIndex = (lastImageView) ?
    ([self imageIndexWithImageViewIndex:lastImageView.tag] + 1) % self.images.count :
    0;
    UIImageView *imageView = [self imageViewWithImageIndex:imageIndex];
    
    if (imageView) {
        [self.visibleImageViews addObject:imageView];
        CGRect imageRect = (CGRect){originX, 0, kImageWidhtHeight, kImageWidhtHeight};
        imageView.frame = imageRect;
        [self.imageContainer addSubview:imageView];
    }
    
    return MAX(originX, CGRectGetMaxX(imageView.frame));
}

- (CGFloat)insertNewImageOnLeft:(CGFloat)left {
    UIImageView *firstImageView = self.visibleImageViews.firstObject;
    NSInteger imageIndex = (firstImageView) ?
    (([self imageIndexWithImageViewIndex:firstImageView.tag] - 1) >=0 ?
     [self imageIndexWithImageViewIndex:firstImageView.tag] - 1 :
     [self imageIndexWithImageViewIndex:firstImageView.tag] - 1 + self.images.count) :
    0;
    UIImageView *imageView = [self imageViewWithImageIndex:imageIndex];
    
    if (imageView) {
        [self.visibleImageViews insertObject:imageView atIndex:0];
        CGRect imageRect = (CGRect){left - kImageWidhtHeight, 0,
            kImageWidhtHeight, kImageWidhtHeight};
        imageView.frame = imageRect;
        [self.imageContainer addSubview:imageView];
    }
    
    return MIN(left, CGRectGetMinX(imageView.frame));
}

- (void)tileImagesFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    // the upcoming tiling logic depends on there already being at least one image view in the visibleImageViews array, so
    // to kick off the tiling we need to make sure there's at least one image view
    if ([self.visibleImageViews count] == 0)
    {
        [self appendNewImageOnRight:minimumVisibleX];
    }
    
    // add image views that are missing on right side
    UIImageView *lastImageView = [self.visibleImageViews lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastImageView frame]);
    while (rightEdge < maximumVisibleX) {
        rightEdge = [self appendNewImageOnRight:rightEdge];
    }
    
    // add image views that are missing on left side
    UIImageView *firstImageView = self.visibleImageViews[0];
    CGFloat leftEdge = CGRectGetMinX([firstImageView frame]);
    while (leftEdge > minimumVisibleX) {
        leftEdge = [self insertNewImageOnLeft:leftEdge];
    }
    
    // remove image views that have fallen off right edge
    lastImageView = [self.visibleImageViews lastObject];
    while ([lastImageView frame].origin.x > maximumVisibleX) {
        [lastImageView removeFromSuperview];
        [self.visibleImageViews removeLastObject];
        [self.imageViewPool addObject:lastImageView];
        lastImageView = [self.visibleImageViews lastObject];
    }
    
    // remove image views that have fallen off left edge
    firstImageView = self.visibleImageViews[0];
    while (CGRectGetMaxX([firstImageView frame]) < minimumVisibleX) {
        [firstImageView removeFromSuperview];
        [self.visibleImageViews removeObjectAtIndex:0];
        [self.imageViewPool addObject:firstImageView];
        firstImageView = self.visibleImageViews[0];
    }
}

#pragma mark - Lazy Loading 
- (UIView *)imageContainer {
    if (!_imageContainer) {
        _imageContainer = [[UIView alloc] init];
    }
    return _imageContainer;
}
                              
- (NSArray<UIImage *> *)images {
    if (!_images) {
        NSArray *imageNames = @[@"0_icon",
                                @"1_icon",
                                @"2_icon",
                                @"3_icon",
                                @"4_icon",
                                @"5_icon",
                                @"6_icon",
                                @"7_icon",
                                @"8_icon",
                                @"9_icon",];
        
        NSMutableArray<UIImage *> *images =
        [NSMutableArray arrayWithCapacity:imageNames.count];
        for (NSString *imageName in imageNames) {
            UIImage *image = [UIImage imageNamed:imageName];
            if (image) {
                [images addObject:image];
            }
        }
        _images = [images copy];
    }
    return _images;
}

- (NSMutableArray<UIImageView *> *)visibleImageViews {
    if (!_visibleImageViews) {
        _visibleImageViews = [NSMutableArray array];
    }
    return _visibleImageViews;
}

- (NSMutableArray<UIImageView *> *)imageViewPool {
    if (!_imageViewPool) {
        _imageViewPool = [NSMutableArray array];
    }
    return _imageViewPool;
}

@end
