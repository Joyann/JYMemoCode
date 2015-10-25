//
//  JYSnowViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYSnowViewController.h"
#import "JYSnowView.h"

@interface JYSnowViewController ()

@end

@implementation JYSnowViewController

- (void)loadView
{
    JYSnowView *snowView = [[JYSnowView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    snowView.backgroundColor = [UIColor blackColor];
    self.view = snowView;
}

@end
