//
//  SnowView.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "SnowView.h"

@interface SnowView ()

@end

@implementation SnowView

static CGFloat pointY = 0;

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode: NSDefaultRunLoopMode];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage *snowImage = [UIImage imageNamed:@"雪花"];
    [snowImage drawAtPoint:CGPointMake(0, pointY)];
}

#pragma mark - Handle Actions

- (void)handleDisplayLink: (CADisplayLink *)displayLink
{
    pointY += 10.0;
    if (pointY > self.bounds.size.height) {
        pointY = 0.0;
    }
    [self setNeedsDisplay];
}


@end
