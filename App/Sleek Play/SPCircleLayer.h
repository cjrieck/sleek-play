//
//  SPCircleLayer.h
//  Sleek Play
//
//  Created by Clayton Rieck on 8/22/14.
//  Copyright (c) 2014 CLA. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SPCircleLayer : CAShapeLayer

// !!!: Must be numberWithFloat
@property (strong, nonatomic) NSNumber *beginningValue;
@property (strong, nonatomic) NSNumber *endingValue;

@end
