//
//  PTMainTabViewController.m
//  Partner
//
//  Created by JiangWang on 12/08/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "PTMainTabViewController.h"
#import "PTHomeViewController.h"
#import "PTUserProfileViewController.h"

@interface PTMainTabViewController ()
<UITabBarControllerDelegate>

@end

@implementation PTMainTabViewController

#pragma mark - Life Cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //选中首位
    [self setSelectedIndex:0];
}

#pragma mark - Private
- (void)setupViewControllers {
    PTHomeViewController *homeVC = [[PTHomeViewController alloc] init];
    UIViewController *configuredHomeVC =
    [self configuredViewController:homeVC
                       tabBarTitle:@"Home"
                 selectedImageName:@"ic_dock_home_on"
                   normalImageName:@"ic_dock_home_off"];
    
    PTUserProfileViewController *userVC = [[PTUserProfileViewController alloc] init];
    UIViewController *configuredUserVC =
    [self configuredViewController:userVC
                       tabBarTitle:@"Me"
                 selectedImageName:@"ic_dock_self_off"
                   normalImageName:@"ic_dock_self_on"];
    
    NSArray *viewControllers = @[configuredHomeVC, configuredUserVC];
    [self setViewControllers:viewControllers animated:NO];
}

- (__kindof UIViewController *)configuredViewController:(UIViewController *)controller
                                            tabBarTitle:(NSString *)tabTitle
                                      selectedImageName:(NSString *)selImageName
                                        normalImageName:(NSString *)norImageName {
    UIImage *selectedImage = [UIImage imageNamed:selImageName];
    UIImage *normalImage = [UIImage imageNamed:norImageName];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle
                                                             image:normalImage
                                                     selectedImage:selectedImage];
    controller.tabBarItem = tabBarItem;
    return controller;
}

#pragma mark - Delegate

@end
