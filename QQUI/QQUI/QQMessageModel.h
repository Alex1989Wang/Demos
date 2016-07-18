//
//  QQMessageModel.h
//  QQUI
//
//  Created by JiangWang on 16/4/29.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QQUserType) {
    QQUserTypeOther,
    QQUserTypeMe,
};

@interface QQMessageModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) QQUserType type;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)qqMessageModelWithDict: (NSDictionary *)dict;


@end
