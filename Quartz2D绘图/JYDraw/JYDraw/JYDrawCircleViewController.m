//
//  JYDrawCircleViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYDrawCircleViewController.h"
#import "JYDrawView.h"

@interface JYDrawCircleViewController ()

@end

@implementation JYDrawCircleViewController

- (void)loadView
{
    JYDrawView *circleView = [[JYDrawView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    circleView.backgroundColor = [UIColor orangeColor];
    self.view = circleView;
}

@end
