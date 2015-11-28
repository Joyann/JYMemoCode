//
//  JYVideoTableViewCell.h
//  JYParseAndDownload
//
//  Created by joyann on 15/11/7.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYVideo;

@class JYDownloadButton;

@interface JYVideoTableViewCell : UITableViewCell

@property (nonatomic, strong) JYVideo *video;
@property (nonatomic, strong) JYDownloadButton *downloadButton;
@end
