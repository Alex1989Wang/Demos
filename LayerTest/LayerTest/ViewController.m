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
    [self explicitAnimationTest];
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
