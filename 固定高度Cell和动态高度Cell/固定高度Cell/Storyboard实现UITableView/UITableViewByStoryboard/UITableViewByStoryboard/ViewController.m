//
//  ViewController.m
//  UITableViewByStoryboard
//
//  Created by joyann on 15/9/30.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "JYShop.h"
#import "JYTableViewCell.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSArray *shops;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.tableView.rowHeight = 100.0;
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

/*
    使用Storyboard的方式是最简洁方便的,只需在Storyboard中设置好identifier, 并且我们处理好数据的问题, 其他什么都不用管.
    有一点需要注意的是, 如果使用Storyboard的方式, 又register了一个class/nib的cell文件, 那么会优先经过注册的cell.
    实际上tableView是先看看有没有注册的cell, 如果有则会用这个cell; 如果没有, 则去Storyboard中再找有没有可以使用的cell.
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.shop = self.shops[indexPath.row];
    return cell;
}

@end
