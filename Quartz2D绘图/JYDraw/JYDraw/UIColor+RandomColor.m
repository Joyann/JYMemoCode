//
//  UIImage+RandomColor.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+ (instancetype)randomColor
{
    CGFloat red   = arc4random() % 256 / 255.0;
    CGFloat blue  = arc4random() % 256 / 255.0;
    CGFloat green = arc4random() % 256 / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return color;
}

@end
