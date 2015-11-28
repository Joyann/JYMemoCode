//
//  JYDownloadButton.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/7.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYDownloadButton.h"

@implementation JYDownloadButton

+ (instancetype)downloadButton
{
    JYDownloadButton *downloadButton = [[JYDownloadButton alloc] init];
    
    return downloadButton;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = self.bounds.size.height * 0.15;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + self.progress * M_PI * 2;
    CGFloat defaultStartAngle = startAngle;
    CGFloat defaultEndAngle = M_PI * 2;
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius * 1.5 startAngle:defaultStartAngle endAngle:defaultEndAngle clockwise:YES];
    UIBezierPath *downloadPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor blueColor] setStroke];
    downloadPath.lineWidth = 5.0;
    [downloadPath stroke];
    [[UIColor orangeColor] setStroke];
    roundPath.lineWidth = 3.0;
    [roundPath stroke];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

@end
