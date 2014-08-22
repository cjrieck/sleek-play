//
//  SPCircularControlsView.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPCircularControlsView.h"

@interface SPCircularControlsView ()

@property (strong, nonatomic) UIView *seekCircle;

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
    
}

@end
