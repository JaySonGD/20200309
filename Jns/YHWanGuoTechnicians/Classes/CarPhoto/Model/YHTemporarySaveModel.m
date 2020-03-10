//
//  YHTemporarySaveModel.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/12.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHTemporarySaveModel.h"

@implementation YHProjectValModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}

@end

@implementation YHInitialSurveyProjectValModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"projectVal":[YHProjectValModel class]};
}

@end

@implementation YHTemporarySaveModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"initialSurveyProjectVal":[YHInitialSurveyProjectValModel class]};
}

@end
