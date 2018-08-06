//
//  SCWebAdLoadView.m
//  SelfieCamera
//
//  Created by zyf on 17/3/22.
//  Copyright © 2017年 Pinguo. All rights reserved.
//

#import "UIImage+Blur.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage(Blur)

+ (UIImage *)pgs_BlurImage:(UIImage *)sourceImage blurLevel:(CGFloat)blurLevel shouldRevertRgb:(BOOL)revert
{
    if (!sourceImage) {
        return nil;
    }
    
    int boxSize = (int)(blurLevel * 85.f);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    UIImage *bluredImage = nil;
    CGImageRef cgImage = sourceImage.CGImage;
    vImage_Buffer inputBuffer, outputBuffer;
    vImage_Error error;
    void *pixelBuffer;

    CGDataProviderRef inputProvider = CGImageGetDataProvider(cgImage);
    CFDataRef inputBitmapData = CGDataProviderCopyData(inputProvider);
    
    inputBuffer.width = CGImageGetWidth(cgImage);
    inputBuffer.height = CGImageGetHeight(cgImage);
    inputBuffer.rowBytes = CGImageGetBytesPerRow(cgImage);
    inputBuffer.data = (void *)CFDataGetBytePtr(inputBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(cgImage) * CGImageGetHeight(cgImage));
    if (pixelBuffer != NULL)
    {
        //是否反转像素
        vImage_Buffer revertBuffer;
        void *revertPixelData = NULL;
        if (revert) {
            revertPixelData = malloc(CGImageGetBytesPerRow(cgImage) * CGImageGetHeight(cgImage));
            revertBuffer.data = revertPixelData;
            revertBuffer.width = CGImageGetWidth(cgImage);
            revertBuffer.height = CGImageGetHeight(cgImage);
            revertBuffer.rowBytes = CGImageGetBytesPerRow(cgImage);
            const uint8_t map[4] = {2, 1, 0, 3}; //rgba -> bgra
            vImagePermuteChannels_ARGB8888(&inputBuffer, &revertBuffer, map, kvImageNoFlags);
        }

        outputBuffer.data = pixelBuffer;
        outputBuffer.width = CGImageGetWidth(cgImage);
        outputBuffer.height = CGImageGetHeight(cgImage);
        outputBuffer.rowBytes = CGImageGetBytesPerRow(cgImage);
        
        vImage_Buffer bufferToUse = (revert && (revertBuffer.data != NULL)) ? revertBuffer : inputBuffer;
        error = vImageBoxConvolve_ARGB8888(&bufferToUse,
                                           &outputBuffer,
                                           NULL,
                                           0,
                                           0,
                                           boxSize,
                                           boxSize,
                                           NULL,
                                           kvImageEdgeExtend);
        if (error == kvImageNoError)
        {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef context = CGBitmapContextCreate(outputBuffer.data,
                                                         outputBuffer.width,
                                                         outputBuffer.height,
                                                         8,
                                                         outputBuffer.rowBytes,
                                                         colorSpace,
                                                         kCGImageAlphaPremultipliedLast);
            CGImageRef bluredImageRef = CGBitmapContextCreateImage(context);
            bluredImage = [UIImage imageWithCGImage:bluredImageRef];
            
            //free图片生成
            CGColorSpaceRelease(colorSpace);
            CGContextRelease(context);
            CGImageRelease(bluredImageRef);
        }
        
        //free其他buffer
        if (revertPixelData != NULL) {
            free(revertPixelData);
        }
    }
    
    //free pixelBuffer
    if (pixelBuffer != NULL) {
        free(pixelBuffer);
    }
    CFRelease(inputBitmapData);
    return bluredImage;
}

@end
