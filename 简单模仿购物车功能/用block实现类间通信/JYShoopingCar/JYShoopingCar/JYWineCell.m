//
//  JYWineCell.m
//  JYShoopingCar
//
//  Created by joyann on 15/10/9.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYWineCell.h"
#import "JYWine.h"

@interface JYWineCell ()

@property (weak, nonatomic) IBOutlet UIImageView *wineImageView;
@property (weak, nonatomic) IBOutlet UILabel *wineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wineMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *wineCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end

@implementation JYWineCell


#pragma mark - setter methods

- (void)setWine:(JYWine *)wine
{
    _wine = wine;
    
    self.wineImageView.image = [UIImage imageNamed:wine.image];
    self.wineNameLabel.text = wine.name;
    self.wineMoneyLabel.text = [NSString stringWithFormat:@"$ %@", wine.money];
    
    // cell的setter方法就是用来每次cell重用的时候覆盖原来的数据的, 如果不在这个方法中设置数据, 就会出现cell复用显示数据错误的问题.
    // 也就是说, 下面的addWine:和removeWine:方法相当于修改当前界面看到的cell
    // 而这个setter方法相当于保证cell经过重用后显示的数据依然是正确的.（用户上滑或下滑之后数据依然显示正确）
    self.wineCountLabel.text = [NSString stringWithFormat:@"%ld", self.wine.count];
    
    // 同样, 要保证removeButton在cell重用的时候依然保持与数据同步
    self.removeButton.enabled = self.wine.count > 0;
    
    /*
     可以得出结论, 当前页面显示数据正确但是当上下滑tableView的时候发现数据显示不正确, 那么就是在设置数据的方法中（这里是setWine:方法）没有进行数据更新. 因为这个方法每次cell重用再出现的时候就会被调用（在cellForRowAtIndexPath方法中会调用这个方法）, 所以只修改当前看到的界面是不够的, 还要保证cell重用后数据设置依然正确.
     */
}

#pragma mark - action methods

- (IBAction)addWine:(id)sender
{
    NSInteger oldValue = self.wine.count;
    
    // 通过修改模型数据更改view的显示, 不可以直接修改view.
    // 之前在VC中修改模型数据后更新tableView, 但是此时是在cell中修改模型数据, 所以不能再刷新tableView, 而是修改对应的控件.
    self.wine.count ++;
    
    self.wineCountLabel.text = [NSString stringWithFormat:@"%ld", self.wine.count];
    
    // 当self.removeButton不可用并且在点击添加按钮的时候, 将设置removeButton可用.
    if (!self.removeButton.enabled) {
        self.removeButton.enabled = YES;
    }
    
    // 添加之后回调这个block, 传回self.wine.count在添加前的值和添加后的值以及对应的wine.
    self.wineCellDidSelected(oldValue, self.wine.count, self.wine);
    
}

- (IBAction)removeWine:(id)sender
{
    NSInteger oldValue = self.wine.count;
    
    self.wine.count --;
    
    self.wineCountLabel.text = [NSString stringWithFormat:@"%ld", self.wine.count];
    
    // 当self.wine.count的个数 == 0的时候, 设置removeButton不可再点击.
    self.removeButton.enabled = self.wine.count > 0;
    
    // 移除后回调这个block, 传回self.wine.count在移除前的值和移除后的值以及对应的wine.
    self.wineCellDidSelected(oldValue, self.wine.count, self.wine);
}


@end
