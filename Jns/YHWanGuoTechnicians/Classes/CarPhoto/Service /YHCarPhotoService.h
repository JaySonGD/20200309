//
//  YHCarPhotoService.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHNetworkPHPManager.h"
@class YHSurveyCheckProjectModel,YHCarBaseModel,YHTemporarySaveModel,TTZSYSModel,YTCheckResultModel,YTPlanModel,YTSplitPayInfoModel,YTDiagnoseModel,YTPointsDealModel,YTPointsDealListModel,YTPointsDealDetailModel,YTPayModeInfo,YTExtended,YTPackageModel;
@interface YHCarPhotoService : YHNetworkPHPManager

//- (void)detailForBillId:(NSString *)billId
//                success:(void (^)(NSMutableArray<YHSurveyCheckProjectModel *>*models,YHCarBaseModel*baseInfo))success
//                failure:(void (^)(NSError *error))failure;

//- (void)checkCustomerForVin:(NSString *)vin
//                    Success:(void (^)(NSDictionary *))success
//                    failure:(void (^)(NSError *error))failure;

- (void)detailForBillId:(NSString *)billId
                 isHelp:(BOOL)isHelp
                success:(void (^)(NSMutableArray<YHSurveyCheckProjectModel *>*models,YHCarBaseModel*baseInfo,YHTemporarySaveModel*temp))success
                failure:(void (^)(NSError *error))failure;

- (void)temporarySaveForBillId:(NSString *)billId
                         value:(NSDictionary *)val
                        isHelp:(BOOL)isHelp
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure;

- (void)saveInitialSurveyForBillId:(NSString *)billId
                             value:(NSArray *)val
                              info:(NSDictionary *)baseInfo
                            isHelp:(BOOL)isHelp
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure;

- (void)addEventForBillId:(NSString *)value1
                   proVal:(NSString *)value2
                 isFinish:(BOOL)finish;


//代录
- (void)saveReplaceDetectiveInitialSurvey:(NSString *)billId
                                    value:(NSArray *)val
                                     info:(NSDictionary *)baseInfo
                                  success:(void (^)(void))success
                                  failure:(void (^)(NSError *error))failure;

//保存复检项目录入
- (void)saveRecheckInputInitialSurvey:(NSString *)billId
                             value:(NSArray *)val
                           success:(void (^)(void))success
                              failure:(void (^)(NSError *error))failure;

- (void)checkRestrictForVin:(NSString *)vin
                    Success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSError *error))failure;

/**
 * 故障码获取电控检测项目列表
 */

- (void)getElecCtrlProjectListByBillId:(NSString*)billId
                            sysClassId:(NSString*)sysClassId
                             faultCode:(NSString*)faultCode
                               success:(void (^)(NSDictionary *))success
                               failure:(void (^)(NSError *error))failure;

- (void)getEngineWaterTProjectListByBillId:(NSString*)billId
                                 projectId:(NSString*)projectId
                                projectVal:(NSString*)projectVal
                                   success:(void (^)(NSArray *))success
                                   failure:(void (^)(NSError *error))failure;


/**
 * new
 */
- (void)newWorkOrderDetailForBillId:(NSString *)billId
                            success:(void (^)(NSMutableArray<TTZSYSModel *>*models,NSDictionary*obj))success
                            failure:(void (^)(NSError *error))failure;

- (void)newTemporarySaveForBillId:(NSString *)billId
                            value:(NSDictionary *)val
                          success:(void (^)(void))success
                          failure:(void (^)(NSError *error))failure;

- (void)saveInitialSurveyForBillId:(NSString *)billId
                             value:(NSArray *)val
                              info:(NSDictionary *)baseInfo
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure;

- (void)saveInitialSurveyForBillId:(NSString *)billId
                             value:(NSArray *)val
                              info:(NSDictionary *)baseInfo
                            isJ002:(BOOL)isJ002
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure;

- (void)deleteBillImageByBillId:(NSString*)billId
                         imgURL:(NSString*)url
                           type:(NSInteger)type
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure;


- (void)getBillImageListByBillId:(NSString*)billId
                         imgCode:(NSString*)code
                            type:(NSInteger)type
                         success:(void (^)(NSArray *list))success
                         failure:(void (^)(NSError *error))failure;


//FIXME:  - 重置密码
- (void)resetPassword:(NSString *)pwd
                phone:(NSString *)mobile
              success:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;
//FIXME:  - 验证验证码
- (void)checkVerifyCode:(NSString *)verifyCode
                  phone:(NSString *)mobile
                success:(void (^)(void))success
                failure:(void (^)(NSError *error))failure;
//FIXME:  - 获取验证码
//- (void)sendSms:(NSString *)mobile
//           code:(NSString *)autoVerifyCode
//        success:(void (^)(NSString *code ,NSString *expire,NSString *imgCode))success
//        failure:(void (^)(NSError *error))failure;
- (void)sendSms:(NSString *)mobile
           code:(NSString *)autoVerifyCode
        success:(void (^)(NSString *expire,NSString *imgCodeUrl))success
        failure:(void (^)(NSError *error))failure;

////FIXME:  - 获取图片验证码
//- (void)getLoginVerifyCodeSuccess:(void (^)(NSString *imgCode))success
//                          failure:(void (^)(NSError *error))failure;


//FIXME:  - 根据车架号获取最新未完成的工单状态接口
- (void)getBillStatusByVin:(NSString *)vin
                   success:(void (^)(BOOL billStatus))success
                   failure:(void (^)(NSError *error))failure;

//FIXME:  - 根据车牌号获取vin号
- (void)getVinByPlateNumber:(NSString *)plate_number
                    success:(void (^)(NSString *vin,BOOL billStatus))success
                    failure:(void (^)(NSError *error))failure;

- (void)saveYAY001InitialSurveyForBillId:(NSString *)billId
                                   value:(NSArray *)val
                                    info:(NSDictionary *)baseInfo
                                 success:(void (^)(void))success
                                 failure:(void (^)(NSError *error))failure;


- (void)getCheckResultList:(NSString *)keyword
                   success:(void (^)(NSMutableArray<YTCheckResultModel *>*models))success
                   failure:(void (^)(NSError *error))failure;

- (void)getQualitySolutionDataList:(NSString *)solution_check_result_id
                          brand_id:(NSString *)brand_id
                           line_id:(NSString *)line_id
                            car_cc:(NSString *)car_cc
                          car_year:(NSString *)car_year
                           success:(void (^)(NSMutableArray<YTPlanModel *>*models))success
                           failure:(void (^)(NSError *error))failure;

- (void)orgFunctionOrderPaySuccess:(void (^)(NSDictionary *info))success
                           failure:(void (^)(NSError *error))failure;


- (void)splitPayInfo:(NSString *)billId
             success:(void (^)(YTSplitPayInfoModel *info))success
             failure:(void (^)(NSError *error))failure;

- (void)airConditionOrderPay:(NSString *)order_id
                     success:(void (^)(NSDictionary *info))success
                     failure:(void (^)(NSError *error))failure;
//- (void)solutionPay:(NSString *)billId
//            success:(void (^)(NSDictionary *info))success
//            failure:(void (^)(NSError *error))failure;
- (void)solutionPay:(NSString *)billId
              price:(NSString *)price
            success:(void (^)(NSDictionary *info))success
            failure:(void (^)(NSError *error))failure;


- (void)newW001WorkOrderDetailForBillId:(NSString *)billId
                                success:(void (^)(YTDiagnoseModel *model,NSDictionary*obj))success
                                failure:(void (^)(NSError *error))failure;


/*
 "billId":1,
 "billType":"G",
 "nowStatusCode":"endBill",
 "nextStatusCode":"",
 "handleType":"detail",
 */
- (void)saveAffirmComplete:(NSString *)billId
                   success:(void (^)(NSDictionary*obj))success
                   failure:(void (^)(NSError *error))failure;
    
    
    - (void)helperAirConditionSuccess:(void (^)(NSMutableArray<TTZSYSModel *>*models))success
                              failure:(void (^)(NSError *error))failure;
    
    - (void)getAirConditionResult:(NSArray *)check_project
                          success:(void (^)(NSMutableArray<NSDictionary *>*models))success
                          failure:(void (^)(NSError *error))failure;


- (void)getPointsDealPayInfoSuccess:(void (^)(YTPointsDealModel *obj))success
                            failure:(void (^)(NSError *error))failure;


- (void)getPointsDealListOrgCode:(NSString *)org_code
                         success:(void (^)( NSMutableArray <YTPointsDealListModel *> *obj))success
                         failure:(void (^)(NSError *error))failure;


- (void)getPointsDealInfoById:(NSString *)id
                      success:(void (^)(YTPointsDealDetailModel *obj))success
                      failure:(void (^)(NSError *error))failure;

- (void)pointsDealPay:(NSString *)org_id
                price:(NSString *)pay_amount
              success:(void (^)(NSDictionary *info))success
              failure:(void (^)(NSError *error))failure;


//- (void)getAirConditionerItemDataOrderId:(NSString *)order_id
//                                 success:(void (^)(NSMutableArray<TTZSYSModel *>*models))success
//                                 failure:(void (^)(NSError *error))failure;
- (void)getAirConditionerItemDataOrderId:(NSString *)order_id
                                 success:(void (^)(NSMutableArray<TTZSYSModel *>*models,NSDictionary *baseInfo))success
                                 failure:(void (^)(NSError *error))failure;

- (void)saveAirConditionCheckInfoWithOrderId:(NSString *)order_id
                                       value:(NSArray *)check_project
                                     success:(void (^)(void))success
                                     failure:(void (^)(NSError *error))failure;

//- (void)getPayModeInfo:(NSString *)bill_id
//               success:(void (^)(YTPayModeInfo *obj))success
//               failure:(void (^)(NSError *error))failure;
- (void)getPayModeInfo:(NSString *)bill_id
   parts_suggestion_id:(NSString *)parts_suggestion_id
              buy_type:(NSInteger )buy_type
             bill_sort:(NSString *)bill_sort
                   vin:(NSString *)vin
                  code:(NSString *)code
               success:(void (^)(YTPayModeInfo *obj))success
               failure:(void (^)(NSError *error))failure;

//- (void)determinePayMode:(NSString *)bill_id
//                 payType:(NSString *)type
//                  mobile:(NSString *)mobile
//                 success:(void (^)(NSDictionary *obj))success
//                 failure:(void (^)(NSError *error))failure;
- (void)determinePayMode:(NSString *)bill_id
                 payType:(NSString *)type
                  mobile:(NSString *)mobile
                buy_type:(NSInteger )buy_type
     parts_suggestion_id:(NSString *)parts_suggestion_id
               bill_sort:(NSString *)bill_sort
                     vin:(NSString *)vin
                    code:(NSString *)code
                 success:(void (^)(NSDictionary *obj))success
                 failure:(void (^)(NSError *error))failure;

- (void)saveJ004InitialSurveyForBillId:(NSString *)billId
                                 value:(NSArray *)val
                                  info:(NSDictionary *)baseInfo
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *error))failure;

//FIXME:  -  J007提交诊断接口
- (void)saveJ007InitialSurveyForBillId:(NSString *)billId
                                 value:(NSArray *)val
                                  info:(NSDictionary *)baseInfo
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *error))failure;


- (void)saveStorePushNewWholeCarReport:(NSString *)billId
                                 phone:(NSString *)phone
                               success:(void (^)(NSDictionary *obj))success
                               failure:(void (^)(NSError *error))failure;


- (void)getJ005ItemBillId:(NSString *)billId
                  success:(void (^)(NSMutableArray<TTZSYSModel *>*models,NSDictionary *baseInfo))success
                  failure:(void (^)(NSError *error))failure;

//FIXME:  -  保存二手车估值信息
- (void)saveE003QuoteTime:(NSString *)car_license_time
                    price:(NSString *)car_inspection_evaluation_price
         sync_buche_value:(NSInteger )sync_buche_value
                   billId:(NSString *)billId
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure;


- (void)getDidUsedCarStatus:(NSString *)vin
                    success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSError *error))failure;

- (void)copyUsedCarInitialSurvey:(NSString *)copy_bill_id
                         bill_id:(NSString *)bill_id
                         success:(void (^)(NSDictionary *))success
                         failure:(void (^)(NSError *error))failure;

- (void)getExtendedWarrantyPackageListBill_id:(NSString *)bill_id
                                      success:(void (^)(YTExtended *))success
                                      failure:(void (^)(NSError *error))failure;


- (void)saveExtendedWarrantyPackageBill_id:(NSString *)bill_id
                                   ssss_price:(NSString *)ssss_price
                            extended_warranty:(NSArray *)extended_warranty
                                      success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure;


- (void)saveStorePushExtWarrantyReportBill_id:(NSString *)billId
                                        phone:(NSString *)phone
                            syncWarrantyPhone:(BOOL)syncWarrantyPhone
                                      success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure;


- (void)getBillPackageList:(NSString *)bill_id
                   success:(void (^)(YTPackageModel *))success
                   failure:(void (^)(NSError *error))failure;

- (void)saveBillPackage:(NSString *)bill_id
                  phone:(NSString *)phone
                is_sync:(BOOL )is_sync
           bill_package:(NSMutableArray *)bill_package
                success:(void (^)(void))success
                failure:(void (^)(NSError *error))failure;


//"version":"1.0.1",//版本号
//"force_update":"Y",//是否强制更新
//"app_address":"http://192.168.1.200/files/apk/1.apk",//app下载地址

- (void)getAppEditionParam:(NSDictionary *)param
                   success:(void (^)(NSDictionary *info))success
                   failure:(void (^)(NSError *error))failure;


//流程类型：1-维修拆装，2-pdf阅读，0-暂无
- (void)getFlowType:(NSString *)vin
            success:(void (^)(NSInteger))success
            failure:(void (^)(NSError *error))failure;
@end

