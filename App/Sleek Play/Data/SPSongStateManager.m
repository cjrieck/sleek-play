//
//  SPSongStateManager.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/24/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPSongStateManager.h"

@interface SPSongStateManager ()

@property (weak, nonatomic) MPMediaItem *nowPlayingSong;

@property (assign, nonatomic) NSTimeInterval currentPlaybackTime;
@property (assign, nonatomic) BOOL isPlaying;

@end

@implementation SPSongStateManager

+ (instancetype)sharedManager
{
    static SPSongStateManager *s_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_sharedManager = [[SPSongStateManager alloc] init];
    });
    return s_sharedManager;
}

- (id)init
{
    self = [super init];
    if ( self ) {
        
        if ( [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem] ) {
//            _nowPlayingSong = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
            _currentPlaybackTime = [[MPMusicPlayerController iPodMusicPlayer] currentPlaybackTime];
        }
        else {
            _nowPlayingSong = nil;
            _currentPlaybackTime = 0.0f;
        }
        
        switch ([[MPMusicPlayerController iPodMusicPlayer] playbackState]) {
            case MPMusicPlaybackStatePlaying:
                _isPlaying = YES;
                break;
                
            default:
                _isPlaying = NO;
                break;
        }
        
        NSLog(@"PLAYING STATE: %@", _isPlaying ? @"YES" : @"NO");
    }
    return self;
}

- (void)setNowPlayingSong:(MPMediaItem *)nowPlayingSong
{
    _nowPlayingSong = nowPlayingSong;
}

- (MPMediaItem *)currentSong
{
    return self.nowPlayingSong;
}

- (NSTimeInterval)currentTimeInSong
{
    self.currentPlaybackTime = [[MPMusicPlayerController iPodMusicPlayer] currentPlaybackTime];
    return self.currentPlaybackTime;
}

- (BOOL)songState
{
    return self.isPlaying;
}

- (void)setSongPlaying
{
    self.isPlaying = YES;
}

- (void)setSongStopped
{
    self.isPlaying = NO;
}

@end
