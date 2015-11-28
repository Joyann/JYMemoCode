//
//  JYItem.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/6.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYItem.h"

@implementation JYItem

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    JYItem *item = [[JYItem alloc] init];
    item.title = title;
    item.subTitle = subTitle;
    return item;
}

@end
