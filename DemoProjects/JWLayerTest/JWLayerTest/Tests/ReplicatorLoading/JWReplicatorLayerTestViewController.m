//
//  JWReplicatorLayerTestViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 07/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWReplicatorLayerTestViewController.h"

@interface JWReplicatorLayerTestViewController ()
@property (nonatomic, strong) CAReplicatorLayer *replicaorCanvas;
@end

@implementation JWReplicatorLayerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setupReplicatorAnimation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupReplicatorAnimation {
    CGRect replicatorLayerRect = (CGRect){100, 200, 200, 60};
    CGFloat instanceHeight = replicatorLayerRect.size.height;
    CGFloat instanceWidth = instanceHeight * 0.25;
    CGFloat instanceOffset = instanceWidth * 0.5;
    NSInteger instanceCount = (NSInteger)(replicatorLayerRect.size.width + instanceOffset)/(instanceOffset + instanceWidth);

    _replicaorCanvas = [CAReplicatorLayer layer];
    _replicaorCanvas.frame = replicatorLayerRect;
    _replicaorCanvas.backgroundColor = [UIColor whiteColor].CGColor;
    _replicaorCanvas.masksToBounds = NO;
    [self.view.layer addSublayer:_replicaorCanvas];
    if (_replicaorCanvas) {
        CGRect instanceRect = (CGRect){0, 0, instanceWidth, instanceHeight};
        CALayer *roundCornerColumn = [CALayer layer];
        roundCornerColumn.backgroundColor = [UIColor brownColor].CGColor;
        roundCornerColumn.frame = instanceRect;
        roundCornerColumn.cornerRadius = MIN(instanceWidth, instanceHeight) * 0.5;
        [_replicaorCanvas addSublayer:roundCornerColumn];
        
        //add height animation
        CABasicAnimation *heightAnim = [CABasicAnimation animation];
        heightAnim.keyPath = @"bounds.size.height";
        heightAnim.fromValue = @(roundCornerColumn.bounds.size.height);
        heightAnim.toValue = @(roundCornerColumn.bounds.size.height * 0.6);
        heightAnim.duration = 0.3;
        heightAnim.repeatCount = CGFLOAT_MAX;
        heightAnim.autoreverses = YES;
        heightAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        heightAnim.removedOnCompletion = NO;
        [roundCornerColumn addAnimation:heightAnim forKey:@"com.jiangwang.heightAnimation"];
        
        _replicaorCanvas.instanceCount = instanceCount;
        _replicaorCanvas.instanceTransform = CATransform3DMakeTranslation(instanceWidth + instanceOffset, 0, 0);
        _replicaorCanvas.instanceDelay = 0.2;
    }
}


@end
