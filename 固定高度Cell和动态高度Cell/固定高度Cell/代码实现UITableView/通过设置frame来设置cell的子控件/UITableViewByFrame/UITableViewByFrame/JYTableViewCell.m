//
//  JYTableViewCell.m
//  UITableViewByFrame
//
//  Created by joyann on 15/9/30.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYTableViewCell.h"
#import "JYShop.h"

#define ShopTitleFont               [UIFont systemFontOfSize:17]
#define ShopPriceFont               [UIFont systemFontOfSize:14]
#define ShopButCountFont            [UIFont systemFontOfSize:14]
#define ScreenWidth                 [UIScreen mainScreen].bounds.size.width

@interface JYTableViewCell ()

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *buyCountLabel;

@end

@implementation JYTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加icon
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        // 添加title
        UILabel *titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
        titleLabel.font = ShopTitleFont;
        self.titleLabel = titleLabel;
        
        // 添加price
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.font = ShopPriceFont;
        priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        
        // 添加buyCount
        UILabel *buyCountLabel = [[UILabel alloc] init];
        buyCountLabel.font = ShopButCountFont;
        [self.contentView addSubview:buyCountLabel];
        self.buyCountLabel = buyCountLabel;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算子控件frame
    CGFloat spacing = 10;
    CGFloat iconImageViewWH = 60;
    
    // 计算iconImageView的frame
    CGFloat iconImageViewX = spacing;
    CGFloat iconImageViewY = spacing;
    CGFloat iconImageViewW = iconImageViewWH;
    CGFloat iconImgaeViewH = iconImageViewWH;
    self.iconImageView.frame = CGRectMake(iconImageViewX, iconImageViewY, iconImageViewW, iconImgaeViewH);
    
    // 计算titleLabel的frame
    CGFloat titleLabelX = CGRectGetMaxX(self.iconImageView.frame) + spacing;
    CGFloat titleLabelY = iconImageViewY;
    CGSize titleSize = [self.shop.title sizeWithAttributes:@{ NSFontAttributeName: ShopTitleFont }];
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleSize.width, titleSize.height);
    
    /*
     因为setShop:在这个方法之前调用, 所以拿到的self.priceLabel.text和self.buyCountLabel.text就是字符串拼接之后的长度, 满足我们的需求.
     如果用的是self.shop.price和self.shop.buyCount(发送sizeWithAttributes:消息),那么这两个label是不能显示完全的. 因为我们计算的是数据模型的文字宽度, 而真正显示的是拼接后的文字的宽度, 用原来的宽度来装拼接后的字符串, 很明显是装不下的.
     如果没有进行拼接字符串, 即最后self.shop.price和self.priceLabel.text的内容完全一致, self.shop.buyCount和self.buyCountLabel.text的内容完全一致, 那么无论给哪个发送sizeWithAttributes:消息都可以正确显示,因为计算出来的宽度和原宽度以及显示出来的宽度一样.
     */
    
    // 计算priceLabel的frame
    CGFloat priceLabelX = titleLabelX;
    CGFloat priceLabelY = CGRectGetMaxY(self.titleLabel.frame) + spacing;
    CGSize priceLabelSize = [self.priceLabel.text sizeWithAttributes:@{ NSFontAttributeName: ShopPriceFont }];
    self.priceLabel.frame = CGRectMake(priceLabelX, priceLabelY, priceLabelSize.width, priceLabelSize.height);
    
    // 计算buyCountLabel的frame
    CGSize buyCountLabelSize = [self.buyCountLabel.text sizeWithAttributes:@{ NSFontAttributeName: ShopButCountFont }];
    CGFloat buyCountLabelW = buyCountLabelSize.width;
    CGFloat buyCountLabelH = buyCountLabelSize.height;
    CGFloat buyCountLabelX = ScreenWidth - spacing - buyCountLabelW;
    CGFloat buyCountLabelY = CGRectGetMaxY(self.contentView.bounds) - spacing - buyCountLabelH;
    self.buyCountLabel.frame = CGRectMake(buyCountLabelX, buyCountLabelY, buyCountLabelW, buyCountLabelH);
}

- (void)setShop:(JYShop *)shop
{
    if (_shop != shop) {
        _shop = shop;
        
        // 设置图片
        self.iconImageView.image = [UIImage imageNamed:shop.icon];
        
        // 设置标题
        self.titleLabel.text = shop.title;
        
        // 设置价格
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", shop.price];
        
        // 设置购买人数
        self.buyCountLabel.text = [NSString stringWithFormat:@"已有%@人购买", shop.buyCount];
    }
}

@end
