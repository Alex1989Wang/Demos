//
//  GlobalSettings.m
//  LoadAndInitialize
//
//  Created by JiangWang on 7/21/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "GlobalSettings.h"
#import "Constants.h"

@implementation GlobalSettings


+ (void)initialize {
    if (self == [GlobalSettings self]) {
        //do the initialization here
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:globalSettingTest];
        
    }
}

+ (BOOL)fetchGlobalSettingWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

@end
