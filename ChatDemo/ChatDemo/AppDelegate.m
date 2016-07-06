//
//  AppDelegate.m
//  ChatDemo
//
//  Created by JiangWang on 7/5/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "AppDelegate.h"
#import "XDMessageController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:[[XDMessageController alloc] init]];
    self.window.rootViewController = rootViewController;

    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
