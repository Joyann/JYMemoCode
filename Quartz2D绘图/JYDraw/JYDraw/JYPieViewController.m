//
//  JYPieViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYPieViewController.h"
#import "JYPiewView.h"

@interface JYPieViewController ()

@end

@implementation JYPieViewController

- (void)loadView
{
    JYPiewView *pieView = [[JYPiewView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    pieView.backgroundColor = [UIColor orangeColor];
    self.view = pieView;
}

@end
