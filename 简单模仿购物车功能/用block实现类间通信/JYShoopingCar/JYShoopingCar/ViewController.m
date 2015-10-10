//
//  ViewController.m
//  JYShoopingCar
//
//  Created by joyann on 15/10/9.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "JYWine.h"
#import "JYWineCell.h"
#import "MJExtension.h"

static NSString * const JYWineCellIdentifier = @"JYWineCellIdentifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

/**
 *  全部wine数据
 */
@property (nonatomic, strong) NSArray *wines;

/**
 *  用户加入购物车的wines
 */
@property (nonatomic, strong) NSMutableArray *shoppingCar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *sumPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *settleAccountsButton;

@end

@implementation ViewController

#pragma mark - getter methods

- (NSArray *)wines
{
    if (!_wines) {
        _wines = [JYWine objectArrayWithFilename:@"wine.plist"];
    }
    return _wines;
}

- (NSMutableArray *)shoppingCar
{
    if (!_shoppingCar) {
        _shoppingCar = [NSMutableArray array];
    }
    return _shoppingCar;
}

#pragma mark - view controller cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 80.0;
}

#pragma mark - action methods

- (IBAction)settleAccounts:(id)sender
{
    for (JYWine *wine in self.shoppingCar) {
        [self printInfoWithWine:wine];
    }
}

- (IBAction)clearShoppingCar:(id)sender
{
    self.sumPriceLabel.text = [NSString stringWithFormat:@"0"];
    self.settleAccountsButton.enabled = NO;
    
    // 将购物车中的wine的个数设置为0并更新数据
    for (JYWine *wine in self.shoppingCar) {
        wine.count = 0;
    }
    
    [self.tableView reloadData];
    
    // 并且要将购物车清空, 否则之前的wine一直在购物车中, 出现错误
    [self.shoppingCar removeAllObjects];
}

#pragma mark - helper methods

- (void)printInfoWithWine: (JYWine *)wine
{
    NSLog(@"***********************************************************************************");
    NSLog(@"购买物品名称: %@", wine.name);
    NSLog(@"购买物品单价: %@", wine.money);
    NSLog(@"购买物品数量: %ld", wine.count);
    NSLog(@"---------------------------");
    NSLog(@"总价: %ld", (wine.money.integerValue * wine.count));
    NSLog(@"***********************************************************************************");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYWineCell *cell = [tableView dequeueReusableCellWithIdentifier:JYWineCellIdentifier];
    cell.wine = self.wines[indexPath.row];
    
    // 设置block
    // 在添加/移除按钮点击后会回调这个block.
    cell.wineCellDidSelected = ^(NSInteger oldValue, NSInteger newValue, JYWine *wine) {
        if (newValue > oldValue) { // 点击的是添加按钮
            self.sumPriceLabel.text = [NSString stringWithFormat:@"%ld", self.sumPriceLabel.text.integerValue + wine.money.integerValue];
            if (!self.settleAccountsButton.enabled) {
                self.settleAccountsButton.enabled = YES;
            }
            // 点击添加按钮, 如果购物车中没有, 则将对应的wine加到购物车中.如果购物车中有, 它的count已经在其他方法中增加了, 所以这里就不需要我们再管了.这样能保证购物车中正确的wine的数量.
            if (![self.shoppingCar containsObject:wine]) {
                [self.shoppingCar addObject:wine];
            }
        } else { // 点击的是移除按钮
            self.sumPriceLabel.text = [NSString stringWithFormat:@"%ld", self.sumPriceLabel.text.integerValue - wine.money.integerValue];
            self.settleAccountsButton.enabled = self.sumPriceLabel.text.integerValue > 0;
            // 点击移除按钮, 移除购物车中的wine.
            if ([self.shoppingCar containsObject:wine]) {
                [self.shoppingCar removeObject:wine];
            }
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
