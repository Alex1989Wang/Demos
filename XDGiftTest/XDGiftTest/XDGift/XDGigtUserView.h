//
//  XDTopView.h
//  testGift
//
//  Created by 形点网络 on 16/6/30.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDGigtUserView : UIView

#warning - 定义一个嘉宾主持人模型，模型中有这些属性，重新set方法进行赋值

// 主持人？男女嘉宾？
@property (nonatomic, strong) NSString *markName;

// 昵称
@property (nonatomic, strong) NSString *name;

// 头像
@property (nonatomic, strong) NSString *iconUrl;

// 是否选中
@property (nonatomic, assign, getter=isBig) BOOL big;  // big 表示小
@end
