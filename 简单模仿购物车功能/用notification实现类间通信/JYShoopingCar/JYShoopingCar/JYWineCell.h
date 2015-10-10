//
//  JYWineCell.h
//  JYShoopingCar
//
//  Created by joyann on 15/10/9.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYWine;

// 通知
extern NSString * const JYWineCellAddNotification;
extern NSString * const JYWineCellRemoveNotification;

@interface JYWineCell : UITableViewCell

/**
 *  wine 数据模型
 */
@property (nonatomic, strong) JYWine *wine;

@end
