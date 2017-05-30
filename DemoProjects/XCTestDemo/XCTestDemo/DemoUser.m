//
//  DemoUser.m
//  XCTestDemo
//
//  Created by JiangWang on 29/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoUser.h"

@implementation DemoUser

#pragma mark - Public Methods
- (instancetype)initWithUserInfoData:(NSData *)userInfoData {
    NSDictionary *userInfoDict =
    [self userInfoDictWithUserInfoData:userInfoData];
    if (!userInfoDict) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _userName = [userInfoDict valueForKey:@"login"];
        id userID = [userInfoDict valueForKey:@"id"];
        if ([userID respondsToSelector:
             @selector(unsignedIntegerValue)]) {
            _userID = [userID unsignedIntegerValue];
        }
        _userAvatarURL = [userInfoDict valueForKey:@"avatar_url"];
        _userLocation = [userInfoDict valueForKey:@"location"];
    }
    return self;
}

#pragma mark - Private
- (instancetype)init {
    return [self initWithUserInfoData:nil];
}

- (NSDictionary *)userInfoDictWithUserInfoData:(NSData *)userInfoData {
    if (!userInfoData) {
        return nil;
    }
    
    NSDictionary *returnedDict = nil;
    returnedDict = [NSJSONSerialization JSONObjectWithData:userInfoData
                                                   options:NSJSONReadingAllowFragments
                                                     error:NULL];
    return returnedDict;
}
@end
