//
//  YTPlanModel.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 19/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import "YTPlanModel.h"
#import "NSObject+BGModel.h"

@implementation YTBaseInfo
/*
 
 @property (nonatomic, copy) NSString * carBrandId;
 @property (nonatomic, copy) NSString * carBrandLogo;
 @property (nonatomic, copy) NSString * carBrandName;
 @property (nonatomic, copy) NSString * carCc;
 @property (nonatomic, copy) NSString * carLineId;
 @property (nonatomic, copy) NSString * carLineName;
 @property (nonatomic, copy) NSString * carModelFullName;
 @property (nonatomic, copy) NSString * carModelId;
 @property (nonatomic, copy) NSString * carStyle;
 @property (nonatomic, copy) NSString * carType;
 @property (nonatomic, copy) NSString * carYear;
 @property (nonatomic, copy) NSString * fuelMeter;
 @property (nonatomic, copy) NSString * gearboxType;
 @property (nonatomic, copy) NSString * phone;
 @property (nonatomic, copy) NSString * plateNumber;
 @property (nonatomic, copy) NSString * plateNumberC;
 @property (nonatomic, copy) NSString * plateNumberP;
 @property (nonatomic, copy) NSString * startTime;
 @property (nonatomic, copy) NSString * tripDistance;
 @property (nonatomic, copy) NSString * userName;
 @property (nonatomic, copy) NSString * vin;
 

 {
 "car_brand_name" = "\U4fdd\U65f6\U6377";
 "car_cc" = "3.6";
 "car_cc_unit" = L;
 "car_icon" = "bsj_ico";
 "car_line_name" = "\U5e15\U7eb3\U7f8e\U62c9(\U8fdb\U53e3)";
 "car_model_full_name" = "\U4fdd\U65f6\U6377 \U5e15\U7eb3\U7f8e\U62c9(\U8fdb\U53e3) 2010\U6b3e 3.6L \U53cc\U79bb\U5408\U53d8\U901f\U5668(PDK)";
 "gearbox_type" = "\U53cc\U79bb\U5408\U53d8\U901f\U5668(PDK)";
 "nian_kuan" = 2010;
 vin = WP0AA2978BL012976;
 }
 */
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"carBrandName":@[@"carBrandName",@"car_brand_name"],
             @"carCc":@[@"carCc",@"car_cc"],
             @"labor_price":@[@"labor_price",@"car_cc_unit"],
             @"carBrandLogo":@[@"carBrandLogo",@"car_icon"],
             @"carLineName":@[@"carLineName",@"car_line_name"],
             @"carModelFullName":@[@"carModelFullName",@"car_model_full_name"],
             @"gearboxType":@[@"gearboxType",@"gearbox_type"],
             @"carYear":@[@"carYear",@"nian_kuan"]
             };
}


@end

@implementation packageOwnerModel @end

@implementation YTPaymentRecordModel @end


@implementation YTSplitPayInfoModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"payment_record":[YTPaymentRecordModel class]};
}

@end

@implementation YTCheckResultModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

@end

@implementation YTLaborModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"labor_name":@[@"labor_name",@"item_name"],
             @"labor_price":@[@"labor_price",@"item_price"]
             };
}
@end

@implementation YHLPCModel1

@end


@implementation YTPartModel
//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{z
//             @"consumable_name":@[@"consumable_name",@"item_name"],
//             @"consumable_unit":@[@"consumable_unit",@"item_unit"],
//             @"consumable_standard":@[@"consumable_standard",@"item_standard"],
//             @"consumable_price":@[@"consumable_price",@"item_price"]
//             };
//}

@end
@implementation YTConsumableModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"consumable_name":@[@"consumable_name",@"item_name"],
             @"consumable_unit":@[@"consumable_unit",@"item_unit"],
             @"consumable_standard":@[@"consumable_standard",@"item_standard"],
             @"consumable_price":@[@"consumable_price",@"item_price"]
             };
}
@end

@implementation YTPlanModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id",
             @"repairCaseId" : @"id"
    };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"labor":[YTLaborModel class],
             @"parts":[YTPartModel class],
             @"consumable":[YTConsumableModel class]
             };
}

- (NSMutableArray<YTPartModel *> *)parts{
    
    if (!_parts) {
        _parts = [NSMutableArray array];
    }
    return _parts;
}

- (NSMutableArray<YTLaborModel *> *)labor{
    if (!_labor) {
        _labor = [NSMutableArray array];
    }
    return _labor;
}
- (NSMutableArray<YTConsumableModel *> *)consumable{
    if (!_consumable) {
        _consumable = [NSMutableArray array];
    }
    return _consumable;
}
@end



@implementation YTCResultModel @end


@implementation YTDiagnoseModel

+ (NSArray *)uniqueKeys
{
    return @[@"billId"];
}

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"maintain_scheme":[YTPlanModel class],
             @"package_owner":[packageOwnerModel class],
             @"recheck_item":[TTZSYSModel class]
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"repairCaseId":@[@"id"]
             };
}

- (BOOL)isHistoryOrder{
    return [_nowStatusCode isEqualToString:@"endBill"];
}


- (YTCResultModel *)checkResultArr{
    if (!_checkResultArr) {
        _checkResultArr = [YTCResultModel new];
    }
    return _checkResultArr;
}

- (NSMutableArray<YTPlanModel *> *)maintain_scheme{
    if (!_maintain_scheme) {
        _maintain_scheme = [NSMutableArray array];
    }
    return _maintain_scheme;
}

- (void)saveDiagnose{
    if(!_isTechOrg) return;
    if(![_nextStatusCode isEqualToString:@"initialSurveyCompletion"]) return;
    [self saveOrUpdate];
}
@end
