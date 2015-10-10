//
//  JYStatusCell.m
//  CalculateDynamicHeightOfCellByFrame
//
//  Created by joyann on 15/9/29.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYStatusCell.h"
#import "JYStatus.h"

@interface JYStatusCell ()

@property (nonatomic, weak) UIImageView *iconImgaeView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *vipImageView;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIImageView *contentImageView;

@end

@implementation JYStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 在这个方法中添加子控件
        // 添加头像控件
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImgaeView = iconImageView;
        // 添加名称控件
        UILabel *nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        // 添加vip控件
        UIImageView *vipImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:vipImageView];
        self.vipImageView = vipImageView;
        // 添加正文控件
        UILabel *contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:contentLabel];
        contentLabel.numberOfLines = 0;           // 需要设置contentLabel不受行数限制
        contentLabel.font = ContentLabelFont;     // 需要设置字体和bounding中的字体一样
        self.contentLabel = contentLabel;
        // 添加正文中图片控件
        UIImageView *contentImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:contentImageView];
        contentImageView.backgroundColor = [UIColor orangeColor];
        self.contentImageView = contentImageView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconImgaeView.frame = self.status.cellInfo.statusIconImageViewFrame;
    self.nameLabel.frame = self.status.cellInfo.statusNameLabelFrame;
    self.contentLabel.frame = self.status.cellInfo.statusTextLabelFrame;
    self.contentImageView.frame = self.status.cellInfo.statusPictureLabelFrame;
    self.vipImageView.frame = self.status.cellInfo.statusVipFrame;
    
}

- (void)setStatus:(JYStatus *)status
{
    // 在这个方法中给各个控件设置数据
    _status = status;
    
    // 设置头像
    self.iconImgaeView.image = [UIImage imageNamed:status.icon];
    // 设置昵称
    self.nameLabel.text = status.name;
    // 设置vip
    if (status.isVip) {
        self.vipImageView.hidden = NO;
        self.vipImageView.image = [UIImage imageNamed:@"vip"];
        self.nameLabel.textColor = [UIColor redColor];
    } else {
        self.vipImageView.hidden = YES;
    }
    // 设置正文
    self.contentLabel.text = status.text;
    // 设置正文图片
    if (status.picture) {
        self.contentImageView.hidden = NO;
        self.contentImageView.image = [UIImage imageNamed:status.picture];
    } else {
        self.contentImageView.hidden = YES;
    }
}


@end
