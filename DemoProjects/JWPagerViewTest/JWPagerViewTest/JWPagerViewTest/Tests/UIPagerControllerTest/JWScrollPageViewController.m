//
//  JWScrollPageViewController.m
//  JWPagerViewTest
//
//  Created by JiangWang on 22/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWScrollPageViewController.h"

@interface JWScrollPageViewController ()
<UIPageViewControllerDelegate,
UIPageViewControllerDataSource>

@end

@implementation JWScrollPageViewController

- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style
                  navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation
                                options:(NSDictionary<NSString *,id> *)options {
    self = [super initWithTransitionStyle:style
                    navigationOrientation:navigationOrientation
                                  options:options];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UIPageViewControllerDelegate

// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers  {
    NSLog(@"page view controller: %@", pageViewController);
}

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
}

// Delegate may specify a different spine location for after the interface orientation change. Only sent for transition style 'UIPageViewControllerTransitionStylePageCurl'.
// Delegate may set new view controllers or update double-sided state within this method's implementation as well.
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return UIPageViewControllerSpineLocationMid;
}

- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - UIPageViewControllerDataSource

// In terms of navigation direction. For example, for 'UIPageViewControllerNavigationOrientationHorizontal', view controllers coming 'before' would be to the left of the argument view controller, those coming 'after' would be to the right.
// Return 'nil' to indicate that no more progress can be made in the given direction.
// For gesture-initiated transitions, the page view controller obtains view controllers via these methods, so use of setViewControllers:direction:animated:completion: is not required.
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *viewController1 = [[UIViewController alloc] init];
    viewController1.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0
                                                           green:arc4random_uniform(255)/255.0
                                                            blue:arc4random_uniform(255)/255.0
                                                           alpha:1.0];;
    return viewController1;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *viewController1 = [[UIViewController alloc] init];
    viewController1.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0
                                                           green:arc4random_uniform(255)/255.0
                                                            blue:arc4random_uniform(255)/255.0
                                                           alpha:1.0];;
    return viewController1;
}

// A page indicator will be visible if both methods are implemented, transition style is 'UIPageViewControllerTransitionStyleScroll', and navigation orientation is 'UIPageViewControllerNavigationOrientationHorizontal'.
// Both methods are called in response to a 'setViewControllers:...' call, but the presentation index is updated automatically in the case of gesture-driven navigation.
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 10;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 4;
}

@end
