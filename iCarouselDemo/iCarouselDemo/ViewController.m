//
//  ViewController.m
//  iCarouselDemo
//
//  Created by JiangWang on 06/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

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

        default:
            return value;
            break;
    }
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel
   itemTransformForOffset:(CGFloat)offset
            baseTransform:(CATransform3D)transform
{
    CGAffineTransform affineTransform =
    CATransform3DGetAffineTransform(transform);
    NSLog(@"offset: %f ---- transform: %@",
          offset,
          NSStringFromCGAffineTransform(affineTransform));
    
    CGFloat tilt = -0.2;
    CGFloat spacing = 0.1;
    CGFloat newOffset = -offset;
    return CATransform3DTranslate(transform,
                                  newOffset * carousel.itemWidth * tilt,
                                  0.0,
                                  newOffset * carousel.itemWidth * spacing);
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
        _nameCardContainer.delegate = self;
        _nameCardContainer.dataSource = self;
    }
    return _nameCardContainer;
}


@end
