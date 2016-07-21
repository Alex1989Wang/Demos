//
//  GlobalSettings.h
//  LoadAndInitialize
//
//  Created by JiangWang on 7/21/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalSettings : NSObject

+ (BOOL)fetchGlobalSettingWithKey:(NSString *)key;

@end
