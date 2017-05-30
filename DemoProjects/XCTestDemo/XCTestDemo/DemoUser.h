//
//  DemoUser.h
//  XCTestDemo
//
//  Created by JiangWang on 29/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 
 {
 "login": "h",
 "id": 3854874,
 "avatar_url": "https://avatars3.githubusercontent.com/u/3854874?v=3",
 "gravatar_id": "",
 "url": "https://api.github.com/users/h",
 "html_url": "https://github.com/h",
 "followers_url": "https://api.github.com/users/h/followers",
 "following_url": "https://api.github.com/users/h/following{/other_user}",
 "gists_url": "https://api.github.com/users/h/gists{/gist_id}",
 "starred_url": "https://api.github.com/users/h/starred{/owner}{/repo}",
 "subscriptions_url": "https://api.github.com/users/h/subscriptions",
 "organizations_url": "https://api.github.com/users/h/orgs",
 "repos_url": "https://api.github.com/users/h/repos",
 "events_url": "https://api.github.com/users/h/events{/privacy}",
 "received_events_url": "https://api.github.com/users/h/received_events",
 "type": "User",
 "site_admin": false,
 "name": "Samuel Hoffstaetter",
 "company": "Software Engineer at Google",
 "blog": "linkedin.com/in/hoffstaetter",
 "location": "New York",
 "email": null,
 "hireable": null,
 "bio": null,
 "public_repos": 4,
 "public_gists": 2,
 "followers": 10,
 "following": 6,
 "created_at": "2013-03-13T14:47:30Z",
 "updated_at": "2017-05-20T05:46:34Z"
 }
 */

@interface DemoUser : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSUInteger userID;
@property (nonatomic, copy) NSString *userAvatarURL;
@property (nonatomic, copy) NSString *userLocation;


/**
 Create a user instance with the user info data obtained from search.

 @param userInfoData The raw user info data;
 @return user
 */
- (instancetype)initWithUserInfoData:(NSData *)userInfoData NS_DESIGNATED_INITIALIZER;
@end
