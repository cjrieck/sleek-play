//
//  SPSongStateManager.m
//  Sleek Play
//
//  Created by Clayton Rieck on 8/24/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import "SPSongStateManager.h"

@implementation SPSongStateManager

+ (instancetype)sharedManager
{
    static SPSongStateManager *s_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_sharedManager = [[SPSongStateManager alloc] init];
    });
    return s_sharedManager;
}

@end
