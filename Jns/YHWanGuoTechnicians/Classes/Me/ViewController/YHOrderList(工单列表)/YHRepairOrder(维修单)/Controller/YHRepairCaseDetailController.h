//
//  YHRepairCaseDetailController.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/12/17.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"

@class YTDiagnoseModel;
@interface YHRepairCaseDetailController : YHBaseViewController


@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) YTDiagnoseModel *model;

@property (nonatomic,copy) NSString *billType;

@property (nonatomic, copy) void(^refreshOrderStatusBlock)(void);


+ (void)submitRepairCaseModel:(YTDiagnoseModel *)model completeBlock:(void(^)(BOOL isSuccess,NSString *message))completeBlock;

@end
