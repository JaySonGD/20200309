//
//  YHIntelligentCheckModel.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/3/8.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHIntelligentCheckModel.h"

@implementation TutorialListModel

@end

@implementation YHCheckResultArrModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{


    return @{
             @"makeResult":@[@"makeResult",@"make_result"],
             @"makeIdea":@[@"makeIdea",@"make_idea"]
             };
}
@end

@implementation YHBaseInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /*
     [[YHNetworkPHPManager sharedYHNetworkPHPManager] getPartsWithExactWay:[YHTools getAccessToken] partName:text brandId:[self.baseInfo.carBrandId intValue] lineId:[self.baseInfo.carLineId intValue] car_cc:self.baseInfo.carCc carYear:[self.baseInfo.carYear intValue]
     */
    return @{
             @"car_cc":@[@"car_cc",@"carCc"],
             @"car_cc_unit":@[@"car_cc_unit",@"item_price"]
             };
}

@end


@implementation YHLPCModel

@end

@implementation YHLaborModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"labor_name":@[@"labor_name",@"part_name",@"item_name",@"full_name"],
             @"labor_price":@[@"labor_price",@"item_price"]
             };
}
@end

@implementation YHPartsModel

//- (NSString *)status{
//    return _status ? : @"2";
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"part_name":@[@"name",@"part_name",@"item_name",@"full_name"],
             @"part_price":@[@"part_price",@"item_price",@"price"],
             @"part_brand":@[@"part_brand",@"specification",@"item_standard",@"brand"],
             @"part_unit":@[@"part_unit",@"item_unit",@"unit"],
             @"part_type": @[@"part_type",@"parts_type_id"],
             @"part_type_name": @[@"part_type_name",@"parts_type_name"],
             };
}

@end

@implementation YHConsumableModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{

    return @{
             @"consumable_name":@[@"name",@"part_name",@"consumable_name",@"item_name",@"full_name"],
             @"consumable_price":@[@"consumable_price",@"item_price",@"price"],
             @"consumable_brand":@[@"consumable_brand",@"item_standard",@"brand"],
             @"consumable_unit":@[@"consumable_unit",@"item_unit",@"unit"],
             @"consumable_standard":@[@"consumable_standard",@"specification"]
             };
}

@end

@implementation YHSchemeModel

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"labor":[YHLaborModel class],
             @"parts":[YHPartsModel class],
             @"consumable":[YHConsumableModel class]
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"repairCaseId":@[@"id"]
             };
}

- (NSString *)quality_desc{
    
    _quality_desc =  _quality_desc ? : @"";
    _quality_desc = [_quality_desc stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    return _quality_desc;
}
- (NSMutableArray<YHPartsModel *> *)parts{
    
    if (!_parts) {
        _parts = [NSMutableArray array];
    }
    return _parts;
}

- (NSMutableArray<YHLaborModel *> *)labor{
    if (!_labor) {
        _labor = [NSMutableArray array];
    }
    return _labor;
}
- (NSMutableArray<YHConsumableModel *> *)consumable{
    if (!_consumable) {
        _consumable = [NSMutableArray array];
    }
    return _consumable;
}

@end

@implementation YHReportModel
+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"maintain_scheme":[YHSchemeModel class],
             @"tutorial_list" : [TutorialListModel class]
             };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"base_info":@[@"base_info",@"baseInfo"],
             @"checkResultArr":@[@"checkResultArr",@"check_result_info"],
             };
}
@end

