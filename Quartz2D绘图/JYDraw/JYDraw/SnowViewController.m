//
//  SnowViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "SnowViewController.h"
#import "SnowView.h"

@interface SnowViewController ()

@end

@implementation SnowViewController

- (void)loadView
{
    SnowView *snowView = [[SnowView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    snowView.backgroundColor = [UIColor blackColor];
    self.view = snowView;
}


@end
