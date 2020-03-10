//
//  YHIntelligentDiagnoseController.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2019/3/7.
//  Copyright © 2019年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHIntelligentCheckModel.h"
#import "YTPlanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YTDepthController : YHBaseViewController
/** 订单id */

@property (nonatomic, copy) NSString *order_id;

@property(nonatomic, strong) YHReportModel *reportModel;

@property (nonatomic, strong) NSString *orderType;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) YTBaseInfo *baseInfo;
// 删除维修方案->仅限于小虎安检
@property (nonatomic, copy) void(^removeRepairCaseSuccessOperation)(void);

@end

NS_ASSUME_NONNULL_END
