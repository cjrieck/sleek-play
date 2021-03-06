//
//  SPMusicPlayerController.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPMusicPlayerController.h"
#import "SPSongPickerViewController.h"
#import "SPSongStateManager.h"
#import "SPSongDataView.h"

@interface SPMusicPlayerController () <SPCircularControlsDelegate>

@property (strong, nonatomic, readwrite) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic, readwrite) SPCircularControlsView *circularControls;
@property (strong, nonatomic) SPSongDataView *songDataView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureRight;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureLeft;
@property (strong, nonatomic) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;

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
        // TODO: Implement a picker
        
        if ( [[SPSongStateManager sharedManager] currentSong] == nil ) {
            // !!!: Manager handles 'isPlaying' boolean on init
            // TODO: Display picker for user to choose song
            SPSongPickerViewController *songPicker = [[SPSongPickerViewController alloc] init];
            [self.navigationController presentViewController:songPicker animated:YES completion:nil];
        }
        
        [self.songDataView updateViewForCurrentSong:[[SPSongStateManager sharedManager] currentSong]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleItemChange)
                                                     name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleVolumeChange)
                                                     name:MPMusicPlayerControllerVolumeDidChangeNotification
                                                   object:nil];
        
        [self.musicPlayerController beginGeneratingPlaybackNotifications];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
    volumeView.center = CGPointMake(-50.0, -50.0);
    [self.view addSubview:volumeView];
    
    const CGFloat width = CGRectGetWidth(self.view.frame);
    const CGFloat height = CGRectGetHeight(self.view.frame);
    
    self.songDataView = [[SPSongDataView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.songDataView.backgroundColor = [UIColor clearColor];
    [self createParallaxEffectForView:self.songDataView];
    
    self.circularControls = [[SPCircularControlsView alloc] initWithFrame:CGRectMake(0, 0, width, self.view.frame.size.height)];
    self.circularControls.delegate = self;
    
    [self.circularControls animateVolumeStrokeWithEndValue:self.musicPlayerController.volume];
    
    self.swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeGestureRight.numberOfTouchesRequired = 1;
    [self.swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:self.swipeGestureRight];

    self.swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeGestureLeft.numberOfTouchesRequired = 1;
    [self.swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:self.swipeGestureLeft];
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    self.longPress.numberOfTouchesRequired = 1;
    self.longPress.minimumPressDuration = 0.2f;
    [self.view addGestureRecognizer:self.longPress];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAndShow)];
    self.singleTap.numberOfTapsRequired = 1;
    self.singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];

    self.previousVolumeLevel = self.musicPlayerController.volume;
    
    [self.view addSubview:self.songDataView];
    [self.view addSubview:self.circularControls];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    [longPress requireGestureRecognizerToFail:self.singleTap];
    
    if ( longPress.state == UIGestureRecognizerStateChanged ) {
        const CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
        CGFloat fingerPositionY = [self.longPress locationInView:self.view].y;
        CGFloat newVolume = fingerPositionY / (screenHeight*75.0f);
        
        // going UP
        if ( fingerPositionY > self.lastTranslation ) {
            self.previousVolumeLevel -= newVolume;
        }
        else {
            self.previousVolumeLevel += newVolume;
        }
        
        if ( self.previousVolumeLevel >= 1.0f ) {
            self.previousVolumeLevel = 1.0f;
        }
        
        if ( self.previousVolumeLevel <= 0.0f ) {
            self.previousVolumeLevel = 0.0f;
        }
        
        self.musicPlayerController.volume = self.previousVolumeLevel;
        [self.circularControls animateVolumeStrokeWithEndValue:self.previousVolumeLevel];
        
        self.lastTranslation = fingerPositionY;
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
    if ( swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft ) {
        [self didRequestNextSong];
    }
    else if ( swipeGesture.direction == UISwipeGestureRecognizerDirectionRight ) {
        [self didRequestPreviousSong];
    }
}

- (void)createParallaxEffectForView:(UIView *)parallaxView
{
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-20);
    verticalEffect.maximumRelativeValue = @(20);
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-20);
    horizontalEffect.maximumRelativeValue = @(20);
    
    UIMotionEffectGroup *effectGroup = [UIMotionEffectGroup new];
    effectGroup.motionEffects = @[verticalEffect, horizontalEffect];
    
    [parallaxView addMotionEffect:effectGroup];
}

- (void)handleItemChange
{
    NSLog(@"Item Changed");
    [[SPSongStateManager sharedManager] setNowPlayingSong:[self.musicPlayerController nowPlayingItem]];
    [self.songDataView updateViewForCurrentSong:[[SPSongStateManager sharedManager] currentSong]];
    [self.circularControls resetSeekCircle];
    
    NSNumber *duration = [[self.musicPlayerController nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    NSTimeInterval songDuration = [duration doubleValue];
    double currentTime = self.musicPlayerController.currentPlaybackTime / songDuration;
    [self.circularControls configureAnimationTimeWithDuration:songDuration-currentTime andStartingPoint:currentTime];
}

- (void)handleVolumeChange
{
    [self.circularControls animateVolumeStrokeWithEndValue:self.musicPlayerController.volume];
    self.previousVolumeLevel = self.musicPlayerController.volume;
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
    NSLog(@"PLAY");
    [[SPSongStateManager sharedManager] setSongPlaying];
    [self.musicPlayerController play];
}

- (void)didRequestPauseSong
{
    NSLog(@"PAUSE");
    [[SPSongStateManager sharedManager] setSongStopped];
    [self.musicPlayerController pause];
}

- (void)hideAndShow
{
    float newAlpha;
    if ( self.circularControls.alpha == 0.0 ) {
        newAlpha = 1.0f;
    }
    else {
        newAlpha = 0.0f;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.circularControls.alpha = newAlpha;
    }];
}

@end
