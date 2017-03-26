//
//  ViewController.m
//  AudioServiceVibrateAndSoundAlert
//
//  Created by JiangWang on 7/19/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

static SystemSoundID newMessageNotificationSoundID = 0;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self registerNotificationSound];
}

- (void)registerNotificationSound {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"original_sound_alert" ofType:@"wav"];
    CFStringRef soundFilePath = (__bridge CFStringRef) soundPath;
    
    CFURLRef fileURLRef = CFURLCreateWithString(kCFAllocatorDefault, soundFilePath, NULL);
    
    AudioServicesCreateSystemSoundID(fileURLRef, &newMessageNotificationSoundID);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(newMessageNotificationSoundID);
}

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(newMessageNotificationSoundID);
}

@end
