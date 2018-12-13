//
//  JStickersController.h
//  JAppDuplicates
//
//  Created by JiangWang on 2018/12/11.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JStickersController : NSObject

/**
 用来使用shell注入的代码-内部什么都不做
 名字取的有意义一些就ok

 @param completion 完成时的回调
 */
+ (void)loadStickersCompleted:(void(^ _Nullable)(NSArray *_Nullable stickers, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
