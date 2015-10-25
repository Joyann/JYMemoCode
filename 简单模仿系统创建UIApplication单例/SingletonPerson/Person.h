//
//  Person.h
//  SingletonPerson
//
//  Created by joyann on 15/10/12.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

+ (instancetype)sharedPerson;

@end
