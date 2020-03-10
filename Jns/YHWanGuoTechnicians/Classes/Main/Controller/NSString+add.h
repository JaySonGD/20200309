//
//  NSString+add.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (add)
/**
 * 获取时间戳字符串
 */
+ (NSString *)getCurrentTimeStr;

/**
 * 判断字符串是否为空
 */
+ (BOOL)stringIsNull:(NSString *)str;
@end
