//
//  JYStatusCell.h
//  CalculateDynamicHeightOfCellByFrame
//
//  Created by joyann on 15/9/29.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYStatus;

@interface JYStatusCell : UITableViewCell

/**
 *  接受status模型数据
 */
@property (nonatomic, strong) JYStatus *status;

@end
