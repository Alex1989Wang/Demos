//
//  DemoDataManager.h
//  CoreDataDemo
//
//  Created by JiangWang on 10/07/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DemoDataManager : NSObject

/**
 构造单例管理者

 @return 单例管理者
 */
+ (instancetype)sharedManager;

/**
 测试数据插入
 */
- (void)testEmployeeInsertion;

/**
 测试数据查询
 */
- (void)testEmployeeRequest;

@end
