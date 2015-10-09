//
//  ViewController.m
//  UITableViewByFrame
//
//  Created by joyann on 15/9/30.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "JYTableViewCell.h"
#import "MJExtension.h"
#import "JYShop.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface ViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *shops;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 100;
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
    JYTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[JYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    /*
     用代码来实现UITableView共有两种方式:
     1. 像现在这样, 当cell为nil的时候表示对象池中没有可以重用的cell, 那么就创建一个新的. 
        注意这里只能使用initWithStyle:reuseIdentifier:方法, 因为这个方法可以给cell绑定一个重用标识, 如果直接用alloc-init方法则不会绑定, 那么重用的时候(dequeue)永远都找不到可重用的cell.(找不到相同的identifier的cell)
        另外,自定义cell不同于其他自定义控件.其他自定义控件如果用代码的方式创建那么最终都会调用initWithFrame:方法, 而自定义cell则不会调用initWithFrame:方法, 而是会调用initWithStyle:reuseIdentifier:方法.这也说明如果用代码的方式使用cell,需要添加子控件, 应该重写UITableViewCell的initWithStyle:reuseIdentifier:,而不是initWithFrame:方法.
     2. 第二种方式则是提前注册一个自定义cell, 这样当重用的时候如果对象池中没有可重用的cell, 那么tableView就会自动创建一个我们之前注册的类型的cell.
        注册方法：
         [self.tableView registerClass:[JYTableViewCell class] forCellReuseIdentifier:CellIdentifier];
        之后if(!cell){}这些代码就不必写了, 因为现在tableView会自动帮我们创建cell, 我们不必再手动来写.
        注意, 如果用registerClass:forCellReuseIdentifier:,tableView帮我们创建cell的时候调用的也是initWithStyle:reuseIdentifier:.就相当于第一种方式我们写的代码, 但是是由tableView自动帮我们写上的.
        所以这意味着, 如果是用代码方式创建使用cell, 那么添加子控件以及一些初始化操作就是在initWithStyle:reuseIdentifier:而不是initWithFrame:(其他控件).
     */
    
    /*
     ******************************* 最后的总结 *******************************
     总结用代码方式创建使用cell:
     1. 在tableView:CellForRowAtIndexPath:中设置好创建重用cell(手动实现创建cell或者注册cell两种方式)
     2. 重写cell的initWithStyple:reuseIdentifier:方法, 进行添加子控件和一些初始化等操作.
     3. 在cell的layoutSubviews方法中设置frame或者添加约束.
     4. 在cell的模型属性的setter方法中给各个子控件添加数据.
     */
    JYShop *shop = self.shops[indexPath.row];
    cell.shop = shop;
    
    return cell;
}

@end
