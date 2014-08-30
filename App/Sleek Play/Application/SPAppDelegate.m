//
//  SPAppDelegate.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPAppDelegate.h"
#import "SPSongStateManager.h"
#import "SPMusicPlayerController.h"

@interface SPAppDelegate ()

@property (strong, nonatomic) SPMusicPlayerController *musicPlayerController;

@end

@implementation SPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.musicPlayerController = [[SPMusicPlayerController alloc] init];
    UINavigationController *rootNavController = [[UINavigationController alloc] initWithRootViewController:self.musicPlayerController];
    [rootNavController.navigationBar setHidden:YES];
    self.window.rootViewController = rootNavController;
    
    [[SPSongStateManager sharedManager] resetCurrentSong];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSTimeInterval playbackSpot = [[SPSongStateManager sharedManager] currentTimeInSong];
    
    [self.musicPlayerController.circularControls animateSeekStrokeWithEndValue:playbackSpot/[[SPSongStateManager sharedManager] currentSongDuration]];
    [self.musicPlayerController.circularControls configureAnimationTimeWithDuration:[[SPSongStateManager sharedManager] currentSongDuration]-playbackSpot andStartingPoint:playbackSpot/[[SPSongStateManager sharedManager] currentSongDuration]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[MPMusicPlayerController iPodMusicPlayer] pause];
}

@end
