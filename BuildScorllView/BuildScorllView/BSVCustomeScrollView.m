//
//  BSVCustomeScrollView.m
//  BuildScorllView
//
//  Created by JiangWang on 06/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "BSVCustomeScrollView.h"

@implementation BSVCustomeScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewReceivesPan:)];
        [self addGestureRecognizer:panGest];
    }
    return self;
}

- (void)viewReceivesPan:(UIPanGestureRecognizer *)pan {
//    NSLog(@"pan gesture: %@", pan);
    NSLog(@"pan translation: %@", NSStringFromCGPoint([pan translationInView:self]));
    CGFloat minBoundsY = 0;
    CGFloat maxBoundsY = self.contentSize.height - self.bounds.size.height;
    CGFloat minBoundsX = 0;
    CGFloat maxBoundsX = self.contentSize.width - self.bounds.size.width;
    
    CGPoint panTrans = [pan translationInView:self];
    CGFloat panY = panTrans.y;
    CGFloat panX = panTrans.x;
    
    //reset the pan translation
    [pan setTranslation:CGPointZero inView:self];   
    
    //for Y direction
    CGFloat newBoundsY = - panY + self.bounds.origin.y;
    CGFloat newBoundsX = - panX + self.bounds.origin.x;
    
    CGRect bounds = self.bounds;
    bounds.origin.x = fmaxf(minBoundsX, fminf(newBoundsX, maxBoundsX));
    bounds.origin.y = fmaxf(minBoundsY, fminf(newBoundsY, maxBoundsY));
    self.bounds = bounds;
}

@end
