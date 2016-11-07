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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movingTimer =
    [NSTimer scheduledTimerWithTimeInterval:1.f
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
}

- (void)move:(NSTimer *)timer
{
    CGFloat aniViewY = self.aniView.frame.origin.y;
    aniViewY = arc4random_uniform(20) * (-1.0) + aniViewY;
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
    [self resizeAnimationViewWithAniNum:aniNum];
    [self.aniView drawNum:aniNum withSizeChange:YES];
}

- (void)resizeAnimationViewWithAniNum:(NSUInteger)aniNum
{
    NSString *aniNumStr = [@(aniNum) description];
    aniNumStr = (aniNumStr.length < 2) ?
    [@"0" stringByAppendingString:aniNumStr] :
    aniNumStr;
    
    CGFloat width = (aniNumStr.length) * 16;
    self.widthConstraint.constant = width;
    
    NSLog(@"ani view frame: %@", NSStringFromCGRect(self.aniView.frame));
}

@end
