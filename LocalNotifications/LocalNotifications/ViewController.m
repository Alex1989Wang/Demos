//
//  ViewController.m
//  LocalNotifications
//
//  Created by JiangWang on 7/22/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendNoti {
    
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.alertTitle = @"Hi, I am a local notification";
    localNoti.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNoti.category = @"MUTABLE_CATEGORY";
    localNoti.alertBody = @"What?";
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    localNoti.applicationIconBadgeNumber = 23;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    
}

- (IBAction)cancelNoti {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}



@end
