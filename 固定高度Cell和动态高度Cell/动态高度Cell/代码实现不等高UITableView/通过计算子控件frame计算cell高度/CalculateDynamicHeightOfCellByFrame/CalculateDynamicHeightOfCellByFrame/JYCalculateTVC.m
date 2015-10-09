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
    /* 
     1. 动态计算cell高度的第一种想法：
    拿到cell,通过cell找到和cell高度相关的子控件(在.h文件中暴露这些子控件这样外面就可以拿到),然后在tableView:heightForRowAtIndexPath:中计算它们的高度.
    JYStatusCell *cell = (JYStatusCell *)[tableView cellForRowAtIndexPath:indexPath];
     但是这种方法是不行的，因为在发送cellForRowAtIndexPath:的时候也会调用tableView:heightForRowAtIndexPath:方法，这样造成了死循环.
     
     2. 动态计算cell高度的第二种想法：
     在JYStatus中增加一个cellHeight属性用来保存这个JYStatus对象对应的JYStatusCell显示的高度.
     在JYStatusCell中当所有控件的frame计算完，定义一个变量来计算这些控件最大的y值 + spacing就是cell的高度,然后将这个变量赋值给cellHeight(在JYStatusCell中的layoutSubviews方法的后面：self.status.cellHeight = 计算出的值).
     接着在这个方法中拿到对应的status:
     JYStatus *status = self.statuses[indexPath.row];
     最后返回status.cellHeight.
     看起来没有问题,但是也是行不通的.
     因为heightForRowAtIndexPath:方法是在JYStatusCell的layoutSubviews方法之前调用的,也就是说每个cell都是先调用heightForRowAtIndexPath:方法,然后再去显示各个cell的内容(tableView:cellForRowAtIndexPath:方法),在这个方法里才会调用JYStatusCell中的各个方法,包括layoutSubviews方法.所以在heightForRowAtIndexPath:方法中拿到的status.cellHeight实际上并没有计算出来,因为计算cellHeight是JYStatusCell的layoutSubviews方法,此时这个方法还未执行.所以这样做也是不行的.
     
     3. 动态计算cell高度的第三种想法：
     根据第2个方法可以知道必须要在返回高度前就已经计算好高度.
     麻烦的方法是在tableView:heightForRowAtIndexPath:重新计算和cell高度相关的控件的高度(只需要高度不需要其他),然后返回计算出的正确的值.
     和本例cell的高度相关的控件有：iconImgaeView, contentLabel, contentImageView(如果有)
     所以需要在tableView:heightForRowAtIndexPath:重新计算这三个控件的高度.
     */
    
    JYStatus *status = self.statuses[indexPath.row];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat spacing = 10;
    CGFloat iconImageViewWH = 60;
    CGFloat contentImageViewWH = 100;
    // 计算iconImageView的高度
    CGFloat iconImgaeViewH = iconImageViewWH;

    // 计算contentLabel的高度
    CGSize constraintSize = CGSizeMake(width - 2 * spacing, MAXFLOAT);
    CGRect contentLabelRect = [status.text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:15] } context:nil];
    CGFloat contentLabelH = contentLabelRect.size.height;
    
    CGFloat contentImageViewH = contentImageViewWH;
    
    CGFloat cellHeight = 0;
    if (status.picture) {
        cellHeight = iconImgaeViewH + contentLabelH + contentImageViewH + 4 * spacing;
    } else {
        cellHeight = iconImgaeViewH + contentLabelH + 3 * spacing;
    }
    
    return cellHeight;
}

@end
