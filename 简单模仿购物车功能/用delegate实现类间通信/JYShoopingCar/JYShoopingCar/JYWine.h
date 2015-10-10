//
//  JYWine.h
//  JYCustomTableViewDelete
//
//  Created by joyann on 15/10/8.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYWine : NSObject

/**
 *  wine 名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  wine 价格
 */
@property (nonatomic, copy) NSString *money;

/**
 *  wine 图片名称
 */
@property (nonatomic, copy) NSString *image;

/**
 *  wine 当前这个wine加入购物车的个数
 */
@property (nonatomic, assign) NSInteger count;

@end
