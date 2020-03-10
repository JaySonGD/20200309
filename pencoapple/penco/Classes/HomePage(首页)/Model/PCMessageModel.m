//
//  PCMessageModel.m
//  penco
//
//  Created by Jay on 13/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCMessageModel.h"

@implementation PCMessageBodyModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.confirmStatus = YES;
    }
    return self;
}

- (void)setMeasureTime:(NSString *)measureTime{
    _measureTime = [measureTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{@"reportId":@[@"reportId",@"postureId"]};
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"reportId":@[@"reportId",@"figureRecordId",@"postureId",@"postureRecordId"]};

}


@end


@implementation PCMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"info":@[@"measureInfo",@"postureInfo",@"messageInfo",@"info"], @"msgType":@[@"type", @"msgType"]};
}

@end
