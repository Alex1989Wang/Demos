//
//  GlobalSettingsViewController.m
//  settingsTest
//
//  Created by JiangWang on 7/22/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "GlobalSettingsViewController.h"

/*

NSString *const kChatManagementCellAddToBlacklistSwitchStateKey = @"kChatManagementCellAddToBlacklistSwitchStateKey";
NSString *const kChatManagementCellNewMessageNotiSwitchStateKey = @"kChatManagementCellNewMessageNotiSwitchStateKey";
NSString *const kChatManagementCellSoundNotiSwitchStateKey = @"kChatManagementCellSoundNotiSwitchStateKey";
NSString *const kChatManagementCellVibrationNotiSwitchStateKey = @"kChatManagementCellVibrationNotiSwitchStateKey";



NSString *const kGlobalSettingsNewMessageNotiSwitchStateKey = @"kGlobalSettingsNewMessageNotiSwitchStateKey";
NSString *const kGlobalSettingsNewMessageSoundNotiSwitchStateKey = @"kGlobalSettingsNewMessageSoundNotiSwitchStateKey";
NSString *const kGlobalSettingsNewMessageVibrationNotiSwitchStateKey = @"kGlobalSettingsNewMessageVibrationNotiSwitchStateKey";
 */


@interface GlobalSettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *theNewMessage;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vibSwitch;

@end

@implementation GlobalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Global Settings";
    
    [self initializeSwitchStates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initializeSwitchStates {
    self.theNewMessage.on = [[XDGlobalSettingsManager sharedManager] fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageNotiSwitchStateKey];
    self.soundSwitch.on = [[XDGlobalSettingsManager sharedManager] fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey];
    self.vibSwitch.on = [[XDGlobalSettingsManager sharedManager] fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey];
}

- (IBAction)newMessageSwitch:(UISwitch *)textSwitch {
    
    //update userdefaults
    [[XDGlobalSettingsManager sharedManager] writeGlobalBooleanSetting:textSwitch.isOn WithKey:kGlobalSettingsNewMessageNotiSwitchStateKey];
    [[XDGlobalSettingsManager sharedManager] writeGlobalBooleanSetting:textSwitch.isOn WithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey];
    [[XDGlobalSettingsManager sharedManager] writeGlobalBooleanSetting:textSwitch.isOn WithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey];
    
    //update UI
    [self.theNewMessage setOn:[[XDGlobalSettingsManager sharedManager] fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageNotiSwitchStateKey] animated:YES];
    [self.soundSwitch setOn:[[XDGlobalSettingsManager sharedManager] fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey] animated:YES];
    [self.vibSwitch setOn:[[XDGlobalSettingsManager sharedManager] fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey] animated:YES];

}

- (IBAction)switchSoundSwitch:(UISwitch *)textSwitch {
    //update userdefaults;
    [[XDGlobalSettingsManager sharedManager] writeGlobalBooleanSetting:textSwitch.isOn WithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey];
    
    //update UI
    self.soundSwitch.on = [[XDGlobalSettingsManager sharedManager] fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey];

    
}
- (IBAction)switchVibSwitch:(UISwitch *)textSwitch {
    [[XDGlobalSettingsManager sharedManager] writeGlobalBooleanSetting:textSwitch.isOn WithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey];
    
    //update UI
    self.vibSwitch.on = [[XDGlobalSettingsManager sharedManager] fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey];

}

@end
