//
//  JYTableViewCell.m
//  UITableViewByFrame
//
//  Created by joyann on 15/9/30.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYTableViewCell.h"
#import "JYShop.h"

@interface JYTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *buyCountLabel;

@end

@implementation JYTableViewCell


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
