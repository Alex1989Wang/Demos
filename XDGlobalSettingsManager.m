//
//  XDGlobalSettingsManager.m
//  seeYouTime
//
//  Created by JiangWang on 7/21/16.
//  Copyright © 2016 形点网络. All rights reserved.
//

#import "XDGlobalSettingsManager.h"

@interface XDGlobalSettingsManager()

/* individual settings before switch off the global switches - will be recovered if global switches turn on */
@property (nonatomic, strong) NSMutableArray *previousSettings;

/* always be sychronized with the global settings */
@property (nonatomic, strong) NSMutableArray *presentSettings;

@end

@implementation XDGlobalSettingsManager

@synthesize globalSettingsKeys = _globalSettingsKeys;

#pragma mark - initialization
+ (void)initialize {
    if (self == [XDGlobalSettingsManager self]) {
        
        XDLog_Func
        
        XDLog(@"documents path: %@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));

        // do the class specific initialization -
        // even though it's not possible someone would inherit from this class;
        NSArray *globalKeys = [[XDGlobalSettingsManager sharedManager] globalSettingsKeys];
        
        for (NSUInteger index = 0; index < 6; index++) {
            //initialize the values
            id hasState = [[NSUserDefaults standardUserDefaults] objectForKey:globalKeys[index]];
            
            if (nil == hasState) {
                //hasn't been intialized
                BOOL initialValue = (index == 5) ? NO : YES;
                [[XDGlobalSettingsManager sharedManager] writeBooleanSetting:initialValue WithKey:globalKeys[index]];
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

- (BOOL)fetchBooleanSettingWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)writeBooleanSetting:(BOOL)value WithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)logSettings {
    NSArray *globalKeys = self.globalSettingsKeys;
    
    for (NSUInteger index = 0; index < 6; index ++) {
        NSLog(@"bool value: %d", [[XDGlobalSettingsManager sharedManager] fetchBooleanSettingWithKey:globalKeys[index]]);
    }
}

// individual settings
- (BOOL)fetchIndividualMessageSettingWithID:(NSString *)identifier key:(NSString *)key {
    NSDictionary *individualSettings = [[NSUserDefaults standardUserDefaults] objectForKey:identifier];
    
    if (individualSettings == nil) {
        individualSettings = [self generateIndividualSettings:identifier];
    }
    return [[individualSettings objectForKey:key] boolValue];
}

- (void)writeIndividualMessageSetting:(BOOL)setting WithID:(NSString *)identifier key:(NSString *)key {
    NSMutableDictionary *individualSettings = [[NSUserDefaults standardUserDefaults] objectForKey:identifier];
    
    if (individualSettings == nil) {
        individualSettings = [self generateIndividualSettings:identifier];
    }
    
    [individualSettings setObject:@(setting) forKey:key];
}

- (NSMutableDictionary *)generateIndividualSettings:(NSString *)identifier {
    NSMutableDictionary *individualSettings = [NSMutableDictionary dictionary];
    
    [individualSettings setObject:@([self fetchBooleanSettingWithKey:kGlobalSettingsNewMessageNotiSwitchStateKey]) forKey:kChatManagementCellNewMessageNotiSwitchStateKey];
    [individualSettings setObject:@([self fetchBooleanSettingWithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey]) forKey:kChatManagementCellSoundNotiSwitchStateKey];
    [individualSettings setObject:@([self fetchBooleanSettingWithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey]) forKey:kChatManagementCellVibrationNotiSwitchStateKey];
    
    return individualSettings;
}

- (void)saveIndividualSettings:(NSDictionary *)settings withID:(NSString *)identifier {
    NSDictionary *userSettings = @{
                                   identifier : settings
                                   };
    [self.presentSettings addObject:userSettings];
    [self.previousSettings addObject:userSettings];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.presentSettings forKey:kPresentSettings];
    [[NSUserDefaults standardUserDefaults] setObject:self.previousSettings forKey:kPreviousSettings];
}

- (void)removeIndividualSettingsWithID:(NSString *)identifier {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:identifier];
}


#pragma mark - global settings control individual settings;
- (void)synchronizePresentIndividualMessageSettings {
    /* global settings */
    BOOL globalMessage = [[XDGlobalSettingsManager sharedManager] fetchBooleanSettingWithKey:kGlobalSettingsNewMessageNotiSwitchStateKey];
    BOOL globalSound = [[XDGlobalSettingsManager sharedManager] fetchBooleanSettingWithKey:kGlobalSettingsNewMessageSoundNotiSwitchStateKey];
    BOOL globalVibration = [[XDGlobalSettingsManager sharedManager] fetchBooleanSettingWithKey:kGlobalSettingsNewMessageVibrationNotiSwitchStateKey];
    
    if (globalMessage == NO) {
        /* the global new message switch is off */
        NSArray *presentSettings = [[NSUserDefaults standardUserDefaults] objectForKey:kPresentSettings];
        for (NSMutableDictionary *individualSettings in presentSettings) {
            
        }
        
    }else {
        if (globalSound == NO) {
            
        }
        
        if (globalVibration == NO) {
            
        }
    }
}


@end
