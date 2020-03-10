//
//  YHReportDetailModel.h
//  YHCaptureCar
//
//  Created by mwf on 2018/9/17.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHReportDetailModel : NSObject

/**
 *报告详情地址
 */
@property (nonatomic, copy) NSString *rptUrl;

/**
 *支付状态 0-待支付 1-支付完成
 */
@property (nonatomic, copy) NSString *payStatus;

/**
 *支付金额
 */
@property (nonatomic, copy) NSString *payAmt;

@end
