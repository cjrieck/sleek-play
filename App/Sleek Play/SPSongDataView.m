//
//  SPSongDataView.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPSongDataView.h"

@interface SPSongDataView ()

@property (weak, nonatomic) MPMediaItem *currentSong;

@property (strong, nonatomic) UIImageView *albumCoverView;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UILabel *totalTimeLabel;
@property (strong, nonatomic) UIView *progressView;

@end

@implementation SPSongDataView

- (instancetype)initWithSong:(MPMediaItem *)song
{
    self = [super init];
    if ( self ) {
        _currentSong = song;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    // TODO: Init all subviews with appropriate data
    
    self.albumCoverView = [[UIImageView alloc] initWithFrame:self.frame];
    self.albumCoverView.image = [self.currentSong valueForProperty:MPMediaItemPropertyArtwork];
    
    [self addSubview:self.albumCoverView];
}


@end
