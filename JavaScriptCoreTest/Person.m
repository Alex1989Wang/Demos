//
//  Person.m
//  JavaScriptCoreTest
//
//  Created by JiangWang on 20/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)getFullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

+ (instancetype)createWithFirstName:(NSString *)firstName
                           lastName:(NSString *)lastName
{
    Person *person = [[Person alloc] init];
    person.firstName = firstName;
    person.lastName = lastName;
    return person;
}

@end
