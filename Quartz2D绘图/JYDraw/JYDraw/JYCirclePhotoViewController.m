//
//  JYCirclePhotoViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/23.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYCirclePhotoViewController.h"

@interface JYCirclePhotoViewController ()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation JYCirclePhotoViewController

/*
    裁剪圆形图片：开启位图上下文 -> 使用BezierPath设置圆形路径 -> 将image画/imageView渲染到上下文 -> 取出新的图片
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addImageView];
    [self clip];
}

#pragma mark - Add Image View

- (void)addImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"阿狸头像"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

- (void)clip
{
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, 0.0);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:self.imageView.bounds];
    [circlePath addClip];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = newImage;
}


@end
