//
//  JYSnowView.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYSnowView.h"
#import "JYSnow.h"

static const NSInteger JYNumberOfSnow = 20;

@interface JYSnowView ()

@property (nonatomic, strong) NSMutableArray *snows;

@end

@implementation JYSnowView

#pragma mark - View Controller Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSnows];
        
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

#pragma mark - Getter Methods

- (NSMutableArray *)snows
{
    if (!_snows) {
        _snows = [NSMutableArray array];
    }
    return _snows;
}

#pragma mark - Add Snows

- (void)addSnows
{
    for (int i = 0; i < JYNumberOfSnow; i++) {
        JYSnow *snow = [[JYSnow alloc] init];
        [snow resetSnowStates];
        [self.snows addObject:snow];
    }
}

#pragma mark - Handle Display Link

- (void)handleDisplayLink: (CADisplayLink *)displayLink
{
    [_snows enumerateObjectsUsingBlock:^(JYSnow *snow, NSUInteger index, BOOL * _Nonnull stop) {
        CGPoint location = snow.location;
        if (location.y > self.bounds.size.height) {
            [snow resetSnowStates];
            location = CGPointMake(location.x, 0); // 重置状态之后要将location的y值设置为0重新开始，否则即使重置状态，也是在原来y的基础上增加新的speed，只会离可视范围更远
        }
        location.y += snow.speed;
        snow.location = location;
    }];
    [self setNeedsDisplay];
}

#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect
{
    UIImage *snowImage = [UIImage imageNamed:@"雪花"];
    [_snows enumerateObjectsUsingBlock:^(JYSnow *snow, NSUInteger index, BOOL * _Nonnull stop) {
        [snowImage drawAtPoint:snow.location];
    }];
}

@end
