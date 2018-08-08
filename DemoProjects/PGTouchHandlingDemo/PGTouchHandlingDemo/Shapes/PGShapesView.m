//
//  PGShapesView.m
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/8.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "PGShapesView.h"

@implementation PGShapesView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

+ (instancetype)shapeView {
    NSArray *randomShapes = @[@(PGShapesTypeSquare),
                              @(PGShapesTypeCircle),
                              @(PGShapesTypeTriangle)];
    NSInteger randomIndex = arc4random_uniform(256) % randomShapes.count;
    PGShapesType shape = [randomShapes[randomIndex] integerValue];
    PGShapesView *shapeView = [[self alloc] initWithFrame:(CGRect){0, 0, kPGShapeWidthHeight, kPGShapeWidthHeight}];
    switch (shape) {
        case PGShapesTypeSquare: {
            shapeView.backgroundColor = [self randomColor];
            break;
        }
        case PGShapesTypeTriangle: {
            UIBezierPath *trianglePath = [[UIBezierPath alloc] init];
            [trianglePath moveToPoint:(CGPoint){0, kPGShapeWidthHeight}];
            [trianglePath addLineToPoint:(CGPoint){kPGShapeWidthHeight/2, 0}];
            [trianglePath addLineToPoint:(CGPoint){kPGShapeWidthHeight, kPGShapeWidthHeight}];
            [trianglePath closePath];
            [shapeView shapeLayer].path = trianglePath.CGPath;
            [shapeView shapeLayer].fillColor = [self randomColor].CGColor;
            break;
        }
        case PGShapesTypeCircle: {
            UIBezierPath *circlePath = [[UIBezierPath alloc] init];
            [circlePath moveToPoint:(CGPoint){kPGShapeWidthHeight/2, kPGShapeWidthHeight/2}];
            [circlePath addArcWithCenter:(CGPoint){kPGShapeWidthHeight/2, kPGShapeWidthHeight/2}
                                  radius:(kPGShapeWidthHeight/2 - 1)
                              startAngle:0 endAngle:M_PI * 2
                               clockwise:YES];
            [shapeView shapeLayer].path = circlePath.CGPath;
            [shapeView shapeLayer].fillColor = [self randomColor].CGColor;
            break;
        }
        default:
            NSAssert(NO, @"no such type.");
            break;
    }
    return shapeView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *panGest =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanShapeView:)];
        [self addGestureRecognizer:panGest];
    }
    return self;
}

#pragma mark - Actions
- (void)didPanShapeView:(UITapGestureRecognizer *)panGest {
    NSLog(@"did pan shape view");
}

#pragma mark - Raw touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began.");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches moved.");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches ended");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches cancelled.");
}

#pragma mark - Helpers
+ (UIColor *)randomColor {
    return [UIColor colorWithRed:(1.0 * arc4random_uniform(256)/255.0)
                           green:(1.0 * arc4random_uniform(256)/255.0)
                            blue:(1.0 * arc4random_uniform(256)/255.0)
                           alpha:1.0];
}

@end
