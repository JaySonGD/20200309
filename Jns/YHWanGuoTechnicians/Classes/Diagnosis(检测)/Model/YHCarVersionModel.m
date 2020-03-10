
//
//  YHCarVersionModel.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/9.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarVersionModel.h"

@implementation YHCarVersionModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"userName" : @[@"userName",@"username"],
             };
}

@end
