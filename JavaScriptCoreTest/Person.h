//
//  Person.h
//  JavaScriptCoreTest
//
//  Created by JiangWang on 20/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol PersonJSExport <JSExport>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSInteger ageToday;

- (NSString *)getFullName;
+ (instancetype)createWithFirstName:(NSString *)firstName
                           lastName:(NSString *)lastName;

@end

@interface Person : NSObject <PersonJSExport>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSInteger ageToday;

@end
