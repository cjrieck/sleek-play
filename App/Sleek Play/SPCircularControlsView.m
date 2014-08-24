//
//  SPCircularControlsView.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPCircularControlsView.h"
#import "SPSongStateManager.h"

@interface SPCircularControlsView ()

@property (strong, nonatomic) UIButton *playPauseCircle;
@property (strong, nonatomic) CAShapeLayer *seekCircle;
@property (strong, nonatomic) CAShapeLayer *volumeCircle;

@property (assign, nonatomic) BOOL isPlaying;

@end

@implementation SPCircularControlsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self setUpCircles];
    }
    return self;
}

- (void)setUpCircles
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = self.bounds;
    
    self.playPauseCircle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
    self.playPauseCircle.layer.cornerRadius = 55;
    self.playPauseCircle.center = self.center;
    self.playPauseCircle.backgroundColor = [UIColor purpleColor];
    [self.playPauseCircle addTarget:self action:@selector(playPauseAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:blurView];
    [self addSubview:self.playPauseCircle];
    
    self.volumeCircle = [self setUpLayerWithLineRadius:135 lineWidth:20 borderColor:[UIColor blueColor] fillColor:nil];
    self.seekCircle = [self setUpLayerWithLineRadius:90 lineWidth:70 borderColor:[UIColor greenColor] fillColor:nil];
    
    // Add to parent layer
    [self.layer addSublayer:self.volumeCircle];
    [self.layer addSublayer:self.seekCircle];
}

- (CAShapeLayer *)setUpLayerWithLineRadius:(int)radius lineWidth:(int)lineWidth borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor
{
    CAShapeLayer *newLayer = [CAShapeLayer layer];
    // Make a circular shape
    newLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                        cornerRadius:radius].CGPath;
    // Center the shape in self.view
    newLayer.position = CGPointMake(CGRectGetMidX(self.frame)-radius,
                                             CGRectGetMidY(self.frame)-radius);
    
    // Configure the apperence of the circle
    if ( fillColor ) {
        newLayer.fillColor = fillColor.CGColor;
    }
    else {
        newLayer.fillColor = [UIColor clearColor].CGColor;
    }
    
    if ( borderColor ) {
        newLayer.strokeColor = borderColor.CGColor;
    }
    else {
        newLayer.strokeColor = [UIColor blackColor].CGColor;
    }
    
    newLayer.lineWidth = lineWidth;
    
    return newLayer;
}

- (void)resetSeekCircle
{
    self.seekCircle.strokeStart = 0.0f;
}

- (void)configureAnimationTimeWithDuration:(CFTimeInterval)duration andStartingPoint:(double)start
{
    NSLog(@"ADD ANIMATION");
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = duration; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
//
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:start];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0];

    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add the animation to the circle
    [self.seekCircle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

- (void)animateVolumeStrokeWithEndValue:(float)end
{
    [CATransaction setDisableActions:YES];
    self.volumeCircle.strokeStart = 0.0f;
    self.volumeCircle.strokeEnd = end;
    [CATransaction setDisableActions:NO];
}

- (void)animateSeekStrokeWithEndValue:(float)end
{
    NSLog(@"ANIMATE SEEK STROKE");
    [CATransaction setDisableActions:YES];
    self.seekCircle.strokeStart = 0.0f;
    self.seekCircle.strokeEnd = end;
    [CATransaction setDisableActions:NO];
}

- (void)pauseAnimation
{
    NSLog(@"PAUSE ANIMATION");
    CFTimeInterval pausedTime = [self.seekCircle convertTime:CACurrentMediaTime() fromLayer:nil];
    self.seekCircle.speed = 0.0f;
    self.seekCircle.timeOffset = pausedTime;
}

- (void)playAnimation
{
    NSLog(@"PLAY ANIMATION");
    CFTimeInterval pausedTime = self.seekCircle.timeOffset;
    self.seekCircle.speed = 1.0f;
    self.seekCircle.timeOffset = 0.0f;
    self.seekCircle.beginTime = 0.0f;
    CFTimeInterval timeSincePause = [self.seekCircle convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.seekCircle.beginTime = timeSincePause;
}

- (void)playPauseAnimation
{
    NSLog(@"Play/Pause ANIMATION");
    if ( [[SPSongStateManager sharedManager] songState] ) {
        [self.delegate didRequestPauseSong];
        [[SPSongStateManager sharedManager] setSongStopped];
        [self pauseAnimation];
    }
    else {
        [self.delegate didRequestPlaySong];
        [[SPSongStateManager sharedManager] setSongPlaying];
        [self playAnimation];
    }
}

@end
