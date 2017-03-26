//
//  DraggableCardView.m
//  DraggableViewDemo
//
//  Created by JiangWang on 06/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "DraggableCardView.h"
#import <Masonry.h>

@interface DraggableCardView()

@property (nonatomic, strong) UIPanGestureRecognizer *panGuesture;
@property (nonatomic, assign) CGPoint originalCenter;

@end

@implementation DraggableCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.panGuesture =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(dragged:)];
        [self addGestureRecognizer:self.panGuesture];
        [self setupSubImageView];
    }
    return self;
}


- (void)setupSubImageView
{
    UIImage *image = [UIImage imageNamed:@"jack"];
    UIImageView *cardImageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:cardImageView];
    
    [cardImageView mas_makeConstraints:
    ^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self);
    }];
    
    cardImageView.layer.cornerRadius = 8.0;
    cardImageView.layer.masksToBounds = YES;
    
//    self.layer.cornerRadius = 8.0;
//    self.layer.masksToBounds = YES;
    
    self.layer.shadowOffset = CGSizeMake(7, 7);
    self.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.8;
}

- (void)dragged:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self];
    NSLog(@"pan guesture translation: %@", NSStringFromCGPoint(translation));
    
    switch (pan.state)
    {
            
        case UIGestureRecognizerStateBegan:
        {
            self.originalCenter = self.center;
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            [self adjustPositionAndTransformWithTranslation:translation];
            break;
        }
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self recoverOriginalPositionAndTransform];
            break;
        }
            
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }
}

- (void)adjustPositionAndTransformWithTranslation:(CGPoint)translation
{
    CGFloat transX = translation.x;
    CGFloat transY = translation.y;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //new position
    CGPoint newCenter =
    CGPointMake(self.originalCenter.x + transX, self.originalCenter.y + transY);
    self.center = newCenter;
    
    //rotation
    CGFloat panStrength = MIN(transX / screenWidth, 1);
    CGFloat rotationAngel = M_PI / 6 * panStrength;
    CGAffineTransform angelTrans = CGAffineTransformMakeRotation(rotationAngel);
    CGFloat scale = 1 - fabs(panStrength);
    CGFloat scaleRange = MAX(scale, 0.5);
    CGAffineTransform integratedTrans =
    CGAffineTransformScale(angelTrans, scaleRange, scaleRange);
    self.transform = integratedTrans;
    
    NSLog(@"rotation: %f ---- scale: %f",rotationAngel, scale);
}

- (void)recoverOriginalPositionAndTransform
{
    [UIView animateWithDuration:0.2
                     animations:
     ^{
         self.transform = CGAffineTransformIdentity;
         self.center = self.originalCenter;
     }];
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGuesture];
    self.panGuesture = nil;
}

@end
