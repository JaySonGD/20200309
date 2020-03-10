//
//  TTZSurveyModel.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 26/6/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZSurveyModel.h"
#import "TTZDBModel.h"

#import "NSObject+BGModel.h"

@implementation TTZChildModel
@end

@implementation TTZValueModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"childList":[TTZChildModel class],@"cylinderList":[TTZChildModel class]};
}

- (NSMutableArray<TTZChildModel *> *)cylinderList{
    if (!_cylinderList) {
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:6];
        for (NSInteger i = 1; i < 7; i++) {
            TTZChildModel *c  = [TTZChildModel new];
            c.name = [NSString stringWithFormat:@"第%ld缸",(long)i];
            c.value = [NSString stringWithFormat:@"%ld",i];
            [list addObject:c];
        }
        _cylinderList = list;
    }
    return _cylinderList;
}

@end

@implementation TTZRangeModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[TTZValueModel class]};
}

@end

@implementation TTZSurveyModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id": @"id",@"intervalRangeBak":@"intervalRange"};
}
//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{@"elecCtrlProjectList":[TTZSurveyModel class]};
//}

- (NSMutableArray<TTZDBModel *> *)dbImages{
    if (!_dbImages) {
        _dbImages = [NSMutableArray array];
        NSArray <TTZDBModel *> *dbImages = [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",self.billId,self.code]];
        // 现添加远程资源
        for (NSInteger i = 0; i < self.projectRelativeImgList.count; i ++) {
            TTZDBModel *db = [TTZDBModel new];
            //db.fileId = imgs[i];
            db.fileId = [NSString stringWithFormat:@"%@;%@",self.projectThumbImgList[i],self.projectRelativeImgList[i]];
            
            [_dbImages addObject:db];
        }
        
        
        NSLog(@"%s---%@----%@--%@", __func__,_projectName,_billId,dbImages);
        if (dbImages.count) {
            [_dbImages addObjectsFromArray:dbImages];
            if(dbImages.count <5){
                TTZDBModel *defaultModel = [TTZDBModel new];
                defaultModel.image = [UIImage imageNamed:@"otherAdd"];
                [_dbImages addObject:defaultModel];
            }
        }
        else
        {
            TTZDBModel *defaultModel = [TTZDBModel new];
            defaultModel.image = [UIImage imageNamed:@"otherAdd"];
            [_dbImages addObject:defaultModel];
        }
    }
    return _dbImages;
}

- (NSMutableArray<NSString *> *)codes{
    if (!_codes) {
        _codes = [NSMutableArray array];
    }
    return _codes;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"intervalRangeBak"] && [value isKindOfClass:[NSArray class]]) {
        _intervalRange = [TTZRangeModel new];
        _intervalRange.placeholder = ((NSArray *)value).firstObject;
    }
    
//    if ([key isEqualToString:@"code"] && [value isEqualToString:@"engine_waterT"] ) {
//        _isRequirRequest = YES;
//    }
//    'engine_coolantP': // 冷却液液位
//    'engine_coolantLeak': // 冷却液有无泄露
//    'engine_fanSpeed': // 风扇转速
//    'engine_waterTank': // 水箱
//    if ([key isEqualToString:@"code"] && [value isEqualToString:@"engine_coolantP"] ) {
//        _isRequirRequest = YES;
//    }
//    if ([key isEqualToString:@"code"] && [value isEqualToString:@"engine_coolantLeak"] ) {
//        _isRequirRequest = YES;
//    }
//    if ([key isEqualToString:@"code"] && [value isEqualToString:@"engine_fanSpeed"] ) {
//        _isRequirRequest = YES;
//    }
//    if ([key isEqualToString:@"code"] && [value isEqualToString:@"engine_waterTank"] ) {
//        _isRequirRequest = YES;
//    }

    if ([key isEqualToString:@"code"] &&
        ([value isEqualToString:@"engine_waterT"] ||
         [value isEqualToString:@"engine_coolantP"] ||
         [value isEqualToString:@"engine_coolantLeak"] ||
         [value isEqualToString:@"engine_fanSpeed"] ||
         [value isEqualToString:@"engine_waterTank"] ||
         [value isEqualToString:@"engine_sensor1_f"] ||
         [value isEqualToString:@"engine_sensor2_f"])) {
        _isRequirRequest = YES;
    }

    
}

- (void)setProjectVal:(NSString *)projectVal{
    _projectVal = projectVal;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_intervalType isEqualToString:@"select"] || [_intervalType isEqualToString:@"radio"]) {
            if(!IsEmptyStr(projectVal)){
                NSArray <NSString *>*names = [projectVal componentsSeparatedByString:@","];
                [names enumerateObjectsUsingBlock:^(NSString * name, NSUInteger idx, BOOL * _Nonnull stop) {
                    [_intervalRange.list enumerateObjectsUsingBlock:^(TTZValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if([name isEqualToString:obj.name]){
                            obj.isSelected = YES;
                            *stop = YES;
                        }
                    }];
                }];
            }
            
        }else if ([_intervalType isEqualToString:@"input"] || [_intervalType isEqualToString:@"text"]){
            if(!IsEmptyStr(projectVal)) _intervalRange.interval = projectVal;
        }else if ([_intervalType isEqualToString:@"gatherInputAdd"]){
            if(!IsEmptyStr(projectVal)) _codes = [projectVal componentsSeparatedByString:@","].mutableCopy;
            // _showFaultCode = (BOOL)_codes.count;
        }
        
//    });
}

@end
@implementation TTZGroundModel
//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{@"Id": @"id"};
//}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[TTZSurveyModel class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id": @"id",@"projectName":@[@"projectName",@"name"]};
}
- (void)setProjectName:(NSString *)projectName{
    _projectName = projectName;
    _itemWidth = [projectName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}].width;
}

@end

@implementation TTZSYSSupModel


@end

@implementation TTZSYSNewModel


@end

@implementation TTZSYSNewSubModel


@end
@implementation TTZSYSModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id": @"id",@"className":@"name"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[TTZGroundModel class] , @"Sublist" :[TTZSYSNewSubModel class] };
}

- (CGFloat)progress{
    __block  NSInteger total = 0;
    __block NSInteger checkProgress = 0;
    [_list enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull gObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [gObj.list enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull cellObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSInteger index = (NSInteger)idx - 1;
            if (index >= 0 && [cellObj.intervalType isEqualToString:@"gatherInputAdd"]) {//是故障码
                TTZSurveyModel *obj = gObj.list[index];
                NSArray *selects = [obj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0 and value != 1"]];

                if (obj.showFaultCode || cellObj.codes.count || selects.count) {
                    total += 1;
                }
            }else{
                if(![cellObj.intervalType isEqualToString:@"elecCodeForm"] && ![cellObj.intervalType isEqualToString:@"sameIncrease"] && ![cellObj.intervalType isEqualToString:@"form"]) total += 1;
            }
            
            if ([cellObj.intervalType isEqualToString:@"select"] || [cellObj.intervalType isEqualToString:@"radio"]) {
                
                
//                if(cellObj.intervalRange){//wenxun
//                    NSArray *selects = [cellObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
//                    if(selects.count) checkProgress +=1;
//
//                }else{
//                    if(!IsEmptyStr(cellObj.projectVal)) checkProgress +=1;
//                }
                
                if(!IsEmptyStr(cellObj.projectVal)) checkProgress +=1;
                else if([cellObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]].count)  checkProgress +=1;
                

            }else if ([cellObj.intervalType isEqualToString:@"input"] || [cellObj.intervalType isEqualToString:@"text"]){
                
//                if(cellObj.intervalRange){//wenxun
//                    if(cellObj.intervalRange.interval.length) checkProgress += 1;
//                }else{
//                    if(!IsEmptyStr(cellObj.projectVal)) checkProgress +=1;
//
//                }
                
                if(!IsEmptyStr(cellObj.projectVal)) checkProgress +=1;
                else if(cellObj.intervalRange.interval.length) checkProgress += 1;
                
            }else if ([cellObj.intervalType isEqualToString:@"gatherInputAdd"]){
//                if(cellObj.intervalRange){//wenxun
//                    if(cellObj.codes.count) checkProgress += 1;
//                }else{
//                    if(!IsEmptyStr(cellObj.projectVal)) checkProgress +=1;
//                }
                
                if(!IsEmptyStr(cellObj.projectVal)) checkProgress +=1;
                else if(cellObj.codes.count) checkProgress += 1;
            }
        }];
    }];
    
    return 1.0 * checkProgress/total;
    
}

@end


