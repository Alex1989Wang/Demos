//
//  JStickersController.m
//  JAppDuplicates
//
//  Created by JiangWang on 2018/12/11.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JStickersController.h"

@implementation JStickersController

+ (void)loadStickersCompleted:(void(^ _Nullable )(NSArray *_Nullable stickers, NSError *_Nullable error))completion {
    //冗余代码内部实现-其实什么都不做
    if (completion) {
        completion(nil, nil);
    }
}

@end
