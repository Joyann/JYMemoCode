//
//  JYPiewView.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYPiewView.h"
#import "UIColor+RandomColor.h"

#define JYPieRadius 150

@interface JYPiewView ()

@property (nonatomic, strong) NSMutableArray *pies;

@end

@implementation JYPiewView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pies = [NSMutableArray arrayWithArray:@[@25, @25, @50]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawPie];
}

#pragma mark - Draw Pie

- (void)drawPie
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = JYPieRadius;
    __block CGFloat startAngle = 0;
    __block CGFloat endAngle   = 0;
    [self.pies enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger index, BOOL *stop) {
        startAngle = endAngle;
        endAngle   = startAngle + number.integerValue / 100.0 * M_PI * 2;
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [circlePath addLineToPoint:center];
        [[UIColor randomColor] setFill];
        [circlePath fill];
    }];
}

#pragma mark - Handle Actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}

@end










