#if !__has_feature(objc_arc)
#  error Please compile this class with ARC (-fobjc-arc).
#endif

#import "UIImage+SK_NinePatch.h"

@implementation UIImage(SK_NinePatch)

static BOOL SKBitmapIsBlackAtOffset(UInt8 const *data, size_t offset) {
    return (data[offset] == 0x00 && data[offset+1] == 0x00 && data[offset+2] == 0x00 && data[offset+3] == 0xFF);
}

/**
 Workhorse method that will find the upper frame for the given image.
 */
CGRect SKUpperFrame(UIImage *image) {
    CGRect frame = CGRectZero;
    
    CGImageRef cgImage = [image CGImage];
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    if (width < 1 || height < 1) {
        return frame;
    }
    
    CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    CFDataRef bitmap = CGDataProviderCopyData(provider);
    UInt8 const *data = CFDataGetBytePtr(bitmap);
    
    // Find a black pixel, any will do.
    size_t w = width;
    size_t x = 0;
    size_t z = x;
    size_t offset = 0;
    
    size_t l = 0;
    size_t r = MAX(l, width-1);
    
    BOOL isBlack = NO;
    while (w > 0) {
        x = w >> 1;
        z = x;
        l = 0;
        while (z < width) {
            offset = z << 2;
            isBlack = SKBitmapIsBlackAtOffset(data, offset);
            if (isBlack) {
                break;
            }
            l = z;
            z += w;
        }
        if (isBlack) {
            break;
        } else {
            w >>= 1;
        }
    }
    
    if (isBlack) {
        // Isolate a leftmost black pixel. If we find a black pixel with no adjacent black pixel to its left we assume
        // we are done and stop.
        size_t m = z;
        while (1) {
            m = l + ((z-l)>>1);
            offset = m << 2;
            isBlack = SKBitmapIsBlackAtOffset(data, offset);
            if (isBlack) {
                z = m;
            } else if (l == m) {
                break;
            } else {
                l = m;
            }
        }
        
        // Start setting the frame, declaring the leftmost pixel.
        frame = CGRectMake(z, 0.0f, 1.0f, 1.0f);
        
        // Isolate a rightmost black pixel. If we find a black pixel with no adjacent black pixel to its right we assume
        // we are done and stop.
        while (1) {
            m = z + ((r-z)>>1);
            offset = m << 2;
            isBlack = SKBitmapIsBlackAtOffset(data, offset);
            if (isBlack) {
                if (z == m) {
                    break;
                }
                z = m;
            } else {
                r = m;
            }
        }
        
        // Assume that each of the intervening pixels is black.
        frame.size.width = z - CGRectGetMinX(frame) + 1.0f;
    }
        
    CFRelease(bitmap);
    return frame;
}

- (CGRect)skUpperFrame {
    return SKUpperFrame(self);
}

- (CGRect)skLeftFrame {
    CGRect frame = CGRectZero;
    
    CGSize size = CGSizeMake([self size].height, [self size].width);
    UIGraphicsBeginImageContextWithOptions(size, NO, [self scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(context, -M_PI_2);
    CGContextScaleCTM(context, -1.0f, 1.0f);
    
    [self drawAtPoint:CGPointZero];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGRect transformedFrame = SKUpperFrame(image);
    frame = CGRectMake(CGRectGetMinY(transformedFrame),
                       CGRectGetMinX(transformedFrame),
                       CGRectGetHeight(transformedFrame),
                       CGRectGetWidth(transformedFrame));
        
    UIGraphicsEndImageContext();
    
    return frame;
}

- (CGRect)skLowerFrame {
    CGRect frame = CGRectZero;

    UIGraphicsBeginImageContextWithOptions([self size], NO, [self scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0f, [self size].height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    [self drawAtPoint:CGPointZero];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGRect rotatedFrame = SKUpperFrame(image);
    frame = CGRectMake(CGRectGetMinX(rotatedFrame),
                       CGImageGetHeight([self CGImage])-CGRectGetHeight(rotatedFrame),
                       CGRectGetWidth(rotatedFrame),
                       CGRectGetHeight(rotatedFrame));
    
    UIGraphicsEndImageContext();
    
    return frame;
}

- (CGRect)skRightFrame {
    CGRect frame = CGRectZero;
    
    CGSize size = CGSizeMake([self size].height, [self size].width);
    UIGraphicsBeginImageContextWithOptions(size, NO, [self scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0f, size.height);
    CGContextRotateCTM(context, -M_PI_2);
    
    [self drawAtPoint:CGPointZero];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGRect rotatedFrame = SKUpperFrame(image);
    frame = CGRectMake(CGImageGetWidth([self CGImage])-CGRectGetHeight(rotatedFrame),
                       CGRectGetMinX(rotatedFrame),
                       CGRectGetHeight(rotatedFrame),
                       CGRectGetWidth(rotatedFrame));
    
    UIGraphicsEndImageContext();
    
    return frame;
}

@end
