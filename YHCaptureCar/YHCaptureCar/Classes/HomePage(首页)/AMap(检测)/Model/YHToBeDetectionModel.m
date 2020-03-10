
//
//  YHToBeDetectionModel.m
//  YHCaptureCar
//
//  Created by liusong on 2018/1/30.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHToBeDetectionModel.h"
#import <MJExtension/MJExtension.h>

@implementation YHToBeDetectionModel

/**
告诉Mj需要将id转化成ID
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID": @"id",
             @"name":@[@"name",@"orgName"],
             @"bookDate":@[@"bookDate",@"arrivalStartTime"]};
}

//- (void)setBookDate:(NSString *)bookDate{
//    
//    //2019-05-28 23:00:00
//    _bookDate = [NSString stringWithFormat:@"%@-%@",[bookDate substringToIndex:15],[_arrivalEndTime substringWithRange:NSMakeRange(11, 15)]];
//    NSLog(@"%s--%@", __func__,_bookDate);
//}

@end
