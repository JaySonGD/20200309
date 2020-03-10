//
//  YHFunctionsEditerController.h
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseViewController.h"


    
//}else if ([[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"initialSurvey"] || [[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"newWholeCarInitialSurvey"] || [[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"usedCarInitialSurvey"] || [[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"extWarrantyInitialSurvey"] ){
//    // 初检
//    self.isCheckComplete = YES;
//    self.isUpLoad = YES;
//    self.isPushReport = NO;
//}else if([[NSString stringWithFormat:@"%@", dataDict[@"nowStatusCode"]] isEqualToString:@"endBill"]
         
typedef NS_ENUM(NSInteger, YHFunctionCode) {//
    YHFunctionIdConsulting ,//问询
    YHFunctionIdInitialSurvey ,//初检
    YHFunctionIdEndBill ,//完成
    YHFunctionIdClose,//关闭
    YHFunctionIdReCheck//复检
};

typedef NS_ENUM(NSInteger, YHFunctionId) {
    YHFunctionIdCreateWorkOrder ,//新建工单
    YHFunctionIdNewWorkOrder ,//未处理工单
    YHFunctionIdHistoryWorkOrder ,//历史工单
    YHFunctionIdUnfinishedWorkOrder ,//未完成工单
    YHFunctionIdFinancialStatements ,//财务统计
    YHFunctionIdCircuitDiagram ,//电路图
    YHFunctionIdIncomeExpenses,//其他收支
    YHFunctionIdUnprocessedOrder,//未处理订单
    YHFunctionIdHistoryOrder,//历史订单
    YHFunctionIdWarranty,//延长保修管理 （二手车）
    YHFunctionIdExtrendBack ,//延长保修返现
    YHFunctionIdDiagnosis ,//诊断
    YHFunctionIdWorkshop ,//车间 （工单管理）
    YHFunctionIdTrain ,//培训 （项目培训）
    YHFunctionIdHelper ,//帮手 （技术帮手）
    YHFunctionIdWealth ,//财富 （项目分成）
    YHFunctionIdSecondCar,//（二手车）
    YHFunctionIdSecondCarCheck,//（二手车检测）
    YHFunctionIdGoodFor,// （查供应商）（优供） （优供商城）
    YHFunctionIdGood,//（优才） （人才优配）
    YHFunctionIdCarCondition,//（车况） （车况查询）
    YHFunctionIdSecurityInspection,// 安全检测
    YHFunctionIdExtendTheWarranty,// 延长质保
    YHFunctionIdReservationOrder,// 预约订单(MWF)
    YHFunctionIdIntelligentSolution, //智能解决方案(MWF)
    YHFunctionIdProfessionExamine, // 专项检测
    YHFunctionIdSecondHandBussinesman, // 二手车商
    YHFunctionIdValueAddedProject,//增值项目(MWF)
    YHFunctionIdHelpSell,//估值帮卖
    YHFunctionIdMGas,//YHFunctionIdMGas
    YHFunctionIdCold,//YHFunctionIdCold
    YHFunctionIdAll ,//全部
};

@interface YHFunctionsEditerController : YHBaseViewController

@end
