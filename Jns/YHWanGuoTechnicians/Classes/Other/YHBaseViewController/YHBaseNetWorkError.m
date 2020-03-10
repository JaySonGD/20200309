//
//  YHBaseNetWorkError.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/21.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseNetWorkError.h"

extern NSString *const notificationReloadLoginInfo;
@implementation YHBaseNetWorkError

//单点登录判断
- (bool)sso:(NSString*)retCode{
    if ([retCode isEqualToString:@"COMMON026"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
        return YES;
    }
    return NO;
}


//登录过期
- (bool)networkServiceCenter:(NSNumber*)retCode{
    return NO;
}
@end
