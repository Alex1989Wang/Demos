//
//  GLSensitiveWordsFilter.h
//  GLive
//
//  Created by JiangWang on 26/07/2017.
//  Copyright © 2017 3g.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLSensitiveWordsFilter : NSObject

/**
 对于铭感词的过滤

 @return 共同的过滤着
 */
+ (GLSensitiveWordsFilter *)sharedFilter;

/**
 设置词库地址

 @param vocabPath 词库路径
 */
- (void)setFilterVocabularyPath:(NSString *)vocabPath;

/**
 是否打开filter

 @param filpOn filter是否打开
 */
- (void)filpFilter:(BOOL)filpOn;

/**
 过滤字符串

 @param words 需要过滤的字符串
 @return 已经过滤的字符串
 */
- (NSString *)filterWords:(NSString *)words;

@end
