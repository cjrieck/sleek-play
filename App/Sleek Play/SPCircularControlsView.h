//
//  SPCircularControlsView.h
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPCircularControlsDelegate <NSObject>

- (void)didRequestPlaySong;
- (void)didRequestPauseSong;

@end

@interface SPCircularControlsView : UIView

- (void)resetSeekCircle;
- (void)configureAnimationTimeWithDuration:(NSTimeInterval)duration andStartingPoint:(double)start;
- (void)animateVolumeStrokeWithEndValue:(float)end;
- (void)animateSeekStrokeWithEndValue:(float)end;
//- (void)setPlayingStatus:(BOOL)playing;
- (void)expandVolumeCircle;
- (void)compressVolumeCircle;

@property (weak, nonatomic)id<SPCircularControlsDelegate>delegate;

@end
