//
//  AppDelegate.m
//  JWAutoRotateExpOne
//
//  Created by JiangWang on 15/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "AppDelegate.h"
#import "JWRootNavigationController.h"
#import "JWMainTabViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:screenRect];
    
    //root view controller
    JWMainTabViewController *mainTabCon = [[JWMainTabViewController alloc] init];
    JWRootNavigationController *rootNaviCon =
    [[JWRootNavigationController alloc] initWithRootViewController:mainTabCon];
    mainWindow.rootViewController = rootNaviCon;
    
    self.window = mainWindow;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
