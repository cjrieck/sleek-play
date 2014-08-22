//
//  SPSongControlsView.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPSongControlsView.h"

@implementation SPSongControlsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self createControls];
    }
    return self;
}

- (void)createControls
{
    const CGFloat buttonHeight = 50.0f;
    const CGFloat buttonWidth = 50.0f;
    
    UIButton *previousButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-buttonHeight, buttonWidth, buttonHeight)];
    previousButton.backgroundColor = [UIColor redColor];
    previousButton.titleLabel.text = @"Prev";
    [previousButton addTarget:self action:@selector(previousSong) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x - (buttonWidth/2.0), self.frame.size.height-buttonHeight, buttonWidth, buttonHeight)];
    playButton.backgroundColor = [UIColor blueColor];
    playButton.titleLabel.text = @"Play";
    [playButton addTarget:self action:@selector(playPauseSong) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-buttonWidth, self.frame.size.height-buttonHeight, buttonWidth, buttonHeight)];
    nextButton.backgroundColor = [UIColor redColor];
    nextButton.titleLabel.text = @"Next";
    [nextButton addTarget:self action:@selector(nextSong) forControlEvents:UIControlEventTouchUpInside];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height)/4.0f, self.frame.size.width, self.frame.size.height - buttonHeight)];
    volumeView.backgroundColor = [UIColor clearColor];
    volumeView.showsRouteButton = NO;
    
    [self addSubview:volumeView];
    [self addSubview:previousButton];
    [self addSubview:playButton];
    [self addSubview:nextButton];
}

- (void)nextSong
{
    [self.delegate didRequestNextSong];
}

- (void)previousSong
{
    [self.delegate didRequestPreviousSong];
}

- (void)playPauseSong
{
    if ( self.isPlaying ) {
        [self.delegate didRequestPauseSong];
        self.isPlaying = NO;
    }
    else {
        [self.delegate didRequestPlaySong];
        self.isPlaying = YES;
    }
}

@end
