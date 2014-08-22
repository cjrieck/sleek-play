//
//  SPCircularControlsView.h
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPCircularControlsView : UIView

- (void)resetSeekCircle;
- (void)configureAnimationTimeWithDuration:(NSTimeInterval)duration;
- (void)animateVolumeStrokeWithEndValue:(float)end;

@end
