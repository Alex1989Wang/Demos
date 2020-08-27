//
//  UIImage+ExchangeChannel.h
//  PgImageProEditUISDK
//
//  Created by 权欣权忆 on 2019/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ExchangeChannel)

- (NSData *)unpackedImageData;

- (NSData *)RGBA;

@end

NS_ASSUME_NONNULL_END
