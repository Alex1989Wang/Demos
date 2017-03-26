//
//  ContainerViewController.m
//  ViewControllerProgrammingGuideDemo
//
//  Created by JiangWang on 25/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ContainerViewController.h"
#import "PopoverTestController.h"
#import "TestTwoViewController.h"
#import "TestViewController.h"
#import <Masonry.h>

#define kCornerContainerW (0.5 * kScreenWidth)
#define kCornerContainerHeightToWidth (4.0/3.0)
#define kCornerContainerH kCornerContainerW * kCornerContainerHeightToWidth

typedef NS_ENUM(NSUInteger, ContainerViewControllerState)
{
    ContainerViewControllerStateOriginal, //original size and positon
    ContainerViewControllerStateLeftEnlarged, //left corner container enlarged;
    ContainerViewControllerStateRightEnalarged, //right corner container enlarged;
};

@interface ContainerViewController ()

@property (nonatomic, assign) ContainerViewControllerState state;
@property (nonatomic, weak) UIView *mainContainer;
@property (nonatomic, weak) UIView *leftContainer;
@property (nonatomic, weak) UIView *rightContainer;

@property (nonatomic, weak) TestViewController *testVC;
@property (nonatomic, weak) TestTwoViewController *testTwoVC;

//use container to add other view controller's view;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(adjustContainerViewSize:)];
    [self.view addGestureRecognizer:tapGuest];
    
    [self setupMainContainer];
    [self setupLeftCornerContainer];
    [self setupRightCornerContainer];
    self.state = ContainerViewControllerStateOriginal;
    
    [self setupMainContainerContent];
    [self setupLeftContainerContent];
}

- (void)setupLeftContainerContent
{
    TestViewController *testVC = [[TestViewController alloc] init];
    self.testVC = testVC;
    [self addChildViewController:testVC];
    [self.leftContainer addSubview:testVC.view];
    testVC.view.frame = self.leftContainer.bounds;
    [testVC didMoveToParentViewController:self];
}

- (void)setupMainContainerContent
{
    PopoverTestController *popoverTest = [[PopoverTestController alloc] init];
    [self addChildViewController:popoverTest];
    [self.mainContainer addSubview:popoverTest.view];
    popoverTest.view.frame = self.mainContainer.bounds;
    [popoverTest didMoveToParentViewController:self];
}

- (void)setupMainContainer
{
    CGFloat height = kScreenHeight - kCornerContainerH;
    CGRect mianContainerFrame = CGRectMake(0, 0, kScreenWidth, height);
    UIView *mainContainer = [[UIView alloc] initWithFrame:mianContainerFrame];
    mainContainer.backgroundColor = [UIColor purpleColor];
    self.mainContainer = mainContainer;
    [self.view addSubview:mainContainer];
}

- (void)setupLeftCornerContainer
{
    CGPoint leftAnchor = CGPointMake(0, 1.0);
    CGPoint leftPosition = CGPointMake(0, kScreenHeight);
    
    UIView *leftContainer = [self cornerContainerWithAnchorPoint:leftAnchor
                                                        position:leftPosition];
    leftContainer.backgroundColor = [UIColor brownColor];
    self.leftContainer = leftContainer;
    [self.view addSubview:leftContainer];
}

- (void)setupRightCornerContainer
{
    CGPoint rightAnchor = CGPointMake(1.0, 1.0);
    CGPoint rightPosition = CGPointMake(kScreenWidth, kScreenHeight);
    
    UIView *rightContainer = [self cornerContainerWithAnchorPoint:rightAnchor
                                                        position:rightPosition];
    rightContainer.backgroundColor = [UIColor blueColor];
    self.rightContainer = rightContainer;
    [self.view addSubview:rightContainer];
}

- (UIView *)cornerContainerWithAnchorPoint:(CGPoint)anchor
                                  position:(CGPoint)position
{
    CGRect cornerContainerBounds =
    CGRectMake(0, 0, kCornerContainerW, kCornerContainerH);
    
    UIView *container = [[UIView alloc] init];
    container.bounds = cornerContainerBounds;
    container.layer.anchorPoint = anchor;
    container.layer.position = position;
    
    UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(adjustContainerViewSize:)];
    [container addGestureRecognizer:tapGuest];
    return container;
}

- (void)adjustContainerViewSize:(UITapGestureRecognizer *)tap
{
    UIView *containerView = tap.view;
    
    //tap the left corner container
    CGAffineTransform largeTrans = CGAffineTransformMakeScale(1.25, 1.25);
    CGAffineTransform oppositeTrans = CGAffineTransformMakeScale(0.75, 0.75);
    if (self.leftContainer == containerView &&
        self.state != ContainerViewControllerStateLeftEnlarged)
    {
        [UIView animateWithDuration:0.2
                         animations:
         ^{
             self.leftContainer.transform = largeTrans;
             self.rightContainer.transform = oppositeTrans;
         }];
        self.state = ContainerViewControllerStateLeftEnlarged;
        
        [self transitionToTestTwoController];
    }
    
    //tap the right
    if (self.rightContainer == containerView &&
        self.state != ContainerViewControllerStateRightEnalarged)
    {
        [UIView animateWithDuration:0.2
                         animations:
         ^{
             self.leftContainer.transform = oppositeTrans;
             self.rightContainer.transform = largeTrans;
         }];
        self.state = ContainerViewControllerStateRightEnalarged;
        
    }
    
    //tap the main
    if (self.view == containerView &&
        self.state != ContainerViewControllerStateOriginal)
    {
        CGAffineTransform identityTrans = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.2
                         animations:
         ^{
             self.leftContainer.transform = identityTrans;
             self.rightContainer.transform = identityTrans;
         }];
        self.state = ContainerViewControllerStateOriginal;
        [self transitionToTestController];
    }
}

- (void)transitionToTestTwoController
{
    TestTwoViewController *testTwoVC = [[TestTwoViewController alloc] init];
    self.testTwoVC = testTwoVC;
    [self.testVC willMoveToParentViewController:nil];
    [self addChildViewController:testTwoVC];
    
    CGRect disappearRect = CGRectZero;
    
    [self transitionFromViewController:self.testVC
                      toViewController:testTwoVC
                              duration:0.2
                               options:0
                            animations:
     ^{
         testTwoVC.view.frame = self.leftContainer.bounds;
         self.testVC.view.frame = disappearRect;
     }
                            completion:
     ^(BOOL finished)
     {
         [testTwoVC didMoveToParentViewController:self];
         [self.testVC removeFromParentViewController];
     }];
}

- (void)transitionToTestController
{
    TestViewController *testController = [[TestViewController alloc] init];
    self.testVC = testController;
    [self.testTwoVC willMoveToParentViewController:nil];
    [self addChildViewController:testController];
    
    [self transitionFromViewController:self.testTwoVC
                      toViewController:self.testVC
                              duration:0.2
                               options:0
                            animations:
     ^{
         self.testVC.view.frame = CGRectZero;
         self.testTwoVC.view.frame = self.leftContainer.bounds;
     }
                            completion:
     ^(BOOL finished)
     {
         [testController didMoveToParentViewController:self];
         [self.testTwoVC removeFromParentViewController];
     }];
}

@end
