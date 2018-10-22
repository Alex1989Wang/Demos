//
//  AppDelegate.m
//  NowPlaying
//
//  Created by JiangWang on 2018/10/7.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "AppDelegate.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    if (sessionError) {
        NSLog(@"audio session error: %@", sessionError);
    }
//    [application beginReceivingRemoteControlEvents];
    
    [self remoteControlEventHandler];
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
//    [application endReceivingRemoteControlEvents];
}

//- (void)remoteControlReceivedWithEvent:(UIEvent *)event
//{
//    // 根据事件的子类型(subtype) 来判断具体的事件类型, 并做出处理
//    switch (event.subtype) {
//        case UIEventSubtypeRemoteControlPlay:
//        case UIEventSubtypeRemoteControlPause: {
//            // 执行播放或暂停的相关操作 (锁屏界面和上拉快捷功能菜单处的播放按钮)
//            break;
//        }
//        case UIEventSubtypeRemoteControlPreviousTrack: {
//            // 执行上一曲的相关操作 (锁屏界面和上拉快捷功能菜单处的上一曲按钮)
//            break;
//        }
//        case UIEventSubtypeRemoteControlNextTrack: {
//            // 执行下一曲的相关操作 (锁屏界面和上拉快捷功能菜单处的下一曲按钮)
//            break;
//        }
//        case UIEventSubtypeRemoteControlTogglePlayPause: {
//            // 进行播放/暂停的相关操作 (耳机的播放/暂停按钮)
//            break;
//        }
//        default:
//            break;
//    }
//}

// 在需要处理远程控制事件的具体控制器或其它类中实现
- (void)remoteControlEventHandler
{
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
    commandCenter.playCommand.enabled = YES;
    // 为播放命令添加响应事件, 在点击后触发
    [commandCenter.playCommand addTarget:self action:@selector(stubMethod:)];
    
    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
    // 为暂停, 上一曲, 下一曲分别添加对应的响应事件
    [commandCenter.pauseCommand addTarget:self action:@selector(stubMethod:)];
    [commandCenter.previousTrackCommand addTarget:self action:@selector(stubMethod:)];
    [commandCenter.nextTrackCommand addTarget:self action:@selector(stubMethod:)];
    
    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
    commandCenter.togglePlayPauseCommand.enabled = YES;
    // 为耳机的按钮操作添加相关的响应事件
    [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(stubMethod:)];
}

- (void)stubMethod:(MPRemoteCommand *)command {
    NSLog(@"comand: %@", command);
}

@end
