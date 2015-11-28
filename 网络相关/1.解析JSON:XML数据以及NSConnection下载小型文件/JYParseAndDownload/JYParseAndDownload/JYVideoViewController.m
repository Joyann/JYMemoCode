//
//  JYVideoViewController.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/7.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYVideoViewController.h"
#import "JYVideoTableViewCell.h"
#import "JYVideo.h"
#import "YYModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "JYDownloadButton.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "JYDownloadHelper.h"

/*
 这里使用NSURLConnection的代理，每次获得一些数据就将数据添加到downloadedData中，在所有数据都下载完后，将整个数据写到沙盒中.
 但是这种情况只适用于下载`小文件`(也可以直接在sendAsync的block中拿到数据，比如解析数据的时候用的就是这种方式，当然这种方式要求数据大小应该更小),因为如果文件很大，那么每次下载的数据都会加到内存中，这样会让内存慢慢增大.所以只适用于`小文件`.
 如果是`大文件`,采用的策略是不将数据加到downloadedData属性中，而是拿到一点数据就直接写在沙盒里，具体的代码在`NSConnection大文件下载`程序中.
 */

static NSString * const JYVideoCellIdentifier = @"JYVideoCellIdentifier";
static NSString * const JYVideoBaseURL = @"http://120.25.226.186:32812/video?type=JSON";
static NSString * const JYBaseURL = @"http://120.25.226.186:32812/";

@interface JYVideoViewController () <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, strong) NSMutableData *downloadedData;
@property (nonatomic, assign) NSInteger expectedDataLength;
@property (nonatomic, copy) NSString *suggestedName;
@property (nonatomic, assign) NSInteger downloadedIndex;
@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSMutableArray *downloadIndexs;

@end

@implementation JYVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addTableView];
    
    self.tableView.rowHeight = 70.0;
    self.downloadedIndex = -1;
    
    [self registerCell];
    
    [self loadData];
}

#pragma mark - Getter Methods

- (NSMutableArray *)connections
{
    if (!_connections) {
        _connections = [NSMutableArray array];
    }
    return _connections;
}

- (NSMutableArray *)downloadIndexs
{
    if (!_downloadIndexs) {
        _downloadIndexs = [NSMutableArray array];
    }
    return _downloadIndexs;
}

- (NSArray *)videos
{
    if (!_videos) {
        _videos = [NSArray array];
    }
    return _videos;
}

- (NSMutableData *)downloadedData
{
    if (!_downloadedData) {
        _downloadedData = [NSMutableData data];
    }
    return _downloadedData;
}

#pragma mark - Private Methods

- (void)loadData
{
    NSURL *url = [NSURL URLWithString:JYVideoBaseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // 解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray *videos = dict[@"videos"];
        self.videos = [NSArray yy_modelArrayWithClass:[JYVideo class] json:videos];
        // 刷新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

- (void)registerCell
{
    [self.tableView registerClass:[JYVideoTableViewCell class] forCellReuseIdentifier:JYVideoCellIdentifier];
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)playVideoWithIndexPath: (NSIndexPath *)indexPath
{
    JYVideo *video = self.videos[indexPath.row];
    MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[JYBaseURL stringByAppendingString:video.url]]];

    [self presentMoviePlayerViewControllerAnimated:playerVC];
}

#pragma mark - UITableViewDataStource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JYVideoCellIdentifier];
    JYVideo *video = self.videos[indexPath.row];
    cell.video = video;
    cell.downloadButton.tag = indexPath.row;
    cell.downloadButton.progress = video.progress;
    [cell.downloadButton addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelagate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 播放视频
    [self playVideoWithIndexPath: indexPath];
}

#pragma mark - Download

// 下载视频
- (void)download: (JYDownloadButton *)downloadButton
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadButton.downloadURL]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    if (self.downloadedData.length != 0) { // 当前有任务正在下载
        [SVProgressHUD showInfoWithStatus:@"当前已经有任务正在下载，已加入下载队列"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    } else {
        self.downloadedIndex = downloadButton.tag;
        if (self.connections.count == 0) {
            [connection start];
        }
    }
    
    [self.downloadIndexs addObject:@(downloadButton.tag)];
    [self.connections addObject:connection];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
    self.expectedDataLength = urlResponse.expectedContentLength;
    self.suggestedName = urlResponse.suggestedFilename;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadedData appendData:data];
    NSInteger downloadedDataLength = self.downloadedData.length;
    CGFloat progress = 1.0 * downloadedDataLength / self.expectedDataLength;
    
    JYVideo *video = self.videos[self.downloadedIndex];
    video.progress = progress;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.downloadedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

// 将下载的视频写入沙盒
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fullPath = [path stringByAppendingString:self.suggestedName];
    if ([self.downloadedData writeToFile:fullPath atomically:YES]) {
        [SVProgressHUD showSuccessWithStatus:@"下载完成"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"下载失败"];
    }
    
    // 将connection从connetions移除
    [self.downloadIndexs removeObjectAtIndex:0];
    [self.connections removeObjectAtIndex:0];
    
    if (self.connections != 0) {
        NSURLConnection *connection = (NSURLConnection *)self.connections.firstObject;
        self.downloadedIndex = [self.downloadIndexs.firstObject integerValue];
        [connection start];
        // 将当前下载好的数据清空
        self.downloadedData = nil;
    }
}

@end
