//
//  SPSongDataView.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPSongDataView.h"
#import "SPSongStateManager.h"

@interface SPSongDataView ()

@property (strong, nonatomic) UIImageView *albumCoverView;
@property (strong, nonatomic) UILabel *songTitleLabel;
@property (strong, nonatomic) UILabel *artistLabel;

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
    [self setTitleAndArtist];
}

- (void)createSubviews
{
    // TODO: Init all subviews with appropriate data
    
    const CGFloat width = self.bounds.size.width + 40.0f;
    const CGFloat textLabelHeight = CGRectGetHeight(self.frame)/4.0;
    
    self.albumCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    self.albumCoverView.center = self.center;
    
    self.songTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-40.0f, textLabelHeight)];
    self.songTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
    self.songTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width+textLabelHeight-40.0f, width-40.0f, textLabelHeight)];
    self.artistLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
    self.artistLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.albumCoverView];
    [self addSubview:self.songTitleLabel];
    [self addSubview:self.artistLabel];
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

- (void)setTitleAndArtist
{
    self.songTitleLabel.text = [self.currentSong valueForProperty:MPMediaItemPropertyTitle];
    self.artistLabel.text = [self.currentSong valueForProperty:MPMediaItemPropertyArtist];
}

@end
