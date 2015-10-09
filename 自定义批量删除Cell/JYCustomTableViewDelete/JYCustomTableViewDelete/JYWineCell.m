//
//  JYWineCell.m
//  JYCustomTableViewDelete
//
//  Created by joyann on 15/10/8.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYWineCell.h"
#import "JYWine.h"

@interface JYWineCell ()



@end

@implementation JYWineCell

- (void)setWine:(JYWine *)wine
{
    _wine = wine;
    
    self.wineImageView.image = [UIImage imageNamed:wine.image];
    self.wineNameLabel.text = wine.name;
    self.wineMoneyLabel.text = [NSString stringWithFormat:@"$ %@", wine.money];
    self.wineCheckedImageView.hidden = !wine.isChecked;
}

@end
