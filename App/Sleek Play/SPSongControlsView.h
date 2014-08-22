//
//  SPSongControlsView.h
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPSongControlsDelegate <NSObject>

- (void)didRequestNextSong;
- (void)didRequestPreviousSong;
- (void)didRequestPlaySong;
- (void)didRequestPauseSong;

@end

@interface SPSongControlsView : UIView

@property (assign, nonatomic) BOOL isPlaying;

@property (weak, nonatomic)id<SPSongControlsDelegate>delegate;

@end
