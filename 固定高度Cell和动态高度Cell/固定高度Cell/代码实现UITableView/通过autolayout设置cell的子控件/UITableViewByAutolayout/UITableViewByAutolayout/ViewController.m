//
//  ViewController.m
//  UITableViewByAutolayout
//
//  Created by joyann on 15/9/30.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "JYShop.h"
#import "MJExtension.h"
#import "JYTableViewCell.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSArray *shops;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 100;
    
    // 注册JYTableViewCell
    [self.tableView registerClass:[JYTableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - getter methods

- (NSArray *)shops
{
    if (!_shops) {
        _shops = [JYShop objectArrayWithFilename:@"tgs.plist"];
    }
    return _shops;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    JYShop *shop = self.shops[indexPath.row];
    cell.shop = shop;
    
    return cell;
}


@end
