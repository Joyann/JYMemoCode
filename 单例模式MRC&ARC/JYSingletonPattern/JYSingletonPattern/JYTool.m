//
//  JYTool.m
//  JYSingletonPattern
//
//  Created by joyann on 15/11/3.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYTool.h"

static JYTool *_instance;

@implementation JYTool

#pragma mark - ARC

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
//    @synchronized(self) {
//        if (!_instance) {
//            _instance = [super allocWithZone:zone];
//        }
//    }
    return _instance;
}

+ (instancetype)shareTool
{
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

#pragma mark - MRC

#if __has_feature(objc_arc)

// ARC


#else

// MRC

- (instancetype)retain
{
    return _instance;
}

- (oneway void)release
{
    
}

- (NSUInteger)retainCount
{
    return MAXFLOAT;
}

#endif


@end
