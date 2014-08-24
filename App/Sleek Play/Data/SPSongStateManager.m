//
//  SPSongStateManager.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/24/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPSongStateManager.h"

@interface SPSongStateManager ()

@property (strong, nonatomic) MPMediaItem *nowPlayingSong;

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
            _nowPlayingSong = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
        }
        else {
            _nowPlayingSong = nil;
        }
        
        switch ([[MPMusicPlayerController iPodMusicPlayer] playbackState]) {
            case MPMusicPlaybackStatePlaying:
            case MPMusicPlaybackStateSeekingForward:
            case MPMusicPlaybackStateSeekingBackward:
                _isPlaying = YES;
                break;
                
            default:
                _isPlaying = NO;
                break;
        }
    }
    return self;
}

- (void)setNowPlayingSong:(MPMediaItem *)nowPlayingSong
{
    _nowPlayingSong = nowPlayingSong;
}

@end
