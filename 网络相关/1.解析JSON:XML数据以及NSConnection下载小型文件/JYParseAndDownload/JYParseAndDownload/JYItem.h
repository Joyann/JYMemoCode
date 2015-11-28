//
//  JYItem.h
//  JYParseAndDownload
//
//  Created by joyann on 15/11/6.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

+ (instancetype)itemWithTitle: (NSString *)title subTitle: (NSString *)subTitle;

@end
