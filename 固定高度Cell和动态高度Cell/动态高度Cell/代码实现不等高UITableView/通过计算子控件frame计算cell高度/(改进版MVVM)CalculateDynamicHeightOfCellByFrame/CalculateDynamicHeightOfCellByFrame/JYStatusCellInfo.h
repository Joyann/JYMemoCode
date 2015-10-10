//
//  JYStatusCellInfo.h
//  CalculateDynamicHeightOfCellByFrame
//
//  Created by joyann on 15/10/10.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NameLabelFont [UIFont systemFontOfSize:17]
#define ContentLabelFont [UIFont systemFontOfSize:15]

@class JYStatus;

@interface JYStatusCellInfo : NSObject

/**
 *  info对应的status实例
 */
@property (nonatomic, weak, readonly) JYStatus *status;
/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/**
 *  icon的frame
 */
@property (nonatomic, assign, readonly) CGRect statusIconImageViewFrame;
/**
 *  nameLabel的frame
 */
@property (nonatomic, assign, readonly) CGRect statusNameLabelFrame;
/**
 *  contentLabel的frame
 */
@property (nonatomic, assign, readonly) CGRect statusTextLabelFrame;
/**
 *  picture的frame
 */
@property (nonatomic, assign, readonly) CGRect statusPictureLabelFrame;
/**
 *  vip的frame
 */
@property (nonatomic, assign, readonly) CGRect statusVipFrame;

/**
 *  JYStatusCellInfo的指定初始化方法, 只能通过这个方法来创建cellInfo.
 *
 *  @param status 表示这个info对应的status
 *
 *  @return 返回一个JYStatusCellInfo的对象
 */
- (instancetype)initWithStatus: (JYStatus *)status;

@end
