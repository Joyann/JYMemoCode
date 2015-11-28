//
//  JYVideo.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/7.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYVideo.h"
#import "YYModel.h"

@implementation JYVideo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"videoID": @"id",
             };
}

@end
