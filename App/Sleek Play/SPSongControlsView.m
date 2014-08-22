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
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height)/2.0, self.frame.size.width, self.frame.size.height)];
    volumeView.backgroundColor = [UIColor clearColor];
    volumeView.showsRouteButton = NO;
    
    [self addSubview:volumeView];
}

@end
