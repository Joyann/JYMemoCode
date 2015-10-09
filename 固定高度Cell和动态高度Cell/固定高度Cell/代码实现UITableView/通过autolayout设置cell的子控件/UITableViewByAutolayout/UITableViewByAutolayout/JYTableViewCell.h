//
//  JYTableViewCell.h
//  UITableViewByFrame
//
//  Created by joyann on 15/9/30.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYShop;

@interface JYTableViewCell : UITableViewCell

/**
 *  商品模型
 */
@property (nonatomic, strong) JYShop *shop;


@end
