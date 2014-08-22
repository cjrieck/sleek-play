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

@interface SPMusicPlayerController ()

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
    
    self.songDataView = [[SPSongDataView alloc] initWithFrame:CGRectMake(0, statusBarHeight, width, height)];
    self.songDataView.backgroundColor = [UIColor blackColor];
    [self createParallaxEffectForView:self.songDataView];
    
    if ( [self.musicPlayerController nowPlayingItem] ) {
        self.songDataView.currentSong = [self.musicPlayerController nowPlayingItem];
    }
    
    self.songControlsView = [[SPSongControlsView alloc] initWithFrame:CGRectMake(0, height, width, statusBarHeight+height/4.0f)];
    self.songControlsView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
//    self.songControlsView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.songDataView];
    [self.view addSubview:self.songControlsView];

}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

- (void)createParallaxEffectForView:(UIView *)parallaxView
{
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-5);
    verticalEffect.maximumRelativeValue = @(5);
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-20);
    horizontalEffect.maximumRelativeValue = @(20);
    
    UIMotionEffectGroup *effectGroup = [UIMotionEffectGroup new];
    effectGroup.motionEffects = @[verticalEffect, horizontalEffect];
    
    [parallaxView addMotionEffect:effectGroup];
}

@end
