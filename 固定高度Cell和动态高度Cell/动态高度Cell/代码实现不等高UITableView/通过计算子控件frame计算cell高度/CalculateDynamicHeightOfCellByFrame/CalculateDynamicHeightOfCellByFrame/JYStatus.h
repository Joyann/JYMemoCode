//
//  JYStatus.h
//  CalculateDynamicHeightOfCellByFrame
//
//  Created by joyann on 15/9/29.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYStatus : NSObject

/**
 *  正文内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  头像名称
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  正文图片
 */
@property (nonatomic, copy) NSString *picture;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  vip
 */
@property (nonatomic, assign, getter=isVip) BOOL vip;

@end
