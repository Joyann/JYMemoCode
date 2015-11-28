//
//  ViewController.m
//  JYAFNUpload
//
//  Created by joyann on 15/11/10.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

/*
 这里提供了三种使用AFN上传文件的方法：
 1. 使用sessionManager直接POST，这种方式最简单，但是缺点是不能得到下载进度. 使用GET/POST这种方式都很简单，但是拿到的都是整个data，也就是说`只能得到结果，但是不知道过程`.要想更`高级`的下载，则可以在sessionManager的基础上创建`downloadTask`.
 2. 使用session和uploadTaskWithRequest创建一个uploadTask，此时可以拿到进度，但是设置起来很复杂.
 3. 通过multipartFormRequestWithMethod设置request，再通过uploadTaskWithStreamedRequest来创建一个uploadTask任务，这种方式避免了拼接字符串，并且可以得到上传进度.
 */

static NSString * const JYUpLoadBoundary = @"WebKitFormBoundarySlmARvX5fycie0mq";
static NSString * const JYUpLoadURLString = @"http://120.25.226.186:32812/upload";
static NSString * const JYFileName = @"1";
static NSString * const JYUserName = @"joyann";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)upload:(id)sender
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager POST:JYUpLoadURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *image = [UIImage imageNamed:@"1"];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"1.png" mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)uploadWithProgress:(id)sender
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:JYUpLoadURLString]];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=----%@", JYUpLoadBoundary] forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    
    NSMutableData *fileData = [NSMutableData data];
    NSString *boundaryString = [NSString stringWithFormat:@"------%@", JYUpLoadBoundary];
    [fileData appendData:[boundaryString dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *contentDisposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.png\"", JYFileName];
    [fileData appendData: [contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *contentType = @"Content-Type: application/octet-stream"; //默认文件为`通用格式`
    [fileData appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 上传的文件的二进制数据
    UIImage *image = [UIImage imageNamed:@"1"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [fileData appendData:imageData];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [fileData appendData:[boundaryString dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"Content-Disposition: form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [fileData appendData:[JYUserName dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [fileData appendData:[[NSString stringWithFormat:@"------%@--", JYUpLoadBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [sessionManager uploadTaskWithRequest:request fromData:fileData progress:&progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", responseObject);

    }];
    
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:nil];
    
    [uploadTask resume];
}
- (IBAction)uploadFile:(id)sender
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [sessionManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:JYUpLoadURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *image = [UIImage imageNamed:@"1"];
        NSData *imageData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"1.png" mimeType:@"image/png"];
    } error:nil];
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [sessionManager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", responseObject);
    }];
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:nil];
    [uploadTask resume];
}

#pragma mark - Get Progress -> KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSProgress *)progress change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"%f",1.0 * progress.completedUnitCount / progress.totalUnitCount);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
    });
}

@end
