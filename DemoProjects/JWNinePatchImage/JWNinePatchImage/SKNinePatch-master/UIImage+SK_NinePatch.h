#import <UIKit/UIKit.h>

@interface UIImage(SK_NinePatch)

/**
 Assumes there is only one respective black frame in the defining image file. Returns a frame representing an interval
 of black pixels, which can be taken as correct if our assumption is correct. Returns SKFrameZero if no black pixels are
 found. For improved initial seek performance, allow the respective black regions to be relatively long; that is, make
 them easy to find.
 */
- (CGRect)skUpperFrame;
- (CGRect)skLeftFrame;
- (CGRect)skLowerFrame;
- (CGRect)skRightFrame;

@end
