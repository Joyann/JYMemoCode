//
//  JYWineCell.h
//  JYCustomTableViewDelete
//
//  Created by joyann on 15/10/8.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYWine;

@interface JYWineCell : UITableViewCell

@property (nonatomic, strong) JYWine *wine;

@property (weak, nonatomic) IBOutlet UIImageView *wineImageView;
@property (weak, nonatomic) IBOutlet UILabel *wineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wineMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wineCheckedImageView;

@end
