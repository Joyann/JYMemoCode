//
//  JYStatusCell.m
//  CalculateDynamicHeightOfCellByFrame
//
//  Created by joyann on 15/9/29.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYStatusCell.h"
#import "JYStatus.h"

#define NameLabelFont [UIFont systemFontOfSize:17]
#define ContentLabelFont [UIFont systemFontOfSize:15]

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
        if (self.status.isVip) {
            self.nameLabel.textColor = [UIColor redColor];
        }
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
    
    // 在这个方法中设置控件的frame
    CGFloat cellWidth = self.contentView.bounds.size.width;
    CGFloat cellHeight = self.contentView.bounds.size.height;
#pragma unused(cellHeight)
    CGFloat spacing = 10;
    CGFloat iconWH = 60;
    CGFloat vipWH = 14;
    CGFloat contentImageWH = 100;
    
    // 计算头像的frame.
    CGFloat iconImageViewX = spacing;
    CGFloat iconImageViewY = spacing;
    CGFloat iconImageViewW = iconWH;
    CGFloat iconImageViewH = iconWH;
    self.iconImgaeView.frame = CGRectMake(iconImageViewX, iconImageViewY, iconImageViewW, iconImageViewH);
    
    // 计算昵称的frame.
    CGFloat nameLabelX = CGRectGetMaxX(self.iconImgaeView.frame) + spacing;
    CGFloat nameLabelY = iconImageViewY;
    // 计算UILabel文字所占尺寸（注意这个方法只能计算一行的文字，不能用这个方法来计算正文的尺寸）
    // 另外，在layoutSubviews中可以拿到self.status，说明setStatus:在layoutSubviews后面执行，也就是说layoutSubviews在将要出现在屏幕上的时候调用一次，然后每当frame改变的时候都会调用一次
    CGSize nameLabelSize = [self.status.name sizeWithAttributes:@{ NSFontAttributeName:  NameLabelFont }];
    CGFloat nameLabelW = nameLabelSize.width;
    CGFloat nameLabelH = nameLabelSize.height;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    // 只有确定是vip才计算frame.
    if (self.status.vip) {
        CGFloat vipLabelW = vipWH;
        CGFloat vipLabelH = vipWH;
        CGFloat vipLabelX = CGRectGetMaxX(self.nameLabel.frame) + spacing;
        CGFloat vipLabelY = CGRectGetMidY(self.nameLabel.frame) - vipLabelH / 2;
        self.vipImageView.frame = CGRectMake(vipLabelX, vipLabelY, vipLabelW, vipLabelH);
    }
    
    // 计算正文的frame.
    CGFloat contentLabelX = iconImageViewX;
    CGFloat contentLabelY = CGRectGetMaxY(self.iconImgaeView.frame) + spacing;
    // 设置给正文限定的size
    // 意思是最大的宽度是cell的宽度减去2个spcing，最大的高度是无限大.用无限大是因为下面的方法总会选择小的高度，比如高度是50，那么就会选择50，如果是100，那么就会选择100.用无限大保证能一直取到较小的值.
    // 也就是说，我们希望内容的宽度是cellWidth - 2 * spacing，高度不限.
    CGSize constraintSize = CGSizeMake(cellWidth - 2 * spacing, MAXFLOAT);
    CGRect contentLabelRect = [self.status.text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: ContentLabelFont } context:nil];
    self.contentLabel.frame = CGRectMake(contentLabelX, contentLabelY, contentLabelRect.size.width, contentLabelRect.size.height);
    
    // 只有确定正文中有图片才计算frame.
    if (self.status.picture) {
        CGFloat contentImageViewX = iconImageViewX;
        CGFloat contentImgaeViewY = CGRectGetMaxY(self.contentLabel.frame) + spacing;
        CGFloat contentImageViewW = contentImageWH;
        CGFloat contentImageViewH = contentImageWH;
        self.contentImageView.frame = CGRectMake(contentImageViewX, contentImgaeViewY, contentImageViewW, contentImageViewH);
    }
    
}

- (void)setStatus:(JYStatus *)status
{
    // 在这个方法中给各个控件设置数据
    if (_status != status) {
        _status = status;
        
        // 设置头像
        self.iconImgaeView.image = [UIImage imageNamed:status.icon];
        // 设置昵称
        self.nameLabel.text = status.name;
        // 设置vip
        if (status.isVip) {
            self.vipImageView.hidden = NO;
            self.vipImageView.image = [UIImage imageNamed:@"vip"];
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
}


@end
