//
//  UIImage+ExchangeChannel.m
//  PgImageProEditUISDK
//
//  Created by 权欣权忆 on 2019/1/25.
//

#import "UIImage+ExchangeChannel.h"

@implementation UIImage (ExchangeChannel)

- (NSData *)unpackedImageData
{
    CGDataProviderRef provider = CGImageGetDataProvider(self.CGImage);
    CFDataRef dataRef = CGDataProviderCopyData(provider);
    return (__bridge_transfer NSData *)dataRef;
}

- (NSData *)RGBA
{
    CGImageRef imageRef = [self CGImage];
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
//    NSUInteger bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
//    NSUInteger bytesPerPixel = CGImageGetBitsPerPixel(imageRef) / 8;
//    NSUInteger bytesPerRow = CGImageGetBytesPerRow(imageRef);

    // 使用下面的定值而不是使用上面真实的imageRef中的相关数值的原因是：
    // 整套SDK只支持处理RGBA四通道，单个通道8位的数据格式的图片。
    // 在iOS平台上，经测试，从iOS12开始，系统截屏输出的图片单个通道已经是16位
    // 因此这里除了将图像通道顺序统一为RBGA外，还兼顾了将可能的非8位图像数据重新绘制为8位图像数据
    NSUInteger bitsPerComponent = 8;
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;

    size_t dataLength = width * height * sizeof(unsigned char) * bytesPerPixel;
    unsigned char *rawData = (unsigned char *) malloc(dataLength);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);

    NSData *RGBAData = [[NSData alloc] initWithBytes:rawData length:dataLength];
    free(rawData);

    return RGBAData;
}

@end
