//
//  ViewController.m
//  UIAnimationTest
//
//  Created by JiangWang on 25/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic, weak) UITextField *firstTextF;
@property (nonatomic, weak) UITextField *secondTextF;
@property (nonatomic, weak) UITextField *currentVisibleTextF;
@property (nonatomic, weak) UIView *animationView;
@property (nonatomic, weak) UIView *loginView;
@property (nonatomic, weak) UIView *regView;
@property (nonatomic, assign, getter=isLoginShown) BOOL loginShown;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create Animation View
//    [self configureAnimationView];
    
    //Create A Control Button
//    [self configureControlButton];
    
    //Two Text View
//    [self configureTwoTextFields];
    
    //Transition Between Two Main Views;
    [self configureRootView];
    [self configureTwoMainViews];
}

- (void)configureAnimationView
{
    CGFloat sideLength = 100;
    CGFloat originX = (self.view.bounds.size.width - sideLength) * 0.5;
    CGRect squareRect =
    CGRectMake(originX, 300, sideLength, sideLength);
    UIView *animationView = [[UIView alloc] initWithFrame:squareRect];
    animationView.backgroundColor = [UIColor brownColor];
    
    [self.view addSubview:animationView];
    self.animationView = animationView;
}


- (void)configureControlButton
{
    UIButton *controlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    controlButton.center = CGPointMake(self.view.bounds.size.width * 0.5, 100);
    CGRect btnFrame = controlButton.frame;
    btnFrame.size = CGSizeMake(80, 20);
    controlButton.frame = btnFrame;
    [self.view addSubview:controlButton];
    [controlButton setTitle:@"delegate动画" forState:UIControlStateNormal];
    UIColor *blackColor = [UIColor blackColor];
    [controlButton setTitleColor:blackColor forState:UIControlStateNormal];
    [controlButton setTitle:@"block动画" forState:UIControlStateSelected];
    [controlButton addTarget:self
                      action:@selector(startTransitionAnimation)
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)switchAnimationType:(UIButton *)ctrlButton
{
    ctrlButton.selected = !ctrlButton.selected;
    if (ctrlButton.selected)
    {
        [self startBlockAnimation];
    }
    else
    {
        [self startDelegateAnimation];
    }
}

- (void)startBlockAnimation
{
    UIViewKeyframeAnimationOptions options =
    UIViewKeyframeAnimationOptionAutoreverse |
    UIViewKeyframeAnimationOptionRepeat;
    
    CGRect newFrame = self.animationView.frame;
    newFrame.origin.y -= 150;
    [UIView animateKeyframesWithDuration:3
                                   delay:0
                                 options:options
                              animations:
     ^{
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [UIView setAnimationRepeatCount:1];
         self.animationView.frame = newFrame;
     }
                              completion:
     ^(BOOL finished)
    {
         if (finished)
         {
             UIViewKeyframeAnimationOptions newOpts =
             UIViewKeyframeAnimationOptionOverrideInheritedOptions |
             UIViewKeyframeAnimationOptionOverrideInheritedDuration;
             
             CGRect newRect = self.animationView.frame;
             newRect.origin.y += 150;
             [UIView animateKeyframesWithDuration:5
                                            delay:1
                                          options:newOpts
                                       animations:
              ^{
                  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                  [UIView setAnimationRepeatCount:2];
                  self.animationView.frame = newRect;
              }
                                       completion:nil];
         }
     }];
}

- (void)startDelegateAnimation
{
    [UIView beginAnimations:@"move_downward_animation" context:NULL];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationDuration:3];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:YES];
    CGRect newFrame = self.animationView.frame;
    newFrame.origin.y -= 150;
    self.animationView.frame = newFrame;
    [UIView commitAnimations];
}

- (void)animationWillStart:(NSString *)animationID
                   context:(void *)context
{
    NSLog(@"delegate animation: begin");
}

- (void)animationDidStop:(NSString *)animationID
                finished:(NSNumber *)finished
                 context:(void *)context
{
    NSLog(@"delegate animation finied");
    
    [UIView beginAnimations:@"move_upward_animtion" context:NULL];
    [UIView setAnimationRepeatCount:2];
    [UIView setAnimationDuration:5];
    [UIView setAnimationDelay:1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGRect newFrame = self.animationView.frame;
    newFrame.origin.y += 150;
    self.animationView.frame = newFrame;
    [UIView commitAnimations];
}

- (void)startTransitionAnimation
{
    UIViewAnimationOptions transOpts =
    UIViewAnimationOptionTransitionCurlUp;
    
    [UIView transitionWithView:self.view
                      duration:2
                       options:transOpts
                    animations:
     ^{
         self.firstTextF.hidden = NO;
         self.secondTextF.hidden = YES;
     }
                    completion:
     ^(BOOL finished)
     {
         UITextField *temp = self.secondTextF;
         self.secondTextF = self.firstTextF;
         self.firstTextF = temp;
     }];
}

- (void)configureTwoTextFields
{
    CGRect firstRect = CGRectMake(0, 20, 150, 40);
    UITextField *firstTextF = [[UITextField alloc] initWithFrame:firstRect];
    firstTextF.backgroundColor = [UIColor orangeColor];
    self.firstTextF = firstTextF;
    
    CGRect secondRect = CGRectMake(0, 20, 150, 40);
    UITextField *secondTextF = [[UITextField alloc] initWithFrame:secondRect];
    secondTextF.backgroundColor = [UIColor blueColor];
    self.secondTextF = secondTextF;
    
    [self.view addSubview:firstTextF];
    [self.view addSubview:secondTextF];
}


- (void)configureTwoMainViews
{
    //登录
    CGRect rootViewBounds = [[UIScreen mainScreen] bounds];
    UIView *loginView = [[UIView alloc] initWithFrame:rootViewBounds];
    [self.view addSubview:loginView];
    self.loginView = loginView;
    self.loginView.hidden = NO;
    self.loginShown = YES;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = [UIColor lightGrayColor];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginView addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:
    ^(MASConstraintMaker *make)
    {
        make.width.mas_equalTo(200);
        make.centerX.equalTo(loginView.mas_centerX);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(loginView.mas_top).with.mas_offset(124);
    }];
    
    //注册
    UIView *regView = [[UIView alloc] initWithFrame:rootViewBounds];
    [self.view addSubview:regView];
    self.regView = regView;
    self.regView.hidden = YES;
    
    UIButton *regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    regButton.backgroundColor = [UIColor orangeColor];
    [regButton setTitle:@"注册" forState:UIControlStateNormal];
    [regView addSubview:regButton];
    
    [regButton mas_makeConstraints:
    ^(MASConstraintMaker *make)
    {
        make.width.mas_equalTo(200);
        make.centerX.equalTo(regView.mas_centerX);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(regView.mas_top).with.mas_offset(124);
    }];
}

- (void)configureRootView
{
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"更换"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(changeMainView)];
}

- (void)changeMainView
{
    UIViewAnimationOptions opts =
    UIViewAnimationOptionShowHideTransitionViews |
    ((self.isLoginShown) ?
     UIViewAnimationOptionTransitionCurlUp :
     UIViewAnimationOptionTransitionCurlDown);
    
    UIView *fromView = (self.isLoginShown) ? self.loginView : self.regView;
    UIView *toView = (self.isLoginShown) ? self.regView : self.loginView;
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:opts
                    completion:
     ^(BOOL finished)
    {
        if (finished)
        {
            self.loginShown = !self.isLoginShown;
        }
    }];
}

@end
