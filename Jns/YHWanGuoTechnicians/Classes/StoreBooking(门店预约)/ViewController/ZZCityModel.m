//
//  ZZCityModel.m
//  YHCaptureCar
//
//  Created by Jay on 15/11/2018.
//  Copyright © 2018 YH. All rights reserved.
//

#import "ZZCityModel.h"


@implementation ZZCityModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id": @"id"};
}
@end


@implementation ZZCity

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"hotCityList":[ZZCityModel class],@"regionList":[ZZCityRegionModel class]};
}


@end


@implementation ZZCityRegionModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"cityList":[ZZCityModel class]};
}
@end
