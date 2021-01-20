//
//  ImageConvertor.h
//  P3ShowCase
//
//  Created by JiangWang on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageConvertor : NSObject

+ (UIImage *)convertP3Image:(UIImage *)p3Image;

@end

NS_ASSUME_NONNULL_END
