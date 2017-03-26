//
//  ViewController.h
//  KeyValueObserving
//
//  Created by JiangWang on 16/7/26.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XDUserIndentityType) {
    XDUserIndentityTypeAnonymous        = 1 << 0,           //匿名用户  anonymous user
    XDUserIndentityTypeNormalUser       = 1 << 1,           //普通观众  normal audience
    XDUserIndentityTypeLiveMaleGuest    = 1 << 2,           //正在直播的男嘉宾    live male guest
    XDUserIndentityTypeLiveFemaleGuest  = 1 << 3,           //正在直播的女嘉宾    live female guest
    XDUserIndentityTypeOwner            = 1 << 4,           //房主     the room owner
    XDUserIndentityTypePresenter        = 1 << 5,           //主持人   the presenter
};

@interface ViewController : UIViewController


@end

