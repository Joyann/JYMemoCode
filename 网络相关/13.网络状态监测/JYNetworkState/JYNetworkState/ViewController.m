//
//  ViewController.m
//  JYNetworkState
//
//  Created by joyann on 15/11/10.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"

/*
 这里提供了两种监测网络状态的方式：
 1. APPLE自带
 2. 利用AFN的AFNetworkReachabilityManager.
 */

@interface ViewController ()

@property (nonatomic ,strong)Reachability *r;
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change) name:kReachabilityChangedNotification object:nil];
    
    Reachability *r = [Reachability reachabilityForInternetConnection];
    [r startNotifier];
    self.r= r;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.r stopNotifier];
}
-(void)change
{
    /*
     NotReachable = 0,
     ReachableViaWiFi,
     ReachableViaWWAN
     */
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == ReachableViaWWAN) {
        NSLog(@"3G---");
        return;
    }
    
    if ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == ReachableViaWiFi) {
        NSLog(@"wifi");
        return ;
    }
    
    NSLog(@"没有网络");
}
-(void)afn
{
    //1.获得网络监测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.检测
    /*
     AFNetworkReachabilityStatusUnknown          = -1,
     AFNetworkReachabilityStatusNotReachable     = 0,
     AFNetworkReachabilityStatusReachableViaWWAN = 1,
     AFNetworkReachabilityStatusReachableViaWiFi =
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知-----");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}

@end
