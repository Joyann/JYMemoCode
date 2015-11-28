//
//  ViewController.m
//  JYDownloadImagesAsync
//
//  Created by joyann on 15/11/3.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "JYApp.h"

/*
 
 UITableView中每个cell都要显示从网络加载的图片，异步下载，并且在cache文件夹有缓存.
 
 思路：
      1. 首先应该设置异步加载图片，这里使用的是NSOperation + NSOperationQueue
      2. 当cell加载图片的时候，首先应该现在`内存缓存`中查找，如果没有，则去`沙盒缓存(cache文件夹)`中寻找，如果没有，再去网络下载.
         内存缓存使用一个NSMutableDictionary来存储下载好的图片.当图片下载好了之后，就将图片加到内存缓存中.
         沙盒缓存是将下载好的图片写入到cache文件夹
      3. 在cellForRowAtIndexPath方法中直接`cell.imageView.image = image`，如果这样写会发现程序刚开始是不会有任何图片的，只有滚动tableView进行刷新的时候才会有图片. 这是因为，在刚开始的时候，每个cell对应的cellForRowAtIndexPath方法中cell.imageView是不会显示的，因为image正在下载，cell.imageView.image还没有被赋值，所以cell.imageView不会显示，也就是说imageView的尺寸是0. 当image下载完毕，将执行`cell.imageView.image = image`操作，但是cell.imageView尺寸为0，所以图片不会显示出来. 当滚动tableView，cell将重新刷新，此时已有图片缓存，cell刷新的时候image有值，cell.imageView的尺寸也将不再是0，每个cell的图片将被正常显示.
          解决办法：在刷新的时候image将要去下载，此时我们应该设置cell.imageView的占位图片，这样保证第一次刷新的时候imageView是有尺寸的，这样当image下载完毕，就将赋值给这个尺寸的imageView.注意，如果占位图片的大小和下载的图片大小不一致，那么当图片下载完毕，图片会被显示为占位图片的大小，因为imageView就是占位图片的大小. 再刷新tableView发现image大小显示正常，因为cell刷新的时候image有值，就被直接正确的显示在imageView中.
          当然前面所说的都是因为使用的是`cell.imageView.image = image`，如果使用`reloadRowsAtIndexPaths`，每次下载好新的图片重新刷新cell就不会有这种情况了.
      4. 在cellForRowAtIndexPath方法中直接给`cell.imageView.image = image`这样赋值是有问题的. 因为在最开始在网络下载图片的时候，以第一行cell为例，它会在网络中加载图片，如果此时网速并不快，那么需要耗时下载，此时如果滚动tableView，第一行cell从屏幕上消失被放到缓存池中，那么在以后出现的cell中就会重用这个cell，而这时候第一行cell的图片下载好了，因为使用的是给cell.imageView.image直接赋值，那么系统会找到这个cell对象，给这个cell的imageView赋值（也就是说，即使cell被重用了，地址依然是不变的，那么当时的赋值操作在图片下载好了之后依旧会找到这个cell进行赋值，哪怕cell已经被重用）。所以现在如果在加载图片的时候快速滚动tableView，就会发现有些图片莫名其妙的被赋值给了不和它对应的cell上。如果再刷新，可能又会恢复回来，因为这个cell的图片下载好了将旧的图片覆盖了。要解决这个bug很简单，只要我们不直接给cell的imageView赋值，而是只刷新这一行的cell，那么就会重新调用cellForRowAtIndexPath方法，在这个方法中会找到当前这个cell对应的模型，也就是找到对应的图片，这样就可以正确显示了.
      5. 如果网速很慢，并且快速滚动tableView，会发现`有很多重复的操作被加到队列中`.这是因为，当图片在下载还未完成的时候是不会被加到缓存中的，当再次刷新到这行cell的时候发现缓存中没有图片，又会将任务加到队列中，也就是说，如果一直滚动tableView，只有图片下载好了之后加到缓存里下次任务才不会再次加到队列中.
         解决办法：我们可以将`操作`进行内存缓存，这样当下载的时候就将`操作`加到内存缓存中，下次刷新的时候如果缓存中有这个操作则不再添加.当图片成功下载后就将`操作`从内存缓存中移除.这样保证一个队列中不会有两个相同的任务.
                 要注意如果imageData没有获取成功，此时已经将`操作`加入到内存缓存中了，所以要先将`操作`先从缓存中移除，然后使用return结束当前方法.这样下次刷新的时候在缓存中没有这个操作才会去重新获取imageData. 如果不移除，那么当前imageData没有值但是这个操作已经在缓存中，下次刷新也不会去重新获得imageData了.
 
 */

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSArray *apps;

// 内存缓存
@property (nonatomic, strong) NSMutableDictionary *imagesCache;

// 操作缓存
@property (nonatomic, strong) NSMutableDictionary *operationsCache;

// 并发队列 不必每次刷新cell的时候都会新建一个queue
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.imagesCache = nil;
    self.operationsCache = nil;
    [self.queue cancelAllOperations];
}

#pragma mark - Getter Methods

- (NSOperationQueue *)queue
{
    if (!_queue) {
        // 创建并发队列
        _queue = [[NSOperationQueue alloc] init];
        // 设置最大并发数
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}

- (NSMutableDictionary *)operationsCache
{
    if (!_operationsCache) {
        _operationsCache = [NSMutableDictionary dictionary];
    }
    return _operationsCache;
}

- (NSMutableDictionary *)imagesCache
{
    if (!_imagesCache) {
        _imagesCache = [NSMutableDictionary dictionary];
    }
    return _imagesCache;
}

- (NSArray *)apps
{
    if (!_apps) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil];
        NSArray *results = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in results) {
            JYApp *app = [JYApp appWithDict:dict];
            [tempArray addObject:app];
        }
        _apps = tempArray;
    }
    return _apps;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYCellIdentifier"];
    
    JYApp *app = self.apps[indexPath.row];
    
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.download;
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fullPath = [cachePath stringByAppendingPathComponent:app.icon.lastPathComponent];
    NSData *cacheData = [NSData dataWithContentsOfFile:fullPath];
    // 首先在内存缓存中查找是否已经下载过图片
    UIImage *memoryImage = [self.imagesCache objectForKey:app.icon.lastPathComponent];
    if (memoryImage) {
        cell.imageView.image = memoryImage;
    } else if (cacheData) { // 如果内存缓存中没有缓存，则去沙盒缓存中读取图片
        UIImage *cacheImage = [UIImage imageWithData:cacheData];
        cell.imageView.image = cacheImage;
    } else { // 如果没有缓存，则去下载图片
        // 添加占位图片
        UIImage *placeholderImage = [UIImage imageNamed: @"placeholderImage"];
        cell.imageView.image = placeholderImage;
        // 检查是否有操作缓存
        NSBlockOperation *cacheOperation = [self.operationsCache objectForKey:app.icon];
        if (!cacheOperation) { // 如果没有则创建一个下载操作，如果有则什么也不做
            // 下载图片
            NSBlockOperation *downloadOperation = [NSBlockOperation blockOperationWithBlock:^{
                NSData *downloadData = [NSData dataWithContentsOfURL:[NSURL URLWithString:app.icon]];
                if (!downloadData) {
                    [self.operationsCache removeObjectForKey:app.icon];
                    return ;
                } else if (downloadData) {
                    UIImage *downloadImage = [UIImage imageWithData: downloadData];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        if (downloadImage) {
                            // 图片下载成功就先加入到内存缓存中
                            [self.imagesCache setObject:downloadImage forKey:app.icon.lastPathComponent];
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            // 将操作从操作缓存中移除
                            [self.operationsCache removeObjectForKey:app.icon];
                        }
                    }];
                    // 因为读写操作也是耗时操作，所以不在主队列中执行
                    // 将图片写入沙盒
                    [downloadData writeToFile:fullPath atomically:YES];
                }
            }];
            
            [self.operationsCache setObject:downloadOperation forKey:app.icon];
            
            [self.queue addOperation:downloadOperation];
        }

    }
    
    return cell;
}


@end
