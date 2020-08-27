//
//  main.m
//  CGContextDrawImageEXC_BAD_ACCESS
//
//  Created by JiangWang on 2020/5/21.
//  Copyright © 2020 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
