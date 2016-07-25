//
//  IndividualSettings.m
//  settingsTest
//
//  Created by JiangWang on 7/22/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "IndividualSettings.h"

@interface IndividualSettings ()

@property (weak, nonatomic) IBOutlet UISwitch *theNewMessage;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vibSwitch;


@end

@implementation IndividualSettings

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /* initialize individual settings */
    [self initializeIndividualSettingsWithID:self.userID];
}


- (void)initializeIndividualSettingsWithID:(NSString *)identifier {
    self.theNewMessage.on = [[XDGlobalSettingsManager sharedManager] fetchIndividualMessageSettingWithID:identifier key:kChatManagementCellNewMessageNotiSwitchStateKey];
    self.soundSwitch.on = [[XDGlobalSettingsManager sharedManager] fetchIndividualMessageSettingWithID:identifier key:kChatManagementCellSoundNotiSwitchStateKey];
    self.vibSwitch.on = [[XDGlobalSettingsManager sharedManager] fetchIndividualMessageSettingWithID:identifier key:kChatManagementCellVibrationNotiSwitchStateKey];
}


- (IBAction)newMessageSwitch:(UISwitch *)textSwitch {
    
    if (textSwitch.isOn) {
        
        BOOL canTurnOn = [[XDGlobalSettingsManager sharedManager] canTurnOnIndividualSettingWithID:self.userID key:kChatManagementCellSoundNotiSwitchStateKey];
        if (canTurnOn) {
            NSLog(@"can turn on");
        }else {
            NSLog(@"can't turn on");
            [textSwitch setOn:NO animated:YES];
            
            //return immediately - no need to save the state;
            return;
        }
    }

    [[XDGlobalSettingsManager sharedManager] writeIndividualMessageSetting:textSwitch.isOn WithID:self.userID key:kChatManagementCellNewMessageNotiSwitchStateKey];
}



- (IBAction)switchSoundSwitch:(UISwitch *)textSwitch {
    
    if (textSwitch.isOn) {
        
        BOOL canTurnOn = [[XDGlobalSettingsManager sharedManager] canTurnOnIndividualSettingWithID:self.userID key:kChatManagementCellSoundNotiSwitchStateKey];
        if (canTurnOn) {
            NSLog(@"can turn on");
        }else {
            NSLog(@"can't turn on");
            [textSwitch setOn:NO animated:YES];
            
            //return immediately - no need to save the state;
            return;
        }
    }
    
    
    [[XDGlobalSettingsManager sharedManager] writeIndividualMessageSetting:textSwitch.isOn WithID:self.userID key:kChatManagementCellSoundNotiSwitchStateKey];
}
- (IBAction)switchVibSwitch:(UISwitch *)textSwitch {
    
    BOOL canTurnOn = [[XDGlobalSettingsManager sharedManager] canTurnOnIndividualSettingWithID:self.userID key:kChatManagementCellVibrationNotiSwitchStateKey];
    if (canTurnOn) {
        NSLog(@"can turn on");
    }else {
        NSLog(@"can't turn on");
        [textSwitch setOn:NO animated:YES];
        
        //return immediately - no need to save the state;
        return;
    }


    [[XDGlobalSettingsManager sharedManager] writeIndividualMessageSetting:textSwitch.isOn WithID:self.userID key:kChatManagementCellVibrationNotiSwitchStateKey];
}

@end
