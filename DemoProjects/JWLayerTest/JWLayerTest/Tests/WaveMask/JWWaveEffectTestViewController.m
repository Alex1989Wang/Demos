//
//  JWWaveEffectTestViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 18/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWWaveEffectTestViewController.h"
#import "JWTimerWaveView.h"
#import "JWReplicatorWaveView.h"

typedef NS_ENUM(NSUInteger, JWWaveViewType) {
    JWWaveViewTypeTimer,
    JWWaveViewTypeReplicator,
};

static JWWaveViewType type = JWWaveViewTypeTimer;

@interface JWWaveEffectTestViewController ()
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) JWTimerWaveView *timerWaveView;
@property (nonatomic, strong) JWReplicatorWaveView *replicatorWaveView;
@end

@implementation JWWaveEffectTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    //flip the type value every time.
    type = (type == JWWaveViewTypeTimer) ? JWWaveViewTypeReplicator :
    JWWaveViewTypeTimer;
    self.title = (type == JWWaveViewTypeTimer) ? @"Wave Built by Timer" :
    @"Wave by Replicator Layer";
    
    //add a avatar view
    self.avatarView.frame = (CGRect){80, 200, 100, 100};
    self.avatarView.image = [UIImage imageNamed:@"ic_broadcast_receive"];
    self.avatarView.layer.cornerRadius = 100 * 0.5;
    self.avatarView.layer.masksToBounds = YES;
    [self.view addSubview:self.avatarView];

    //add wave view
    CGRect avatarRect = self.avatarView.bounds;
    CGRect waveRect = (CGRect){0, CGRectGetMidY(avatarRect),
        CGRectGetWidth(avatarRect), CGRectGetHeight(avatarRect) * 0.5};
    self.timerWaveView.frame = waveRect;
    self.replicatorWaveView.frame = waveRect;
    [self.avatarView addSubview:(type == JWWaveViewTypeTimer) ? self.timerWaveView : self.replicatorWaveView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //start wave effect if needed;
    if (type == JWWaveViewTypeTimer) {
        [self.timerWaveView startWavingIfNeeded];
    }
    else {
        [self.replicatorWaveView startWavingIfNeeded];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //pause waving if needed;
    if (type == JWWaveViewTypeTimer) {
        [self.timerWaveView pauseWavingIfNeeded];
    }
    else {
        [self.replicatorWaveView pauseWavingIfNeeded];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect avatarRect = self.avatarView.bounds;
    CGRect waveRect = (CGRect){0, CGRectGetMidY(avatarRect),
        CGRectGetWidth(avatarRect), CGRectGetHeight(avatarRect) * 0.5};
    self.timerWaveView.frame = waveRect;
    self.replicatorWaveView.frame = waveRect;
    //start wave effect if needed;
    if (type == JWWaveViewTypeTimer) {
        [self.timerWaveView startWavingIfNeeded];
    }
    else {
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

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
    }
    return _avatarView;
}

@end
