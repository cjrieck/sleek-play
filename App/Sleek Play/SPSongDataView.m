//
//  SPSongDataView.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPSongDataView.h"

@interface SPSongDataView ()

@property (strong, nonatomic) UIImageView *albumCoverView;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UILabel *totalTimeLabel;
@property (strong, nonatomic) UIView *progressView;

@end

@implementation SPSongDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self createSubviews];
    }
    return self;
}

- (void)setCurrentSong:(MPMediaItem *)currentSong
{
    _currentSong = currentSong;
    [self setPicture];
}

- (void)createSubviews
{
    // TODO: Init all subviews with appropriate data
    
    const CGFloat width = self.bounds.size.width + 20.0f;
    const CGFloat height = self.bounds.size.height + 20.0f;
    
    self.albumCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    self.albumCoverView.center = self.center;
    
    [self addSubview:self.albumCoverView];
}

- (void)setPicture
{
    const CGFloat width = self.bounds.size.width + 20.0f;
    if ( [self.currentSong valueForProperty:MPMediaItemPropertyArtwork] ) {
        self.albumCoverView.image = [[self.currentSong valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(width, width)];
    }
    else {
        // TODO: Put in filler image
    }
    
}

@end
