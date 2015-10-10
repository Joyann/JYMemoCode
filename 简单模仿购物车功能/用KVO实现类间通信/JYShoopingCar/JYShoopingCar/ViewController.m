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

#pragma mark - KVO

// KVO的方式是有些问题的. 当点击清空购物车的时候, 需要遍历购物车中的wine, 并将count设置为0, 此时又会触发KVO的监听方法, 因为count设置为0, 所以newValue = 0, 造成newValue < oldValue这种情况, 相当于点击移除按钮, 此时self.sumPriceLabel.text为0, 那么会继续减去wine.money得到负数, 造成错误.

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSInteger newValue = [change[NSKeyValueChangeNewKey] integerValue];
    NSInteger oldValue = [change[NSKeyValueChangeOldKey] integerValue];
    NSInteger price = self.sumPriceLabel.text.integerValue;
    JYWine *wine = (JYWine *)object;
    
    if (newValue > oldValue) { // 点击添加按钮
        self.sumPriceLabel.text = [NSString stringWithFormat:@"%ld", price + wine.money.integerValue];
        if (!self.settleAccountsButton.enabled) {
            self.settleAccountsButton.enabled = YES;
        }
        if (![self.shoppingCar containsObject:wine]) {
            [self.shoppingCar addObject:wine];
        }
    } else { // 点击移除按钮
        self.sumPriceLabel.text = [NSString stringWithFormat:@"%ld", price - wine.money.integerValue];
        self.settleAccountsButton.enabled = self.sumPriceLabel.text.integerValue > 0;
        if ([self.shoppingCar containsObject:wine]) {
            [self.shoppingCar removeObject:wine];
        }
    }
}

#pragma mark - getter methods

- (NSArray *)wines
{
    if (!_wines) {
        _wines = [JYWine objectArrayWithFilename:@"wine.plist"];
        
        // 在获得wines后监听每个wine.count的变化
        for (JYWine *wine in _wines) {
            [wine addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
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

- (void)dealloc
{
    // 移除监听
    for (JYWine *wine in self.wines) {
        [wine removeObserver:self forKeyPath:@"count"];
    }
}

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
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
