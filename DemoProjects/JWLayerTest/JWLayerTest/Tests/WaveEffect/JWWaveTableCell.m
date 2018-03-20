//
//  JWWaveTableCell.m
//  JWLayerTest
//
//  Created by JiangWang on 19/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWWaveTableCell.h"
#import "JWTimerWaveView.h"
#import "JWReplicatorWaveView.h"

#define kJWWaveTableCellPadding (5)

@interface JWWaveTableCell ()
@property (nonatomic, strong) JWTimerWaveView *timerWaveView;
@property (nonatomic, strong) JWReplicatorWaveView *replicatorWaveView;
@end

@implementation JWWaveTableCell

#pragma mark - Public
- (void)setWaveViewType:(JWWaveViewType)waveViewType {
    if (_waveViewType != waveViewType) {
        _waveViewType = waveViewType;
        [self resetWaveView];
    }
}

- (void)resetWaveView {
    [self.timerWaveView removeFromSuperview];
    [self.replicatorWaveView removeFromSuperview];
    
    //use blue color for timer-based wave view; use red for the other type.
    CGRect avatarRect = self.imageView.bounds;
    CGRect waveRect = (CGRect){0, CGRectGetMidY(avatarRect),
        CGRectGetWidth(avatarRect), CGRectGetHeight(avatarRect) * 0.5};
    if (self.waveViewType == JWWaveViewTypeTimer) {
        self.timerWaveView.frame = waveRect;
        self.timerWaveView.waveColor = [UIColor blueColor];
        [self.imageView addSubview:self.timerWaveView];
    }
    else {
        self.replicatorWaveView.frame = waveRect;
        self.replicatorWaveView.waveColor = [UIColor yellowColor];
        [self.imageView addSubview:self.replicatorWaveView];
    }
}

#pragma mark - Initialization
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    //image view + text label
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseIdentifier];
    if (self) {
        //initial values
        self.imageView.image = [UIImage imageNamed:@"ic_broadcast_receive"];
        _waveViewType = JWWaveViewTypeTimer;
        [self resetWaveView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //round corner;
    CGRect avatarRect = self.imageView.bounds;
    self.imageView.layer.cornerRadius = CGRectGetHeight(avatarRect) * 0.5;
    self.imageView.layer.masksToBounds = YES;
    
    //start wave animation
    CGRect waveRect = (CGRect){0, CGRectGetMidY(avatarRect),
        CGRectGetWidth(avatarRect), CGRectGetHeight(avatarRect) * 0.5};
    if (self.waveViewType == JWWaveViewTypeTimer) {
        self.timerWaveView.frame = waveRect;
        [self.imageView addSubview:self.timerWaveView];
        [self.timerWaveView startWavingIfNeeded];
    }
    else {
        self.replicatorWaveView.frame = waveRect;
        [self.imageView addSubview:self.replicatorWaveView];
        [self.replicatorWaveView startWavingIfNeeded];
    }
}

#pragma mark - Lazy Loading
- (JWTimerWaveView *)timerWaveView {
    if (!_timerWaveView) {
        _timerWaveView = [[JWTimerWaveView alloc] init];
    }
    return _timerWaveView;
}

- (JWReplicatorWaveView *)replicatorWaveView {
    if (!_replicatorWaveView) {
        _replicatorWaveView = [[JWReplicatorWaveView alloc] init];
    }
    return _replicatorWaveView;
}

@end
