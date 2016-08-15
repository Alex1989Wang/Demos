//
//  AGDChatViewController.m
//  AgoraDemo
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 Agora. All rights reserved.
//

#import "AGDChatViewController.h"

#define ScreemWidth [UIScreen mainScreen].bounds.size.width
#define ScreemHeight [UIScreen mainScreen].bounds.size.height
#define MarginT 57
#define MarginB 48
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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomConstraint;

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong, nonatomic) AgoraRtcVideoCanvas *videoCanvas;

@property (strong, nonatomic) NSMutableArray *uids;
@property (strong, nonatomic) NSMutableDictionary *videoMuteForUids;

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
    
#warning 修改约束以及自定义流水布局,设置每个item的尺寸
    self.collectionHeightConstraint.constant = ScreemWidth * 0.5;
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flow.itemSize =  CGSizeMake(ScreemWidth * 0.5, ScreemWidth * 0.5);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.videoMainView.frame = self.videoMainView.superview.bounds; // video view's autolayout cause crash
    NSLog(@"%@", NSStringFromCGRect(self.videoMainView.frame));
    [self joinChannel];
}

#pragma mark -


- (void)initAgoraKit
{
    // use test key
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithVendorKey:self.vendorKey delegate:self];
    
    [self setUpVideo];
    //    [self setUpBlocks];
}

- (void)joinChannel
{
    // 本地化的一些操作,房间等待好友加入...
    [self showAlertLabelWithString:NSLocalizedString(@"wait_attendees", nil)];
    
    // 加入频道,通过key
    [self.agoraKit joinChannelByKey:nil channelName:self.channel info:nil uid:0 joinSuccess:nil];
}

- (void)setUpVideo
{
    [self.agoraKit enableVideo];
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    videoCanvas.view = self.videoMainView;
    // 设置视屏显示模式
    videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    // 设置本地视频视图
    [self.agoraKit setupLocalVideo:videoCanvas];
    self.videoCanvas = videoCanvas;
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"local video display");
    __weak typeof(self) weakSelf = self;
//    weakSelf.videoMainView.frame = weakSelf.videoMainView.superview.bounds; // video view's autolayout cause crash
//    weakSelf.videoMainView.frame = CGRectMake(0, 0, ScreemWidth, 200);
    if (weakSelf.uids.count > 0) {
        weakSelf.videoMainView.frame = CGRectMake(0, 0, ScreemWidth, [UIScreen mainScreen].bounds.size.height - MarginT - 64 - MarginB - self.collectionHeightConstraint.constant);
        self.videoCanvas.renderMode = AgoraRtc_Render_Adaptive;
    }else {
        weakSelf.videoMainView.frame = CGRectMake(0, 0, ScreemWidth, ScreemHeight - 64 - MarginT - MarginB);
         self.videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    }
//    if (weakSelf.uids.count > 0) {
//        weakSelf.BottomConstraint.constant = ScreemHeight - MarginT - weakSelf.collectionHeightConstraint.constant;
//        weakSelf.videoMainView.frame = weakSelf.videoMainView.superview.bounds;
//        
//    }else {
//        weakSelf.BottomConstraint.constant = ScreemHeight - MarginT - MarginB;
//        weakSelf.videoMainView.frame = weakSelf.videoMainView.superview.bounds;
//    }
}

#pragma mark - 自己视频的加入
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    
    NSLog(@"channel: %@, uid: %ld and elapsed: %ld", channel, uid, elapsed);
    
    //扬声器通话设置
    [self.agoraKit setEnableSpeakerphone:YES];
    
    
    // 如果是语音模式
    if (self.type == AGDChatTypeAudio) {
        // 此时切换为纯语音模式
        [self.agoraKit disableVideo];
    }
    
    // 控制whether the idle定时器is disabled for the app
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // 偏好设置存储
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.vendorKey forKey:AGDKeyVendorKey];
}


#pragma mark - 远端视频的加入和退出
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    __weak typeof(self) weakSelf = self;
    NSLog(@"self: %@", weakSelf);
    NSLog(@"engine: %@", engine);
    [weakSelf hideAlertLabel];
    if (weakSelf.uids.count >2) {
        return;
    }
    [weakSelf.uids addObject:@(uid)];
//    if (weakSelf.uids.count > 1) {
//        self.videoCanvas.uid = 0;
//        self.videoCanvas.view.frame = CGRectMake(0, 0, ScreemWidth, ScreemHeight - MarginB - MarginT - self.collectionHeightConstraint.constant);
//        [self.agoraKit setupLocalVideo:self.videoCanvas];
//    }else {
//        weakSelf.videoMainView.frame = weakSelf.videoMainView.superview.bounds;
//        [self.agoraKit setupLocalVideo:self.videoCanvas];
//    }
// 限制加入的人数,不超过2个人
//        if (weakSelf.uids.count <= 3) {
//            [weakSelf.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.uids.count-1 inSection:0]]];
//        }
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
        // 定时器作废
        [weakSelf.durationTimer invalidate];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        // 取消屏幕常亮状态
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }];
}

- (IBAction)didClickAudioMuteButton:(UIButton *)btn
{
    [self selectAudioMuteButtons:!btn.selected];
    // 静音设置
    [self.agoraKit muteLocalAudioStream:btn.selected];
}

- (IBAction)didClickSpeakerButton:(UIButton *)btn
{
    // 扬声器设置
    [self.agoraKit setEnableSpeakerphone:!self.agoraKit.isSpeakerphoneEnabled];
    // 判断是否是扬声器状态
    [self selectSpeakerButtons:!self.agoraKit.isSpeakerphoneEnabled];
}

- (IBAction)didClickVideoMuteButton:(UIButton *)btn
{
    btn.selected = !btn.selected;
    // 暂停发送本地视频
    [self.agoraKit muteLocalVideoStream:btn.selected];
    self.videoMainView.hidden = btn.selected;
}

- (IBAction)didClickSwitchButton:(UIButton *)btn
{
    btn.selected = !btn.selected;
    // 切换前后摄像头
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
        // 设置the ideal 定时器生效<让屏幕常亮,防止锁屏>
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }];
}

- (IBAction)didClickAudioButton:(UIButton *)btn
{
    // Start audio chat
    // 开启语音模式
    [self.agoraKit disableVideo];
    self.type = AGDChatTypeAudio;
}

- (IBAction)didClickVideoButton:(UIButton *)btn
{
    // Start video chat
    // 开启视频模式
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
//            AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
//            videoCanvas.uid = uid.unsignedIntegerValue;
//            videoCanvas.view = cell.videoView;
//            videoCanvas.renderMode = AgoraRtc_Render_Hidden;
//            [self.agoraKit setupRemoteVideo:videoCanvas];
            self.videoCanvas.uid = uid.unsignedIntegerValue;
            self.videoCanvas.view = cell.videoView;
            self.videoCanvas.renderMode = AgoraRtc_Render_Hidden;
            [self.agoraKit setupRemoteVideo:self.videoCanvas];
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
