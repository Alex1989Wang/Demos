//
//  PCMainVC.h
//  SelfieCamera
//
//  Created by Cc on 2016/10/25.
//  Copyright © 2016年 Pinguo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PCMainVC : UIViewController

+ (void)pEnterHomePage;

+ (void)sGotoCameraOnMainVCWithParam:(NSDictionary *)param withCompletion:(void(^)(NSError *error))completion;

@end

