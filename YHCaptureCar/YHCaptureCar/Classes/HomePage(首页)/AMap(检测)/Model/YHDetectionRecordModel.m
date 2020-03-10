//
//  YHDetectionRecordModel.m
//  YHCaptureCar
//
//  Created by liusong on 2018/1/30.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHDetectionRecordModel.h"
#import "YHTools.h"

@implementation YHDetectionRecordModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}


- (void)setCarPicture:(NSString *)carPicture{
    _carPicture = [YHTools hmacsha1YHJns:[carPicture componentsSeparatedByString:@","].firstObject width:120];
}
@end
