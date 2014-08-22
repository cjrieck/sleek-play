//
//  SPMusicPlayerController.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPMusicPlayerController.h"
#import "SPSongDataView.h"
#import "SPSongControlsView.h"

@interface SPMusicPlayerController () <SPSongControlsDelegate>

@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic) SPSongDataView *songDataView;
@property (strong, nonatomic) SPSongControlsView *songControlsView;

@end

@implementation SPMusicPlayerController

- (id)init
{
    self = [super init];
    if ( self ) {
        _musicPlayerController = [MPMusicPlayerController iPodMusicPlayer];
        
        // get all music from ipod library
        MPMediaQuery *allQuery = [[MPMediaQuery alloc] initWithFilterPredicates:nil];
        [_musicPlayerController setQueueWithQuery:allQuery];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleItemChange)
                                                     name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                   object:nil];
        [self.musicPlayerController beginGeneratingPlaybackNotifications];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    const CGFloat width = CGRectGetWidth(self.view.frame);
    const CGFloat height = (3.0f * CGRectGetHeight(self.view.frame))/4.0f;
    const CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.songDataView = [[SPSongDataView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.songDataView.backgroundColor = [UIColor blackColor];
    [self createParallaxEffectForView:self.songDataView];
    
    if ( [self.musicPlayerController nowPlayingItem] ) {
        self.songDataView.currentSong = [self.musicPlayerController nowPlayingItem];
        [self.musicPlayerController pause];
    }
    
    self.songControlsView = [[SPSongControlsView alloc] initWithFrame:CGRectMake(0, height, width, statusBarHeight+height/4.0f)];
    self.songControlsView.delegate = self;
    self.songControlsView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    self.songControlsView.isPlaying = NO;
    
    [self.view addSubview:self.songDataView];
    [self.view addSubview:self.songControlsView];

}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

- (void)createParallaxEffectForView:(UIView *)parallaxView
{
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-30);
    horizontalEffect.maximumRelativeValue = @(30);
    
    UIMotionEffectGroup *effectGroup = [UIMotionEffectGroup new];
    effectGroup.motionEffects = @[horizontalEffect];
    
    [parallaxView addMotionEffect:effectGroup];
}

- (void)handleItemChange
{
    self.songDataView.currentSong = [self.musicPlayerController nowPlayingItem];
}

- (void)didRequestNextSong
{
    [self.musicPlayerController skipToNextItem];
}

- (void)didRequestPreviousSong
{
    NSTimeInterval currentTime = self.musicPlayerController.currentPlaybackTime;
    if ( currentTime < 2.0 ) {
        [self.musicPlayerController skipToPreviousItem];
    }
    else {
        [self.musicPlayerController skipToBeginning];
    }
}

- (void)didRequestPlaySong
{
    [self.musicPlayerController play];
}

- (void)didRequestPauseSong
{
    [self.musicPlayerController pause];
}

@end
