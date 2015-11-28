//
//  ViewController.m
//  JYUsingAFNToGetAndPost
//
//  Created by joyann on 15/11/9.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

/*
 AFN常用的几部分: AFHTTPRequestOperationManager -> 对应NSURLConnection
               AFHTTPSessionManager -> 对应NSURLSeesion
               AFNetworkReachabilityManager -> 网络状态监测
               
 总结：不管是利用AFHTTPRequestOperationManager的GET/POST还是AFHTTPSessionManager的GET/POST都非常简单并且代码非常相似，不管是GET还是POST都将请求参数放入字典中.AFN默认采用JSON的数据格式`自动`解析数据，返回一个名为responseObject的OC对象.如果是XML格式的数据，则responseObject变为一个`parser`对象，此时可以利用苹果提供的NSXMLParser来解析XML数据.相当于如果是JSON格式，AFN帮我们直接解析好，我们只需将OC对象变为模型对象.如果是XML格式，AFN则帮我们创建了一个parser，我们需要设置这个parser的delegate，使用NSXMLParser来解析.如果采用`[AFHTTPResponseSerializer serializer]`这种方式拿到数据，那么此时responseObject变为`data`二进制对象（只要设置了`manager.responseSerializer = [AFHTTPResponseSerializer serializer]`，不管从服务器下载下来的是XML还是JSON格式的数据，得到的都是其对应的二进制data对象），这种方式就变为了`NSURLConnection/NSURLSession`发送网络请求后获得的数据的格式（相当于AFN没有为我们自动解析数据），此时因为拿到的是NSData对象，所以我们有了更灵活的处理方式 -> JSON数据可以使用NSJSONSerializer...XML数据可以使用GData..或者通过data数据创建一个xmlParser...
     如果请求的对象是XML或者不想让其自动解析（想得到NSData），可以通过设置`responseSerializer`来改变解析策略.如果有些请求页面的数据内容AFN不能兼容解析，则可以设置`acceptableContentTypes`让其兼容.
 */

static NSString * const JYURLString = @"http://120.25.226.186:32812/login";

@interface ViewController () <NSXMLParserDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - Actions
- (IBAction)requestOperationGET:(id)sender
{
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    // 请求参数放在字典中
    NSDictionary *parameters = @{
                                 @"username": @"1",
                                 @"pwd": @"2"
                                 };
    [requestManager GET:JYURLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        // responseObject为一个OC字典 -> AFN默认使用JSON格式将数据解析成OC对象.
        NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)requestOperationPOST:(id)sender
{
    // 注意，在使用AFN的时候发送GET请求和发送POST请求几乎一样，不像NSURLConnection/NSURLSession，在发送POST请求的时候需要将request变成mutable，并且要将参数加到请求体中.使用AFN直接将参数放在字典中它就会根据GET/POST请求自动处理.注意，这里得到的responseObject并不像NSURLConnection/NSURLSession那样返回的是二进制数据，需要我们自己来解析数据，这里的responseObject是已经按照JSON的格式解析好的OC对象（在这里是字典）,AFN自动帮我们解析了二进制数据，但是也会产生很多问题：比如得到的数据是XML格式的，AFN默认用的是JSON格式来解析，所以需要我们设置`responseSerializer`为`[AFXMLParserResponseSerializer serializer]`.比如得到的数据格式我们就想要NSData的二进制数据，那么也可以设置`responseSerializer`为`[AFHTTPResponseSerializer serializer]`.如果是XML格式，那么得到的responseObject则变为一个`parser`对象，此时可以定义一个`NSXMLParser`并设置delegate，利用苹果提供的解析XML的方法来处理.
    // 主要有三种解析方式：AFJSONResponseSerializer，AFXMLParserResponseSerializer，AFHTTPResponseSerializer.
    // 如果请求的页面返回的数据格式AFN不能解析，可能会出错，解决方法是让AFN接受新的数据格式，比如是`text/html`：
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"username": @"5",
                                 @"pwd": @"5"
                                 };
    [requestManager POST:JYURLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)sessionGET:(id)sender
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"username": @"1",
                                 @"pwd": @"2"
                                 };
    [sessionManager GET:JYURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (IBAction)sessionPOST:(id)sender
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"username": @"1",
                                 @"pwd": @"2"
                                 };
    [sessionManager POST:JYURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)sessionGETWithXML:(id)sender
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"type": @"XML"
                                 };
    sessionManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [sessionManager GET:@"http://120.25.226.186:32812/video" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 此时得到的responseObject是一个`NSXMLParser`对象,需要设置delegate进行解析
        NSXMLParser *parser = responseObject;
        parser.delegate = self;
        [parser parse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)sessionPOSTWithXML:(id)sender
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"type": @"XML"
                                 };
    sessionManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [sessionManager POST:@"http://120.25.226.186:32812/video" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 此时responseObject为一个`NSXMLParser`对象，需要设置delegate进行解析
        NSXMLParser *parser = (NSXMLParser *)responseObject;
        parser.delegate = self;
        [parser parse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)sessionGETWithData:(id)sender
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager GET:@"http://120.25.226.186:32812/video" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 此时得到的是NSData对象.
        NSData *data = (NSData *)responseObject;
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)sessionPOSTWithData:(id)sender
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"type": @"XML"
                                 };
    [sessionManager POST:@"http://120.25.226.186:32812/video" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 此时得到的是NSData对象.
        NSData *data = (NSData *)responseObject;
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ([elementName isEqualToString:@"videos"]) {
        return;
    }
    NSLog(@"%@", attributeDict);
}

@end
