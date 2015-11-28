//
//  ViewController.m
//  JYConnectionUpLoad
//
//  Created by joyann on 15/11/9.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"

/*
 上传文件步骤:
 1.设置请求头
 Content-Type:multipart/form-data; boundary=----WebKitFormBoundarygSvklWjpcBBprQ0A
 2.设置请求体
 按照固定的格式来拼接
 ------WebKitFormBoundarygSvklWjpcBBprQ0A
 Content-Disposition: form-data; name="file"; filename=""
 Content-Type: application/octet-stream
 
 文件参数
 ------WebKitFormBoundarygSvklWjpcBBprQ0A
 Content-Disposition: form-data; name="username"
 
 xiaomage
 ------WebKitFormBoundarygSvklWjpcBBprQ0A--
 
 简化拼接格式:
 分隔符:----WebKitFormBoundarygSvklWjpcBBprQ0A
 1.拼接文件参数:
 --分隔符
 Content-Disposition: form-data; name="file"; filename="123.png"
 Content-Type: application/octet-stream
 空行
 文件参数
 
 2.拼接非文件参数:
 --分隔符
 Content-Disposition: form-data; name="username"
 空行
 xiaomage
 3.结尾标识
 --分隔符--
 */

/*
 
 文件上传应该以`POST`的方式，将`上传请求`设置为`请求头`，将`上传数据`设置为`请求体`.格式固定，不要少写符号和空格.
 
 */

static NSString * const JYUpLoadBoundary = @"WebKitFormBoundarySlmARvX5fycie0mq";
static NSString * const JYUpLoadURLString = @"http://120.25.226.186:32812/upload";
static NSString * const JYFileName = @"hello.png";
static NSString * const JYUserName = @"joyann";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:JYUpLoadURLString]];
    // 设置请求头 -> 此次请求为上传文件
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=----%@", JYUpLoadBoundary] forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    // 拼接二进制数据
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
    UIImage *image = [UIImage imageNamed:@"hello"];
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
    
    request.HTTPBody = fileData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    }];
    
}

@end
