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

- (void)setCurrentSong:(MPMediaItem *)currentSong
{
    _currentSong = currentSong;
    [self createSubviews];
}

- (void)createSubviews
{
    // TODO: Init all subviews with appropriate data
    
    const CGFloat width = self.frame.size.width + 50.0f;
    const CGFloat height = self.frame.size.height + 50.0f;
    
    self.albumCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    self.albumCoverView.image = [[self.currentSong valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(self.frame.size.height, self.frame.size.height)];
    self.albumCoverView.clipsToBounds = NO;
    self.albumCoverView.center = self.center;
    
    [self addSubview:self.albumCoverView];
}


@end
