//
//  JYWineCell.h
//  JYShoopingCar
//
//  Created by joyann on 15/10/9.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYWine;

@interface JYWineCell : UITableViewCell

/**
 *  wine 数据模型
 */
@property (nonatomic, strong) JYWine *wine;

@property (nonatomic, copy) void (^wineCellDidSelected) (NSInteger oldValue, NSInteger newValue, JYWine *wine);

@end
