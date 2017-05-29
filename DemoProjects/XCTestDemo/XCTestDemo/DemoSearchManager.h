//
//  DemoSearchManager.h
//  XCTestDemo
//
//  Created by JiangWang on 29/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SearchResultBlock)(NSData *userInfoData);

@interface DemoSearchManager : NSObject

/**
 Initilize the shared manager;
 Demo search manager is used to send search request and return a dictionary containing a user's infomation or nil object.

 @return the shared instance.
 */
+ (DemoSearchManager *)sharedManager;

/**
 Send the search-user request with the user's name.

 @param userName The user's name to be searched.
 @param completion The completion block.
 */
- (void)getUserInfoWithUserName:(NSString *)userName
                      completed:(SearchResultBlock)completion;

@end
