//
//  YTPayModeInfo.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 21/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTPayModeInfo.h"
@implementation YTPayMode
@end
@implementation YTDiscount
@end

@implementation YTPayModeInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"pay_mode":[YTPayMode class],@"discount_info":[YTDiscount class]};
}

@end
