//
//  AppDelegate.m
//  CollectionViewTutorial
//
//  Created by JiangWang on 9/2/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "AppDelegate.h"
#import "TrialCollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1.0 Instantiate A Root VC;
    UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    keyWindow.rootViewController = [[TrialCollectionViewController alloc] initWithNibName:@"TrialCollectionViewController" bundle:nil];
    self.window = keyWindow;
    [keyWindow makeKeyAndVisible];
    
    return YES;
}


@end
