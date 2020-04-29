//
//  main.m
//  ObjcTests
//
//  Created by JiangWang on 2019/12/18.
//  Copyright © 2019 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTDummy.h"
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        OTDummy *dummy = [[OTDummy alloc] init];
        dummy.name = @"Dummy0";
        Class dummyCls = object_getClass(dummy);
        
        OTDummy *dummy1 = [[OTDummy alloc] init];
        dummy1.name = @"Dummy1";
        Class dummyCls1 = object_getClass(dummy1);
        
        NSLog(@"class the same: %@", (dummyCls == dummyCls1) ? @"yes" : @"no");
        
        BOOL isClass = object_isClass(dummy1);
        if (!isClass) {
            NSLog(@"objc is not a class.");
        }
        
        /// iVars
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList(object_getClass(dummy1), &count);
        for (int index = 0; index < count; index++) {
            Ivar ivar = ivarList[index];
            NSLog(@"ivar %s type: %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
        }
       
        /// Properties
        objc_property_t *pptList = class_copyPropertyList(object_getClass(dummy1), &count);
        for (int index = 0; index < count; index++) {
            objc_property_t ppt = pptList[index];
            NSLog(@"property %s ", property_getName(ppt));
        }
    }
    return 0;
}
