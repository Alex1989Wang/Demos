//
//  AppDelegate.m
//  textShare
//
//  Created by 形点网络 on 16/6/29.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //register app on wechat
    [WXApi registerApp:@"wx9b64ff39631009d9"];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSLog(@"url: %@", url);
    
    return YES;
}

@end
