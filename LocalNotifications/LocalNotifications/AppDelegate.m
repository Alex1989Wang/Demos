//
//  AppDelegate.m
//  LocalNotifications
//
//  Created by JiangWang on 7/22/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //register for local notifications
    
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
    
    //actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    [acceptAction setIdentifier:@"ACCEPT_ACTION"];
    [acceptAction setTitle:@"接收"];
    [acceptAction setAuthenticationRequired:NO];
    [acceptAction setBehavior:UIUserNotificationActionBehaviorDefault];
    [acceptAction setActivationMode:UIUserNotificationActivationModeBackground];
    
    UIMutableUserNotificationAction *ignoreAction = [[UIMutableUserNotificationAction alloc] init];
    [ignoreAction setIdentifier:@"IGNORE_ACTION"];
    [ignoreAction setTitle:@"忽略"];
    [ignoreAction setAuthenticationRequired:NO];
    [ignoreAction setBehavior:UIUserNotificationActionBehaviorTextInput];
    [ignoreAction setActivationMode:UIUserNotificationActivationModeBackground];
    
    //categories
    UIMutableUserNotificationCategory *mutableCate = [[UIMutableUserNotificationCategory alloc] init];
    [mutableCate setIdentifier:@"MUTABLE_CATEGORY"];
    [mutableCate setActions:@[acceptAction, ignoreAction] forContext:UIUserNotificationActionContextMinimal];
    
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:[NSSet setWithObjects:mutableCate, nil]];
    
    [application registerUserNotificationSettings:settings];
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey] != nil) {
        [application.keyWindow.rootViewController.view addSubview:[[UISwitch alloc] init]];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"local notification arrived");
}



@end
