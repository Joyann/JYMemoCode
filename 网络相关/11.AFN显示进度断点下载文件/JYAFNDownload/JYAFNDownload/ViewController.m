//
//  ViewController.m
//  JYAFNDownload
//
//  Created by joyann on 15/11/10.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

/*
 在使用AFHttpSessionManager的时候，因为基于NSURLSessionManager：
 一般的请求/小数据下载/解析 -> 使用GET/POST请求 -> 就是使用的NSURLSessionDataTask -> 特点是拿到的data是整个获取的data，不易获得下载/上传进度.
 想要获取下载进度/上传进度/大文件断点 -> 使用downloadTask.../uploadTask... -> 就是使用的NSURLSeesionDownloadTask/NSURLSessionUploadTask(继承自NSURLSessionDataTask)
 上传有两种方式：使用POST或者uploadTask...-> 本质上都是使用的NSURLSessionDataTask
 下载可以直接使用downloadTask... -> 既可以得到下载进度，AFN还自动帮我们下载文件，只需剪切就可以拿到文件
 
 如果不使用AFN，而是使用NSURLSessionManager，此时创建NSURLSessionDownloadTask是不容易完成`离线下载`的，此时应该使用NSURLSessionDataTask.(因为dataTask可以准确的拿到每次的具体数据，这样就可以写在沙盒中，再次运行的时候可以拿到文件大小进行进一步操作完成离线下载；但是downloadTask虽然可以拿到文件的整个数据和每次写入数据的大小，而无法得到每次的数据具体是什么，所以无法写入到文件中来判断已经下载的大小.个人理解,可能不准确)
 如果不使用而是直接使用NSURLSessionManager,一般的请求任务使用manager来创建dataTask/downloadTask就可以完成，如果想得到更多的信息，需要设置manager的delegate，此时又需要一个configuration.(一般情况使用default就可以)
 
 AFN既可以方便的拿到每次数据大小，也可以得到具体的数据.
 */

static NSString * const JYDownloadURLString = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";
static NSString * const JYDOwnloadFileName = @"minion_02.mp4";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic, strong) NSOutputStream *stream;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Getter Methods

- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (NSURLSessionDownloadTask *)downloadTask
{
    if (!_downloadTask) {
        AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
        self.manager = sessionManager;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:JYDownloadURLString]];
        NSProgress *progress = nil;
        __block NSString *pathT = nil;
        __block NSString *fullPathT = nil;
        NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request progress:&progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            pathT = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            fullPathT = [pathT stringByAppendingPathComponent:JYDOwnloadFileName];
            return [NSURL fileURLWithPath:fullPathT];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"下载失败"];
                self.progressView.progress = 0.0;
                self.downloadTask = nil;
                [self.startButton setTitle:@"开始下载" forState:UIControlStateNormal];
                return ;
            }
            [self.startButton setTitle:@"开始下载" forState:UIControlStateNormal];
            self.progressView.progress = 0.0;
            [SVProgressHUD showSuccessWithStatus:@"下载成功"];
        }];
        
        _downloadTask = downloadTask;
        
        [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _downloadTask;
}

#pragma mark - Actions

- (IBAction)startDownload:(id)sender
{
    if (self.downloadTask.state == NSURLSessionTaskStateSuspended) {
        [self.downloadTask resume];
        [self.startButton setTitle:@"暂停下载" forState:UIControlStateNormal];
    } else if (self.downloadTask.state == NSURLSessionTaskStateRunning) {
        [self.downloadTask suspend];
        [self.startButton setTitle:@"继续下载" forState:UIControlStateNormal];
    } else if (self.downloadTask.state == NSURLSessionTaskStateCompleted) {
        self.downloadTask = nil;
        [self.downloadTask resume];
        [self.startButton setTitle:@"暂停下载" forState:UIControlStateNormal];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSProgress *)progress change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.progressView.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
    }];
}

#pragma mark - dealloc

- (void)dealloc
{
    [self.stream close];
    self.stream = nil;
}

@end
