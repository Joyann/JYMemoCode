//
//  JYConnectionPostViewController.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/6.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYConnectionPostViewController.h"

/*
    POST和GET的选择：GET请求相对来说并不安全（信息暴露在URL中）, 并且发送的请求参数长度有限制.POST则安全一些, 并且没有限制, 但是相对来说`重`一些, 所以如果是简单的获取数据可以使用GET请求, 若是安全相关或者数据量大则使用POST.
    使用NSURLConnection发送POST请求与发送GET请求的几种方法一致, 但是发送POST请求因为信息不暴露在url中，所以需要设置`请求头`和`请求体`, 并且要修改请求方式为`POST`(默认为`GET`).
    记得要将NSURLRequest改为`NSMutableURLRequest`,否则无法更改其属性.
 */

static NSString * JYBaseURLString = @"http://120.25.226.186:32812/login";

@interface JYConnectionPostViewController () <NSURLConnectionDataDelegate>

@end

@implementation JYConnectionPostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"发送GET请求";
    
    [self usingDelegate];
}

#pragma mark - POST

- (void)sendSync
{
    NSURL *url = [NSURL URLWithString:JYBaseURLString];
    // 注意,这里要创建`可变请求对象`,否则无法修改其属性
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 修改请求方式 默认GET请求
    request.HTTPMethod = @"POST";
    // 设置请求超时
    request.timeoutInterval = 10.0;
    // 设置请求头 注意这里的header field是固定的 不可以随意填写
    [request setValue:@"iOS 9.0" forHTTPHeaderField:@"User-Agent"];
    // 设置请求体 因为在创建request的时候已经绑定baseURL,所以在设置请求体的时候只需传入参数,会自动加上`?`
    request.HTTPBody = [@"username=t&pwd=t" dataUsingEncoding:NSUTF8StringEncoding];
    NSHTTPURLResponse *response = nil;
    // 同步执行 阻塞主线程
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSLog(@"response: %@ \n result: %@", response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)sendAsync
{
    NSURL *url = [NSURL URLWithString:JYBaseURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    [request setValue:@"iOS 9.0" forHTTPHeaderField:@"User-Agent"];
    request.HTTPBody = [@"username=t&pwd=t" dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"response: %@ \n result: %@", response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

- (void)usingDelegate
{
    NSURL *url = [NSURL URLWithString:JYBaseURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 更改请求方式
    request.HTTPMethod = @"POST";
    // 设置请求超时
    request.timeoutInterval = 10.0;
    // 设置请求头
    [request setValue:@"iOS 9.0" forHTTPHeaderField:@"User-Agent"];
    // 设置请求体
    request.HTTPBody = [@"username=t&pwd=t" dataUsingEncoding:NSUTF8StringEncoding];
    // 1.第一种方式设置代理
//    [NSURLConnection connectionWithRequest:request delegate:self];
    // 2.第二种方式设置代理
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [connection start];
    // 3.第三种方式设置代理
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection start];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response: %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"result: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"完成接收数据");
}

@end
