//
//  partSearchModel.m
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/6/17.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "partSearchModel.h"

@implementation partSearchModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"full_name":@[@"part_name",@"item_name",@"full_name",@"name"],
             };
}


@end
