//
//  XDGlobalSettingsManager.m
//  seeYouTime
//
//  Created by JiangWang on 7/21/16.
//  Copyright © 2016 形点网络. All rights reserved.
//

#import "XDGlobalSettingsManager.h"

@interface XDGlobalSettingsManager()

/* use to temporarily store present settings */
@property (nonatomic, strong) NSMutableDictionary *presentSettings;

/* individual new message settings category */
@property (nonatomic, strong) NSDictionary *messageSettingsStates;
@property (nonatomic, strong) NSDictionary *soundSettingsStates;
@property (nonatomic, strong) NSDictionary *vibrationSettingsStates;


@end

@implementation XDGlobalSettingsManager

@synthesize globalSettingsKeys = _globalSettingsKeys;

#pragma mark - initialization
+ (void)initialize {
    if (self == [XDGlobalSettingsManager self]) {
        // do the class specific initialization - global settings
        // even though it's not possible someone would inherit from this class;
        
        NSLog(@"documents path: %@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));

        NSArray *globalKeys = [[XDGlobalSettingsManager sharedManager] globalSettingsKeys];
        for (NSUInteger index = 0; index < 6; index++) {
            //initialize the values
            id hasState = [[NSUserDefaults standardUserDefaults] objectForKey:globalKeys[index]];
            
            if (nil == hasState) {
                //hasn't been intialized
                BOOL initialValue = (index == 5) ? NO : YES;
                [[XDGlobalSettingsManager sharedManager] writeGlobalBooleanSetting:initialValue WithKey:globalKeys[index]];
            }            
        }
    }
}

#pragma mark - global settings keys;
- (NSArray *)globalSettingsKeys {
    if (_globalSettingsKeys == nil) {
        _globalSettingsKeys = @[
                                /* section zero */
                                kGlobalSettingsNewMessageNotiSwitchStateKey,            //section zero row zero
                                kGlobalSettingsNewMessageSoundNotiSwitchStateKey,       //section zero row one
                                kGlobalSettingsNewMessageVibrationNotiSwitchStateKey,   //section zero row two
                                
                                /* section one */
                                kGlobalSettingsReceiveLiveShowNotiSwitchStateKey,           //section one row zero
                                kGlobalSettingsReceiveLiveShowSoundNotiSwitchStateKey,      //section one row one
                                kGlobalSettingsReceiveLiveShowVibrationNotiSwitchStateKey   //section one row two
                                ];
    }
    return _globalSettingsKeys;
}

#pragma mark - shared manager singleton

+ (instancetype)sharedManager {
    static XDGlobalSettingsManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[XDGlobalSettingsManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - instance methods

- (BOOL)fetchGlobalBooleanSettingWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)writeGlobalBooleanSetting:(BOOL)value WithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)logSettings {
    NSArray *globalKeys = self.globalSettingsKeys;
    
    for (NSUInteger index = 0; index < 6; index ++) {
        NSLog(@"bool value: %d", [[XDGlobalSettingsManager sharedManager] fetchGlobalBooleanSettingWithKey:globalKeys[index]]);
    }
}


#pragma mark - individual settings 

- (BOOL)canTurnOnIndividualSettingWithID:(NSString *)identifier key:(NSString *)key {
    
    //global setting states -
    //does really need local message switch state here;
    //local sound or vibration switches will be invisible if local message switch is off;
    //so, the user can never even touch the local switch;
    
    BOOL globalMessage = [self fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageNotiSwitchStateKey];
    BOOL globalSound = [self fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey];
    BOOL globalVibration = [self fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey];
    
    if (globalMessage == NO) {
        return NO;
    }else {
        if (key == kChatManagementCellSoundNotiSwitchStateKey) {
            return globalSound;
        }
        
        if (key == kChatManagementCellVibrationNotiSwitchStateKey) {
            return globalVibration;
        }
        
        //has listed all the values, because we only have three keys; return NO to eliminate complier error
        return NO;
    }
}

- (void)writeIndividualMessageSetting:(BOOL)setting WithID:(NSString *)identifier key:(NSString *)key {
    
    //write directy to the user defaults;
    //get this individual's settings
    NSMutableDictionary *individualSetting = [[[NSUserDefaults standardUserDefaults] objectForKey:identifier] mutableCopy];
    
    //does it exist?
    if (nil == individualSetting) {
        individualSetting = [self generateIndividualSettingsAndArchive:identifier];
    }
    
    //change the corresponding value
    [individualSetting setObject:@(setting) forKey:key];
    
    //reset the old individual setting
    [[NSUserDefaults standardUserDefaults] setObject:[individualSetting copy] forKey:identifier];
}

- (BOOL)fetchIndividualMessageSettingWithID:(NSString *)identifier key:(NSString *)key {
    
    //fetch directly from the user defaults;
    NSDictionary *hasIndividualSettings = [[NSUserDefaults standardUserDefaults] objectForKey:identifier];
    if (hasIndividualSettings == nil) {
        hasIndividualSettings = [self generateIndividualSettingsAndArchive:identifier];
    }
    
    //what value should be returned????? - extremely important: global settings have control over individual ones;
    BOOL globalMessage = [self fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageNotiSwitchStateKey];
    BOOL globalSound = [self fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey];
    BOOL globalVibration = [self fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey];
    
    //local message switch - this controls all the local switches;
    BOOL localMessage = [[hasIndividualSettings objectForKey:kChatManagementCellNewMessageNotiSwitchStateKey] boolValue];
    
    if (globalMessage == NO || localMessage == NO) {              //regardless of what key is in use
        return NO;
    }else {
        if (key == kChatManagementCellNewMessageNotiSwitchStateKey) {
            return [[hasIndividualSettings objectForKey:kChatManagementCellNewMessageNotiSwitchStateKey] boolValue];
        }
        
        if (key == kChatManagementCellSoundNotiSwitchStateKey) {
            return globalSound ? [[hasIndividualSettings objectForKey:kChatManagementCellSoundNotiSwitchStateKey] boolValue] : globalSound;
        }
        
        if (key == kChatManagementCellVibrationNotiSwitchStateKey) {
            return globalVibration ? [[hasIndividualSettings objectForKey:kChatManagementCellVibrationNotiSwitchStateKey] boolValue] : globalVibration;
        }
        
        //has listed all the values, because we only have three keys; return NO to eliminate complier error
        return NO;
    }
}

- (void)removeIndividualSettingsWithID:(NSString *)identifier {
    
    //remove directly from the user defualts
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:identifier];
    
}

- (NSMutableDictionary *)generateIndividualSettingsAndArchive:(NSString *)identifier {
    NSMutableDictionary *individualSettings = [NSMutableDictionary dictionary];
    
    [individualSettings setObject:@([self fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageNotiSwitchStateKey]) forKey:kChatManagementCellNewMessageNotiSwitchStateKey];
    [individualSettings setObject:@([self fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey]) forKey:kChatManagementCellSoundNotiSwitchStateKey];
    [individualSettings setObject:@([self fetchGlobalBooleanSettingWithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey]) forKey:kChatManagementCellVibrationNotiSwitchStateKey];
    
    //archiving settings
    [[NSUserDefaults standardUserDefaults] setObject:individualSettings forKey:identifier];
    
    //return the generated settings;
    return individualSettings;
}


@end
