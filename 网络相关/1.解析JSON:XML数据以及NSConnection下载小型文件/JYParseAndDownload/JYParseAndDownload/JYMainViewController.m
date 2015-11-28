//
//  JYMainViewController.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/6.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYMainViewController.h"
#import "JYItem.h"
#import "JYConnectionGetViewController.h"
#import "JYConnectionPostViewController.h"
#import "JYLoginViewController.h"
#import "JYParseJSONViewController.h"
#import "JYVideoViewController.h"
#import "JYParseXMLController.h"
#import "JYGDataXMLViewController.h"

static NSString * const JYCellIdentifier = @"JYCellIdentifier";

@interface JYMainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@end

@implementation JYMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addTableView];
    
    self.tableView.rowHeight = 70.0;
}

#pragma mark - Getter Methdos

- (NSArray *)items
{
    if (!_items) {
        _items = @[
                   [JYItem itemWithTitle:@"NSURLConnection发送GET请求" subTitle:@"NSURLConnection发送GET请求"],
                   [JYItem itemWithTitle:@"NSURLConnection发送POST请求" subTitle:@"NSURLConnection发送POST请求"],
                   [JYItem itemWithTitle:@"登录Demo" subTitle:@"用过NSURLConnection发送登录请求"],
                   [JYItem itemWithTitle:@"解析JSON" subTitle:@"没有多少代码，只是解析JSON的小知识"],
                   [JYItem itemWithTitle:@"观看视频,下载视频" subTitle:@"通过NSURLConnection发送请求，可直接观看视频，也可将视频下载下来"],
                   [JYItem itemWithTitle:@"解析XML1" subTitle:@"通过NSXMLParser解析"],
                   [JYItem itemWithTitle:@"解析XML2" subTitle:@"通过GDataXML解析"],
                   ];
    }
    return _items;
}

#pragma mark - Private Methods

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JYCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:JYCellIdentifier];
    }
    JYItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    
    return cell;
}

#pragma mark - UITableViewDelgate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            JYConnectionGetViewController *getVC = [[JYConnectionGetViewController alloc] init];
            getVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:getVC animated:YES];
            break;
        }
        case 1:
        {
            JYConnectionPostViewController *postVC = [[JYConnectionPostViewController alloc] init];
            postVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:postVC animated:YES];
            break;
        }
        case 2:
        {
            JYLoginViewController *loginVC = [[JYLoginViewController alloc] init];
            loginVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:loginVC animated:YES];
            break;
        }
        case 3:
        {
            JYParseJSONViewController *parseJSONVC = [[JYParseJSONViewController alloc] init];
            parseJSONVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:parseJSONVC animated:YES];
            break;
        }
        case 4:
        {
            JYVideoViewController *videoVC = [[JYVideoViewController alloc] init];
            videoVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:videoVC animated:YES];
            break;
        }
        case 5:
        {
            JYParseXMLController *parseXMLVC = [[JYParseXMLController alloc] init];
            parseXMLVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:parseXMLVC animated:YES];
            break;
        }
        case 6:
        {
            JYGDataXMLViewController *gDataXMLVC = [[JYGDataXMLViewController alloc] init];
            gDataXMLVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:gDataXMLVC animated:YES];
            break;
        }
            
        default:
            break;
    }
    
}

@end
