//
//  ViewController.m
//  NowPlaying
//
//  Created by JiangWang on 2018/10/7.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"rain" withExtension:@"mp3"];
    
//    AVAsset *asset = [AVAsset assetWithURL:fileUrl];
//    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
//    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
//    [player play];
//    self.player = player;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    self.audioPlayer = audioPlayer;
    self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer play];

    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSDictionary *dict = @{MPMediaItemPropertyAlbumTitle : @"Title",
                           MPMediaItemPropertyArtist : @"Jiang"};
    center.nowPlayingInfo = dict;
}



@end
