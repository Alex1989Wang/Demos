//
//  ViewController.m
//  LayerTest
//
//  Created by JiangWang on 09/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "LayerTestView.h"
#import "NewTestViewController.h"

@interface ViewController ()
@property (nonatomic, weak) UIView *cornerRadiusTestView;

@property (nonatomic, weak) UIView *transTestOne;
@property (nonatomic, weak) UIView *transTestTwo;

@property (nonatomic, weak) UIButton *pushButton;
@end

@implementation ViewController

- (void)loadView {
    self.view = [[LayerTestView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"old test";
    
    //test view
//    LayerTestView *layerTestView = [[LayerTestView alloc] init];
//    _testView = layerTestView;
//    layerTestView.frame = self.view.bounds;
//    [self.view addSubview:layerTestView];
    
    //test image
    [self testImage];
    
    //test corner radius
    [self cornerRadiusTestView];
    [self transTestOne];
//    [self transTestTwo];
    [self pushButton];
    
    //new test
    UIBarButtonItem *rightItem =
    [[UIBarButtonItem alloc] initWithTitle:@"new test"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(pushNewTestViewController)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self explicitAnimationTest];
//    [self keyFrameAnimationTest];
//    [self implicitAndExplicitAnimationMixture];
//    [self transitionTest];
//    [self autoReverseAnimation];
//    [self transactionTest];
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

- (void)transitionTest {
    if (!self.transTestOne.hidden &&
        self.transTestTwo.hidden) {
        self.transTestOne.hidden = NO;
        self.transTestTwo.hidden = NO;
    }
   
    CIFilter* aFilter = [CIFilter filterWithName:@"CIBarsSwipeTransition"];
    [aFilter setValue:[NSNumber numberWithFloat:3.14] forKey:@"inputAngle"];
    [aFilter setValue:[NSNumber numberWithFloat:30.0] forKey:@"inputWidth"];
    [aFilter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputBarOffset"];
    
    CATransition *pushTrans = [CATransition animation];
    pushTrans.startProgress = 0.0;
    pushTrans.endProgress = 1.0;
    pushTrans.filter = aFilter;
    pushTrans.duration = 1.0f;
    
    [self.transTestTwo setHidden:NO];
    [self.transTestOne.layer addAnimation:pushTrans forKey:@"transition"];
    [self.transTestTwo.layer addAnimation:pushTrans forKey:@"transition"];
    
    //final values
    [self.transTestOne setHidden:YES];
}

- (void)pushButtonDidClick:(UIButton *)pushButton {
//    [self transitionTest];
//    if (fpclassify(self.transTestOne.layer.speed) == FP_ZERO) {
//        [self resumeAnimation];
//    }
//    else {
//        [self animationPause];
//    }
//    [self transactionTest];
    [self implicitLayerAnimation];
}

- (void)autoReverseAnimation {
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"position";
    CGPoint originalPosition = self.transTestOne.layer.position;
    basicAnimation.fromValue = [NSValue valueWithCGPoint:originalPosition];
    originalPosition.y += 200;
    basicAnimation.toValue = [NSValue valueWithCGPoint:originalPosition];
    basicAnimation.autoreverses = YES;
    basicAnimation.duration = 1.5f;
    basicAnimation.repeatCount = CGFLOAT_MAX;
    
    [self.transTestOne.layer addAnimation:basicAnimation forKey:@"position_animation"];
}

- (void)animationPause {
    self.transTestOne.layer.speed = 0.f;
    CFTimeInterval pausedTime = [self.transTestOne.layer convertTime:CACurrentMediaTime()
                                                             toLayer:nil];
    self.transTestOne.layer.timeOffset = pausedTime;
}

- (void)resumeAnimation {
    CFTimeInterval pausedTime = [self.transTestOne.layer timeOffset];
    self.transTestOne.layer.speed = 1.f;
    self.transTestOne.layer.beginTime = 0.f;
    self.transTestOne.layer.timeOffset = 0.f;
    CFTimeInterval currentTime = [self.transTestOne.layer convertTime:CACurrentMediaTime()
                                                              toLayer:nil];
    CFTimeInterval timeSincePaused = (currentTime - pausedTime);
    self.transTestOne.layer.beginTime = timeSincePaused;
}

- (void)transactionTest {
    self.transTestOne.layer.opacity = 0.5f;
    
    [CATransaction begin];
    CAMediaTimingFunction *timingFunc = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [CATransaction setAnimationDuration:2.f];
    [CATransaction setAnimationTimingFunction:timingFunc];
    [CATransaction setCompletionBlock:^{
        NSLog(@"transaction finished.");
        //subsequently added animations
    }];
    NSLog(@"transaction began");
    CGPoint originalPos = self.transTestOne.layer.position;
    self.transTestOne.layer.backgroundColor = [UIColor greenColor].CGColor;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnimation.fromValue = [NSValue valueWithCGPoint:originalPos];
    basicAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(originalPos.x, originalPos.y + 200)];
    [self.transTestOne.layer addAnimation:basicAnimation forKey:@"position_animation"];
    [CATransaction commit];
}

- (void)implicitLayerAnimation {
    LayerTestView *testView = (LayerTestView *)self.view;
    CALayer *animationLayer = testView.animationLayer;
    
    if (CGColorEqualToColor(animationLayer.backgroundColor, [UIColor purpleColor].CGColor)) {
        [CATransaction begin];
        NSLog(@"transaction began");
        [CATransaction setCompletionBlock:^{
            NSLog(@"transaction ended.");
        }];
        [CATransaction setDisableActions:YES];
        animationLayer.backgroundColor = [UIColor blueColor].CGColor;
        [CATransaction commit];
    }
    else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:2.0];
        NSLog(@"animation timing function: %@", [CATransaction animationTimingFunction]);
        animationLayer.backgroundColor = [UIColor purpleColor].CGColor;
        NSLog(@"CAActions: %@", animationLayer.presentationLayer.actions);
        NSLog(@"animation timing function: %@", [CATransaction animationTimingFunction]);
        [CATransaction commit];
        NSLog(@"CAActions: %@", animationLayer.actions);
    }
}

#pragma mark - new test
- (void)pushNewTestViewController {
    NewTestViewController *newCon = [[NewTestViewController alloc] init];
    [self.navigationController pushViewController:newCon animated:YES];
}

#pragma mark - Lazy Loading
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

- (UIView *)transTestOne {
    if (nil == _transTestOne) {
        UIView *transTestOne = [[UIView alloc] init];
        _transTestOne = transTestOne;
        CGRect transRect = CGRectMake(200, 200, 150, 150);
        transTestOne.frame = transRect;
        [self.view addSubview:transTestOne];
        
        transTestOne.backgroundColor = [UIColor yellowColor];
    }
    return _transTestOne;
}


- (UIView *)transTestTwo {
    if (nil == _transTestTwo) {
        UIView *transTestTwo = [[UIView alloc] init];
        _transTestTwo = transTestTwo;
        CGRect transRect = CGRectMake(200, 200, 150, 150);
        transTestTwo.frame = transRect;
        [self.view addSubview:transTestTwo];
        
        transTestTwo.backgroundColor = [UIColor redColor];
    }
    return _transTestTwo;
}

- (UIButton *)pushButton {
    if (nil == _pushButton) {
        UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pushButton.frame = CGRectMake(175, 400, 80, 40);
        _pushButton = pushButton;
        [self.view addSubview:pushButton];
        
        [pushButton setTitle:@"Click To Push" forState:UIControlStateNormal];
        [pushButton addTarget:self
                       action:@selector(pushButtonDidClick:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
}

@end
