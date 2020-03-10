//
//  NSString+add.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "NSString+add.h"

@implementation NSString (add)

+ (BOOL)stringIsNull:(NSString *)str{
    
    if (!str) {
        return YES;
    }
    if ([str isEqualToString:@""]) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (str.length == 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)productTimestr_iOS{
    
    return [NSString stringWithFormat:@"%@_iOS",[self getCurrentTimeStr]];
}

+ (NSString *)getCurrentTimeStr{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time= [date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

@end
