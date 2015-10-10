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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, JYWineCellDelegate>

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
    NSLog(@"***********************************************************************");
    NSLog(@"购买物品名称: %@", wine.name);
    NSLog(@"购买物品单价: %@", wine.money);
    NSLog(@"购买物品数量: %ld", wine.count);
    NSLog(@"---------------------------");
    NSLog(@"总价: %ld", (wine.money.integerValue * wine.count));
    NSLog(@"***********************************************************************");
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
    // 将每一行cell的代理都设置为self
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - JYWineCellDelegate

- (void)wineCellDidClickAddButton:(JYWineCell *)wineCell
{
    // 根据传入的wineCell.wine来设置UI
    NSInteger price = wineCell.wine.money.integerValue;
    self.sumPriceLabel.text = [NSString stringWithFormat:@"%ld", self.sumPriceLabel.text.integerValue + price];
    
    // 设置settleAccountsButton
    if (!self.settleAccountsButton.enabled) {
        self.settleAccountsButton.enabled = YES;
    }
    
    // 首先判断购物车中是否有当前的wine, 若有则不添加, 若没有则添加.
    // 这是为了保证购物车中相同的wine只有一种, 而wine.count是在其他方法中改变的, 保证结果是正确的.
    if (![self.shoppingCar containsObject:wineCell.wine]) {
        [self.shoppingCar addObject:wineCell.wine];
    }
}

- (void)wineCellDidClickRemoveButton:(JYWineCell *)wineCell
{
    // 根据传入的wineCell.wine来设置UI
    NSInteger price = wineCell.wine.money.integerValue;
    self.sumPriceLabel.text = [NSString stringWithFormat:@"%ld", self.sumPriceLabel.text.integerValue - price];
    
    // 设置settleAccountsButton
    self.settleAccountsButton.enabled = self.sumPriceLabel.text.integerValue > 0;
    
    if ([self.shoppingCar containsObject:wineCell.wine]) {
        [self.shoppingCar removeObject:wineCell.wine];
    }
}


@end
