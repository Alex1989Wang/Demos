//
//  ViewController.m
//  iCarouselDemo
//
//  Created by JiangWang on 06/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angl

#import "ViewController.h"
#import "CarouselReuseView.h"

#import <iCarousel.h>
#import <Masonry.h>

@interface ViewController ()
<iCarouselDelegate,
iCarouselDataSource>

@property (nonatomic, strong) iCarousel *nameCardContainer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.nameCardContainer];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.nameCardContainer mas_makeConstraints:
    ^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self.view).with.insets(insets);
    }];
}

#pragma mark - iCarousel的数据源和代理
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSInteger)index
         reusingView:(UIView *)view
{
    //如果有重用view
    if (view)
    {
        CarouselReuseView *reuseView = (CarouselReuseView *)view;
        NSAssert([reuseView isKindOfClass:[CarouselReuseView class]],
                 @"wrong reuse view class");
        reuseView.image = [UIImage imageNamed:@"KVO-KVC"];
        return view;
    }
    //新增view
    else
    {
        CGFloat padding = 60;
        CGSize carouselSize = carousel.bounds.size;
        CGRect reuseViewBounds =
        CGRectMake(padding, padding,
                   carouselSize.width - 2 * padding,
                   carouselSize.height - 2 * padding);
        CarouselReuseView *reuseView =
        [[CarouselReuseView alloc] initWithFrame:reuseViewBounds];
        reuseView.image = [UIImage imageNamed:@"jack"];
        reuseView.text = [NSString stringWithFormat:@"index %ld \n \
                          view: %@", index, view];
        return reuseView;
    }
}

- (CGFloat)carousel:(iCarousel *)carousel
     valueForOption:(iCarouselOption)option
        withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
            break;
        }
            case iCarouselOptionTilt:
        {
            return 0.9;
            break;
        }
            case iCarouselOptionSpacing:
        {
            return 0.25;
            break;
        }

        default:
            return value;
            break;
    }
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel
   itemTransformForOffset:(CGFloat)offset
            baseTransform:(CATransform3D)transform
{
    CGFloat tilt = 0.0;
    CGFloat spacing = 0.25;
    CGFloat clampedOffset = MAX(-1.0, MIN(1.0, offset));
    
    NSLog(@"\noffset: %f --- \n\
          current index: %ld  ---\n\
          scroll offset: %f ---",
          offset,
          carousel.currentItemIndex,
          carousel.scrollOffset);
    
    CGFloat x = (clampedOffset * 0.5 * tilt + offset * spacing) * carousel.itemWidth;
    CGFloat z = fabs(clampedOffset) * -carousel.itemWidth * 0.5;
    if ((carousel.scrollOffset + offset) == carousel.currentItemIndex)
    {
        //当前item
        transform = CATransform3DTranslate(transform, x, 0.0, z);
        return CATransform3DRotate(transform, offset * M_PI_4, 0.0, 0.0, 1.0);
    }
    else
    {
        transform = CATransform3DTranslate(transform, x, 0.0, z);
        return CATransform3DRotate(transform, -clampedOffset * M_PI_2 * tilt, 0.0, 1.0, 0.0);
    }
}

#pragma mark - 懒加载
- (iCarousel *)nameCardContainer
{
    if (nil == _nameCardContainer)
    {
        _nameCardContainer = [[iCarousel alloc] init];
        _nameCardContainer.backgroundColor = [UIColor brownColor];
        _nameCardContainer.type = iCarouselTypeCustom;
        _nameCardContainer.pagingEnabled = YES;
        _nameCardContainer.vertical = NO;
        _nameCardContainer.delegate = self;
        _nameCardContainer.dataSource = self;
    }
    return _nameCardContainer;
}


@end
