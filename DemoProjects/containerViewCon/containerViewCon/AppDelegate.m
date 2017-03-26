//
//  AppDelegate.m
//  containerViewCon
//
//  Created by JiangWang on 9/18/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "AppDelegate.h"
#import "ContainerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ContainerViewController *rootVC = [[ContainerViewController alloc] init];
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
