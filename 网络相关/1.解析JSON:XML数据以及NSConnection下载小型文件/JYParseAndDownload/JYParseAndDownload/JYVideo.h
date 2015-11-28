//
//  JYVideo.h
//  JYParseAndDownload
//
//  Created by joyann on 15/11/7.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JYVideo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger videoID;

@property (nonatomic, assign) CGFloat progress;

@end
