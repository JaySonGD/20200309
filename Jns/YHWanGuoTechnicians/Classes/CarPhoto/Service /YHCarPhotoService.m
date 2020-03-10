//
//  YHCarPhotoService.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarPhotoService.h"
#import "ApiService.h"
#import "YHTools.h"
#import "YHCheckProjectModel.h"
#import "YHTemporarySaveModel.h"
#import "YHCarBaseModel.h"
#import "TTZSurveyModel.h"
#import "YTPlanModel.h"
#import "YTPointsDealModel.h"
#import "YTPayModeInfo.h"
#import "YTWarranty.h"
#import "YTBillPackageModel.h"


#import <MJExtension.h>

@implementation YHCarPhotoService



/**
 * 工单图片接口
 */

- (void)getBillImageListByBillId:(NSString*)billId
                         imgCode:(NSString*)code
                           type:(NSInteger)type
                        success:(void (^)(NSArray *list))success
                        failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (token == nil || billId == nil || code == nil) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"bill_id":billId,@"code":code,@"type":@(type)}mutableCopy];
    [self YHBasePOST:[ApiService sharedApiService].getBillImageListURL
               param:parameters
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              NSArray *lists = [[info valueForKey:@"data"] valueForKey:@"list"];
              !(success)? : success(lists);
          } onError:failure];
    
}

/**
 * 删除工单图片接口
 */

- (void)deleteBillImageByBillId:(NSString*)billId
                         imgURL:(NSString*)url
                           type:(NSInteger)type
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (token == nil || billId == nil || url == nil) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"bill_id":billId,@"img_url":url,@"type":@(type)}mutableCopy];
    [self YHBasePOST:[ApiService sharedApiService].deleteBillImageURL
               param:parameters
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              !(success)? : success();
          } onError:failure];
    
}

/**
 * 故障码获取电控检测项目列表
 */

- (void)getEngineWaterTProjectListByBillId:(NSString*)billId
                            projectId:(NSString*)projectId
                             projectVal:(NSString*)projectVal
                               success:(void (^)(NSArray *))success
                               failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (token == nil || billId == nil || projectId == nil || projectVal == nil) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"projectId":projectId,@"projectVal":projectVal}mutableCopy];
    [self YHBasePOST:[ApiService sharedApiService].getEngineWaterTProjectListURL
               param:parameters
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              NSArray *arrays = [info valueForKey:@"data"];
              !(success)? : success(arrays);
              //!(success)? : success(obj);
              
          } onError:failure];
}
/**
 * 故障码获取电控检测项目列表
 */

- (void)getElecCtrlProjectListByBillId:(NSString*)billId
                       sysClassId:(NSString*)sysClassId
                        faultCode:(NSString*)faultCode
                          success:(void (^)(NSDictionary *))success
                          failure:(void (^)(NSError *error))failure{

    NSString *token = [YHTools getAccessToken];
    if (token == nil || billId == nil || sysClassId == nil || faultCode == nil) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }

    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"sysClassId":sysClassId,@"faultCode":faultCode}mutableCopy];
    [self YHBasePOST:[ApiService sharedApiService].getElecCtrlProjectListByFaultCodeURL
               param:parameters
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              NSDictionary *dic = [info valueForKey:@"data"];
              
              NSDictionary *obj = @{
                @"encyDescs": @"百科呵呵哒了",
                @"list": @[]
                };


              !(success)? : success(dic);
              //!(success)? : success(obj);

          } onError:failure];
 
}


/**
 *  检测是否有工单约束
 */

- (void)checkRestrictForVin:(NSString *)vin
                    Success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,@"vin":vin};
    
    [self YHBasePOST:[ApiService sharedApiService].checkRestrictURL
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]?info[@"msg"]:@"未知错误"}]);
                  
                  return ;
              }
              
              NSDictionary *dic = [info valueForKey:@"data"];
//              NSString *amount = [dic valueForKey:@"amount"];
//              //amount = @"344.00";
//              if (!amount) {
//                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
//                  return;
//              }
              !(success)? : success(dic);
              
          } onError:failure];
}


/**
 *  检测客户车辆信息
 */

//- (void)checkCustomerForVin:(NSString *)vin
//                    Success:(void (^)(NSDictionary *))success
//                    failure:(void (^)(NSError *error))failure{
//    
//    NSString *token = [YHTools getAccessToken];
//    if (!token) {
//        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
//        return;
//    }
//    NSDictionary *param = @{@"token":token,@"vin":vin};
//    
//    [self YHBasePOST:[ApiService sharedApiService].checkCustomerURL
//               param:param
//          onComplete:^(NSDictionary *info) {
//              NSLog(@"%s--%@", __func__,info);
//              
//              NSInteger code = [info[@"code"] integerValue];
//              if (code != 20000) {
//                  
//                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
//                  
//                  return ;
//              }
//              
//              NSDictionary *dic = [info valueForKey:@"data"];
//              
//              !(success)? : success(dic);
//              
//          } onError:failure];
//}

/**
 *  记录事件日志接口
 */
- (void)addEventForBillId:(NSString *)value1
                   proVal:(NSString *)value2
                 isFinish:(BOOL)finish{
    
    NSString *token = [YHTools getAccessToken];
    NSDictionary *param = @{@"token":token,
                            @"event_type":@(1),
                            @"event_stype":@(1),
                            @"event_gstype":@(1+finish),
                            @"value1":value1,
                            @"value2":value2};
    [self YHBasePOST:[ApiService sharedApiService].addEventLogURL
               param:param
          onComplete:^(NSDictionary *info) {
              
          } onError:^(NSError *error) {
              
          }];
    
}

//代录
- (void)saveReplaceDetectiveInitialSurvey:(NSString *)billId
                             value:(NSArray *)val
                              info:(NSDictionary *)baseInfo
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"billId":billId,
                            @"baseInfo":baseInfo,
                            @"initialSurveyVal":val,
                            @"reqType" : @"initialSurvey"
                            };
    
    
    [self YHBasePOST:[ApiService sharedApiService].saveReplaceInitialSurveyURL
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success();
              
          } onError:failure];
}

//保存复检项目录入
- (void)saveRecheckInputInitialSurvey:(NSString *)billId
                             value:(NSArray *)val
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"billId":billId,
                            @"initialSurveyVal":val
                            };
    
    
    [self YHBasePOST:[ApiService sharedApiService].saveRecheckInput
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success();
              
          } onError:failure];
}

- (void)saveInitialSurveyForBillId:(NSString *)billId
                             value:(NSArray *)val
                              info:(NSDictionary *)baseInfo
                            isHelp:(BOOL)isHelp
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"billId":billId,
                            @"baseInfo":baseInfo,
                            @"initialSurveyVal":val,};

    
    [self YHBasePOST:((isHelp)? ([ApiService sharedApiService].saveHelpInitialSurveyURL) : ([ApiService sharedApiService].saveUsedCarInitialSurveyURL))
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success();
              
          } onError:failure];
}

- (void)temporarySaveForBillId:(NSString *)billId
                         value:(NSDictionary *)val
                        isHelp:(BOOL)isHelp
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    
    [self YHBasePOST: ((isHelp)? ([ApiService sharedApiService].temporaryHelpSaveURL) : ([ApiService sharedApiService].temporarySaveURL))
               param:@{@"billId":billId,@"val":val,@"token":token}
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              !(success)? : success();
              
          } onError:failure];
    
}



- (void)detailForBillId:(NSString *)billId
                 isHelp:(BOOL)isHelp
                success:(void (^)(NSMutableArray<YHSurveyCheckProjectModel *>*models,YHCarBaseModel*baseInfo,YHTemporarySaveModel*temp))success
                failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    //NSDictionary *parameters = @{@"token":token,@"billId":billId};
    [self YHBasePOST:((isHelp)? ([ApiService sharedApiService].getHelpBillDetailURL) : ([ApiService sharedApiService].getBillDetailURL)) 
               param:@{@"token":token,@"billId":billId}
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              NSMutableArray <YHSurveyCheckProjectModel *>*models = [YHSurveyCheckProjectModel mj_objectArrayWithKeyValuesArray:info[@"data"][@"initialSurveyCheckProject"]];
              
              YHTemporarySaveModel *model = [YHTemporarySaveModel mj_objectWithKeyValues:info[@"data"][@"temporarySave"]];
              
              YHCarBaseModel *baseInfo = [YHCarBaseModel mj_objectWithKeyValues:info[@"data"][@"baseInfo"]];

              
              //遍历缓存数据
              [model.initialSurveyProjectVal enumerateObjectsUsingBlock:^(YHInitialSurveyProjectValModel * _Nonnull tempSave, NSUInteger idx, BOOL * _Nonnull stop) {
                  
                  // 缓存状态
                  [models enumerateObjectsUsingBlock:^(YHSurveyCheckProjectModel * _Nonnull page, NSUInteger idx, BOOL * _Nonnull stop) {
                      
                      if(!page.isFinish) { page.isFinish = ([tempSave.saveType isEqualToString:@"finish"] && [tempSave.sysId isEqualToString:page.name]);}
                      
                  }];
                  //遍历范围数据
                  [models enumerateObjectsUsingBlock:^(YHSurveyCheckProjectModel * _Nonnull surveyCheckProjectModel, NSUInteger idx, BOOL * _Nonnull stop) {
                      
                      // 缓存数据==二级页面
                      if([tempSave.sysId isEqualToString:surveyCheckProjectModel.name]){
                          
                          // 所有缓存数据
                          [tempSave.projectVal enumerateObjectsUsingBlock:^(YHProjectValModel * _Nonnull projectVal, NSUInteger idx, BOOL * _Nonnull stop) {
                              
                              [surveyCheckProjectModel.projectList enumerateObjectsUsingBlock:^(YHProjectListGroundModel * _Nonnull groundModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                  
                                  if([groundModel.intervalType isEqualToString:@"textarea"] && !groundModel.projectList.count){
                                      
                                      YHProjectListModel *listModel = [YHProjectListModel new];
                                      listModel.intervalType = @"textarea";
                                      listModel.Id = groundModel.Id;
                                      [groundModel.projectList addObject:listModel];

                                  }
                                  
                                  [groundModel.projectList enumerateObjectsUsingBlock:^(YHProjectListModel * _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
                                      
                                      if ([projectVal.Id isEqualToString:list.Id]) {// 缓存数据== cell id
                                          
                                          NSArray *val = [projectVal.projectVal componentsSeparatedByString:@","];
                                          
                                          [val enumerateObjectsUsingBlock:^(NSString *  _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
                                              
                                              if([list.intervalType isEqualToString:@"select"] || [list.intervalType isEqualToString:@"radio"]){
                                                  [list.intervalRange.list enumerateObjectsUsingBlock:^(YHlistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                      if ([v isEqualToString:obj.name]) {
                                                          obj.isSelect = YES;
                                                      }
                                                  }];
                                              }else if ([list.intervalType isEqualToString:@"text"]){
                                                  list.projectVal = val.firstObject;
                                              }else if ([list.intervalType isEqualToString:@"textarea"]){
                                                  list.projectVal = val.firstObject;
                                              }
                                              else if ([list.intervalType isEqualToString:@"form"]){
                                                  if(idx==0){ list.intervalRange.list.firstObject.name = v;}
                                                 else{
                                                     YHlistModel *model = [YHlistModel new];
                                                     model.isDelete = YES;
                                                     model.name = v;
                                                     model.placeholder = list.intervalRange.list.firstObject.placeholder;

                                                     [list.intervalRange.list addObject:model];
                                                 }
                                              }

                                              
                                          }];
                                          
                                          
                                      }
                                      
                                  }];
                              }];
                          }];
                      }
                      
                  }];
                  
              }];
              
              !(success)? : success(models,baseInfo,model);
              
          } onError:failure];
    
}

//FIXME:  -  NEW
- (void)newWorkOrderDetailForBillId:(NSString *)billId
                success:(void (^)(NSMutableArray<TTZSYSModel *>*models,NSDictionary*obj))success
                failure:(void (^)(NSError *error))failure{
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getHelpBillDetailURL
               param:@{@"token":token,@"billId":billId}
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              NSArray *initialSurveyItemVals = [[info valueForKeyPath:@"data"] valueForKeyPath:@"initialSurveyItemVal"];
              NSArray *initialSurveyItems = [[info valueForKeyPath:@"data"] valueForKeyPath:@"initialSurveyItem"];
              NSArray *m_item_vals = [[info valueForKeyPath:@"data"] valueForKeyPath:@"m_item_val"];
              NSArray *arr = [info[@"data"][@"billType"] isEqualToString:@"J007"] ? m_item_vals : initialSurveyItems?initialSurveyItems:initialSurveyItemVals;
        
            if([info[@"data"][@"billType"] isEqualToString:@"A"] && [info[@"nowStatusCode"] isEqualToString:@"extWarrantyInitialSurvey"]){//查看结果
                arr = [[info valueForKeyPath:@"data"] valueForKeyPath:@"reportData.sysInfo"];
            }
            
            if([info[@"data"][@"nextStatusCode"] isEqualToString:@"extendReview"]){//复检单
                arr = [[info valueForKeyPath:@"data"] valueForKeyPath:@"recheck_item"];
            }
             
           
              NSMutableArray <TTZSYSModel *>*models = [TTZSYSModel mj_objectArrayWithKeyValuesArray:arr];
              [models enumerateObjectsUsingBlock:^(TTZSYSModel * _Nonnull sobj, NSUInteger idx, BOOL * _Nonnull stop) {
                  [sobj.list enumerateObjectsUsingBlock:^(TTZGroundModel * _Nonnull gobj, NSUInteger idx, BOOL * _Nonnull stop) {
                      [gobj.list enumerateObjectsUsingBlock:^(TTZSurveyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                          obj.billId = billId;
                          if(obj.uploadImgStatus) [obj dbImages];
                      }];
                  }];
              }];
              
              !(success)? : success(models,info);
              
          } onError:failure];
    
}

//FIXME:  -  new
- (void)newTemporarySaveForBillId:(NSString *)billId
                         value:(NSDictionary *)val
                       success:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure{
    
    [self temporarySaveForBillId:billId value:val isHelp:YES success:success failure:failure];
}

//FIXME:  -  new
- (void)saveInitialSurveyForBillId:(NSString *)billId
                             value:(NSArray *)val
                              info:(NSDictionary *)baseInfo
                            isJ002:(BOOL)isJ002
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure{

    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"billId":billId,
                            @"baseInfo":baseInfo,
                            @"initialSurveyVal":val,};
    
    
    
    [self YHBasePOST:((isJ002)? ([ApiService sharedApiService].saveJ002InitialSurveyURL) : ([ApiService sharedApiService].saveKJ001InitialSurveyURL))
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success();
              
          } onError:failure];

}

//FIXME:  -  new
- (void)saveYAY001InitialSurveyForBillId:(NSString *)billId
                             value:(NSArray *)val
                              info:(NSDictionary *)baseInfo
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"billId":billId,
                            @"baseInfo":baseInfo,
                            @"initialSurveyVal":val,};
    
    
    
    [self YHBasePOST:[ApiService sharedApiService].saveYAY001InitialSurveyURL
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success();
              
          } onError:failure];
    
}

//FIXME:  -  new
- (void)saveJ004InitialSurveyForBillId:(NSString *)billId
                                   value:(NSArray *)val
                                    info:(NSDictionary *)baseInfo
                                 success:(void (^)(void))success
                                 failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"billId":billId,
                            @"baseInfo":baseInfo,
                            @"initialSurveyVal":val,};
    
    
    
    [self YHBasePOST:[ApiService sharedApiService].saveJ004InitialSurveyURL
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success();
              
          } onError:failure];
    
}

//FIXME:  -  J007提交诊断接口
- (void)saveJ007InitialSurveyForBillId:(NSString *)billId
                                 value:(NSArray *)val
                                  info:(NSDictionary *)baseInfo
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"billId":billId,
                            @"reqType":@"initialSurvey",
                            @"baseInfo":baseInfo,
                            @"initialSurveyVal":val,};
    
    
    
    [self YHBasePOST:[ApiService sharedApiService].saveJ007InitialSurveyURL
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success();
              
          } onError:failure];
    
}

//FIXME:  - 获取验证码
- (void)sendSms:(NSString *)mobile
           code:(NSString *)autoVerifyCode
        success:(void (^)(NSString *expire,NSString *imgCodeUrl))success
        failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    param[@"checkType"] = @"sendSms";
    if (autoVerifyCode) {
        param[@"autoVerifyCode"] = autoVerifyCode;
    }

    
    [self YHBasePOST:[ApiService sharedApiService].findPassword
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              
              if (code == 20000) {
                  !(success)? : success(info[@"data"][@"intervalTime"],nil);
                  return ;
              }
              if (code == 40800) {
                  !(success)? : success(nil,[ApiService sharedApiService].getFindPasswordImage);
                  return ;
              }
              
              if (code == 40000 && autoVerifyCode) {//验证码过期
                  
                  !(failure)? : failure(nil);
                  return;
              }
              
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);

          } onError:failure];
    
}


//FIXME:  - 验证验证码
- (void)checkVerifyCode:(NSString *)verifyCode
                phone:(NSString *)mobile
              success:(void (^)(void))success
              failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    param[@"checkType"] = @"checkVerifyCode";
    param[@"verifyCode"] = verifyCode;
    
    
    
    [self YHBasePOST:[ApiService sharedApiService].findPassword
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              
              if (code == 20000) {
                  !(success)? : success();
                  return ;
              }
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
              
          } onError:failure];
    
}


//FIXME:  - 重置密码
- (void)resetPassword:(NSString *)pwd
                phone:(NSString *)mobile
              success:(void (^)(void))success
              failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    param[@"checkType"] = @"resetPassword";
    param[@"passwd"] = pwd;
    
    
    
    [self YHBasePOST:[ApiService sharedApiService].findPassword
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              
              if (code == 20000) {
                  !(success)? : success();
                  return ;
              }
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
              
          } onError:failure];
    
}


//- (void)getLoginVerifyCodeSuccess:(void (^)(NSString *imgCode))success
//                          failure:(void (^)(NSError *error))failure{
//    
//    
//    [self YHBasePOST:[ApiService sharedApiService].getFindPasswordImage
//               param:nil
//          onComplete:^(NSDictionary *info) {
//              NSLog(@"%s--%@", __func__,info);
//              
//              NSInteger code = [info[@"code"] integerValue];
//              
//              if (code == 20000) {
//                  !(success)? : success(info[@"data"][@"verify_img"]);
//                  return ;
//              }
//              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
//              
//          } onError:failure];
//    
//}


//FIXME:  - 根据车牌号获取vin号
- (void)getVinByPlateNumber:(NSString *)plate_number
                    success:(void (^)(NSString *vin,BOOL billStatus))success
              failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"plate_number":plate_number,
                            };
    
    
    [self YHBasePOST:[ApiService sharedApiService].getVinByPlateNumberURL
               param:param
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
//              "vin": "WW3W3OK9J9DFJI84J"    //车架号
//              "bill_status":1    //是否有未完成工单 1:有，0：没有
              if (code == 20000) {
                  NSString *vin = [info[@"data"] valueForKey:@"vin"];
                  BOOL bill_status = [[info[@"data"] valueForKey:@"bill_status"] boolValue];

                  !(success)? : success(vin,bill_status);
                  return ;
              }
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
              
          } onError:failure];
    
}


//FIXME:  - 根据车架号获取最新未完成的工单状态接口
- (void)getBillStatusByVin:(NSString *)vin
                   success:(void (^)(BOOL billStatus))success
                   failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"vin":vin,
                            };
    
    
    [self YHBasePOST:[ApiService sharedApiService].getBillStatusByVinURL
               param:param
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              //              "vin": "WW3W3OK9J9DFJI84J"    //车架号
              //              "bill_status":1    //是否有未完成工单 1:有，0：没有
              if (code == 20000) {
                  BOOL bill_status = [[info[@"data"] valueForKey:@"bill_status"] boolValue];
                  
                  !(success)? : success(bill_status);
                  return ;
              }
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
              
          } onError:failure];
    
}


- (void)orgFunctionOrderPaySuccess:(void (^)(NSDictionary *info))success
                           failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token
                            };
    [self YHBasePOST:[ApiService sharedApiService].orgFunctionOrderPayURL
               param:param
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code == 30100) {
                  NSDictionary *data = info[@"data"];
                  !(success)? : success(data);
                  return ;
              }else if (code == 40017){
                  !(success)? : success(nil);
                  return;
              }
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
              
          } onError:failure];
    
}


//FIXME:  -  NEW
- (void)getCheckResultList:(NSString *)keyword
                            success:(void (^)(NSMutableArray<YTCheckResultModel *>*models))success
                            failure:(void (^)(NSError *error))failure{
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getCheckResultListURL
               param:@{@"token":token,
                       @"keyword":keyword,
                       @"page" : @(1),
                       @"pagesize" : @(1000)
                       }
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              NSArray *list = [[info valueForKeyPath:@"data"] valueForKeyPath:@"list"];
              
              NSMutableArray <YTCheckResultModel *>*models = [YTCheckResultModel mj_objectArrayWithKeyValuesArray:list];
              !(success)? : success(models);
              
          } onError:failure];
    
}



//FIXME:  -  NEW
//参数名    必选    类型    说明
//token    是    string    登录标识
//solution_check_result_id    是    int    解决方案诊断结果id
//brand_id    是    int    品牌ID
//line_id    是    int    车系ID
//car_cc    是    string    排量 如：1.6L，要带单位
//car_year    是    int    年份

- (void)getQualitySolutionDataList:(NSString *)solution_check_result_id
                          brand_id:(NSString *)brand_id
                          line_id:(NSString *)line_id
                          car_cc:(NSString *)car_cc
                          car_year:(NSString *)car_year
                   success:(void (^)(NSMutableArray<YTPlanModel *>*models))success
                   failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getQualitySolutionDataListURL
               param:@{@"token":token,
                       @"solution_check_result_id":solution_check_result_id,
                       @"brand_id":brand_id,
                       @"line_id":line_id,
                       @"car_cc":car_cc,
                       @"car_year":car_year
                       }
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              NSArray *list = [[info valueForKeyPath:@"data"] valueForKeyPath:@"scheme"];
              
              NSMutableArray <YTPlanModel *>*models = [YTPlanModel mj_objectArrayWithKeyValuesArray:list];
              !(success)? : success(models);
              
          } onError:failure];
}

//参数名    必选    类型    说明
//token    是    string    标识
//billId    是    int    工单id
//price    否    int    需要付的钱（不给默认支付全额）

- (void)pointsDealPay:(NSString *)org_id
              price:(NSString *)pay_amount
            success:(void (^)(NSDictionary *info))success
            failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].pointsDealPay
               param:  @{@"token":token,
                         @"org_id":org_id,
                         @"pay_amount":pay_amount
                         }
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code == 30100) {
                  NSDictionary *data = info[@"data"];
                  !(success)? : success(data);
                  return ;
              }
//                  else if (code == 40017){
//                  !(success)? : success(nil);
//                  return;
//              }
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
              
          } onError:failure];
}


//参数名    必选    类型    说明
//token    是    string    标识
//billId    是    int    工单id
//price    否    int    需要付的钱（不给默认支付全额）

- (void)solutionPay:(NSString *)billId
              price:(NSString *)price
                           success:(void (^)(NSDictionary *info))success
                           failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].solutionPayURL
               param: IsEmptyStr(price)? @{@"token":token,
                                           @"bill_id":billId
                                           } : @{@"token":token,
                       @"bill_id":billId,
                       @"price":price
                       }
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code == 30100) {
                  NSDictionary *data = info[@"data"];
                  !(success)? : success(data);
                  return ;
              }else if (code == 40017){
                  !(success)? : success(nil);
                  return;
              }
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);

          } onError:failure];
}



//参数名    必选    类型    说明
//参数名    必选    类型    说明
//token    是    string    token
//billId    是    string    工单id

- (void)splitPayInfo:(NSString *)billId
            success:(void (^)(YTSplitPayInfoModel *info))success
            failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].splitPayInfoURL
               param:@{@"token":token,
                       @"bill_id":billId
                       }
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code == 20000) {
                  NSDictionary *data = info[@"data"];
                  YTSplitPayInfoModel *model = [YTSplitPayInfoModel mj_objectWithKeyValues:data];
                  !(success)? : success(model);
                  return ;
              }
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
              
          } onError:failure];
}

//参数名    必选    类型    说明
//参数名    必选    类型    说明
//token    是    string    token
//order_id    是    string    工单id

- (void)airConditionOrderPay:(NSString *)order_id
             success:(void (^)(NSDictionary *info))success
             failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    /*
     token:6a16968bb93a4f3e303bd48ee2f23548
     order_id:115
     */
    [self YHBasePOST:[ApiService sharedApiService].airConditionOrderPayInfoURL
               param:@{ @"token":token,
                       @"order_id":order_id
                       }
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code == 30100) {
                  NSDictionary *data = info[@"data"];
                  !(success)? : success(data);
                  return ;
              }
              !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
              
          } onError:failure];
}


//FIXME:  -  W001
- (void)newW001WorkOrderDetailForBillId:(NSString *)billId
                            success:(void (^)(YTDiagnoseModel *model,NSDictionary*obj))success
                            failure:(void (^)(NSError *error))failure{
    NSString *token = [YHTools getAccessToken];
    if (!token || !billId) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getHelpBillDetailURL
               param:@{@"token":token,@"billId":billId}
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              NSDictionary *data = [info valueForKey:@"data"];
              
//              NSArray *initialSurveyItemVals = [[info valueForKeyPath:@"data"] valueForKeyPath:@"initialSurveyItemVal"];
//              NSArray *initialSurveyItems = [[info valueForKeyPath:@"data"] valueForKeyPath:@"initialSurveyItem"];
//
              YTDiagnoseModel *model = [YTDiagnoseModel mj_objectWithKeyValues:data];
              model.billId = billId;
              !(success)? : success(model,info);
              
          } onError:failure];
    
}

/*
 "billId":1,
 "billType":"G",
 "nowStatusCode":"endBill",
 "nextStatusCode":"",
 "handleType":"detail",
 */
- (void)saveAffirmComplete:(NSString *)billId
                   success:(void (^)(NSDictionary*obj))success
                   failure:(void (^)(NSError *error))failure{
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].saveAffirmCompleteURL
               param:@{@"token":token,@"billId":billId}
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              NSDictionary *billStatus = [info valueForKey:@"billStatus"];
              !(success)? : success(billStatus);
              
          } onError:failure];
    
}
    
    
    /*
     "billId":1,
     "billType":"G",
     "nowStatusCode":"endBill",
     "nextStatusCode":"",
     "handleType":"detail",
     */
- (void)helperAirConditionSuccess:(void (^)(NSMutableArray<TTZSYSModel *>*models))success
                   failure:(void (^)(NSError *error))failure{
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].helperAirConditionListURL
               param:@{@"token":token}
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              NSArray *list = [[info valueForKey:@"data"] valueForKey:@"list"];
              NSMutableArray <TTZSurveyModel *>*lists = [TTZSurveyModel mj_objectArrayWithKeyValuesArray:list];
              
              TTZGroundModel *gs = [TTZGroundModel new];
              gs.list = lists;
              gs.projectName = @"空调诊断";

              
              TTZSYSModel *sys = [TTZSYSModel new];
              sys.list = [NSMutableArray arrayWithObject:gs];
              sys.className = @"空调诊断";
              
              //NSMutableArray <TTZSYSModel *>*models = [TTZSYSModel mj_objectArrayWithKeyValuesArray:initialSurveyItems?initialSurveyItems:initialSurveyItemVals];
              //!(success)? : success(models,info);
              
              //NSDictionary *billStatus = [info valueForKey:@"billStatus"];
              !(success)? : success([NSMutableArray arrayWithObject:sys]);
              
          } onError:failure];
    
}
    
    
    - (void)getAirConditionResult:(NSArray *)check_project
                              success:(void (^)(NSMutableArray<NSDictionary *>*models))success
                              failure:(void (^)(NSError *error))failure{
        NSString *token = [YHTools getAccessToken];
        if (!token) {
            !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
            return;
        }
        [self YHBasePOST:[ApiService sharedApiService].getAirConditionResultURL
                   param:@{@"token":token,@"check_project":check_project}
              onComplete:^(NSDictionary *info) {
                  NSLog(@"%s", __func__);
                  
                  NSInteger code = [info[@"code"] integerValue];
                  if (code != 20000) {
                      
                      !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                      return ;
                  }
                  NSDictionary *data = [info valueForKey:@"data"];
                  
                  NSDictionary *detectResult = @{
                                                 @"title":@"诊断结果",
                                                 @"list":@[@{@"title":data[@"detectResult"]?data[@"detectResult"]:@""}]
                                                 };
                  
                  NSMutableArray *maintenancelist = @[].mutableCopy;
                  [data[@"maintenance"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                      [maintenancelist addObject:@{@"title":[NSString stringWithFormat:@"%ld.%@",idx + 1,obj[@"itemName"]]}];
                  }];
                  NSDictionary *maintenance = @{
                                                @"title":@"维修项目",
                                                @"list":maintenancelist
                                                };


                  NSDictionary *parts = @{
                                          @"title":@"配件",
                                          @"list":data[@"parts"]?data[@"parts"]:@[]

                                          };
                  
                  NSDictionary *supplies = @{
                                          @"title":@"配件",
                                          @"list":data[@"supplies"]?data[@"supplies"]:@[]
                                          };

                  
                  NSLog(@"%s", __func__);
//                  NSArray *list = [[info valueForKey:@"data"] valueForKey:@"list"];
//                  NSMutableArray <TTZSurveyModel *>*lists = [TTZSurveyModel mj_objectArrayWithKeyValuesArray:list];
//
//                  TTZGroundModel *gs = [TTZGroundModel new];
//                  gs.list = lists;
//                  gs.projectName = @"空调诊断";
//
//
//                  TTZSYSModel *sys = [TTZSYSModel new];
//                  sys.list = [NSMutableArray arrayWithObject:gs];
//                  sys.className = @"空调诊断";
                  
                  //NSMutableArray <TTZSYSModel *>*models = [TTZSYSModel mj_objectArrayWithKeyValuesArray:initialSurveyItems?initialSurveyItems:initialSurveyItemVals];
                  //!(success)? : success(models,info);
                  
                  //NSDictionary *billStatus = [info valueForKey:@"billStatus"];
                  !(success)? : success(@[detectResult,maintenance,parts,supplies].mutableCopy);
                  
              } onError:failure];
        
    }



- (void)getPointsDealPayInfoSuccess:(void (^)(YTPointsDealModel *obj))success
                            failure:(void (^)(NSError *error))failure{
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getPointsDealPayInfoURL
               param:@{@"token":token}
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              !(success)? : success([YTPointsDealModel mj_objectWithKeyValues:info[@"data"]]);
              
          } onError:failure];
    
}


- (void)getPointsDealListOrgCode:(NSString *)org_id
                         success:(void (^)( NSMutableArray <YTPointsDealListModel *> *obj))success
                            failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getPointsDealList
               param:@{@"token":token,@"org_id":org_id,@"pagesize":@"100000000000"}
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              !(success)? : success([YTPointsDealListModel mj_objectArrayWithKeyValuesArray:info[@"data"][@"list"]]);
              
          } onError:failure];
    
}



- (void)getPointsDealInfoById:(NSString *)id
                      success:(void (^)(YTPointsDealDetailModel *obj))success
                      failure:(void (^)(NSError *error))failure{
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getPointsDealInfoById
               param:@{@"token":token,@"id":id}
          onComplete:^(NSDictionary *info) {
              
//              NSDictionary *obj = @{@"shopOpenId":@"657932D9155649389D0E5F570B6C7D01",
//                                    @"shopName":@"绿地中心站21",
//                                    @"priceList":@[
//                                            @"50",
//                                            @"100",
//                                            @"200",
//                                            @"800"
//                                            ]};
//
//              !(success)? : success([YTPointsDealModel mj_objectWithKeyValues:obj]);
//              return ;
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              !(success)? : success([YTPointsDealDetailModel mj_objectWithKeyValues:info[@"data"]]);
              
          } onError:failure];
    
}

//FIXME:  -  获取AI空调检测项目接口
- (void)getAirConditionerItemDataOrderId:(NSString *)order_id
                                 success:(void (^)(NSMutableArray<TTZSYSModel *>*models,NSDictionary *baseInfo))success
                                 failure:(void (^)(NSError *error))failure{
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getAirConditionerItemData
               param:@{@"token":token,@"order_id":order_id}
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              NSArray *list = [[info valueForKey:@"data"] valueForKey:@"list"];
              NSMutableArray <TTZSurveyModel *>*lists = [TTZSurveyModel mj_objectArrayWithKeyValuesArray:list];
              
              TTZGroundModel *gs = [TTZGroundModel new];
              gs.list = lists;
              gs.projectName = @"空调诊断";
              
              
              TTZSYSModel *sys = [TTZSYSModel new];
              sys.list = [NSMutableArray arrayWithObject:gs];
              sys.className = @"空调诊断";
              
              //NSMutableArray <TTZSYSModel *>*models = [TTZSYSModel mj_objectArrayWithKeyValuesArray:initialSurveyItems?initialSurveyItems:initialSurveyItemVals];
              //!(success)? : success(models,info);
              
              //NSDictionary *billStatus = [info valueForKey:@"billStatus"];
              !(success)? : success([NSMutableArray arrayWithObject:sys],[[info valueForKey:@"data"] valueForKey:@"base_info"]);
              
          } onError:failure];
    
}


//FIXME:  -  保存编辑AI空调检测数据接口
- (void)saveAirConditionCheckInfoWithOrderId:(NSString *)order_id
                                       value:(NSArray *)check_project
                                     success:(void (^)(void))success
                                     failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"order_id":order_id,
                            @"check_project":check_project,
                            };
    
    
    
    [self YHBasePOST:[ApiService sharedApiService].saveAirConditionCheckInfo
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success();
              
          } onError:failure];
    
}


//FIXME:  -  保存编辑AI空调检测数据接口
- (void)getPayModeInfo:(NSString *)bill_id
   parts_suggestion_id:(NSString *)parts_suggestion_id
              buy_type:(NSInteger )buy_type
             bill_sort:(NSString *)bill_sort
             vin:(NSString *)vin
             code:(NSString *)code
               success:(void (^)(YTPayModeInfo *obj))success
               failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSMutableDictionary *param = @{@"token":token}.mutableCopy;
    if(bill_id){
        param[@"bill_id"] = bill_id;
    }
    if(parts_suggestion_id){
        param[@"parts_suggestion_id"] = parts_suggestion_id;
    }
    if(buy_type){
        param[@"buy_type"] = @(buy_type);
    }
    if(bill_sort){
        param[@"bill_sort"] = bill_sort;
    }
    if(vin){
        param[@"vin"] = vin;
    }
    if(code){
        param[@"code"] = code;
    }


    
    [self YHBasePOST: code? [ApiService sharedApiService].getRepairDismountingPayInfo : [ApiService sharedApiService].getPayModeInfo
               param:param
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success([YTPayModeInfo mj_objectWithKeyValues:[info valueForKey:@"data"]]);
              
          } onError:failure];
    
}
    

//FIXME:  -  保存编辑AI空调检测数据接口
- (void)determinePayMode:(NSString *)bill_id
                 payType:(NSString *)type
                 mobile:(NSString *)mobile
                buy_type:(NSInteger )buy_type
     parts_suggestion_id:(NSString *)parts_suggestion_id
               bill_sort:(NSString *)bill_sort
                     vin:(NSString *)vin
                    code:(NSString *)code
               success:(void (^)(NSDictionary *obj))success
               failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSMutableDictionary *param = @{@"token":token,
                            }.mutableCopy;
    
    
    if(bill_id){
        param[@"bill_id"] = bill_id;
    }

    if (!IsEmptyStr(type)) {
        param[@"type"] = type;
    }

    if (mobile) {
        param[@"mobile"] = mobile;
    }
    if (!IsEmptyStr(parts_suggestion_id)) {
        param[@"parts_suggestion_id"] = parts_suggestion_id;
    }
    if(buy_type){
        param[@"buy_type"] = @(buy_type);
    }

    
    if (!IsEmptyStr(bill_sort)) {
        param[@"bill_sort"] = bill_sort;
    }
    if(vin){
        param[@"vin"] = vin;
    }
    if(code){
        param[@"code"] = code;
    }

    
    [self YHBasePOST:code? [ApiService sharedApiService].determineRepairDismountingPay : [ApiService sharedApiService].determinePayMode
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
              
              if (code == 30100) {
                  NSDictionary *obj = [info valueForKey:@"data"];
                  !(success)? : success(obj.allKeys.count? obj : nil);

                  return ;
              }else if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success(nil);
              
          } onError:failure];
    
}


- (void)saveStorePushNewWholeCarReport:(NSString *)billId
                  phone:(NSString *)phone
                 success:(void (^)(NSDictionary *obj))success
                 failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *param = @{@"token":token,
                            @"billId":billId,
                            @"phone":phone,
                            };
    
    [self YHBasePOST:[ApiService sharedApiService].saveStorePushNewWholeCarReport
               param:param
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s--%@", __func__,info);
              
              NSInteger code = [info[@"code"] integerValue];
             if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  
                  return ;
              }
              
              !(success)? : success([info valueForKey:@"data"]);
              
          } onError:failure];
    
}



//FIXME:  -  获取J005检测项目接口
- (void)getJ005ItemBillId:(NSString *)billId
                  success:(void (^)(NSMutableArray<TTZSYSModel *>*models,NSDictionary *baseInfo))success
                 failure:(void (^)(NSError *error))failure{
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getItemList
               param:@{@"token":token,@"billId":billId}
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              
              NSArray *list = [[info valueForKey:@"data"] valueForKey:@"list"];
              NSMutableArray <TTZSurveyModel *>*lists = [TTZSurveyModel mj_objectArrayWithKeyValuesArray:list];
              
              TTZGroundModel *gs = [TTZGroundModel new];
              gs.list = lists;
              gs.projectName = @"深度诊断";
              
              
              TTZSYSModel *sys = [TTZSYSModel new];
              sys.list = [NSMutableArray arrayWithObject:gs];
              sys.className = @"深度诊断";
              
              //NSMutableArray <TTZSYSModel *>*models = [TTZSYSModel mj_objectArrayWithKeyValuesArray:initialSurveyItems?initialSurveyItems:initialSurveyItemVals];
              //!(success)? : success(models,info);
              
              //NSDictionary *billStatus = [info valueForKey:@"billStatus"];
              !(success)? : success([NSMutableArray arrayWithObject:sys],[[info valueForKey:@"data"] valueForKey:@"base_info"]);
              
          } onError:failure];
    
}



//FIXME:  -  保存二手车估值信息
- (void)saveE003QuoteTime:(NSString *)car_license_time
                    price:(NSString *)car_inspection_evaluation_price
         sync_buche_value:(NSInteger )sync_buche_value
                   billId:(NSString *)billId
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].saveE003Quote
               param:@{
                       @"token":token,@"bill_id":billId,
                       @"car_inspection_evaluation_price":car_inspection_evaluation_price,
                       @"car_license_time":car_license_time,
                       @"sync_buche_value":@(sync_buche_value),
                       }
          onComplete:^(NSDictionary *info) {
              NSLog(@"%s", __func__);
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              !(success)? : success();
              
          } onError:failure];
    
}


- (void)getDidUsedCarStatus:(NSString *)vin
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getDidUsedCarStatus
               param:@{
                       @"token":token,@"vin":vin
                       }
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              !(success)? : success([info valueForKey:@"data"]);
              
          } onError:failure];
    
}

- (void)copyUsedCarInitialSurvey:(NSString *)copy_bill_id
                         bill_id:(NSString *)bill_id
                    success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].copyUsedCarInitialSurvey
               param:@{
                       @"token":token,
                       @"bill_id":bill_id,
                       @"copy_bill_id":copy_bill_id
                       }
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              !(success)? : success([info valueForKey:@"data"]);
              
          } onError:failure];
    
}


- (void)getExtendedWarrantyPackageListBill_id:(NSString *)bill_id
                         success:(void (^)(YTExtended *))success
                         failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getExtendedWarrantyPackageList
               param:@{
                       @"token":token,
                       @"bill_id":bill_id,
                       }
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              !(success)? : success([YTExtended mj_objectWithKeyValues:[info valueForKey:@"data"]]);
              
          } onError:failure];
    
}

- (void)saveExtendedWarrantyPackageBill_id:(NSString *)bill_id
                                   ssss_price:(NSString *)ssss_price
                            extended_warranty:(NSArray *)extended_warranty
                                      success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].saveExtendedWarrantyPackage
               param:@{
                       @"token":token,
                       @"bill_id":bill_id,
                       @"ssss_price":ssss_price,
                       @"extended_warranty":extended_warranty
                       }
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              !(success)? : success();
              
          } onError:failure];
    
}


- (void)saveStorePushExtWarrantyReportBill_id:(NSString *)billId
                                phone:(NSString *)phone
                         syncWarrantyPhone:(BOOL)syncWarrantyPhone
                                   success:(void (^)(void))success
                                   failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].saveStorePushExtWarrantyReport
               param:@{
                       @"token":token,
                       @"billId":billId,
                       @"phone":phone,
                       @"syncWarrantyPhone":@(syncWarrantyPhone)
                       }
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              !(success)? : success();
              
          } onError:failure];
    
}


- (void)getBillPackageList:(NSString *)bill_id
                                      success:(void (^)(YTPackageModel *))success
                                      failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getBillPackageList
               param:@{
                       @"token":token,
                       @"bill_id":bill_id,
                       }
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              !(success)? : success([YTPackageModel mj_objectWithKeyValues:[info valueForKey:@"data"]]);
              
          } onError:failure];
    
}


- (void)saveBillPackage:(NSString *)bill_id
                  phone:(NSString *)phone
                is_sync:(BOOL )is_sync
                         bill_package:(NSMutableArray *)bill_package
                                   success:(void (^)(void))success
                                   failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].saveBillPackage
               param:@{
                       @"token":token,
                       @"bill_id":bill_id,
                       @"bill_package":bill_package,
                       @"is_sync":@(is_sync),
                       @"phone":phone
//                       @"bill_package":
//                               @{@"first_maintenance_package_a":@[@"11",@"33"],
//                           @"first_maintenance_package_b":@[@"11",@"33"]}
//                           ]
                       }
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              !(success)? : success();
              
          } onError:failure];
    
}


- (void)getAppEditionParam:(NSDictionary *)param
                   success:(void (^)(NSDictionary *info))success
                   failure:(void (^)(NSError *error))failure{
    
    [self YHBasePOST:[ApiService sharedApiService].getAppEdition
               param:param
//                    @{
//                       @"app_id":@"yh1XqnVMsZxJNrqAPs",
//                       @"app_type":@"ios",
//                       @"app_type_id":@"jns"
//                       }
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              !(success)? : success(info[@"data"]);
              
          } onError:failure];
    
}



- (void)getFlowType:(NSString *)vin
            success:(void (^)(NSInteger))success
                failure:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    [self YHBasePOST:[ApiService sharedApiService].getFlowType
               param:@{
                       @"token":token,
                       @"vin":vin
                       }
          onComplete:^(NSDictionary *info) {
              
              NSInteger code = [info[@"code"] integerValue];
              if (code != 20000) {
                  
                  !(failure)? : failure([NSError errorWithDomain:@"" code:code userInfo:@{@"message" : info[@"msg"]}]);
                  return ;
              }
              NSInteger flow_type = [info[@"data"][@"flow_type"] integerValue];
              !(success)? : success(flow_type);
              
          } onError:failure];
    
}




@end
