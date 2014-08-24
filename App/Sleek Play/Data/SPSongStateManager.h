//
//  SPSongStateManager.h
//  Sleek Play
//
//  Created by Clayton Rieck on 8/24/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSongStateManager : NSObject

+ (instancetype)sharedManager;

- (void)setNowPlayingSong:(MPMediaItem *)nowPlayingSong;
- (MPMediaItem *)currentSong;
- (NSTimeInterval)currentTimeInSong;
- (CFTimeInterval)currentSongDuration;
- (BOOL)songState;
- (void)setSongPlaying;
- (void)setSongStopped;

@end
