//
//  JYCirclePathWithBorderViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/23.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYCirclePathWithBorderViewController.h"

/*
    裁剪出带有边框的圆形图片：开启位图上下文（上下文的大小根据想要的border来设置，大小为想要裁剪圆的大小+2*border） -> 先使用BezierPath画一个大圆用作背景 -> 使用BezierPath画出想要裁剪图片大小的路径用作裁剪区域 -> 将image画到上下文中 -> 此时image将被裁剪，并且覆盖之前的大圆，只露出border部分(裁剪区域并不会裁剪之前的大圆，因为已经绘制) -> 从上下文中获得新的图片 -> 关闭位图上下文
 */

@interface JYCirclePathWithBorderViewController ()
@end

@implementation JYCirclePathWithBorderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self clipImageViewWithBorder];
}

#pragma mark - Clip

- (void)clipImageViewWithBorder
{
    UIImage *image = [UIImage imageNamed:@"阿狸头像"];
    CGFloat border = 5.0;
    CGFloat borderCicleWidth = image.size.width + 2 * border;
    CGFloat borderCicleHeight = image.size.height + 2 * border;
    CGSize size = CGSizeMake(borderCicleWidth, borderCicleHeight);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    // 绘制大圆
    UIBezierPath *borderCiclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    [[UIColor orangeColor] setFill];
    [borderCiclePath fill];
    // 设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, image.size.width, image.size.height)];
    [clipPath addClip];
    // 绘制image
    [image drawAtPoint:CGPointMake(border, border)];
    // 得到新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

@end
