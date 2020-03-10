//
//  YHOrderDetailNewController.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/25.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHFunctionsEditerController.h"
@class TTZSYSModel;
@interface YHOrderDetailNewController : YHBaseViewController
/** 工单是否已检测完毕 */
@property (nonatomic, assign) BOOL isCheckComplete;

@property (nonatomic, copy) NSDictionary *orderDetailInfo;
/** 车检数据 */
@property (nonatomic, copy) NSDictionary *checkCarVal;

@property (nonatomic) YHFunctionId functionKey;

/** 检测方案数据源 */
@property (nonatomic, strong) NSMutableArray <TTZSYSModel *>*dataArr;

@property (nonatomic, copy) NSDictionary *info;

@end
