//
//  JYDrawView.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYDrawView.h"
#import "Masonry.h"

#define JYLabelWidth        100
#define JYLabelHeight       100
#define JYPathLineWidth     20
#define JYNumber            100
#define JYSliderX           30
#define JYSliderY           JYDrawViewCenter.y + 200
#define JYSliderHeight      20
#define JYSliderWidth       self.bounds.size.width - 2 * JYSliderX
#define JYProgressRadius    70
#define JYTextFont          [UIFont systemFontOfSize: 17]
#define JYDrawViewCenter    CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)

@interface JYDrawView ()

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, weak) UILabel *progressLabel;

@end

@implementation JYDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加Slider
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(JYSliderX, JYSliderY, JYSliderWidth, JYSliderHeight)];
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:slider];
        
        
        // 添加Label
        UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JYLabelWidth, JYLabelHeight)];
        progressLabel.center = JYDrawViewCenter;
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.font = JYTextFont;
        self.progressLabel = progressLabel;
        [self addSubview:progressLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawPercentageCircle];
}

#pragma mark - Draw

// 绘制进度条
- (void)drawPercentageCircle
{
    CGPoint center = JYDrawViewCenter;
    CGFloat radius = JYProgressRadius;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + self.progress * M_PI * 2;
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    arcPath.lineWidth = JYPathLineWidth;
    [[UIColor whiteColor] setStroke];
    [arcPath stroke];
}

#pragma mark - Target Action

- (void)sliderValueChanged: (UISlider *)slider
{
    self.progress = slider.value;
}

#pragma mark - Setter Mehods

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", progress * JYNumber];
    
    [self setNeedsDisplay];
}

@end
