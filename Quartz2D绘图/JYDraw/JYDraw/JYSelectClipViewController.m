//
//  JYSelectClipViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/23.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYSelectClipViewController.h"

/*
 选择区域截屏：给imageView增加pan手势 -> 新建一个UIView（coverView）用来表示选中的区域，此时并不知道frame -> 开启位图上下文 -> 在手势的监听方法中计算手指开始到停下的范围即为coverView的frame -> 手指离开时在上下文中设置截屏区域为coverView的frame -> 将imageView渲染到上下文中 -> 在上下文中得到新的图片 -> 关闭位图上下文
 */

@interface JYSelectClipViewController ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) CGPoint beginPosition;
@property (nonatomic, assign) CGPoint endPosition;
@property (nonatomic, weak) UIView *coverView;
@end

@implementation JYSelectClipViewController

- (UIView *)coverView
{
    if (!_coverView) {
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = [UIColor redColor];
        coverView.alpha = 0.7;
        [self.view addSubview:coverView]; // 这里不能在imageView上添加，因为imageView会进行渲染，那时无法移除coverView
        _coverView = coverView;
    }
    return _coverView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addImageView];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Add Image View

- (void)addImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: self.view.bounds];
    imageView.image = [UIImage imageNamed:@"火影"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    self.imageView = imageView;
    [self.view addSubview:imageView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [imageView addGestureRecognizer:pan];
}

#pragma mark - Handle Pan

- (void)handlePan: (UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.imageView];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.beginPosition = point;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            self.endPosition = point;
            CGFloat width = self.endPosition.x - self.beginPosition.x;
            CGFloat height = self.endPosition.y - self.beginPosition.y;
            self.coverView.frame = CGRectMake(self.beginPosition.x, self.beginPosition.y, width, height);
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0.0);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.coverView.frame];
            [bezierPath addClip];
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.imageView.layer renderInContext:context];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.imageView.image = newImage;
            [self.coverView removeFromSuperview];
            
            break;
        }
            
        default:
            break;
    }
}


@end
