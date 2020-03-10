//
//  ApiService.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "ApiService.h"
#import "YHNetworkPHPManager.h"

@implementation ApiService
DEFINE_SINGLETON_FOR_CLASS(ApiService);


/**
 *  延长保修检测--获取发动机水温检测项目列表
 */
#pragma mark  -  延长保修检测--获取发动机水温检测项目列表
- (NSString *)getEngineWaterTProjectListURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/getEngineWaterTProjectList", SERVER_PHP_Trunk];
}




/**
 *  初检页面-输入检测code=fault_code的故障码
 */
#pragma mark  -  初检页面-输入检测code=fault_code的故障码
- (NSString *)getElecCtrlProjectListByFaultCodeURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/getElecCtrlProjectListByFaultCode", SERVER_PHP_Trunk];
}


/**
 *  检测是否有工单约束
 */
#pragma mark  -  检测是否有工单约束
- (NSString *)checkRestrictURL{
    return [NSString stringWithFormat:@"%@/Bill/CreateNew/checkRestrict", SERVER_PHP_Trunk];
}


/**
 *  工单-工单详情接口---(检车项目界面)
 */
#pragma mark  -  工单-工单详情接口---(检车项目界面)
- (NSString *)getBillDetailURL{
    return [NSString stringWithFormat:@"%@/UsedCarCheck/UsedCarCheck/getBillDetail", SERVER_PHP_Trunk];
}

/**
 *  工单-帮检工单详情接口---
 */
#pragma mark  -  工单-工单详情接口---(检车项目界面)
- (NSString *)getHelpBillDetailURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/getBillDetail", SERVER_PHP_Trunk];
}

    /**
     *  工单数据暂存
     */
#pragma mark  -  工单数据暂存
- (NSString *)temporarySaveURL{
    return [NSString stringWithFormat:@"%@/UsedCarCheck/UsedCarCheck/temporarySave", SERVER_PHP_Trunk];
}

/**
 *  帮检工单数据暂存
 */
#pragma mark  -  工单数据暂存
- (NSString *)temporaryHelpSaveURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/temporarySave", SERVER_PHP_Trunk];
}

/**
 *  二手车检测工单初检
 */
#pragma mark  -  二手车检测工单初检
- (NSString *)saveUsedCarInitialSurveyURL{
    return [NSString stringWithFormat:@"%@/UsedCarCheck/UsedCarCheck/saveUsedCarInitialSurvey", SERVER_PHP_Trunk];
}


/**
 *  帮检工单初检
 */
#pragma mark  -  帮检工单初检
- (NSString *)saveHelpInitialSurveyURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveUsedCarInitialSurvey", SERVER_PHP_Trunk];
}

/**
 *  帮检工单代录初检
 */
#pragma mark  -  帮检工单代录初检
- (NSString *)saveReplaceInitialSurveyURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveReplaceDetectiveInitialSurvey", SERVER_PHP_Trunk];
}

/**
 *  保存复检项目录入
 */
#pragma mark  -  帮检工单代录初检
- (NSString *)saveRecheckInput{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveRecheckInput", SERVER_PHP_Trunk];
}


/**
 *  v4版全车检测工单初检 - J002
 */
#pragma mark  -  v4版全车检测工单初检 - J002
- (NSString *)saveJ002InitialSurveyURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveInitialSurvey", SERVER_PHP_Trunk];
}

/**
 *  新全车检测工单初检 - K、J001
 */
#pragma mark  -  新全车检测工单初检 - K、J001
- (NSString *)saveKJ001InitialSurveyURL{ //
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveNewWholeCarInitialSurvey", SERVER_PHP_Trunk];
}


/**
 *  质量延长检测工单初检 - Y、A
 */
#pragma mark  -  Y A Y001
- (NSString *)saveYAY001InitialSurveyURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveExtWarrantyInitialSurvey", SERVER_PHP_Trunk];
}

#pragma mark  -  J004
- (NSString *)saveJ004InitialSurveyURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveNewWholeCarInitialSurvey", SERVER_PHP_Trunk];
}

#pragma mark  -  J007提交诊断数据
- (NSString *)saveJ007InitialSurveyURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveProjectValue", SERVER_PHP_Trunk];
}

/**
 *  上传工单图片接口
 */
#pragma mark  -  上传工单图片接口
- (NSString *)uploadBillImageURL{
    return [NSString stringWithFormat:@"%@/%@/Common/Upload/billImage",SERVER_PHP_URL, SERVER_PHP_Trunk];
}


/**
 *  记录事件日志接口
 */
#pragma mark  -  记录事件日志接口
- (NSString *)addEventLogURL{
    return [NSString stringWithFormat:@"%@/Event/EventLog/addEventLog", SERVER_PHP_Trunk];
}



/**
 *  检测客户车辆信息
 */
#pragma mark  -  检测客户车辆信息
- (NSString *)checkCustomerURL{
    return [NSString stringWithFormat:@"%@/Bill/CreateNew/checkCustomer", SERVER_PHP_Trunk];
}


/**
 *  忘记密码：获取验证码，验证验证码，修改密码以及登录
 */
#pragma mark  -  忘记密码：获取验证码，验证验证码，修改密码以及登录
- (NSString *)findPassword{
    return [NSString stringWithFormat:@"%@/Servant/Guest/findPassword", SERVER_PHP_Trunk];
}



/**
 *  获取验证码图片
 */
#pragma mark  -  获取验证码图片
- (NSString *)getFindPasswordImage{
    return [NSString stringWithFormat:@"%@%@/Servant/Guest/getFindPasswordImage", SERVER_PHP_URL,SERVER_PHP_Trunk];
}

/**
 *  删除工单图片
 */
#pragma mark  -  删除工单图片
- (NSString *)deleteBillImageURL{
    return [NSString stringWithFormat:@"%@/Common/Bill/deleteBillImage", SERVER_PHP_Trunk];
}


/**
 *  查看工单图片
 */
#pragma mark  -  查看工单图片
- (NSString *)getBillImageListURL{
    return [NSString stringWithFormat:@"%@/Common/Bill/getBillImageList", SERVER_PHP_Trunk];
}

/**
 *  工单-根据车架号获取最新未完成的工单状态接口
 */
#pragma mark  -  工单-根据车架号获取最新未完成的工单状态接口
- (NSString *)getBillStatusByVinURL{
    return [NSString stringWithFormat:@"%@/Bill/CreateNew/getBillStatusByVin", SERVER_PHP_Trunk];
}

/**
// *  根据车架号去判断是否有二手车的预约单
// */
//#pragma mark  -  根据车架号去判断是否有二手车的预约单
//- (NSString *)checkRestrictURL{
//    return [NSString stringWithFormat:@"%@/Bill/createNew/checkRestrict", SERVER_PHP_Trunk];
//}
/**
 *  根据车牌号获取vin号
 */
#pragma mark  -  根据车牌号获取vin号
- (NSString *)getVinByPlateNumberURL{
    return [NSString stringWithFormat:@"%@/Bill/CreateNew/getVinByPlateNumber", SERVER_PHP_Trunk];
}


/**
 *  门店功能开通支付
 */
#pragma mark  - 门店功能开通支付
- (NSString *)orgFunctionOrderPayURL{
    return [NSString stringWithFormat:@"%@/Servant/CommonServant/OrgFunctionOrderPay", SERVER_PHP_Trunk];
}



#pragma mark  -  智能维修解决方案获取搜索结果列表接口
- (NSString *)getCheckResultListURL{
    return [NSString stringWithFormat:@"%@/AiMaintainSolution/Solution/getCheckResultList", SERVER_PHP_Trunk];
}

#pragma mark  -  根据诊断结果获取解决方案接口
- (NSString *)getQualitySolutionDataListURL{
    return [NSString stringWithFormat:@"%@/AiMaintainSolution/Solution/getQualitySolutionDataList", SERVER_PHP_Trunk];
}


#pragma mark  -支付解决方案
- (NSString *)solutionPayURL{
    return [NSString stringWithFormat:@"%@/AiMaintainSolution/Solution/solutionPay", SERVER_PHP_Trunk];
}

#pragma mark  -获取解决方案拆分支付信息
- (NSString *)splitPayInfoURL{
    return [NSString stringWithFormat:@"%@/AiMaintainSolution/Solution/splitPayInfo", SERVER_PHP_Trunk];
}

#pragma mark  - 空调智能检测支付接口支付信息
- (NSString *)airConditionOrderPayInfoURL{
    return [NSString stringWithFormat:@"%@/AiMaintainSolution/AirConditioner/airConditionOrderPay", SERVER_PHP_Trunk];
}


#pragma mark  - 解决方案W001 - 完工
- (NSString *)saveAffirmCompleteURL{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveAffirmComplete", SERVER_PHP_Trunk];
}

#pragma mark  - 解决方案W001 - 完工
- (NSString *)helperAirConditionListURL{
    return [NSString stringWithFormat:@"%@/Helper/HelperAirCondition/index", SERVER_PHP_Trunk];
}
#pragma mark  - 解决方案W001 - 完工
- (NSString *)getAirConditionResultURL{
    return [NSString stringWithFormat:@"%@/Helper/HelperAirCondition/getAirConditionResult", SERVER_PHP_Trunk];
}


#pragma mark  - 获取机构充值信息页面接口
- (NSString *)getPointsDealPayInfoURL{
    return [NSString stringWithFormat:@"%@/PointsDeal/PointsDeal/getPointsDealPayInfo", SERVER_PHP_Trunk];
}


#pragma mark  - 获取机构余额交易记录列表接口
- (NSString *)getPointsDealList{
    return [NSString stringWithFormat:@"%@/PointsDeal/PointsDeal/getPointsDealList", SERVER_PHP_Trunk];
}

#pragma mark  - 获取机构余额交易详情接口
- (NSString *)getPointsDealInfoById{
    return [NSString stringWithFormat:@"%@/PointsDeal/PointsDeal/getPointsDealInfoById", SERVER_PHP_Trunk];
}

#pragma mark  - 机构余额充值支付接口
- (NSString *)pointsDealPay{
    return [NSString stringWithFormat:@"%@/PointsDeal/PointsDeal/pointsDealPay", SERVER_PHP_Trunk];
}


#pragma mark  - 获取AI空调检测项目列表
- (NSString *)getAirConditionerItemData{
    return [NSString stringWithFormat:@"%@/AiMaintainSolution/AirConditioner/getAirConditionerItemData", SERVER_PHP_Trunk];
}

#pragma mark  - 提交编辑AI空调检测数据
- (NSString *)saveAirConditionCheckInfo{
    return [NSString stringWithFormat:@"%@/AiMaintainSolution/AirConditioner/saveAirConditionCheckInfo", SERVER_PHP_Trunk];
}

#pragma mark  - 获取检测项目列表接口
- (NSString *)getItemList{
    return [NSString stringWithFormat:@"%@/Bill/BillItem/getItemList", SERVER_PHP_Trunk];
}


#pragma mark  -获取维修拆装支付信息详情
- (NSString *)getRepairDismountingPayInfo{
    return [NSString stringWithFormat:@"%@/PointsDeal/PointsDeal/getRepairDismountingPayInfo", SERVER_PHP_Trunk];
}
#pragma mark  -维修拆装支付确认接口
- (NSString *)determineRepairDismountingPay{
    return [NSString stringWithFormat:@"%@/PointsDeal/PointsDeal/determineRepairDismountingPay", SERVER_PHP_Trunk];
}


#pragma mark  -获取支付信息确认页面详情接口
- (NSString *)getPayModeInfo{
    return [NSString stringWithFormat:@"%@/PointsDeal/PointsDeal/getPayModeInfo", SERVER_PHP_Trunk];
}
#pragma mark  -信息确认页面提交接口determinePayMode
- (NSString *)determinePayMode{
    return [NSString stringWithFormat:@"%@/PointsDeal/PointsDeal/determinePayMode", SERVER_PHP_Trunk];
}

#pragma mark  -推送报告
- (NSString *)saveStorePushNewWholeCarReport{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveStorePushNewWholeCarReport", SERVER_PHP_Trunk];
}

#pragma mark  -保存二手车估值信息
- (NSString *)saveE003Quote{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveE003Quote", SERVER_PHP_Trunk];
}

#pragma mark  -获取做过二手车检车标识
- (NSString *)getDidUsedCarStatus{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/getDidUsedCarStatus", SERVER_PHP_Trunk];
}


#pragma mark  -复用二手车检测数据接口
- (NSString *)copyUsedCarInitialSurvey{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/copyUsedCarInitialSurvey", SERVER_PHP_Trunk];
}

#pragma mark  -获取延长保修服务数据
- (NSString *)getExtendedWarrantyPackageList{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/getExtendedWarrantyPackageList", SERVER_PHP_Trunk];
}

#pragma mark  -暂存延长保修服务数据
- (NSString *)saveExtendedWarrantyPackage{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveExtendedWarrantyPackage", SERVER_PHP_Trunk];
}

#pragma mark  - 推送报告
- (NSString *)saveStorePushExtWarrantyReport{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveStorePushExtWarrantyReport", SERVER_PHP_Trunk];
}

#pragma mark  -首保-获取套餐列表接口
- (NSString *)getBillPackageList{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/getBillPackageList", SERVER_PHP_Trunk];
}

#pragma mark  -首保-保存套餐
- (NSString *)saveBillPackage{
    return [NSString stringWithFormat:@"%@/Bill/Undisposed/saveBillPackage", SERVER_PHP_Trunk];
}


#pragma mark  -获取app版本信息接口
- (NSString *)getAppEdition{
    return [NSString stringWithFormat:@"%@/Channels/Jns/getAppEdition", SERVER_PHP_Trunk];
}


#pragma mark
- (NSString *)getFlowType{
    return [NSString stringWithFormat:@"%@/Dismantled/Index/getFlowType", SERVER_PHP_Trunk];
}


@end
