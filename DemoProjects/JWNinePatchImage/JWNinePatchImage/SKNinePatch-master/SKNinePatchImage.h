#import <UIKit/UIKit.h>
#import "UIImage+SK_NinePatch.h"

/**
 For Android reference on 9-patch images, see
 http://developer.android.com/guide/topics/graphics/2d-graphics.html#nine-patch
 */

@interface SKNinePatchImage : UIImage

/**
 Returns a resizeable image with the intrinsically defined tiling region.
 */
- (UIImage *)resizeableImage NS_AVAILABLE_IOS(5_0);

/**
 Returns a frame into which content such as text may be drawn. We assume that the content region fully consumes the
 tiling region, otherwise we can make no promises about the returned frame.
 */
- (CGRect)innerContentFrameForImageOfSize:(CGSize)size;

@end
