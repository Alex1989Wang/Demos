//
//  ViewController.m
//  LayerTest
//
//  Created by JiangWang on 09/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "LayerTestView.h"

@interface ViewController ()
@property (nonatomic, weak) UIView *cornerRadiusTestView;
@end

@implementation ViewController

- (void)loadView {
    self.view = [[LayerTestView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //test view
//    LayerTestView *layerTestView = [[LayerTestView alloc] init];
//    _testView = layerTestView;
//    layerTestView.frame = self.view.bounds;
//    [self.view addSubview:layerTestView];
    
    //test image
    [self testImage];
    
    //test corner radius
    [self cornerRadiusTestView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self explicitAnimationTest];
//    [self keyFrameAnimationTest];
    [self implicitAndExplicitAnimationMixture];
}

- (void)testImage {
    //test image
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"KVO-KVC" ofType:@"png"];
    UIImage *testImage = [UIImage imageWithContentsOfFile:imagePath];
    LayerTestView *testView = (LayerTestView *)self.view;
    testView.image = testImage;
}

- (void)explicitAnimationTest {
    //explicit animation won't change the animated value when it ends;
    //if you want to change the animated value to the end value; you have to
    //to set it explicitly to keep the effect permanant.
    CABasicAnimation *basicAni = [[CABasicAnimation alloc] init];
    basicAni.keyPath = @"opacity";
    basicAni.fromValue = [NSNumber numberWithFloat:self.cornerRadiusTestView.layer.opacity];
    basicAni.toValue = [NSNumber numberWithFloat:0.f];
    basicAni.duration = 1.f;
    [self.cornerRadiusTestView.layer addAnimation:basicAni forKey:@"opacity"];
    
    //final value
//    self.cornerRadiusTestView.layer.opacity = 0.f;
}

- (void)implicitAndExplicitAnimationMixture {
    [UIView animateWithDuration:1.0
                     animations:
     ^{
         self.cornerRadiusTestView.layer.opacity = 0.5;
         
         CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
         CGPoint oldPoint = self.cornerRadiusTestView.layer.position;
         positionAni.fromValue = [NSValue valueWithCGPoint:oldPoint];
         CGPoint newPoint = CGPointMake(oldPoint.x + 100, oldPoint.y + 100);
         positionAni.toValue = [NSValue valueWithCGPoint:newPoint];
         positionAni.duration = 3.f;
         [self.cornerRadiusTestView.layer addAnimation:positionAni forKey:@"position_animation"];
     }];
}

- (void)keyFrameAnimationTest {
    //key frame animation one
    CAKeyframeAnimation *animationOne = [CAKeyframeAnimation animationWithKeyPath:@"borderWidth"];
    animationOne.values = @[@1.0, @10.0, @5.0, @30.0, @0.5, @15.0, @2.0,
                            @50.0, @0.0];
    animationOne.calculationMode = kCAAnimationPaced;
    
    //key frame animation two
    CAKeyframeAnimation *animationTwo = [CAKeyframeAnimation animationWithKeyPath:@"borderColor"];
    animationTwo.values = @[(id)[UIColor greenColor].CGColor,
                            (id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor];
    animationTwo.calculationMode = kCAAnimationPaced;
    
    //group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[animationOne, animationTwo];
    animationGroup.duration = 5.f;
    
    [self.cornerRadiusTestView.layer addAnimation:animationGroup forKey:@"border_change"];
}

- (UIView *)cornerRadiusTestView {
    if (nil == _cornerRadiusTestView) {
        UIView *cornerTestView  = [[UIView alloc] init];
        _cornerRadiusTestView = cornerTestView;
        [self.view addSubview:cornerTestView];
        
        cornerTestView.frame = CGRectMake(100, 100, 50, 50);
        cornerTestView.backgroundColor = [UIColor brownColor];
        cornerTestView.layer.cornerRadius = 10.f;
        cornerTestView.layer.shadowColor = [UIColor blackColor].CGColor;
        cornerTestView.layer.shadowOffset = CGSizeMake(5.f, 5.f);
        cornerTestView.layer.shadowOpacity = 1.f;
        
        //corner radius always will affect the border and
        //background color; will not affect the content image;
        /*
        UIImageView *innerImage = [[UIImageView alloc] init];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"KVO-KVC" ofType:@"png"];
        UIImage *testImage = [UIImage imageWithContentsOfFile:imagePath];
        innerImage.image = testImage;
        innerImage.frame = cornerTestView.bounds;
        [cornerTestView addSubview:innerImage];
        
        innerImage.layer.cornerRadius = 10.f;
         */
    }
    return _cornerRadiusTestView;
}

@end
