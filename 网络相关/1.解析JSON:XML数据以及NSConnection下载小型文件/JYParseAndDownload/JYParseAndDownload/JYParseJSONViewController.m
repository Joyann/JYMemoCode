//
//  JYParseJSONViewController.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/6.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYParseJSONViewController.h"

@interface JYParseJSONViewController ()

@end

@implementation JYParseJSONViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - JSON -> OC Object

- (void)json2OC
{
    //1.确定url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=adwe&pwd=adad&type=JSON"];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        //4.解析数据
        //直接把json的二进制数据转换为字符串
        /* [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];*/
        
        //使用序列化工具把JSON的二进制数据转换为OC对象
        /*
         NSJSONReadingMutableContainers = (1UL << 0),  可变的数组或者是字典
         NSJSONReadingMutableLeaves = (1UL << 1),  内部的字符串也是可变的  iOS7有问题
         NSJSONReadingAllowFragments = (1UL << 2) 既不是数据也不是字典那么就只能使用这种方法
         */
        /*
         第一个参数:要解析的JSON数据 NSData
         第二个参数:解析可选配置参数 通常为kNilOptions
         第三个参数:错误信息
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict[@"error"]);
    }];
}

#pragma mark - OC Object -> JSON

- (void)OC2Json
{
    //字符串
    NSString *param = @"wqewe3q3eq3eq";
    
    //该方法判断OC对象是否能转换为JSON数据
    BOOL isvalid = [NSJSONSerialization isValidJSONObject:param];
    //需要满足的条件
    /*
     - Top level object is an NSArray or NSDictionary
     最外层的对象必须是字典或者是数组
     - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull
     所有的对象元素必须是NSString, NSNumber, NSArray, NSDictionary, or NSNull
     - All dictionary keys are NSStrings
     字典中所有的key都必须是NSString
     - NSNumbers are not NaN or infinity
     NSNumbers不能为NaN或者是无穷大
     */
    NSLog(@"%d",isvalid);
    
    if (isvalid) {
        /*
         第二个参数:排版
         */
        NSData *data= [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }else
    {
        NSLog(@"不能转换");
    }
    
    /*
     如果是JSON -> OC，那么使用序列化工具的JSONObjectWithData...开头的方法
     如果是OC -> JSON，那么使用序列化工具的dataWithJSONObject...开头的方法
     如果是NSString -> NSData, 那么使用的是字符串的dataUsingEncoding...开头的方法
     如果是NSData -> NSString, 那么使用的是字符串的initWithData...开头的方法
     所以可以总结出来的是， 以什么`开头`就会创建出什么 -> JSONObjectWithData创建出OC对象（这里的JSONObject指OC对象，而data指JSON的数据）, dataWithJSONObject创建出JSON对象（NSData）, dataUsingEncoding创建出NSData对象, initWithData由于是字符串的方法, 那么创建出字符串对象
     */
    
    //JSON数据和OC对象的一一对应关系
    /*
     
     {}     字典
     []     数组
     ""     @""
     10     NSNumber
     10.8   NSNumber
     true   1 NSNumber
     false  0 NSNumber
     null   NSNull
     
     */

}

@end
