//
//  JYApp.m
//  JYDownloadImagesAsync
//
//  Created by joyann on 15/11/3.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYApp.h"

@implementation JYApp

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    JYApp *app = [[JYApp alloc] init];
    
    [app setValuesForKeysWithDictionary:dict];
    
    return app;
}

@end
