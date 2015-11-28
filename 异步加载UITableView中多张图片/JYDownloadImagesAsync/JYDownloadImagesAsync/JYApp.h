//
//  JYApp.h
//  JYDownloadImagesAsync
//
//  Created by joyann on 15/11/3.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYApp : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *download;

+ (instancetype)appWithDict: (NSDictionary *)dict;

@end
