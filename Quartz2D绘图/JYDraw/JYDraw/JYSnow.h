//
//  JYSnow.h
//  JYDraw
//
//  Created by joyann on 15/10/20.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JYSnow : NSObject

/**
 *  snow的透明度.
 */
@property (nonatomic, assign) CGFloat alpha;
/**
 *  snow的速度，也就是每次刷新屏幕向下走的距离.
 */
@property (nonatomic, assign) CGFloat speed;
/**
 *  snow的位置.
 */
@property (nonatomic, assign) CGPoint location;

/**
 *  重置snow的所有状态.
 */
- (void)resetSnowStates;

@end
