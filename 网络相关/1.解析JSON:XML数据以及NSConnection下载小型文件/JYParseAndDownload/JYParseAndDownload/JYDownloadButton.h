//
//  JYDownloadButton.h
//  JYParseAndDownload
//
//  Created by joyann on 15/11/7.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JYDownloadButton : UIButton

+ (instancetype)downloadButton;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) NSString *downloadURL;

@end
