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
#import "SPCircularControlsView.h"

@interface SPMusicPlayerController () <SPSongControlsDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic) SPSongDataView *songDataView;
@property (strong, nonatomic) SPSongControlsView *songControlsView;
@property (strong, nonatomic) SPCircularControlsView *circularControls;

@property (assign, nonatomic) CGFloat previousVolumeLevel;
@property (assign, nonatomic) CGFloat lastTranslation;

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
    
    self.circularControls = [[SPCircularControlsView alloc] initWithFrame:CGRectMake(0, statusBarHeight, width, height-statusBarHeight)];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGesture];
    
    self.previousVolumeLevel = 0.2f;
    
    [self.view addSubview:self.songDataView];
    [self.view addSubview:self.songControlsView];
    [self.view addSubview:self.circularControls];

}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture
{
    const CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
    CGFloat translationY = [panGesture translationInView:self.view].y;
    CGFloat velocityY = [panGesture velocityInView:self.view].y;
    
    NSLog(@"%f", velocityY);
    
    CGFloat newVolume = translationY / (screenHeight*50.0f);
    
    // going UP
    if ( velocityY < 0 ) {
        self.previousVolumeLevel += newVolume;
    }
    else {
        self.previousVolumeLevel -= newVolume;
    }
    
    if ( self.previousVolumeLevel >= 1.0f ) {
        self.previousVolumeLevel = 1.0f;
    }
    
    if ( self.previousVolumeLevel <= 0.0f ) {
        self.previousVolumeLevel = 0.0f;
    }
    
    [self.circularControls animateVolumeStrokeWithEndValue:self.previousVolumeLevel];
    
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
    [self.circularControls resetSeekCircle];
}

- (void)didRequestNextSong
{
    [self.musicPlayerController skipToNextItem];
    [self.circularControls resetSeekCircle];
    
    NSNumber *duration = [[self.musicPlayerController nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    NSTimeInterval songDuration = [duration doubleValue];
    //    float currentSpot = self.musicPlayerController.currentPlaybackTime;
    float circleSpot = self.musicPlayerController.currentPlaybackTime / songDuration;
    [self.circularControls configureAnimationTimeWithDuration:songDuration];
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
    [self.circularControls resetSeekCircle];
}

- (void)didRequestPlaySong
{
    [self.musicPlayerController play];
//    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCircle) userInfo:nil repeats:YES];
}

- (void)didRequestPauseSong
{
    [self.musicPlayerController pause];
}

- (void)updateCircle
{
    [self.circularControls incrementByAmount:1.0];
}

@end
