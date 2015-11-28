//
//  AppDelegate.m
//  JYOffineCache
//
//  Created by joyann on 15/11/28.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "AppDelegate.h"
#import "JYOfflineCacheViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    JYOfflineCacheViewController *offlineCacheVC = [[JYOfflineCacheViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:offlineCacheVC];
    
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
