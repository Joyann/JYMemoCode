//
//  JYWaterMarkViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/23.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYWaterMarkViewController.h"

@interface JYWaterMarkViewController ()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation JYWaterMarkViewController

/*
    给图片添加水印：先将图片绘制到上下文 -> 将文字也绘制到上下文 -> 从上下文中获得新的有水印的图片
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addImageView];
    [self addWaterMark];
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

#pragma mark - Add Watermark

- (void)addWaterMark
{
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
    NSString *waterMark = @"@Joyann";
    CGPoint waterMarkPosition = CGPointMake(self.imageView.bounds.size.width - 100, self.imageView.bounds.size.height - 30);
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:20],
                                  NSForegroundColorAttributeName: [UIColor whiteColor]};
    [waterMark drawAtPoint:waterMarkPosition withAttributes: attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = newImage;
}

@end
