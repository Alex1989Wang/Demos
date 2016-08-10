//
//  AGDChatViewController.m
//  AgoraDemo
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 Agora. All rights reserved.
//

#import "AGDChatViewController.h"

@interface AGDChatViewController ()
{
    __block AgoraRtcStats *lastStat_;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *speakerControlButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *audioMuteControlButtons;
@property (weak, nonatomic) IBOutlet UIButton *cameraControlButton;

@property (weak, nonatomic) IBOutlet UIView *audioControlView;
@property (weak, nonatomic) IBOutlet UIView *videoControlView;

@property (weak, nonatomic) IBOutlet UIView *videoMainView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *talkTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataTrafficLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *audioButton;

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;

@property (strong, nonatomic) NSMutableArray *uids;
@property (strong, nonatomic) NSMutableDictionary *videoMuteForUids;

//
@property (assign, nonatomic) AGDChatType type;
@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) NSString *vendorKey;
@property (assign, nonatomic) BOOL agoraVideoEnabled;
@property (strong, nonatomic) NSTimer *durationTimer;
@property (nonatomic) NSUInteger duration;

@property (strong, nonatomic) UIAlertView *errorKeyAlert;

@end

@implementation AGDChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.uids = [NSMutableArray array];
    self.videoMuteForUids = [NSMutableDictionary dictionary];
    
    self.channel = [self.dictionary objectForKey:AGDKeyChannel];
    self.vendorKey = [self.dictionary objectForKey:AGDKeyVendorKey];
    self.type = self.chatType;
    
    self.title = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"room", nil), self.channel];
//    [self selectSpeakerButtons:YES];
    [self initAgoraKit];
    NSLog(@"self: %@", self);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.videoMainView.frame = self.videoMainView.superview.bounds; // video view's autolayout cause crash
    [self joinChannel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -


- (void)initAgoraKit
{
    // use test key
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithVendorKey:self.vendorKey delegate:self];
        
    [self setUpVideo];
    [self setUpBlocks];
}

- (void)joinChannel
{
    [self showAlertLabelWithString:NSLocalizedString(@"wait_attendees", nil)];
    __weak typeof(self) weakSelf = self;
    [self.agoraKit joinChannelByKey:nil channelName:self.channel info:nil uid:0 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        
        [weakSelf.agoraKit setEnableSpeakerphone:YES];
        if (weakSelf.type == AGDChatTypeAudio) {
            [weakSelf.agoraKit disableVideo];
        }
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:weakSelf.vendorKey forKey:AGDKeyVendorKey];
    }];
}

- (void)setUpVideo
{
    [self.agoraKit enableVideo];
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    videoCanvas.view = self.videoMainView;
    videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"local video display");
    __weak typeof(self) weakSelf = self;
    weakSelf.videoMainView.frame = weakSelf.videoMainView.superview.bounds; // video view's autolayout cause crash
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    __weak typeof(self) weakSelf = self;
    NSLog(@"self: %@", weakSelf);
    NSLog(@"engine: %@", engine);
    [weakSelf hideAlertLabel];
    [weakSelf.uids addObject:@(uid)];
    
    [weakSelf.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.uids.count-1 inSection:0]]];
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason
{
    __weak typeof(self) weakSelf = self;
    NSInteger index = [weakSelf.uids indexOfObject:@(uid)];
    if (index != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [weakSelf.uids removeObjectAtIndex:index];
        [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    __weak typeof(self) weakSelf = self;
    NSLog(@"user %@ mute video: %@", @(uid), muted ? @"YES" : @"NO");
    
    [weakSelf.videoMuteForUids setObject:@(muted) forKey:@(uid)];
    [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[weakSelf.uids indexOfObject:@(uid)] inSection:0]]];
}

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine
{
    __weak typeof(self) weakSelf = self;
    [weakSelf showAlertLabelWithString:NSLocalizedString(@"no_network", nil)];
    weakSelf.videoMainView.hidden = YES;
    weakSelf.dataTrafficLabel.text = @"0KB/s";
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportRtcStats:(AgoraRtcStats*)stats
{
    __weak typeof(self) weakSelf = self;
    // Update talk time
    if (weakSelf.duration == 0 && !weakSelf.durationTimer) {
        weakSelf.talkTimeLabel.text = @"00:00";
        weakSelf.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(updateTalkTimeLabel) userInfo:nil repeats:YES];
    }
    
    NSUInteger traffic = (stats.txBytes + stats.rxBytes - lastStat_.txBytes - lastStat_.rxBytes) / 1024;
    NSUInteger speed = traffic / (stats.duration - lastStat_.duration);
    NSString *trafficString = [NSString stringWithFormat:@"%@KB/s", @(speed)];
    weakSelf.dataTrafficLabel.text = trafficString;
    
    lastStat_ = stats;
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode
{
    __weak typeof(self) weakSelf = self;
    if (errorCode == AgoraRtc_Error_InvalidVendorKey) {
        [weakSelf.agoraKit leaveChannel:nil];
        [weakSelf.errorKeyAlert show];
    }
}

- (void)setUpBlocks
{
//    [self.agoraKit rtcStatsBlock:^(AgoraRtcStats *stat) {
//        // Update talk time
//        if (self.duration == 0 && !self.durationTimer) {
//            self.talkTimeLabel.text = @"00:00";
//            self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTalkTimeLabel) userInfo:nil repeats:YES];
//        }
//        
//        NSUInteger traffic = (stat.txBytes + stat.rxBytes - lastStat_.txBytes - lastStat_.rxBytes) / 1024;
//        NSUInteger speed = traffic / (stat.duration - lastStat_.duration);
//        NSString *trafficString = [NSString stringWithFormat:@"%@KB/s", @(speed)];
//        self.dataTrafficLabel.text = trafficString;
//        
//        lastStat_ = stat;
//    }];
    
//    [self.agoraKit userJoinedBlock:^(NSUInteger uid, NSInteger elapsed) {
//        [self hideAlertLabel];
//        [self.uids addObject:@(uid)];
//        
//        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.uids.count-1 inSection:0]]];
//    }];
    
//    [self.agoraKit userOfflineBlock:^(NSUInteger uid) {
//        NSInteger index = [self.uids indexOfObject:@(uid)];
//        if (index != NSNotFound) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//            [self.uids removeObjectAtIndex:index];
//            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
//        }
//    }];
    

    
//    [self.agoraKit connectionLostBlock:^{
//        [self showAlertLabelWithString:NSLocalizedString(@"no_network", nil)];
//        self.videoMainView.hidden = YES;
//        self.dataTrafficLabel.text = @"0KB/s";
//    }];
    
//    [self.agoraKit userMuteVideoBlock:^(NSUInteger uid, BOOL muted) {
//        NSLog(@"user %@ mute video: %@", @(uid), muted ? @"YES" : @"NO");
//        
//        [self.videoMuteForUids setObject:@(muted) forKey:@(uid)];
//        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.uids indexOfObject:@(uid)] inSection:0]]];
//    }];
//    
//    [self.agoraKit firstLocalVideoFrameBlock:^(NSInteger width, NSInteger height, NSInteger elapsed) {
//        NSLog(@"local video display");
//        self.videoMainView.frame = self.videoMainView.superview.bounds; // video view's autolayout cause crash
//    }];
}

#pragma mark - 

- (void)showAlertLabelWithString:(NSString *)text;
{
    self.alertLabel.hidden = NO;
    self.alertLabel.text = text;
}

- (void)hideAlertLabel
{
    self.alertLabel.hidden = YES;
}

- (void)updateTalkTimeLabel
{
    self.duration++;
    NSUInteger seconds = self.duration % 60;
    NSUInteger minutes = (self.duration - seconds) / 60;
    self.talkTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (unsigned long)minutes, (unsigned long)seconds];
}

#pragma mark - 

- (IBAction)didClickBackView:(id)sender
{
    [self showAlertLabelWithString:NSLocalizedString(@"exiting", nil)];
    __weak typeof(self) weakSelf = self;
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        // Myself leave status
        [weakSelf.durationTimer invalidate];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }];
}

- (IBAction)didClickAudioMuteButton:(UIButton *)btn
{
    [self selectAudioMuteButtons:!btn.selected];
    [self.agoraKit muteLocalAudioStream:btn.selected];
}

- (IBAction)didClickSpeakerButton:(UIButton *)btn
{
    [self.agoraKit setEnableSpeakerphone:!self.agoraKit.isSpeakerphoneEnabled];
    [self selectSpeakerButtons:!self.agoraKit.isSpeakerphoneEnabled];
}

- (IBAction)didClickVideoMuteButton:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.agoraKit muteLocalVideoStream:btn.selected];
    self.videoMainView.hidden = btn.selected;
}

- (IBAction)didClickSwitchButton:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.agoraKit switchCamera];
}

- (IBAction)didClickHungUpButton:(UIButton *)btn
{
    [self showAlertLabelWithString:NSLocalizedString(@"exiting", nil)];
    __weak typeof(self) weakSelf = self;
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        // Myself leave status
        [weakSelf.durationTimer invalidate];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }];
}

- (IBAction)didClickAudioButton:(UIButton *)btn
{
    // Start audio chat
    [self.agoraKit disableVideo];
    self.type = AGDChatTypeAudio;
}

- (IBAction)didClickVideoButton:(UIButton *)btn
{
    // Start video chat
    [self.agoraKit enableVideo];
    self.type = AGDChatTypeVideo;
    if (self.cameraControlButton.selected) {
        self.cameraControlButton.selected = NO;
    }
}

#pragma mark - 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.uids.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AGDChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.type = self.type;
    
    // Get info
    NSNumber *uid = [self.uids objectAtIndex:indexPath.row];
    NSNumber *videoMute = [self.videoMuteForUids objectForKey:uid];
    
    if (self.type == AGDChatTypeVideo) {
        if (videoMute.boolValue) {
            cell.type = AGDChatTypeAudio;
        } else {
            cell.type = AGDChatTypeVideo;
            AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
            videoCanvas.uid = uid.unsignedIntegerValue;
            videoCanvas.view = cell.videoView;
            videoCanvas.renderMode = AgoraRtc_Render_Hidden;
            [self.agoraKit setupRemoteVideo:videoCanvas];
        }
    } else {
        cell.type = AGDChatTypeAudio;
    }
    
    // Audio
    cell.nameLabel.text = uid.stringValue;
    return cell;
}

#pragma mark -

- (void)setType:(AGDChatType)type
{
    _type = type;
    if (type == AGDChatTypeVideo) {
        // Control buttons
        self.videoControlView.hidden = NO;
        self.audioControlView.hidden = YES;
        
        // Video/Audio switch button
        self.videoButton.selected = YES;
        self.audioButton.selected = NO;
        
        //
        self.videoMainView.hidden = NO;
    } else {
        // Control buttons
        self.videoControlView.hidden = YES;
        self.audioControlView.hidden = NO;
        
        // Video/Audio switch button
        self.videoButton.selected = NO;
        self.audioButton.selected = YES;
        
        //
        self.videoMainView.hidden = YES;
    }
    [self.collectionView reloadData];
}

- (void)selectSpeakerButtons:(BOOL)selected
{
    for (UIButton *btn in self.speakerControlButtons) {
        btn.selected = selected;
    }
}

- (void)selectAudioMuteButtons:(BOOL)selected
{
    for (UIButton *btn in self.audioMuteControlButtons) {
        btn.selected = selected;
    }
}

- (UIAlertView *)errorKeyAlert
{
    if (!_errorKeyAlert) {
        _errorKeyAlert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedString(@"wrong_key", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"done", nil)
                                          otherButtonTitles:nil];
    }
    return _errorKeyAlert;
}

@end
