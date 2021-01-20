//
//  ImageConvertor.m
//  P3ShowCase
//
//  Created by JiangWang on 2021/1/20.
//

#import "ImageConvertor.h"
#import "Defines.h"
#import "P3ShowCase-Swift.h"

@implementation ImageConvertor

+ (UIImage *)convertP3Image:(UIImage *)p3Image {
    if (nil == p3Image)
    {
        return NULL;
    }
    
    // Create a bitmap context to draw the uiimage into
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(p3Image.CGImage);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat width = p3Image.scale * p3Image.size.width;
    CGFloat height = p3Image.scale * p3Image.size.height;
    
    unsigned char *_rgba = malloc((size_t)width * (size_t)height * 4);

    CGContextRef _context = CGBitmapContextCreate(_rgba,
                                                  (size_t)width,
                                                  (size_t)height,
                                                  8,
                                                  4 * (size_t)width,
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big); // RGBA
    CGContextSetBlendMode(_context, kCGBlendModeNormal);
    
    assert( NULL != _context );
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (p3Image.imageOrientation)
    {
        case UIImageOrientationUp:
            break;
        case UIImageOrientationDown:          // 180 deg rotation
            transform = CGAffineTransformTranslate(transform, width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:          // 90 deg CCW
            transform = CGAffineTransformTranslate(transform, width, 0.0f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:         // 90 deg CW
            transform = CGAffineTransformTranslate(transform, 0.0f, height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUpMirrored:    // as above but image mirrored along other axis. horizontal flip
            transform = CGAffineTransformTranslate(transform, width, 0.0f);
            transform = CGAffineTransformScale(transform, -1.f, 1.f);
            break;
        case UIImageOrientationDownMirrored:  // horizontal flip
            transform = CGAffineTransformTranslate(transform, width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            transform = CGAffineTransformTranslate(transform, width, 0.0f);
            transform = CGAffineTransformScale(transform, -1.f, 1.f);
            break;
        case UIImageOrientationLeftMirrored:  // vertical flip
            transform = CGAffineTransformTranslate(transform, width, 0.0f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            transform = CGAffineTransformTranslate(transform, 0.0f, height);
            transform = CGAffineTransformScale(transform, 1.f, -1.f);
            break;
        case UIImageOrientationRightMirrored: // vertical flip
            transform = CGAffineTransformTranslate(transform, width, 0.0f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            transform = CGAffineTransformTranslate(transform, 0.0f, height);
            transform = CGAffineTransformScale(transform, 1.f, -1.f);
            break;
        default:
            break;
    }
    
    CGContextConcatCTM(_context, transform);
    
    CGRect _rect = CGRectMake(0, 0, width, height);
    
    switch (p3Image.imageOrientation)
    {
        case UIImageOrientationLeft:          // 90 deg CCW
        case UIImageOrientationRight:         // 90 deg CW
        case UIImageOrientationLeftMirrored:  // vertical flip
        case UIImageOrientationRightMirrored: // vertical flip
        {
            _rect = CGRectMake(0, 0, height, width);
        }
            break;
        default:
            break;
    }
    
    CGImageRef _imageRef = p3Image.CGImage;
    CGContextDrawImage(_context, _rect, _imageRef);
    

    // premultiplied => non-premultiplied
    size_t _count = (size_t)width * (size_t)height;
    unsigned char* _p = _rgba;
    
    for (size_t i = 0;  i < _count; ++ i)
    {
        if (0 == *(_p + 3) || 1 == *(_p + 3))
        {
            _p += 4;
        }
        else
        {
//            float _a = 1.0 / U82F(*(_p + 3));
            // R
            float r = U82F(*_p);
//            *_p = F2U8(U82F(*_p) * _a);
//            ++_p;
            // G
            float g = U82F(*(_p + 1));
//            *_p = F2U8(U82F(*_p) * _a);
//            ++_p;
            // B
            float b = U82F(*(_p + 2));
//            *_p = F2U8(U82F(*_p) * _a);
//            ++_p;
            // Skip Alpha
//            ++_p;
            
//            simd_float3 xyz = simd_make_float3(r, g, b);
//            simd_float4 rgbw = [PixelConverter toSRGB:xyz];
//            *_p = F2U8(rgbw.x);
//            *(_p + 1) = F2U8(rgbw.y);
//            *(_p + 2) = F2U8(rgbw.z);
//            _p += 4;
        }
    }
    
    CGImageRef ret = CGBitmapContextCreateImage(_context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(_context);
    free(_rgba);
    
    UIImage *img = [[UIImage alloc] initWithCGImage:ret];

    return img;

}
@end
