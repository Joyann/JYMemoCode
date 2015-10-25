//
//  JYClipScreenViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/23.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYClipScreenViewController.h"

/*
    截屏：开启上下文 -> 将imageView渲染到上下文中 -> 从上下文拿到图片 -> 保存图片到桌面 -> 关闭上下文
*/

@interface JYClipScreenViewController ()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation JYClipScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addImageView];
    [self clipScreen];
}

#pragma mark - Add Image View

- (void)addImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"火影"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

#pragma mark - Clip Screen

- (void)clipScreen
{
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
//    [data writeToFile:@"/Users/joyann/Desktop/NewImage.jpg" atomically:YES];
    UIGraphicsEndImageContext();
}

@end
