//
//  JYSnow.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYSnow.h"

static const NSInteger JYRandomSeed   = 21;
static const NSInteger JYRandomSeedF  = 20.0;

#define JYUIScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation JYSnow

- (void)resetSnowStates
{
    // 这两个数随便取值，但是要保证前者比后者多1，并且后面的数是浮点数，目的就是产生0-1的小数
    self.alpha = arc4random() % JYRandomSeed / JYRandomSeedF;
    self.speed = arc4random() % JYRandomSeed;
    self.location = CGPointMake(arc4random() % (NSInteger)JYUIScreenWidth, 0);
}

@end
