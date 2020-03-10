//
//  YTWarranty.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 4/9/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTWarranty.h"

@implementation YTWarranty
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"child_system":[YTWarranty class]};
}
@end

@implementation YTExtended

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.check = YES;
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"extended_warranty":[YTWarranty class]};
}

- (NSString *)total_price{
    return [NSString stringWithFormat:@"%f",self.system_total_price.floatValue + _shop_price.floatValue];
}

- (NSString *)system_total_price{
    __block CGFloat total = 0;
    [self.extended_warranty enumerateObjectsUsingBlock:^(YTWarranty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.check) {
            total += [obj.price floatValue];
        }else{
            [obj.child_system enumerateObjectsUsingBlock:^(YTWarranty * _Nonnull cobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (cobj.check) total += [cobj.price floatValue];
            }];
        }
        
    }];
    return [NSString stringWithFormat:@"%f",total];
}
@end


