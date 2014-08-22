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

@interface SPMusicPlayerController () <SPCircularControlsDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic) SPSongDataView *songDataView;
@property (strong, nonatomic) SPSongControlsView *songControlsView;
@property (strong, nonatomic) SPCircularControlsView *circularControls;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;

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
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:volumeView];
    
    const CGFloat width = CGRectGetWidth(self.view.frame);
    
    self.songDataView = [[SPSongDataView alloc] initWithFrame:CGRectMake(0, 0, width, self.view.frame.size.height)];
    self.songDataView.backgroundColor = [UIColor clearColor];
    [self createParallaxEffectForView:self.songDataView];
    
    if ( [self.musicPlayerController nowPlayingItem] ) {
        self.songDataView.currentSong = [self.musicPlayerController nowPlayingItem];
    }
    
    self.circularControls = [[SPCircularControlsView alloc] initWithFrame:CGRectMake(0, 0, width, self.view.frame.size.height)];
    self.circularControls.delegate = self;
    [self.circularControls setPlayingStatus:YES];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:self.panGesture];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAndShow)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:self.swipeGesture];
    
    self.previousVolumeLevel = 0.2f;
    
    [self.view addSubview:self.songDataView];
    [self.view addSubview:self.songControlsView];
    [self.view addSubview:self.circularControls];

}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
    switch (swipeGesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"Left");
            [self didRequestPreviousSong];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [self didRequestNextSong];
            break;
        case UISwipeGestureRecognizerDirectionDown:
        case UISwipeGestureRecognizerDirectionUp:
            break;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture
{
    [self.panGesture requireGestureRecognizerToFail:self.swipeGesture];
    
    const CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
    CGFloat fingerPositionY = [self.panGesture locationInView:self.view].y;
    
    NSLog(@"%f", fingerPositionY);
    
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
    
    NSNumber *duration = [[self.musicPlayerController nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    NSTimeInterval songDuration = [duration doubleValue];
    [self.circularControls configureAnimationTimeWithDuration:songDuration];
}

- (void)didRequestNextSong
{
    [self.musicPlayerController skipToNextItem];
//    [self.circularControls resetSeekCircle];
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
    [self.circularControls setPlayingStatus:YES];
}

- (void)didRequestPauseSong
{
    [self.musicPlayerController pause];
    [self.circularControls setPlayingStatus:NO];
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
