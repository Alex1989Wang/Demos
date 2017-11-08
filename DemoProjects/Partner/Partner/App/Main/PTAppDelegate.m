//
//  PTAppDelegate.m
//  Partner
//
//  Created by JiangWang on 12/08/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "PTAppDelegate.h"

/* controllers */
#import "PTNavigationController.h"
#import "PTMainTabViewController.h"

/* models */
#import "PTLogFormatter.h"

@interface PTAppDelegate ()

@end

@implementation PTAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupLoggers];
    [self setUpMainUI];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private
- (void)setUpMainUI {
    /* root vc */
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:screenBounds];
    PTMainTabViewController *mainTabCon = [[PTMainTabViewController alloc] init];
    PTNavigationController *rootNavCon =
    [[PTNavigationController alloc] initWithRootViewController:mainTabCon];
    keyWindow.rootViewController = rootNavCon;
    self.window = keyWindow;
    [self.window makeKeyAndVisible];
    
}

- (void)setupLoggers {
    //console log
    DDTTYLogger *consoleLoger = [DDTTYLogger sharedInstance];
    consoleLoger.logFormatter = [[PTLogFormatter alloc] init];
    [DDLog addLogger:consoleLoger withLevel:DDLogLevelDebug];
    //file log
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 24 * 60 * 60;
    fileLogger.doNotReuseLogFiles = YES;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
    fileLogger.logFormatter = [[PTLogFormatter alloc] init];
    [DDLog addLogger:fileLogger withLevel:DDLogLevelWarning];
}

@end
