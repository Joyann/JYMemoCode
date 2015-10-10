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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 80.0;
    
    // 在NSNotificationCenter注册本类监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wineCellClickedAddButton:) name:JYWineCellAddNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wineCellClickedRemoveButton:) name:JYWineCellRemoveNotification object:nil];
}

#pragma mark - handle notification methods

- (void)wineCellClickedAddButton: (NSNotification *)notification
{
    // notification.object是指发送消息的对象
    JYWineCell *cell = (JYWineCell *)notification.object;
    // 根据cell找到对应wine设置UI
    NSInteger price = self.sumPriceLabel.text.integerValue + cell.wine.money.integerValue;
    self.sumPriceLabel.text = [NSString stringWithFormat:@"%ld", price];
    // 设置settleAccountsButton
    if (!self.settleAccountsButton.enabled) {
        self.settleAccountsButton.enabled = YES;
    }
    // 加入购物车
    if (![self.shoppingCar containsObject:cell.wine]) {
        [self.shoppingCar addObject:cell.wine];
    }
}

- (void)wineCellClickedRemoveButton: (NSNotification *)notification
{
    // notification.object是指发送消息的对象
    JYWineCell *cell = (JYWineCell *)notification.object;
    // 根据cell找到对应wine设置UI
    NSInteger price = self.sumPriceLabel.text.integerValue - cell.wine.money.integerValue;
    self.sumPriceLabel.text = [NSString stringWithFormat:@"%ld", price];
    // 设置settleAccountsButton
    self.settleAccountsButton.enabled = self.sumPriceLabel.text.integerValue > 0;
    // 从购物车移除
    if ([self.shoppingCar containsObject:cell.wine]) {
        [self.shoppingCar removeObject:cell.wine];
    }
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
