//
//  AppDelegate.m
//  WeChatSDKShare
//
//  Created by JiangWang on 7/27/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//  wx56e4051e66076cba

// original code :wx9b64ff39631009d9

#import "AppDelegate.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "ViewController.h"


#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //send the register request to the WeChat
    [WXApi registerApp:@"wx56e4051e66076cba"];
    
    //QQ authorization
    
    
    return YES;
}







#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}
    

#endif

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    return YES;
}






- (void)onResp:(BaseResp *)resp {
    SendMessageToWXResp *sendResponse = (SendMessageToWXResp *)resp;
    
    NSLog(@"send response: %@", sendResponse);
    
}

@end
