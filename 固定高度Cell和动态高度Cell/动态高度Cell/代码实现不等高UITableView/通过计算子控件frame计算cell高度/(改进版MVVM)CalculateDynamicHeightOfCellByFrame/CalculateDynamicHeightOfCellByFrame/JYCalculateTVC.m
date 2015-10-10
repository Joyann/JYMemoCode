//
//  JYCalculateTVC.m
//  CalculateDynamicHeightOfCellByFrame
//
//  Created by joyann on 15/9/29.
//  Copyright (c) 2015年 Joyann. All rights reserved.
//

#import "JYCalculateTVC.h"
#import "JYStatus.h"
#import "MJExtension.h"
#import "JYStatusCell.h"

static NSString * const JYStatusCellIdentifier = @"JYStatusCellIdentifier";

@interface JYCalculateTVC ()

@property (nonatomic, strong) NSArray *statuses;

@end

@implementation JYCalculateTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 350;
    
    // 注册自定义cell
    [self.tableView registerClass:[JYStatusCell class] forCellReuseIdentifier:JYStatusCellIdentifier];
}

#pragma mark - getter methods

- (NSArray *)statuses
{
    if (!_statuses) {
        _statuses = [JYStatus objectArrayWithFilename:@"statuses.plist"]; // 用MJExtension将.plish文件中的内容转换成模型数据.
    }
    return _statuses;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:JYStatusCellIdentifier];
    
    cell.status = self.statuses[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYStatus *status = self.statuses[indexPath.row];
    JYStatusCellInfo *cellInfo = [[JYStatusCellInfo alloc] initWithStatus:status];
    // 注意这里也要设置status对应的cellInfo, 这样别人才可以成功访问status.cellInfo.也就是说cell和cellInfo是对应的, 两个对象是对方的一个属性.
    // 首先给cellInfo传入对应的status, 在cellInfo的初始化方法中根据status计算出各个控件的frame以及cellHeight并对外公开. 这里使用初始化方法直接计算, 因为frame和cellHeight只需计算一次而不用每次访问cellHeight的时候都要重新计算.
    // 然后将计算后的cellInfo再赋值回status.(cellInfo先用status计算, 计算之后cellInfo变为status的一个属性供以后使用)
    // 现在有了cell的高度, 接着就会执行数据源方法来显示.
    // 在知道显示多少行后来到cellForRowAtIndexPath这个方法, 首先创建一个cell, 然后来到cell的initWithStyle方法(这里用的代码的方式创建cell), 在这个方法中添加cell子控件, 接着执行cell.status = self.statuses[indexPath.row];这行, 调用setStatus:方法, 在这个方法中给cell的子控件赋值. 现在的情况是知道每一行的cell的高度, 并且知道有什么子控件和子控件显示什么数据, 但是还没有设置子控件的frame. 在layoutSubviews方法中设置子控件frame(因为这个方法在第一次调用的时候是在view即将显示在屏幕的时候, 以后则是frame改变就会调用),此时可以拿到status.cellInfo中计算好的各个控件的frame来进行赋值.现在就可以正确显示了.
    // 方法调用的顺序: heightForRowAtIndexPath -> 返回行数的数据源方法 -> cellForRowAtIndexPath -> cell的initWithStyle -> cell的setStatus: -> layoutSubviews
    status.cellInfo = cellInfo;
    return status.cellInfo.cellHeight;
}

@end
