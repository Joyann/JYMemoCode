//
//  JYConnectionGetViewController.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/6.
//  Copyright © 2015年 Joyann. All rights reserved.
//

/*
 使用NSURLConnection发送GET请求可分为以下几种方式：
    1. 使用NSURLConnection的类方法sendSync..方法发送请求 -> 同步的方式
    2. 使用NSURLConnection的类方法sendAsync.方法发送请求 -> 异步的方式
    3. 使用NSURLConnection的delegate:
        3.1. 使用NSURLConnection的类方法connectionWithRequest:delegate:设置代理，实现相应的代理方法.
        3.2. 使用NSURLConnection的对象方法initWithRequest:delegate:设置代理，实现相应的代理方法.
        3.3. 使用NSURLConnection的对象方法initWithRequest:delegate:startImmediately:设置代理，由我们自己来决定何时发送请求，YES为马上发送，不设置则不会发送.实现响应的代理方法.
 */

#import "JYConnectionGetViewController.h"

static NSString * JYBaseURLString = @"http://120.25.226.186:32812/login?username=t&pwd=t";

@interface JYConnectionGetViewController () <NSURLConnectionDataDelegate>

@end

@implementation JYConnectionGetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"发送GET请求";
    
    [self usingDelegate];
}

#pragma mark - GET

// 同步的方式发送请求
- (void)sendSync
{
    NSURL *url = [NSURL URLWithString:JYBaseURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    // 同步执行 阻塞主线程
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response: %@ \n body: %@", response, result);
}

// 异步的方式发送请求
- (void)sendAsync
{
    NSURL *url = [NSURL URLWithString:JYBaseURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 注意这个queue并不是sendAsync在哪个队列，而是指后面的block在哪个队列中执行. 如果是耗时操作，可以创建一个并发队列之后在主队列中刷新UI.这里只是打印操作，在主队列中操作即可.
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"response: %@ \n body: %@", response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

// 代理的方式获得数据
- (void)usingDelegate
{
    // 注意，实现的是NSURLConnectionDataDelegate
    NSURL *url = [NSURL URLWithString:JYBaseURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 第一种delegate方式
//    [NSURLConnection connectionWithRequest:request delegate:self];
    // 第二种delegate方式
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [connection start]; // 这里不使用start方法, 并且不用connection指针指向这个对象, 这样也是可以正确发送请求的.
    // 第三种delegate方式
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO]; // 这里如果是NO,那么说明不要立即发送请求,所以需要手动start. 如果是YES, 则不需要start.
    [connection start];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
}

// 注意这个方法可能会调用多次,因为每一次接受的data是有限的,如果数据很大,这个方法会调用多次.此时可以通过定义一个NSMutableData,每次接收到新数据都拼接到mutableData上,当didFinishLoading的时候,mutableData就是完整的数据.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"结束接受数据");
}

@end
