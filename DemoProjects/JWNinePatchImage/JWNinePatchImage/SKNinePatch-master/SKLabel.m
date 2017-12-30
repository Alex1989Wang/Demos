#import "SKLabel.h"
#import "SKNinePatchImage.h"

@interface SKLabel()

@property(nonatomic) CGRect contentFrame;

@end

@implementation SKLabel

@synthesize background = background_;
@synthesize contentFrame = contentFrame_;

- (void)drawBackgroundInRect:(CGRect)rect {
    if ([self background]) {
        UIImage *image = [[self background] resizeableImage];
        [image drawInRect:rect];        
    }
}

- (void)drawRect:(CGRect)rect {
    [self drawBackgroundInRect:rect];
    [super drawRect:rect];
}

- (void)drawTextInRect:(CGRect)rect {
    CGRect contentRect = rect;
    if ([self background]) {
        CGSize size = rect.size;
        contentRect = [[self background] innerContentFrameForImageOfSize:size];
    }
    [super drawTextInRect:contentRect];
}

@end
