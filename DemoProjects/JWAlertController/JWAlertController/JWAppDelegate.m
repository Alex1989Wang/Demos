//
//  JWAppDelegate.m
//  JWAlertController
//
//  Created by JiangWang on 08/11/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWAppDelegate.h"
#import "JWMainViewController.h"

@interface JWAppDelegate ()

@end

@implementation JWAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Initilize UI
    CGRect screenRect = [UIScreen mainScreen].bounds;
    UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:screenRect];
    JWMainViewController *mainVC = [[JWMainViewController alloc] init];
    mainWindow.rootViewController = mainVC;
    self.window = mainWindow;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
