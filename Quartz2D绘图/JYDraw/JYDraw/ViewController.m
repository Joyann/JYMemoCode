//
//  ViewController.m
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "JYDrawCircleViewController.h"
#import "JYPieViewController.h"
#import "SnowViewController.h"
#import "JYSnowViewController.h"
#import "JYWaterMarkViewController.h"
#import "JYCirclePhotoViewController.h"
#import "JYCirclePathWithBorderViewController.h"
#import "JYClipScreenViewController.h"
#import "JYSelectClipViewController.h"
#import "JYClearViewController.h"

static NSString * const JYCellIdentifier = @"JYCellIdentifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[@{@"title": @"绘制进度条", @"description": @"根据slider变化改变进度条进度"},
                   @{@"title": @"绘制饼状图", @"description": @"根据提供的数据画出对应的饼状图"},
                   @{@"title": @"绘制一片雪花", @"description": @"实现一片雪花移动效果"},
                   @{@"title": @"绘制多片雪花", @"description": @"实现多片雪花移动效果"},
                   @{@"title": @"绘制图片水印", @"description": @"实现给图片添加水印效果"},
                   @{@"title": @"裁剪圆形图片", @"description": @"将一张图片裁剪为圆形图片"},
                   @{@"title": @"裁剪有边框的圆形图片", @"description": @"将一张图片裁剪为带边框的圆形图片"},
                   @{@"title": @"截屏", @"description": @"将屏幕上的imageView截屏并保存到桌面"},
                   @{@"title": @"选择区域截屏", @"description": @"选择区域进行截屏"},
                   @{@"title": @"擦除区域", @"description": @"清除上层图片中涂抹的区域"}];
    
    // 添加tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 70.0;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    // 给tableView添加约束
    [self addConstrains];
}

#pragma mark - Add Constrains

- (void)addConstrains
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:JYCellIdentifier];
    NSDictionary *item = self.items[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"description"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            JYDrawCircleViewController *drawCircleVC = [[JYDrawCircleViewController alloc] init];
            [self.navigationController pushViewController:drawCircleVC animated:YES];
            break;
        }
        case 1:
        {
            JYPieViewController *pieVC = [[JYPieViewController alloc] init];
            [self.navigationController pushViewController:pieVC animated:YES];
            break;
        }
        case 2:
        {
            SnowViewController *snowVC = [[SnowViewController alloc] init];
            [self.navigationController pushViewController:snowVC animated:YES];
            break;
        }
        case 3:
        {
            JYSnowViewController *snowVC = [[JYSnowViewController alloc] init];
            [self.navigationController pushViewController:snowVC animated:YES];
            break;
        }
        case 4:
        {
            JYWaterMarkViewController *waterMarkVC = [[JYWaterMarkViewController alloc] init];
            [self.navigationController pushViewController:waterMarkVC animated:YES];
            break;
        }
        case 5:
        {
            JYCirclePhotoViewController *circlePhotoVC = [[JYCirclePhotoViewController alloc] init];
            [self.navigationController pushViewController:circlePhotoVC animated:YES];
            break;
        }
        case 6:
        {
            JYCirclePathWithBorderViewController *circleWithBorderVC = [[JYCirclePathWithBorderViewController alloc] init];
            [self.navigationController pushViewController:circleWithBorderVC animated:YES
             ];
            break;
        }
        case 7:
        {
            JYClipScreenViewController *clipScreenVC = [[JYClipScreenViewController alloc] init];
            [self.navigationController pushViewController:clipScreenVC animated:YES];
            break;
        }
        case 8:
        {
            JYSelectClipViewController *selectedClipVC = [[JYSelectClipViewController alloc] init];
            [self.navigationController pushViewController:selectedClipVC animated:YES];
            break;
        }
        case 9:
        {
            JYClearViewController *clearVC = [[JYClearViewController alloc] init];
            [self.navigationController pushViewController:clearVC animated:YES];
            break;
        }
        default:
            break;
    }

}

@end
