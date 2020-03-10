//
//  ApiService.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface ApiService : NSObject
DEFINE_SINGLETON_FOR_HEADER(ApiService);



/**
 *  延长保修检测--获取发动机水温检测项目列表
 */

- (NSString *)getEngineWaterTProjectListURL;

/**
 *  初检页面-输入检测code=fault_code的故障码
 */
- (NSString *)getElecCtrlProjectListByFaultCodeURL;

/**
 *  检测是否有工单约束
 */
- (NSString *)checkRestrictURL;

/**
 *  工单-工单详情接口---(检车项目界面)
 */
- (NSString *)getBillDetailURL;

/**
 *  工单-帮检工单详情接口---
 */
#pragma mark  -  工单-工单详情接口---(检车项目界面)
- (NSString *)getHelpBillDetailURL;

/**
  *  工单数据暂存
  */
- (NSString *)temporarySaveURL;

/**
 *  帮检工单数据暂存
 */
#pragma mark  -  工单数据暂存
- (NSString *)temporaryHelpSaveURL;

/**
 *  二手车检测工单初检
 */
- (NSString *)saveUsedCarInitialSurveyURL;


/**
 *  帮检工单初检
 */
#pragma mark  -  帮检工单初检
- (NSString *)saveHelpInitialSurveyURL;

/**
 *  帮检工单代录初检
 */
#pragma mark  -  帮检工单代录初检
- (NSString *)saveReplaceInitialSurveyURL;

/**
 *  保存复检项目录入
 */
#pragma mark  -  帮检工单代录初检
- (NSString *)saveRecheckInput;

/**
 *  上传工单图片接口
 */
- (NSString *)uploadBillImageURL;

/**
 *  记录事件日志接口
 */
- (NSString *)addEventLogURL;


/**
 *  检测客户车辆信息
 */
- (NSString *)checkCustomerURL;

/**
 *  v4版全车检测工单初检 - J002
 */
- (NSString *)saveJ002InitialSurveyURL;
/**
 *  新全车检测工单初检 - K、J001
 */
- (NSString *)saveKJ001InitialSurveyURL;

/**
 *  删除工单图片
 */
- (NSString *)deleteBillImageURL;

/**
 *  查看工单图片
 */
- (NSString *)getBillImageListURL;


/**
 *  忘记密码：获取验证码，验证验证码，修改密码以及登录
 */
- (NSString *)findPassword;


/**
 *  获取验证码图片
 */
- (NSString *)getFindPasswordImage;



/**
 *  工单-根据车架号获取最新未完成的工单状态接口
 */
- (NSString *)getBillStatusByVinURL;


/**
 *  根据车牌号获取vin号
 */
#pragma mark  -  根据车牌号获取vin号
- (NSString *)getVinByPlateNumberURL;


- (NSString *)saveYAY001InitialSurveyURL;


#pragma mark  -  智能维修解决方案获取搜索结果列表接口
- (NSString *)getCheckResultListURL;

- (NSString *)getQualitySolutionDataListURL;

- (NSString *)orgFunctionOrderPayURL;


#pragma mark  -支付解决方案
- (NSString *)solutionPayURL;
#pragma mark  -获取解决方案拆分支付信息
- (NSString *)splitPayInfoURL;
#pragma mark  -空调智能检测支付接口支付信息
- (NSString *)airConditionOrderPayInfoURL;
#pragma mark  - 解决方案W001 - 完工
- (NSString *)saveAffirmCompleteURL;
    
    
- (NSString *)helperAirConditionListURL;
    
    
    - (NSString *)getAirConditionResultURL;

#pragma mark  - 获取机构充值信息页面接口
- (NSString *)getPointsDealPayInfoURL;

#pragma mark  - 获取机构余额交易记录列表接口
- (NSString *)getPointsDealList;

- (NSString *)getPointsDealInfoById;

#pragma mark  - 机构余额充值支付接口
- (NSString *)pointsDealPay;

#pragma mark  - 获取AI空调检测项目列表
- (NSString *)getAirConditionerItemData;

#pragma mark  - 提交编辑AI空调检测数据
- (NSString *)saveAirConditionCheckInfo;

#pragma mark  -获取支付信息确认页面详情接口
- (NSString *)getPayModeInfo;

#pragma mark  -信息确认页面提交接口
- (NSString *)determinePayMode;


#pragma mark  -  J004
- (NSString *)saveJ004InitialSurveyURL;

#pragma mark  -  J007提交诊断数据
- (NSString *)saveJ007InitialSurveyURL;

#pragma mark  -推送报告
- (NSString *)saveStorePushNewWholeCarReport;


#pragma mark  - 获取检测项目列表接口 J005
- (NSString *)getItemList;

#pragma mark  -保存二手车估值信息
- (NSString *)saveE003Quote;


#pragma mark  -获取做过二手车检车标识
- (NSString *)getDidUsedCarStatus;

#pragma mark  -复用二手车检测数据接口
- (NSString *)copyUsedCarInitialSurvey;


- (NSString *)getExtendedWarrantyPackageList;

#pragma mark  -暂存延长保修服务数据
- (NSString *)saveExtendedWarrantyPackage;

#pragma mark  - 推送报告
- (NSString *)saveStorePushExtWarrantyReport;


#pragma mark  -首保-获取套餐列表接口
- (NSString *)getBillPackageList;

#pragma mark  -首保-保存套餐
- (NSString *)saveBillPackage;

- (NSString *)getAppEdition;

- (NSString *)getRepairDismountingPayInfo;
- (NSString *)determineRepairDismountingPay;


- (NSString *)getFlowType;
@end
