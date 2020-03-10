//
//  ZZSubmitDataService.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 27/11/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import "ZZSubmitDataService.h"

#import "YHCarPhotoService.h"

#import "TTZSurveyModel.h"

@implementation ZZSubmitDataService

+ (void)saveInitialSurveyForBillId:(NSString *)billid
                          billType:(NSString *)billType
                        submitData:(NSMutableArray<TTZSYSModel *>*)data
                          baseInfo:(NSDictionary *)info
                           success:(void (^)(void))success
                           failure:(void (^)(NSError * _Nonnull))failure{
    
    NSMutableArray *projectVal = [self submitProjectVal:data with:billType];
     

    //判断是否是有代录权限
    BOOL saveReplaceDetectiveInitialSurvey = YES;//代录
    //NSString *billType = [self.orderDetailInfo valueForKey:@"billType"];
    
    if(saveReplaceDetectiveInitialSurvey && ![billType containsString:@"J007"]){
        
        if(!info){//复检
        [[YHCarPhotoService new] saveRecheckInputInitialSurvey:billid
                                                                    value:projectVal
                                                                  success:^{
                                                                      !(success)? : success();

                                                                  }
                                                                  failure:^(NSError *error) {
                                                                      !(failure)? : failure(error);

                                                                  }];
        }else{

        [[YHCarPhotoService new] saveReplaceDetectiveInitialSurvey:billid
                                                             value:projectVal
                                                              info:info
                                                           success:^{
                                                               !(success)? : success();

                                                           }
                                                           failure:^(NSError *error) {
                                                               !(failure)? : failure(error);

                                                           }];
        }
        return;
    }
    
    if([billType isEqualToString:@"E002"] || [billType isEqualToString:@"E003"]){
        [[YHCarPhotoService new] saveInitialSurveyForBillId:billid value:projectVal info:info isHelp:YES success:^{
            !(success)? : success();
        } failure:^(NSError *error) {
            !(failure)? : failure(error);
        }];
        return;
    }
    
    if ([billType isEqualToString:@"J004"] ||
        [billType isEqualToString:@"J005"] ||
        [billType isEqualToString:@"J006"] ||
        [billType containsString:@"J007"]  ||
        [billType containsString:@"J009"]  ||
        [billType containsString:@"J008"]
        ) {
        
        if([billType hasSuffix:@"J"]){
            [[YHCarPhotoService new] saveJ007InitialSurveyForBillId:billid
                                                              value:projectVal
                                                               info:info
                                                            success:^{
                                                                !(success)? : success();
                                                                
                                                            }
                                                            failure:^(NSError *error) {
                                                                !(failure)? : failure(error);
                                                                
                                                            }];
            
            return;
        }
        
        [[YHCarPhotoService new] saveJ004InitialSurveyForBillId:billid
                                                            value:projectVal
                                                             info:info
                                                          success:^{
                                                              !(success)? : success();
                                                              
                                                          }
                                                          failure:^(NSError *error) {
                                                              !(failure)? : failure(error);
                                                              
                                                          }];

        return;
    }
    
    if ([billType isEqualToString:@"A"] || [billType isEqualToString:@"Y"] || [billType isEqualToString:@"Y001"] || [billType isEqualToString:@"Y002"]) {
        [[YHCarPhotoService new] saveYAY001InitialSurveyForBillId:billid
                                                            value:projectVal
                                                             info:info
                                                          success:^{
                                                              !(success)? : success();

                                                          }
                                                          failure:^(NSError *error) {
                                                              !(failure)? : failure(error);

                                                          }];
        return;
    }
    
    [[YHCarPhotoService new] saveInitialSurveyForBillId:billid
                                                  value:projectVal
                                                   info:info
                                                 isJ002:[billType isEqualToString:@"J002"]
                                                success:^{
                                                    !(success)? : success();

                                                }
                                                failure:^(NSError *error) {
                                                    !(failure)? : failure(error);

                                                }];
    
}



+ (NSMutableArray *)submitProjectVal:(NSMutableArray  <TTZSYSModel *>*)resultArr with:(NSString *)type{
    NSMutableArray *projectVal = [NSMutableArray array];
    
//    NSMutableArray *resultArr = self.dataArr;
//    if ([self.info[@"data"][@"billType"] isEqualToString:@"J003"]) {
//        resultArr = self.professionDataArr;
//    }
    
    [resultArr enumerateObjectsUsingBlock:^(TTZSYSModel *  sysModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [sysModel.list enumerateObjectsUsingBlock:^(TTZGroundModel *  gObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [gObj.list enumerateObjectsUsingBlock:^(TTZSurveyModel *  cellObj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                //单选 多选
                if ([cellObj.intervalType isEqualToString:@"select"] || [cellObj.intervalType isEqualToString:@"radio"]) {
                    
                    NSArray <TTZValueModel *>*selects = [cellObj.intervalRange.list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                    NSString *projectValString = [[selects valueForKeyPath:@"value"] componentsJoinedByString:@","];
                    
                    NSArray <TTZChildModel *>*childList = selects.firstObject.childList;
                    if (childList) {
                        NSArray <TTZChildModel *>*selectChild = [childList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected > 0"]];
                        projectValString = [[selectChild valueForKeyPath:@"value"] componentsJoinedByString:@","];
                        NSLog(@"%s", __func__);
                    }
                    
                    if(selects.count){
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":[[selects valueForKeyPath:@"name"] componentsJoinedByString:@","],@"projectVal":projectValString}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":[type isEqualToString:@"J007J"] ? @"" : cellObj.projectName,@"projectVal":@""}];
                    }
                    
                    
                    //输入文本类型
                }else if ([cellObj.intervalType isEqualToString:@"input"] || [cellObj.intervalType isEqualToString:@"text"]){
                    //if(!IsEmptyStr(cellObj.intervalRange.interval)) {
                    if(!IsEmptyStr(cellObj.projectVal) || !IsEmptyStr(cellObj.intervalRange.interval)) {
                        
                        NSString *projectValString = IsEmptyStr(cellObj.projectVal)? cellObj.intervalRange.interval : cellObj.projectVal;
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":projectValString}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectVal":@""}];
                    }
                    //故障码类型
                }else if ([cellObj.intervalType isEqualToString:@"gatherInputAdd"]){
                    //if(cellObj.codes.count) {
                    if(!IsEmptyStr(cellObj.projectVal)) {
                        
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":cellObj.projectVal}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                    // elecCodeForm 联动故障码
                }else if ([cellObj.intervalType isEqualToString:@"elecCodeForm"]){
                    if(cellObj.codes.count)  {
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":[cellObj.codes componentsJoinedByString:@","]}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                    //  表单
                }else if ([cellObj.intervalType isEqualToString:@"form"]){
                    if(cellObj.codes.count)  {
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":[cellObj.codes componentsJoinedByString:@","]}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                    //  气缸
                }else if ([cellObj.intervalType isEqualToString:@"sameIncrease"]){
                    if(cellObj.codes.count)  {
                        
                        NSMutableArray *codes = [NSMutableArray array];
                        [cellObj.codes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString *code = [NSString stringWithFormat:@"%lu%@-%@%@",idx+1,cellObj.intervalRange.name,obj,cellObj.intervalRange.unit];
                            [codes addObject:code];
                        }];
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":[codes componentsJoinedByString:@","]}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                }else if ([cellObj.intervalType isEqualToString:@"independent"]){
                    if(!IsEmptyStr(cellObj.projectVal)) {
                        
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectOptionName,@"projectVal":cellObj.projectVal}];
                    }else{
                        [projectVal addObject:@{@"projectId":cellObj.Id,@"projectOptionName":cellObj.projectName,@"projectVal":@""}];
                    }
                    NSLog(@"%s", __func__);
                }

                
                
                
            }];
        }];
    }];
    return projectVal;
}

@end
