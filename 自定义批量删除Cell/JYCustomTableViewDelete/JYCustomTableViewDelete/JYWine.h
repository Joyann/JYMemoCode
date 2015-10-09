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
 *  cell 是否显示被选中, 默认不被选中
 */
@property (nonatomic, assign, getter=isChecked) BOOL checked;


@end
