//
//  JYWineCell.h
//  JYShoopingCar
//
//  Created by joyann on 15/10/9.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYWine, JYWineCell;

@protocol JYWineCellDelegate <NSObject>

@optional
- (void)wineCellDidClickAddButton: (JYWineCell *)wineCell;
- (void)wineCellDidClickRemoveButton: (JYWineCell *)wineCell;

@end

@interface JYWineCell : UITableViewCell

/**
 *  wine 数据模型
 */
@property (nonatomic, strong) JYWine *wine;

/**
 *  wineCell的代理属性 -> viewController
 */
@property (nonatomic, weak) id<JYWineCellDelegate> delegate;

@end
