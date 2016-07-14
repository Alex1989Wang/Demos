//
//  PanGestureTestViewController.m
//  PanGesture
//
//  Created by JiangWang on 16/7/14.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "PanGestureTestViewController.h"

@interface PanGestureTestViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint previousTranslation;
@property (nonatomic, weak) UIView *test2;

@end

@implementation PanGestureTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"pan test VC";
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *testView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    [testView1 setBackgroundColor:[UIColor orangeColor]];
    UIView *testView2 = [[UIView alloc] initWithFrame:CGRectMake(0.5 * [UIScreen mainScreen].bounds.size.width - 0.5 * 100, 0.5 * [UIScreen mainScreen].bounds.size.height - 0.5 * 100, 100, 100)];
    [testView2 setBackgroundColor:[UIColor blueColor]];
    self.test2 = testView2;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [testView2 addGestureRecognizer:pan];
    pan.delegate = self;
    
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//    [testView2 addGestureRecognizer:swipe];
    
    //add test view
    [self.view addSubview:testView1];
    [self.view addSubview:testView2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    NSLog(@"velocity: %@", NSStringFromCGPoint([pan velocityInView:self.view]));
    NSLog(@"translation in view: %@", NSStringFromCGPoint([pan translationInView:self.view]));
    
    //use x direction
    CGPoint thisTranslation = [pan translationInView:self.view];
    CGFloat xDiff = thisTranslation.x - self.previousTranslation.x;
    
    CGFloat animationDuration = xDiff / [pan velocityInView:self.view].x;
    
//    [UIView animateWithDuration:animationDuration animations:^{
//
//    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.test2.frame = CGRectMake(self.test2.frame.origin.x + xDiff, self.test2.frame.origin.y + thisTranslation.y - self.previousTranslation.y, self.test2.frame.size.width, self.test2.frame.size.height);
    }];
    
    if (pan.state != UIGestureRecognizerStateEnded) {
        
        self.previousTranslation = [pan translationInView:self.view];
    }else {
        self.previousTranslation = CGPointZero;
    }
}

#pragma mark - UIGesture Recognizer Delegate Methods;
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s", __func__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    NSLog(@"%s", __func__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"%s", __func__);
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"%s", __func__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"%s", __func__);
    return YES;
}


#pragma mark - swipe 
//- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
//    NSLog(@"handleSwipe:%@", swipe);
//}

@end
