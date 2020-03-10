//
//  YHOrderDetailNewOneController.h
//  YHWanGuoTechnicians
//
//  Created by Liangtao Yu on 2019/10/22.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

#import "YHFunctionsEditerController.h"
@class TTZSYSModel;

NS_ASSUME_NONNULL_BEGIN

@interface YHOrderDetailNewOneController : YHBaseViewController
/** 工单是否已检测完毕 */
@property (nonatomic, assign) BOOL isCheckComplete;

@property (nonatomic, copy) NSDictionary *orderDetailInfo;
/** 车检数据 */
@property (nonatomic, copy) NSDictionary *checkCarVal;

@property (nonatomic) YHFunctionId functionKey;

@property (nonatomic) YHFunctionCode functionCode;

/** 检测方案数据源 */
@property (nonatomic, strong) NSMutableArray <TTZSYSModel *>*dataArr;

@property (nonatomic, copy) NSDictionary *info;

@end

NS_ASSUME_NONNULL_END
