//
//  XDGlobalSettingsManager.h
//  seeYouTime
//
//  Created by JiangWang on 7/21/16.
//  Copyright © 2016 形点网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDGlobalSettingsManager : NSObject

@property (nonatomic, readonly, strong) NSArray *globalSettingsKeys;

/**
 *  instantiate a singleton to manager the global settings;
 *
 *  @return a shared manager to manage global settings;
 */

+ (instancetype)sharedManager;

/* global settings manipulation */
- (void)logSettings;
- (BOOL)fetchGlobalBooleanSettingWithKey:(NSString *)key;
- (void)writeGlobalBooleanSetting:(BOOL)value WithKey:(NSString *)key;

/* individual settings manipulation */
/**
 *  this fetches the individual setting from user defaults;
 *
 *  @param identifier individual id
 *  @param key        which switch's state you want to retrive;
 *
 *  @return the setting boolean value;
 */
- (BOOL)fetchIndividualMessageSettingWithID:(NSString *)identifier key:(NSString *)key;

/**
 *  tells whether a user can switch on a personal message setting and write new
 *
 *  @param identifier individual id
 *  @param key        which switch's state you want to switch on;
 *
 *  @return does global settings permits this particular change;
 */
- (BOOL)canTurnOnIndividualSettingWithID:(NSString *)identifier key:(NSString *)key;

/**
 *  changes the individual setting
 *
 *  @param setting    new setting value
 *  @param identifier individual id
 *  @param key        which switch's state you want to change;
 */
- (void)writeIndividualMessageSetting:(BOOL)setting WithID:(NSString *)identifier key:(NSString *)key;

/**
 *  deletes a individual's preserved settings data
 *
 *  @param identifier individual id
 */
- (void)removeIndividualSettingsWithID:(NSString *)identifier;



@end
