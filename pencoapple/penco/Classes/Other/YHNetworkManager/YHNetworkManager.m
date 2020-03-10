//
//  YHNetworkPHPManager.m
//  FTBOCOpSdk
//
//  Created by 朱文生 on 15-1-30.
//  Copyright (c) 2015年 FTSafe. All rights reserved.
//
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "MBProgressHUD+MJ.h"
#import "CheckNetwork.h"
#import "YHCommon.h"
#import "PCPersonModel.h"
#import "PCReportModel.h"
#import "YHModelItem.h"
#import "PCPostureModel.h"
#import "PCMusculatureModel.h"
#import "PCTestRecordModel.h"
#import "PCMessageModel.h"
#import <MJExtension.h>


#define arId @"ios"
#define arIdCsc @"ios_mfb"
#define AppCode @"6627ed9c7b7f404f8bfe3d142fa43081"
static NSString * const AFAppDotNetAPIBaseURLString = @SERVER_JAVA_URL;
//#define NetworkTest
#define TestError
@interface YHNetworkManager ()

@end


@implementation YHNetworkManager
DEFINE_SINGLETON_FOR_CLASS(YHNetworkManager);



/**
 * 登陆
 *
 **/
- (void)login:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    [self YHBasePOST:@"/rest/user/v1/login" param:parameters onComplete:onComplete onError:onError];
}

/**
 1.2.5. 刷新token接口
 *
 **/
- (void)refreshToken:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/user/v1/token/refresh?refreshToken=%@", parameters[@"refreshToken"]] param:nil onComplete:onComplete onError:onError];
}

/**
 * 1.2.4. 账号退出接口
 *
 **/
- (void)logout:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    [self YHBasePOST:@"/rest/user/v1/logout" param:parameters onComplete:onComplete onError:onError];
}

/**
 * 1.1.1. 获取首页引导图接口
 *
 **/
- (void)guideOnComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    [self YHBasePOST:@"/rest/basemodel/v1/guide" param:nil onComplete:onComplete onError:onError];
}

/**
 * 1.6.2. 获取体态测量数据
 *
 **/
- (void)posturesDetail:(nonnull NSString*)personId postureId:(nonnull NSString*)postureId :(nonnull NSString*)accountId OnComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/postures/%@?accountId=%@", personId, postureId, accountId] param:nil onComplete:onComplete onError:onError];
}

//获取增肌标准模型
- (void)shaping:(NSDictionary *)parameters onComplete:(void (^)(YHModelItem *model))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:@"/rest/basemodel/v1/models/shaping" param:parameters onComplete:^(NSDictionary *info){
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            NSDictionary *result = info[@"result"];
            !(onComplete)? : onComplete([YHModelItem mj_objectWithKeyValues:result]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
    
}
//获取塑性标准模型
- (void)muscleGrowth:(NSDictionary *)parameters onComplete:(void (^)(YHModelItem *model))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:@"/rest/basemodel/v1/models/muscleGrowth" param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            NSDictionary *result = info[@"result"];
            !(onComplete)? : onComplete([YHModelItem mj_objectWithKeyValues:result]);
            return ;
        }

        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);

        
    } onError:onError];
}

//测量成员列表
- (void)getPersonsOnComplete:(void (^)(NSMutableArray <PCPersonModel *>*models))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/user/v1/accounts/%@/persons",YHTools.accountId] param:nil onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }

        
        if (![info[@"code"] integerValue]) {

            !(onComplete)? : onComplete([PCPersonModel mj_objectArrayWithKeyValuesArray:info[@"result"]]);
            return ;
        }

        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);

        
    } onError:onError];
}
//添加测量成员
//@{@"personName":@"",@"age":@"",@"sex":@"",@"weight":@"",@"height":@"",@"headImg":@""}
- (void)addPerson:(NSDictionary *)parameters onComplete:(void (^)(PCPersonModel *model))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBasePOST:[NSString stringWithFormat:@"/rest/user/v1/accounts/%@/persons",YHTools.accountId] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }

        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCPersonModel mj_objectWithKeyValues:info[@"result"]]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
    } onError:onError];
}
//修改测量成员
//@{@"personId":@"",@"personName":@"",@"age":@"",@"sex":@"",@"weight":@"",@"height":@"",@"headImg":@""}
- (void)modifyPerson:(NSDictionary *)parameters onComplete:(void (^)(PCPersonModel *model))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBasePUT:[NSString stringWithFormat:@"/rest/user/v1/accounts/%@/persons/%@",YHTools.accountId,parameters[@"personId"]] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }

        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCPersonModel mj_objectWithKeyValues:info[@"result"]]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);

        
    } onError:onError];
}

//删除测量成员
//@{@"personId":@""}
- (void)deletePerson:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseDELETE:[NSString stringWithFormat:@"/rest/user/v1/accounts/%@/persons/%@",YHTools.accountId,parameters[@"personId"]] param:nil onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }

        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete();
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);

    } onError:onError];
}

////测量次数趋势报表
////@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@""}
//- (void)frequencyReport:(NSDictionary *)parameters onComplete:(void (^)(PCReportModel *model))onComplete onError:(void(^)(NSError *error))onError{
//
//    [self YHBaseGet:[NSString stringWithFormat:@"/rest/report/v1/persons/%@/reports/frequency",parameters[@"personId"]] param:parameters onComplete:^(NSDictionary *info) {
//
//        if (![info isKindOfClass:[NSDictionary class]]) {
//            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
//            return ;
//        }
//
//        if (![info[@"code"] integerValue]) {
//
//            !(onComplete)? : onComplete([PCReportModel mj_objectWithKeyValues:info[@"result"]]);
//            return ;
//        }
//
//        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
//
//
//    } onError:onError];
//}
//
////胸围数据趋势报表
////@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@""}
//- (void)bustReport:(NSDictionary *)parameters onComplete:(void (^)(PCReportModel *model))onComplete onError:(void(^)(NSError *error))onError{
//
//    [self YHBaseGet:[NSString stringWithFormat:@"/rest/report/v1/persons/%@/reports/bust",parameters[@"personId"]] param:parameters onComplete:^(NSDictionary *info) {
//
//
//        if (![info isKindOfClass:[NSDictionary class]]) {
//            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
//            return ;
//        }
//
//
//        if (![info[@"code"] integerValue]) {
//            !(onComplete)? : onComplete([PCReportModel mj_objectWithKeyValues:info[@"result"]]);
//            return ;
//        }
//
//        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
//
//
//    } onError:onError];
//}
//
////腰围数据趋势报表
////@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@""}
//- (void)waistReport:(NSDictionary *)parameters onComplete:(void (^)(PCReportModel *model))onComplete onError:(void(^)(NSError *error))onError{
//
//    [self YHBaseGet:[NSString stringWithFormat:@"/rest/report/v1/persons/%@/reports/waist",parameters[@"personId"]] param:parameters onComplete:^(NSDictionary *info) {
//
//        if (![info isKindOfClass:[NSDictionary class]]) {
//            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
//            return ;
//        }
//
//        if (![info[@"code"] integerValue]) {
//            !(onComplete)? : onComplete([PCReportModel mj_objectWithKeyValues:info[@"result"]]);
//            return ;
//        }
//
//        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
//
//
//    } onError:onError];
//}
//
////臀围数据趋势报表
////@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@""}
//- (void)hiplineReport:(NSDictionary *)parameters onComplete:(void (^)(PCReportModel *model))onComplete onError:(void(^)(NSError *error))onError{
//
//    [self YHBaseGet:[NSString stringWithFormat:@"/rest/report/v1/persons/%@/reports/hipline",parameters[@"personId"]] param:parameters onComplete:^(NSDictionary *info) {
//
//        if (![info isKindOfClass:[NSDictionary class]]) {
//            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
//            return ;
//        }
//
//        if (![info[@"code"] integerValue]) {
//            !(onComplete)? : onComplete([PCReportModel mj_objectWithKeyValues:info[@"result"]]);
//            return ;
//        }
//
//        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
//
//
//    } onError:onError];
//}

//趋势报表

//测量次数趋势报表 frequency
//胸围数据趋势报表 bust
//腰围数据趋势报表 waist
//臀围数据趋势报表 hipline
//左上臂数据趋势报表 leftUpperArm
//左下臂数据趋势报表 leftLowerArm
//右上臂数据趋势报表 rightUpperArm
//右下臂数据趋势报表 rightLowerArm
//左小腿数据趋势报表 leftLeg
//左大腿数据趋势报表 leftThigh
//右小腿数据趋势报表 rightLeg
//右大腿数据趋势报表 rightThigh
//肩宽数据趋势报表 shoulder
//https://pvtruler.lenovo.com.cn/rest/report/v1/persons/19/reports/bust?accountId=13&startTime=2017-05-01 00:00:00&endTime=2019-05-28 00:00:00
//@{@"personId":@"19",@"accountId":@"13",@"startTime":@"2017-05-01 00:00:00",@"endTime":@"2019-05-28 00:00:00",@"at":@"bust"}
- (void)getReport:(NSDictionary *)parameters onComplete:(void (^)(PCReportModel *model))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/report/v1/persons/%@/reports/%@",parameters[@"personId"],parameters[@"at"]] param:parameters onComplete:^(NSDictionary *info) {
       
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCReportModel mj_objectWithKeyValues:info[@"result"]]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//体态测量数据列表
//@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@""}
- (void)posturesList:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray <PCPostureModel *>*models))onComplete onError:(void(^)(NSError *error))onError{
    //https://server:port/rest/device/v1/persons/{personId}/postures
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/postures",parameters[@"personId"]] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCPostureModel mj_objectArrayWithKeyValuesArray:info[@"result"]]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//获取体态测量数据
//@{@"personId":@"",@"postureId":@"",@"accountId":@""}
- (void)getPostures:(NSDictionary *)parameters onComplete:(void (^)(PCPostureModel *model))onComplete onError:(void(^)(NSError *error))onError{
    //https://server:port/rest/device/v1/persons/{personId}/postures/{postureId}
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/postures/%@",parameters[@"personId"],parameters[@"postureId"]] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCPostureModel mj_objectWithKeyValues:info[@"result"]]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}


//1.6.3. 体态测量获取最后一次测量成功记录
/*
 rulerToken    必选    String    Header     通行令牌标识
 personId    必选    int    Path     测试成员Id
 accountId    必选    int    Param    账户id
 
 */
- (void)lastPosture:(NSDictionary *)parameters onComplete:(void (^)(PCPostureModel *model))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/postures/last",parameters[@"personId"]] param:@{@"accountId":parameters[@"accountId"]} onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCPostureModel mj_objectWithKeyValues:info[@"result"]]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//删除体态记录
//@{@"personId":@"",@"postureId":@"",@"accountId":@""}
- (void)deletePostures:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError{
    //https://server:port/rest/device/v1/persons/{personId}/postures/{postureId}
    [self YHBaseDELETE:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/postures/%@",parameters[@"personId"],parameters[@"postureId"]] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete();
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//获取肌肉组织
//bodyParts部位类型: 左上臂:leftUpperArm 右上臂:rightUpperArm 左下臂:leftLowerArm 右下臂:rightLowerArm 胸围:bust 臀围:hipline 腰围:waist 左⼩小腿:leftLeg 左⼤大腿:leftThigh 右⼩小腿:rightLeg 右⼤大腿:rightThigh 肩宽:shoulder
//@{@"bodyParts":@""}
- (void)getMusculature:(NSDictionary *)parameters onComplete:(void (^)(PCMusculatureModel *model))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/basemodel/v1/musculatures"] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCMusculatureModel mj_objectWithKeyValues:info[@"result"]]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//1.8.1.测量记录列表
//@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@"",@"offset":@""}
- (void)getReports:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray < PCTestRecordModel *>*models ,BOOL hasMore))onComplete onError:(void(^)(NSError *error))onError{
    
//    NSMutableDictionary *parm = parameters.mutableCopy;
    NSString *personId = parameters[@"personId"];
//    [parm removeObjectForKey:@"personId"];
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/figure",personId] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            //NSMutableArray *models = [PCTestRecordModel mj_objectArrayWithKeyValuesArray:info[@"result"][@"content"]];
            NSMutableArray *models = [PCTestRecordModel mj_objectArrayWithKeyValuesArray:info[@"result"]];

            //NSInteger pageSize = [info[@"result"][@"pageSize"] integerValue];
            
            !(onComplete)? : onComplete(models,(BOOL)models.count);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}


//1.8.2.部位测量记录列表
//部位类型: 左上臂:leftUpperArm 右上臂:rightUpperArm 左下臂:leftLowerArm 右下臂:rightLowerArm 胸围:bust 臀围:hipline 腰围:waist 左⼩小腿:leftLeg 左⼤大腿:leftThigh 右⼩小腿:rightLeg 右⼤大腿:rightThigh 肩宽:shoulder
//@{@"personId":@"",@"startTime":@"",@"endTime":@"",@"bodyParts":@""}
- (void)getBodyReports:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray < PCTestRecordModel *>*models))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/figure/body",parameters[@"personId"]] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCTestRecordModel mj_objectArrayWithKeyValuesArray:info[@"result"]]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//1.8.3.按天查询部位测量记录列表
//部位类型: 左上臂:leftUpperArm 右上臂:rightUpperArm 左下臂:leftLowerArm 右下臂:rightLowerArm 胸围:bust 臀围:hipline 腰围:waist 左⼩小腿:leftLeg 左⼤大腿:leftThigh 右⼩小腿:rightLeg 右⼤大腿:rightThigh 肩宽:shoulder
//@{@"personId":@"",@"reportDate":@"",@"bodyParts":@"",@"accountId":@""}
- (void)getReportDate:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray < PCTestRecordModel *>*models))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/figure/bodyParts",parameters[@"personId"]] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCTestRecordModel mj_objectArrayWithKeyValuesArray:info[@"result"]]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//1.8.4.获取指定测量记录
//@{@"personId":@"",@"reportId":@""}
- (void)getReportId:(NSDictionary *)parameters onComplete:(void (^)(  PCTestRecordModel *model, id info))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/figure/%@",parameters[@"personId"],parameters[@"reportId"]] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCTestRecordModel mj_objectWithKeyValues:info[@"result"]], info[@"result"]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//1.8.5.获取最后一次测量记录(含对比上一次各个部位的差值)
//@{@"personId":@"",@"accountId":@""}
- (void)lastReport:(NSDictionary *)parameters onComplete:(void (^)(  PCTestRecordModel *model, id info))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/figure/lastReport",parameters[@"personId"]] param:@{@"accountId":parameters[@"accountId"]} onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCTestRecordModel mj_objectWithKeyValues:info[@"result"]], info[@"result"]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//1.8.6.测量数据确认接又
//@{@"personId":@"",@"reportId":@"",@"accountId":@""}
- (void)confirmReport:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError{
    NSMutableDictionary *parm = parameters.mutableCopy;
    [parm removeObjectForKey:@"personId"];
    [parm removeObjectForKey:@"reportId"];

    [self YHBasePOST:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/figure/%@/confirm",parameters[@"personId"],parameters[@"reportId"]] param:parm onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete();
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}
//1.8.7.删除测量记录
//@{@"personId":@"",@"reportId":@"",@"accountId":@""}
- (void)deleteFigureRecordId:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseDELETE:[NSString stringWithFormat:@"/rest/device/v1/persons/%@/figure/%@",parameters[@"personId"],parameters[@"reportId"]] param:@{@"accountId":parameters[@"accountId"]} onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete();
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
    } onError:onError];
}

//1.9.1.APP OTA
//@{@"appId":@"",@"accountId":@""}
- (void)appOTA:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary*))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"/rest/ota/v1/app/ota"] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete(info[@"result"]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//1.9.2.获取设备版本号
//@{@"deviceVersionBaseNum":@"",@"deviceMac":@""}
- (void)deviceType:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary*))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"rest/ota/v1/device/ota/L-RUL001"] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete(info[@"result"]);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//1.9.3.软件插件
////@{@"deviceVersionBaseNum":@"",@"deviceMac":@""}
//- (void)deviceType:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary*))onComplete onError:(void(^)(NSError *error))onError{
//    
//    [self YHBaseGet:[NSString stringWithFormat:@"rest/ota/v1/device/ota/L-RUL001"] param:parameters onComplete:^(NSDictionary *info) {
//        
//        if (![info isKindOfClass:[NSDictionary class]]) {
//            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
//            return ;
//        }
//        
//        if (![info[@"code"] integerValue]) {
//            !(onComplete)? : onComplete(info[@"result"]);
//            return ;
//        }
//        
//        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
//        
//        
//    } onError:onError];
//}


//1.10.1.获取用户消息列表
//@{@"accountId":@"",@"offset":@"",@"limit":@""}
- (void)getMessages:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray < PCMessageModel *>*models))onComplete onError:(void(^)(NSError *error))onError{

    [self YHBaseGet:[NSString stringWithFormat:@"rest/message/v1/accounts/%@/messages",parameters[@"accountId"]] param:parameters onComplete:^(NSDictionary *info) {

        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }

        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete([PCMessageModel mj_objectArrayWithKeyValuesArray:info[@"result"]]);
            return ;
        }

        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);


    } onError:onError];
}

//1.10.2.消息未读数量
//@{@"accountId":@""}
- (void)unreadMessageCount:(NSDictionary *)parameters onComplete:(void (^)(NSInteger count))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBaseGet:[NSString stringWithFormat:@"rest/message/v1/accounts/%@/messages/unread",parameters[@"accountId"]] param:nil onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            NSInteger count = [info[@"result"][@"count"] integerValue];
            !(onComplete)? : onComplete(count);
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}

//1.10.3.设置消息为已读
//@{@"accountId":@"",@"msgType":@"",@"businessId":@""} //体形或体态Id 消息类型(figure_result:体形消 息; posture_result:体态消 息)
- (void)readMessages:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBasePUT:[NSString stringWithFormat:@"rest/message/v1/user/messages/read"] param:parameters onComplete:^(NSDictionary *info) {
        
        if (![info isKindOfClass:[NSDictionary class]]) {
            !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"服务器挂了"}]);
            return ;
        }
        
        if (![info[@"code"] integerValue]) {
            !(onComplete)? : onComplete();
            return ;
        }
        
        !(onError)? : onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : info[@"message"]}]);
        
        
    } onError:onError];
}


#pragma mark Init
#pragma mark Initxiu
- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        //        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        //        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil, nil];
        //无条件的信任服务器上的证书
#ifdef YHTest
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        self.securityPolicy = securityPolicy;
#endif
    }
    return self;
}

@end
