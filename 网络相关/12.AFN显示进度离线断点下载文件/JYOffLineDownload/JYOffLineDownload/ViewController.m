//
//  ViewController.m
//  JYOffLineDownload
//
//  Created by joyann on 15/11/13.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

/*
 使用dataTask比downloadTask更易实现`离线下载`.但是缺点是下载文件以及进度等都需要我们自己来计算.
 */

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

static NSString * const JYDownloadURLString = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";
static NSString * const JYFileName = @"minion_02.mp4";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSOutputStream *stream;

@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger currentSize;

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, copy) NSString *fullPath;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)dealloc
{
    [self.stream close];
    self.stream = nil;
}

#pragma mark - Lazy Loading

- (NSURLSessionDataTask *)dataTask
{
    if (!_dataTask) {
        _dataTask = [[NSURLSessionDataTask alloc] init];
    }
    return _dataTask;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
    }
    return _sessionManager;
}

- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
        self.fullPath = [CachePath stringByAppendingPathComponent:JYFileName];
    }
    return _fileManager;
}

#pragma mark - Actions

- (IBAction)startDownload:(id)sender
{
    if (self.dataTask.state == NSURLSessionTaskStateSuspended) {
        [self startTask];
        [self.startButton setTitle:@"停止下载" forState:UIControlStateNormal];
    } else if (self.dataTask.state == NSURLSessionTaskStateRunning) {
        [self.dataTask suspend];
        [self.startButton setTitle:@"开始下载" forState:UIControlStateNormal];
    }
}

- (void)startTask
{
    // 当离线的时候，获得已经下载的文件大小来设置下一次请求的数据大小
    NSDictionary *attributes = [self.fileManager attributesOfItemAtPath:self.fullPath error:nil];
    NSInteger downloadedDataSize = [attributes[@"NSFileSize"] integerValue];
    self.currentSize = downloadedDataSize;
    // 设置每次请求的数据大小
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:JYDownloadURLString]];
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    self.dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        // 下载完成
        NSLog(@"下载成功");
    }];
    
    [self receiveResponse];
    [self writeData];
    
    [self.dataTask resume];
}

- (void)receiveResponse
{
    __weak typeof (self) weakSelf = self;

    [self.sessionManager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        // 因为暂停/离线的原因，task每次请求的大小不一定都是文件总大小，所以此时的总大小应该是此次请求 + 当前的大小.
        weakSelf.totalSize = response.expectedContentLength + self.currentSize;
        
        NSOutputStream *stream = [[NSOutputStream alloc] initToFileAtPath:weakSelf.fullPath append:YES];
        weakSelf.stream = stream;
        [stream open];
        // 接收到响应
        return NSURLSessionResponseAllow;
    }];
}

- (void)writeData
{
    __weak typeof (self) weakSelf = self;
    
    [self.sessionManager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        // 设置当前的文件大小
        weakSelf.currentSize += data.length;
        // 设置下载进度
        CGFloat progress = 1.0 * self.currentSize / self.totalSize;
        weakSelf.progressView.progress = progress;
        // 将数据写入沙盒
        [weakSelf.stream write:data.bytes maxLength:data.length];
    }];
}

@end
