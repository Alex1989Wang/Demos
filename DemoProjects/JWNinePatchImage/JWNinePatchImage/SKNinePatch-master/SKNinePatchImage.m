#import "SKNinePatchImage.h"

@interface SKNinePatchImage()

@property(nonatomic) UIEdgeInsets intrinsicCapInsets;

@property(nonatomic) CGRect innerFrame;
@property(nonatomic) CGRect upperFrame;
@property(nonatomic) CGRect leftFrame;
@property(nonatomic) CGRect lowerFrame;
@property(nonatomic) CGRect rightFrame;

@property(nonatomic) BOOL hasDeterminedCapInsets;
@property(nonatomic) BOOL hasDeterminedInnerFrame;
@property(nonatomic) BOOL hasDeterminedUpperFrame;
@property(nonatomic) BOOL hasDeterminedLeftFrame;
@property(nonatomic) BOOL hasDeterminedLowerFrame;
@property(nonatomic) BOOL hasDeterminedRightFrame;

@end

@implementation SKNinePatchImage

@synthesize intrinsicCapInsets = intrinsicCapInsets_;
@synthesize innerFrame = innerFrame_;
@synthesize upperFrame = upperFrame_;
@synthesize leftFrame = leftFrame_;
@synthesize lowerFrame = lowerFrame_;
@synthesize rightFrame = rightFrame_;

@synthesize hasDeterminedCapInsets = hasDeterminedCapInsets_;
@synthesize hasDeterminedUpperFrame = hasDeterminedUpperFrame_;
@synthesize hasDeterminedLeftFrame = hasDeterminedLeftFrame_;
@synthesize hasDeterminedLowerFrame = hasDeterminedLowerFrame_;
@synthesize hasDeterminedRightFrame = hasDeterminedRightFrame_;

#pragma mark - Image

- (UIImage *)resizeableImage {
    UIEdgeInsets innerInsets = [self innerCapInsets];
    CGRect inner = [self innerFrame];
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], inner);
    UIImage *image = [[UIImage imageWithCGImage:imageRef
                                          scale:[self scale]
                                    orientation:[self imageOrientation]] resizableImageWithCapInsets:innerInsets];
    CGImageRelease(imageRef);
    return image;
}

#pragma mark - Frames

- (CGRect)innerContentFrameForImageOfSize:(CGSize)size {
    CGRect lowerFrame = [self lowerFrame];
    CGRect rightFrame = [self rightFrame];
    
    CGRect fullFrame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIEdgeInsets insets = UIEdgeInsetsMake(CGRectGetMinY(rightFrame)-1,
                                           CGRectGetMinX(lowerFrame)-1,
                                           CGImageGetHeight([self CGImage]) - CGRectGetMaxY(rightFrame) - 1,
                                           CGImageGetWidth([self CGImage]) - CGRectGetMaxX(lowerFrame) - 1);
    return UIEdgeInsetsInsetRect(fullFrame, insets);
}

- (CGRect)innerFrame {
    if (![self hasDeterminedInnerFrame]) {
        size_t width = CGImageGetWidth([self CGImage]);
        size_t height = CGImageGetHeight([self CGImage]);
        innerFrame_ = UIEdgeInsetsInsetRect(CGRectMake(0.0f, 0.0f, width, height),
                                            UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f));
        [self setHasDeterminedInnerFrame:YES];
    }
    return innerFrame_;
}

#pragma mark - Black frame accessors

- (CGRect)upperFrame {
    if (![self hasDeterminedUpperFrame]) {
        upperFrame_ = [self skUpperFrame];
        [self setHasDeterminedUpperFrame:YES];
    }
    return upperFrame_;
}

- (CGRect)leftFrame {
    if (![self hasDeterminedLeftFrame]) {
        leftFrame_ = [self skLeftFrame];
        [self setHasDeterminedLeftFrame:YES];
    }
    return leftFrame_;
}

- (CGRect)lowerFrame {
    if (![self hasDeterminedLowerFrame]) {
        lowerFrame_ = [self skLowerFrame];
        [self setHasDeterminedLowerFrame:YES];
    }
    return lowerFrame_;
}

- (CGRect)rightFrame {
    if (![self hasDeterminedRightFrame]) {
        rightFrame_ = [self skRightFrame];
        [self setHasDeterminedRightFrame:YES];
    }
    return rightFrame_;
}

#pragma mark - Insets

- (UIEdgeInsets)intrinsicCapInsets {
    if (![self hasDeterminedCapInsets]) {
        UIEdgeInsets insets = UIEdgeInsetsMake(CGRectGetMinY([self leftFrame]),
                                               CGRectGetMinX([self upperFrame]),
                                               CGImageGetHeight([self CGImage]) - CGRectGetMaxY([self leftFrame]),
                                               CGImageGetWidth([self CGImage]) - CGRectGetMaxX([self upperFrame]));
        intrinsicCapInsets_ = insets;
        [self setHasDeterminedCapInsets:YES];
    }
    return intrinsicCapInsets_;
}

static UIEdgeInsets UIEdgeInsetsApplyScale(UIEdgeInsets insets, CGFloat scale) {
    return UIEdgeInsetsMake(scale*insets.top, scale*insets.left, scale*insets.bottom, scale*insets.right);
}

static UIEdgeInsets UIEdgeInsetsThicken(UIEdgeInsets insets, CGFloat delta) {
    return UIEdgeInsetsMake(insets.top + delta,
                            insets.left + delta,
                            insets.bottom + delta,
                            insets.right + delta);
}

- (UIEdgeInsets)innerCapInsets {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    CGFloat scale = [self scale];
    if (scale > 0.0f) {
        UIEdgeInsets intrinsicInsets = [self intrinsicCapInsets];
        insets = UIEdgeInsetsThicken(intrinsicInsets, -1.0f);
        insets = UIEdgeInsetsApplyScale(insets, 1/scale);
    }
    return insets;
}

@end
