//
//  ViewController.m
//  MovingAndDraw
//
//  Created by JiangWang on 05/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "XDNumberAnimationView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet XDNumberAnimationView *aniView;
@property (nonatomic, weak) NSTimer *movingTimer;
@property (nonatomic, weak) NSTimer *drawTimer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) NSTimer *cancelTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movingTimer =
    [NSTimer scheduledTimerWithTimeInterval:0.3f
                                     target:self
                                   selector:@selector(move:)
                                   userInfo:nil
                                    repeats:YES];
    
    self.drawTimer =
    [NSTimer scheduledTimerWithTimeInterval:1.f
                                     target:self
                                   selector:@selector(draw:)
                                   userInfo:nil
                                    repeats:YES];
    [self.drawTimer fire];
    
    self.cancelTimer =
    [NSTimer scheduledTimerWithTimeInterval:5.f
                                     target:self
                                   selector:@selector(cancelDrawTimer:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)move:(NSTimer *)timer
{
    CGFloat aniViewY = self.aniView.frame.origin.y;
    aniViewY = arc4random_uniform(20) * (-1.0) + arc4random_uniform(20) + aniViewY;
    CGRect aniViewNewFrame = self.aniView.frame;
    aniViewNewFrame.origin.y = aniViewY;
    
    [UIView animateWithDuration:0.5
                     animations:
     ^{
         self.aniView.frame = aniViewNewFrame;
     }];
    NSLog(@"ani view frame: %@", NSStringFromCGRect(self.aniView.frame));
}

- (void)draw:(NSTimer *)timer
{
    static NSUInteger aniNum = 0;
    aniNum ++;
    [self resizeAnimationViewWithAniNum:aniNum
                    beforeSelfIncrement:(aniNum - 1)];
    [self.aniView drawNum:[@(aniNum) description] withSizeChange:NO];
}

- (void)cancelDrawTimer:(NSTimer *)timer
{
    if (self.drawTimer)
    {
        [self.drawTimer invalidate];
        self.drawTimer = nil;
    }
    
    self.drawTimer =
    [NSTimer scheduledTimerWithTimeInterval:1.f
                                     target:self
                                   selector:@selector(draw:)
                                   userInfo:nil
                                    repeats:YES];
    [self.drawTimer fire];
}

- (void)resizeAnimationViewWithAniNum:(NSUInteger)aniNum
                  beforeSelfIncrement:(NSUInteger)originalAniNum
{
    NSString *aniNumStr = [@(aniNum) description];
    NSString *aniNumBeforeIncre = [@(originalAniNum) description];
    
    if ((aniNumBeforeIncre.length < aniNumStr.length)
        || (aniNumStr.length < 2))
    {
        aniNumStr = (aniNumStr.length < 2) ?
        [@"0" stringByAppendingString:aniNumStr] :
        aniNumStr;
        
        CGFloat width = (aniNumStr.length + 1) * 16;
        self.widthConstraint.constant = width;
        NSLog(@"ani view frame ---- resize: %@", NSStringFromCGRect(self.aniView.frame));
    }
    
}

@end
