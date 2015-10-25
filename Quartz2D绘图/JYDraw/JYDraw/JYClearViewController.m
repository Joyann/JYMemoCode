//
//  JYClearViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/23.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYClearViewController.h"

/*
 选择区域截屏：添加两个imageView -> topImageView增加pan手势 -> 在handle方法中 -> 计算出clear块的位置和尺寸 -> 设置裁剪区域 -> 裁剪 -> 露出bottomImageView中的内容
 */

static const CGFloat JYEraserWH = 20.0;

@interface JYClearViewController ()
@property (nonatomic, weak) UIImageView *topImageView;
@end

@implementation JYClearViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addImageViews];
}

#pragma mark - Add Image Views

- (void)addImageViews
{
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bottomImageView.image = [UIImage imageNamed:@"2B"];
    [self.view addSubview:bottomImageView];
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    topImageView.image = [UIImage imageNamed:@"2A"];
    topImageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.topImageView = topImageView;
    [topImageView addGestureRecognizer:pan];
    [self.view addSubview:topImageView];
}

#pragma mark - Handle Pan

- (void)handlePan: (UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.topImageView];
    CGPoint originPoint = CGPointMake(point.x - JYEraserWH * 0.5, point.y - JYEraserWH * 0.5);
    CGRect blockRect = CGRectMake(originPoint.x, originPoint.y, JYEraserWH, JYEraserWH);
    UIGraphicsBeginImageContextWithOptions(self.topImageView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.topImageView.layer renderInContext:context];
    CGContextClearRect(context, blockRect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.topImageView.image = newImage;
}

@end
