//
//  ViewController.m
//  JYSingletonPattern
//
//  Created by joyann on 15/11/3.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "JYTool.h"
#import "JYSubTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    JYSubTool *subTool1 = [[JYSubTool alloc] init];
    JYSubTool *subTool2 = [JYSubTool sharedSubTool];
    JYSubTool *subTool3 = [subTool1 copy];
    JYSubTool *subTool4 = [subTool1 mutableCopy];
    NSLog(@"subTool1: %@", subTool1);
    NSLog(@"subTool2: %@", subTool2);
    NSLog(@"subTool3: %@", subTool3);
    NSLog(@"subTool4: %@", subTool4);
    NSLog(@"----------------------------------------------------------------");
    
    JYTool *tool1 = [[JYTool alloc] init];
    JYTool *tool2 = [JYTool shareTool];
    JYTool *tool3 = [tool1 copy];
    JYTool *tool4 = [tool1 mutableCopy];
    NSLog(@"tool1: %@", tool1);
    NSLog(@"tool2: %@", tool2);
    NSLog(@"tool3: %@", tool3);
    NSLog(@"tool4: %@", tool4);
    NSLog(@"----------------------------------------------------------------");
}


@end
