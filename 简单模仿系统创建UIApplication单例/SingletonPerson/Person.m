//
//  Person.m
//  SingletonPerson
//
//  Created by joyann on 15/10/12.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "Person.h"

@implementation Person

/**
 *  因为load方法是类方法，无法访问实例变量
 *  所以需要一个全局变量来保存在load方法中创建出的对象
 *  这个全局变量是static的，保证只有一份且只有这个.m文件中可以使用
 */
static Person *_instance;

/**
 *  程序一启动就会把所有类都加载到内存中
 *  这个方法比AppDelegate的didFinishLaunchingWithOptions方法更早.
 */
+ (void)load
{
    _instance = [[self alloc] init];
}

+ (instancetype)sharedPerson
{
    return _instance;
}

/**
 *  重写父类初始化方法, 当使用init方法创建对象时报错
 *  如果_instance不为nil, 表示loadView已经执行, 内存中已经有Person对象, 再用init方法报错
 *  如果_instance为nil, 表示loadView还未执行, 此时调用init方法的是在load方法, 所以需要调用父类初始化方法对类进行初始化.
 */

- (instancetype)init
{
    if (_instance) {
        NSException *exception = [NSException exceptionWithName:@"创建对象错误" reason:@"只能通过sharedPerson方法创建单例对象" userInfo:nil];
        [exception raise];
    }
    return [super init];
}

@end
