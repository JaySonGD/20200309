//
//  YHDiagnosisOrderModel.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/16.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHDiagnosisOrderModel.h"

@implementation YHDiagnosisOrderModel

- (instancetype)init{
    if (self = [super init]) {
        // 默认不显示SegamentContrroll
        self.isShowSegamentContrroll = NO;
    }
    return self;
}

@end
