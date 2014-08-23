//
//  SPMusicPlayerController.h
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPCircularControlsView.h"

@interface SPMusicPlayerController : UIViewController

@property (strong, nonatomic, readonly) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic, readonly) SPCircularControlsView *circularControls;

@end
