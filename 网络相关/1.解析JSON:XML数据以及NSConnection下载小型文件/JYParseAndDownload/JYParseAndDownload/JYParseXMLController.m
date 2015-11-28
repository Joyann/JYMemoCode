//
//  JYParseXMLController.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/8.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYParseXMLController.h"

static NSString * const JYVidelURLString = @"http://120.25.226.186:32812/video?type=XML";

@interface JYParseXMLController () <NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *parser;
@end

@implementation JYParseXMLController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self sendRequest];
}

#pragma mark - Send Request

- (void)sendRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:JYVidelURLString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        self.parser = parser;
        
        [parser parse];
    }];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始解析XML数据");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    NSLog(@"开始解析一个元素");
    
    if ([elementName isEqualToString:@"videos"]) {
        return;
    }
    
    NSLog(@"%@", attributeDict);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"结束解析一个元素");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"结束解析XML数据");
}

@end
