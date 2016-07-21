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


- (void)logSettings;

- (BOOL)fetchBooleanSettingWithKey:(NSString *)key;

- (void)writeBooleanSetting:(BOOL)value WithKey:(NSString *)key;

/* individual new message settings */
- (BOOL)fetchIndividualMessageSettingWithID:(NSString *)identifier key:(NSString *)key;
- (void)writeIndividualMessageSetting:(BOOL)setting WithID:(NSString *)identifier key:(NSString *)key;



@end
