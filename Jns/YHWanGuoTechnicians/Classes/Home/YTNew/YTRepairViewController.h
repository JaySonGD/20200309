//
//  YTRepairViewController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 18/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//



#import "YHBaseViewController.h"
#import "YHFunctionsEditerController.h"
@class TTZSYSModel;
@interface YTRepairViewController : YHBaseViewController
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

