//
//  UIViewController+JWAlertPresentation.m
//  
//
//  Created by JiangWang on 22/07/2017.
//  Copyright © 2017 com.jiangwang All rights reserved.
//

#import "UIViewController+JWAlertPresentation.h"
#import "JWAlertViewController+JWPrivate.h"
#import "JWAppDelegate.h"
#import <objc/runtime.h>

static NSString *const kAlertControllersArray = @"kAlertControllersArray";
static NSString *const kAlertControllerKey = @"kAlertControllerKey";
static NSString *const kAlertAnimationKey = @"kAlertAnimationKey";

static UIWindow *alertRootWindow = nil;

@implementation UIViewController (JWAlertPresentation)

- (void)presentAlertController:(JWAlertViewController *)alertController
                      animated:(BOOL)animated {
    if (!alertController) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect windowBounds = [UIScreen mainScreen].bounds;
        alertRootWindow = [[UIWindow alloc] initWithFrame:windowBounds];
        alertRootWindow.windowLevel = UIWindowLevelNormal;
    });
    
    //缓存第一个弹窗为传入弹窗
    if ([self unpackFirstAlertController] == alertController) {
        if (!alertRootWindow.superview) {
            JWAppDelegate *appDelegate = (JWAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.window addSubview:alertRootWindow];
        }
        alertRootWindow.rootViewController = alertController;
        alertRootWindow.hidden = NO;
        [alertController displayAlertViewAnimated:animated completed:nil];
        return;
    }
    
    //是否已经有弹窗
    NSMutableArray *alertControllers =
    objc_getAssociatedObject(alertRootWindow, &kAlertControllersArray);
    if (alertControllers.count) {
        //只缓存
        NSDictionary *alertInfo = [self infoDictionaryWithController:alertController
                                               willAnimateAppearance:animated];
        if (alertInfo) {
            [alertControllers addObject:alertInfo];
        }
        return;
    }
    
    //没有弹窗
    JWAppDelegate *appDelegate = (JWAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:alertRootWindow];
    alertRootWindow.rootViewController = alertController;
    alertRootWindow.hidden = NO;
    [alertController displayAlertViewAnimated:animated completed:nil];
    
    NSDictionary *alertInfo = [self infoDictionaryWithController:alertController
                                           willAnimateAppearance:YES];
    NSAssert(alertInfo, @"alert info should exist");
    NSMutableArray *alertArray = [NSMutableArray arrayWithObject:alertInfo];
    objc_setAssociatedObject(alertRootWindow, &kAlertControllersArray, alertArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dismissAlertController:(JWAlertViewController *)alertController
                      animated:(BOOL)animated {
    if (!alertController) {
        return;
    }
    
    NSMutableArray *alertControllers =
    objc_getAssociatedObject(alertRootWindow, &kAlertControllersArray);
    __block NSDictionary *foundAlertInfo = nil;
    [alertControllers enumerateObjectsUsingBlock:
     ^(NSDictionary *alertInfo, NSUInteger idx, BOOL * _Nonnull stop) {
         if (alertInfo[kAlertControllerKey] == alertController) {
             foundAlertInfo = alertInfo;
             *stop = YES;
         }
    }];
    
    //去掉找到这个
    [alertControllers removeObject:foundAlertInfo];
    if (foundAlertInfo) {
        __weak typeof(self) weakSelf = self;
        JWAlertViewController *alertCon = foundAlertInfo[kAlertControllerKey];
        [alertCon dismissAlertViewAnimated:animated
                         completed:
         ^(BOOL completed) {
             alertRootWindow.rootViewController = nil;
             [alertCon willMoveToParentViewController:nil];
             [alertCon removeFromParentViewController];
             [alertCon didMoveToParentViewController:nil];
             [alertCon.view removeFromSuperview];
             [alertRootWindow removeFromSuperview];
             alertRootWindow.hidden = YES;
             
             __strong typeof(weakSelf) strSelf = weakSelf;
             [strSelf presentNextAlertController];
         }];
    }
    else {
        alertRootWindow.rootViewController = nil;
        [alertRootWindow removeFromSuperview];
        alertRootWindow.hidden = YES;
        
        [self presentNextAlertController];
    }
}

- (NSDictionary *)infoDictionaryWithController:(JWAlertViewController *)controller
                         willAnimateAppearance:(BOOL)willAnimate {
    if (!controller) {
        return nil;
    }
    return @{kAlertControllerKey : controller,
             kAlertAnimationKey : @(willAnimate),};
}

//目前正在显示的alertController
- (JWAlertViewController *)unpackFirstAlertController {
    NSMutableArray *alertControllers = objc_getAssociatedObject(alertRootWindow, &kAlertControllersArray);
    if (!alertControllers.count) {
        return nil;
    }
    
    NSDictionary *infoDict = [alertControllers firstObject];
    return infoDict[kAlertControllerKey];
}

- (void)presentNextAlertController {
    NSMutableArray *alertControllers =
    objc_getAssociatedObject(alertRootWindow, &kAlertControllersArray);
    if (alertControllers.count) {
        NSDictionary *firstAlertInfo = [alertControllers firstObject];
        JWAlertViewController *alertCon = firstAlertInfo[kAlertControllerKey];
        BOOL willAnimate = firstAlertInfo[kAlertAnimationKey];
        [self presentAlertController:alertCon animated:willAnimate];
    }
}

@end
