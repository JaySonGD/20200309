//
//  YHReportListModel.h
//  YHCaptureCar
//
//  Created by mwf on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHReportListModel : NSObject

/**
 *报告code
 */
@property (nonatomic, copy) NSString *reportCode;

/**
 *工单类型
 */
@property (nonatomic, copy) NSString *billType;

/**
 *工单类型名称
 */
@property (nonatomic, copy) NSString *billTypeName;

/**
 *工单号
 */
@property (nonatomic, copy) NSString *billNumber;

/**
 *检测时间 yyyy-MM-dd
 */
@property (nonatomic, copy) NSString *creationTime;

@property (nonatomic, copy) NSString *rptUrl;

@end
