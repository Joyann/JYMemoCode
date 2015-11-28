//
//  JYGDataXMLViewController.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/8.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYGDataXMLViewController.h"
#import "GDataXMLNode.h"

static NSString * const JYVidelURLString = @"http://120.25.226.186:32812/video?type=XML";

@interface JYGDataXMLViewController ()

@end

@implementation JYGDataXMLViewController

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
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:kNilOptions error:nil];
        NSArray *elements = [document.rootElement elementsForName:@"video"];
        for (GDataXMLElement *element in elements) {
//            [element attributeForName:@"..."];
//            在这里转为模型
            NSLog(@"%@", element);
        }
        
    }];
}


@end
