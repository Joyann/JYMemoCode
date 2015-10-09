//
//  ViewController.m
//  JYCustomTableViewDelete
//
//  Created by joyann on 15/10/8.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "JYWine.h"
#import "JYWineCell.h"

static NSString * const JYWineCellIdentifier = @"JYWineCellIdentifier";
static NSString * const JYWineCellNibName    = @"JYWineCell";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *wines;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  模仿UITableView的indexPathForSelectedRow属性，保存选中的cell的indexPath.
 *  数组，用于表示将要删除的cell的indexPath
 */
@property (nonatomic, strong) NSMutableArray *indexPathForSelectedRow;

@end

@implementation ViewController

#pragma mark - getter methods

- (NSMutableArray *)wines
{
    if (!_wines) {
        // 通过MJExtension将字典 -> 模型
        _wines = [JYWine objectArrayWithFilename:@"wine.plist"];
    }
    return _wines;
}

- (NSMutableArray *)indexPathForSelectedRow
{
    if (!_indexPathForSelectedRow) {
        _indexPathForSelectedRow = [NSMutableArray array];
    }
    return _indexPathForSelectedRow;
}

#pragma mark - view controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:JYWineCellNibName bundle:nil] forCellReuseIdentifier:JYWineCellIdentifier];
    
    // 设置cell的高度
    self.tableView.rowHeight = 80.0;
}

#pragma mark - Actions

- (IBAction)deleteAllSelected:(UIBarButtonItem *)sender
{
    // 1. 第一种方法可以通过遍历整个self.wines来判断，各个wine是否被checked，如果是，那么加入到一个临时数组里，如果不是，则不采取操作。最后在self.wines里面删除这个数组。
    // 这种方法虽然可行，但是明显有效率问题。因为即使只有一个wine被选中，那么也会去遍历整个wines数组。
//    NSMutableArray *tempArray = [NSMutableArray array];
//    for (JYWine *wine in self.wines) {
//        if (wine.isChecked == YES) {
//            [tempArray addObject:wine];
//        }
//    }
//    [self.wines removeObjectsInArray:tempArray];
//    
//    [self.tableView reloadData];
    
    // 2. 第二种方法是模仿Apple在UITableView中的做法。当实现了系统自带的可选中cell的方法，那么这些cell对应的indexPath会被加到UITableView的indexPathForSelectedRow数组中，我们之后可以对这个数组进行操作来进行删除等操作。这里我们模仿Apple的做法，首先定义一个名为indexPathForSelectedRow的可变数组，当点击cell的时候根据wine的checked属性来判断是将这个wine对应的indexPath加入到数组中还是从数组中移除（注意这里直接移除并没有太大关系，因为没有涉及到数据存储，而执行直接从数组中移除的代码之前必然已经执行过将indexPath加入到数组的代码，所以可以保证在移除的时候数组中一定是有这个indexPath的）。我们获得这个数组就可以进行进一步删除操作。
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.indexPathForSelectedRow) {
        [tempArray addObject:self.wines[indexPath.row]];
    }
    [self.wines removeObjectsInArray:tempArray];
    
    [self.tableView deleteRowsAtIndexPaths:self.indexPathForSelectedRow withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 注意这里要将self.indexPathForSelectedRow中的元素移除，否则下次使用的时候上次点击的记录依旧存在会出现错误
    [self.indexPathForSelectedRow removeAllObjects];
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

//    不可以这样做，永远记得view根据model来显示，因为cell的重用，不要直接修改cell的控件
//    JYWineCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.wineCheckedImageView.hidden = !cell.wineCheckedImageView.hidden;

    JYWine *wine = self.wines[indexPath.row];
    wine.checked = !wine.isChecked;
    
    if (wine.checked) { // 如果现在wine是选中的状态，则表示要删除，加入到indexPathForSelectedRow中
        [self.indexPathForSelectedRow addObject:indexPath];
    } else { // 如果现在wine是未选中状态，则从indexPathForSelectedRow中删除表示不被删除
        [self.indexPathForSelectedRow removeObject:indexPath];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}

@end
