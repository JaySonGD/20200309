//
//  YTBillPackageModel.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 9/10/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTBillPackageModel.h"
@implementation YTSystemPackageModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"child_system":[YTSystemPackageModel class]};
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id":@"id"
             };
}
@end
@implementation YTBillPackageModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"system_list":[YTSystemPackageModel class]};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id":@"id"
             };
}

//- (NSString *)sales_price{
//    __block CGFloat total = 0;
//    [self.system_list enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull sobj, NSUInteger idx, BOOL * _Nonnull stop) {
//        total += [sobj.price floatValue];
//        [sobj.child_system enumerateObjectsUsingBlock:^(YTSystemPackageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.is_check) {
//                total += [obj.price floatValue];
//            }
//        }];
//    }];
//    return [NSString stringWithFormat:@"%.2f",total];
//    return [NSString stringWithFormat:@"%.2f",_];
//}



@end

@implementation YTInsuranceInfoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"check":@"is_sync"
             };
}

@end

@implementation YTPackageModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list":[YTBillPackageModel class]};
}

@end

@implementation YTTimerModel

@end
