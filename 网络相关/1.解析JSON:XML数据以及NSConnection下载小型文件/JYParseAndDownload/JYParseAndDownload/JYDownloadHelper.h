//
//  JYDownloadHelper.h
//  JYParseAndDownload
//
//  Created by joyann on 15/11/7.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYDownloadHelper : NSObject

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, assign) NSInteger downloadIndex;

@end
