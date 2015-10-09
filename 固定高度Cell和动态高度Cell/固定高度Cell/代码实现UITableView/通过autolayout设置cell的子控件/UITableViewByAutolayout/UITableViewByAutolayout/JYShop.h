//
//  JYShop.h
//  UITableViewByFrame
//
//  Created by joyann on 15/9/30.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYShop : NSObject

/**
 *  商品名称
 */
@property (nonatomic, copy) NSString *title;
/**
 *  商品图标
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  商品价格
 */
@property (nonatomic, copy) NSString *price;
/**
 *  商品购买人数
 */
@property (nonatomic, copy) NSString *buyCount;

@end
