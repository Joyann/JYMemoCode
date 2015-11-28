//
//  JYVideoTableViewCell.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/7.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYVideoTableViewCell.h"
#import "Masonry.h"
#import "JYVideo.h"
#import "UIImageView+WebCache.h"
#import "JYDownloadButton.h"

static NSString * const JYVideoBaseURL = @"http://120.25.226.186:32812/";

@interface JYVideoTableViewCell ()
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation JYVideoTableViewCell

#pragma mark - Settter Methods

- (void)setVideo:(JYVideo *)video
{
    _video = video;

    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:[JYVideoBaseURL stringByAppendingString:video.image]]];
    self.titleLabel.text = video.name;
    self.subTitleLabel.text = [NSString stringWithFormat:@"%ld", video.length];
    
    NSString *downloadURL = [JYVideoBaseURL stringByAppendingString:video.url];
    self.downloadButton.downloadURL = downloadURL;
}

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

// 添加约束
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 添加imageView的约束
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(16);
        make.width.equalTo(@54);
        make.top.equalTo(self.mas_top).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
    }];
    
    // 添加downloadButton的约束
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(-8);
        make.top.equalTo(self.mas_top).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.equalTo(@54);
    }];
    
    // 添加titleLabel的约束
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.videoImageView.mas_trailing).offset(16);
        make.trailing.equalTo(self.downloadButton.mas_leading).offset(-8);
        make.top.equalTo(self.videoImageView.mas_top);
        make.height.equalTo(@27);
    }];
    
    // 添加subTitleLabel的约束
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.trailing.equalTo(self.titleLabel.mas_trailing);
        make.bottom.equalTo(self.videoImageView.mas_bottom);
        make.height.equalTo(self.titleLabel.mas_height);
    }];
}

#pragma mark - Private Methods

- (void)addSubviews
{
    // 添加imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    self.videoImageView = imageView;
    
    // 添加titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 添加subTitleLabel
    UILabel *subTitleLabel = [[UILabel alloc] init];
    [self addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
    // 添加下载按钮
    JYDownloadButton *downloadButton = [JYDownloadButton downloadButton];
    [self addSubview: downloadButton];
    self.downloadButton = downloadButton;
}

@end
