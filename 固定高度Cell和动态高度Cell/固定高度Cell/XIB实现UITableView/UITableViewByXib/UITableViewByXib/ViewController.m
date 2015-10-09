//
//  ViewController.m
//  UITableViewByXib
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
    
    // 第二种方式创建cell
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYTableViewCell class]) bundle:nil] forCellReuseIdentifier:CellIdentifier];
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
 和用纯代码创建使用cell一样, 使用xib创建使用cell也有两种方式.
    第一种方式:
        在tableView:cellForRowAtIndexPath:中判断cell是否为nil,如果为nil,那么就加载设置好的对应的xib文件来创建一个新的cell.原理其实都是一样的,那就是先去对象池中找没有没可复用的cell,如果有直接用,如果没有就创建.(可以是之前讲过的用纯代码创建cell,也可以是现在这样用xib创建cell).
        注意此时在xib文件中也要设置identifier.
        在xib文件中可以添加子控件并且添加约束,这样就省去了纯代码创建时在initWithStyle:reuseIdentifier:和layoutSubviews中做的事,只需要在对应的cell类中设置模型属性的setter方法直接给各个控件添加数据即可.
        注意此时不会再调用cell的initWithStyle:reuseIdentifier:了.

    第二种方式:
        和用纯代码的第二种方式一样,提前注册对应的cell类.不过因为这次并不是用纯代码来创建cell, 所以不应该使用registerClass:ForCellReuseIdentifier:注册, 而是应该用对应xib的registerNib:ForCellReuseIdentifier:来注册.用这种方式也会首先去对象池找有没有可复用的cell, 如果有直接用, 如果没有tableView会根据之前注册的cell的类自动创建一个新的cell.就相当于自动帮我们写上了第一种方式那样需要我们自己写的代码.
        注意此时不会再调用cell的initWithStyle:reuseIdentifier:了.
 
 在使用xib的时候要注意, xib中所见的cell的高度并不是真实的高度, 真实的高度需要我们自己设置. 只需设置cell的高度, 因为在xib中设置了约束, 那么子控件就会根据cell的尺寸和约束放到合适的位置.
 
 ** 如果在xib中没有设置identifier, 会发现显示的结果依然正确, 但事实上某些情况下cell并未进行真正的重用.
    如果使用的是loadNibNamed:的方式, tableView首先去对象池找是否有可重用的对象, 如果没有, 我们用loadNibName:这种方式加载xib来创建一个cell, 注意在loadNibNamed:方法中并没有给这个cell绑定一个identifier, 那么当cell要进行重用的时候, 会去对象池中找对应identifier的cell, 而用loadNibNamed:又没有绑定, 那么只能依赖xib中设置的identifier来找.所以如果在xib中也不设置, 那么tableView拿着identifier去找, 但是发现并没有相同的identifier可重用对象(因为创建cell的时候无法绑定identifier,只能靠加载xib中设置的identifier来绑定, 而此时又没有设置xib中的identifier),那么就会创建新的cell, 所以cell并未真正重用.
    如果使用的是register的方式, 可以发现在register的时候已经绑定了identifier, 所以xib中即使不设置identifier也不会有问题, 并且cell成功复用.可以打印cell的地址验证.
    但是我们并不确定是用loadNibNamed(xib必须设置identifier)还是用register(可以不设置)来加载的xib文件, 所以最好的办法就是xib无论在哪种情况下都设置identifier.如果使用register的方式, 要保证xib中的identifier和register的identifier一致, 否则会报错.
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 第一种方式创建cell
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYTableViewCell class]) owner:nil options:nil] firstObject];
    }
    NSLog(@"%p", cell);
    cell.shop = self.shops[indexPath.row];
    return cell;
}

@end
