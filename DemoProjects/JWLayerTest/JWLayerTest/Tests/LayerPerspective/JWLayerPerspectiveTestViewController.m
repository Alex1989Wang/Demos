//
//  JWLayerPerspectiveTestViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 08/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWLayerPerspectiveTestViewController.h"

@interface JWLayerPerspectiveTestViewController ()
@property (nonatomic, strong) CALayer *parentLayer;
@end

@implementation JWLayerPerspectiveTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect parentLayerRect = (CGRect){0, 150, self.view.bounds.size.width, 250};
    self.parentLayer.frame = parentLayerRect;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/8;
    self.parentLayer.sublayerTransform = transform;
    [self.view.layer addSublayer:self.parentLayer];
    
    //set up sublayers with different zPosition;
    for (NSInteger index = 0; index < 5; index++) {
        CALayer *subLayer = [CALayer layer];
        UIColor *randomColor = [UIColor colorWithRed:(arc4random_uniform(255)/255.f)
                                               green:(arc4random_uniform(255)/255.f)
                                                blue:(arc4random_uniform(255)/255.f)
                                               alpha:1.0];
        subLayer.backgroundColor = randomColor.CGColor;
        subLayer.zPosition = index;
        subLayer.frame = (CGRect){20+index * 50, (250 - 100) * 0.5, 50 , 100};
        [self.parentLayer addSublayer:subLayer];
    }
}


#pragma mark - Lazy Loading
- (CALayer *)parentLayer {
    if (!_parentLayer) {
        _parentLayer = [CALayer layer];
        _parentLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    }
    return _parentLayer;
}

@end
