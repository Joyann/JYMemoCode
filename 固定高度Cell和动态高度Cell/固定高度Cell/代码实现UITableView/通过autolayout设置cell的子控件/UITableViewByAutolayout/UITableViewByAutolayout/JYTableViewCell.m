//
//  JYTableViewCell.m
//  UITableViewByFrame
//
//  Created by joyann on 15/9/30.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYTableViewCell.h"
#import "JYShop.h"
#import "Masonry.h"

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

/*
    创建和使用cell的步骤是一样的：
    1. 直接使用initWithStyle:reuseIdentifier:创建或者提前注册cell.
    2. 上面的两种方法本质上都会调用initWithStyle:reuseIdentifier:方法, 所以在cell的这个方法中添加子控件.
    3. 加完子控件之后想要正确布局子控件又有两种方式：
       第一种是在layouySubviews方法里面设置各个控件的frame属性;
       第二种是直接在initWithStyle:reuseIdentifier:中给各个控件添加约束.第一种方式不能直接在initWithStyle:reuseIdentifier:中直接设置frame是因为在调用这个方法的时候不能确定frame,因为frame有可能还没有设置.而第二种方式可以直接设置约束是因为约束并不依赖frame,所以我们可以不必在layoutSubviews里面再对控件的位置尺寸进行设置, 而是直接在initWithStyle:reuseIdentifier:中设置约束.
 */

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat spacing = 10;
        CGFloat iconWH = 60;
        // 添加icon
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        // 给icon添加约束
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).offset(spacing);
            make.top.equalTo(self.contentView.mas_top).offset(spacing);
            make.size.mas_equalTo(CGSizeMake(iconWH, iconWH));
        }];
        
        // 添加title
        UILabel *titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
        titleLabel.font = ShopTitleFont;
        titleLabel.numberOfLines = 0;
        self.titleLabel = titleLabel;
        // 给title添加约束
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).offset(spacing);
            make.top.equalTo(self.iconImageView.mas_top);
            make.right.equalTo(self.contentView).offset(-spacing);
            make.height.equalTo(@20);
        }];
        
        // 添加price
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.font = ShopPriceFont;
        priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        // 给price添加约束
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_leading);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(spacing);
            make.width.equalTo(self.titleLabel.mas_width);
            make.height.equalTo(@20);
        }];
        
        // 添加buyCount
        UILabel *buyCountLabel = [[UILabel alloc] init];
        buyCountLabel.font = ShopButCountFont;
        [self.contentView addSubview:buyCountLabel];
        self.buyCountLabel = buyCountLabel;
        // 给buyCount添加约束
        [self.buyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-spacing);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-spacing);
            make.height.equalTo(@20);
        }];
    }
    
    return self;
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
