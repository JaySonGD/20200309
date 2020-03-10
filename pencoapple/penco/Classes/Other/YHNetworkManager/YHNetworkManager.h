//
//  YHNetworkManager.h
//  FTBOCOpSdk
//
//  Created by 朱文生 on 15-1-30.
//  Copyright (c) 2015年 FTSafe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHCommon.h"
#import "SynthesizeSingleton.h"
#import "YHNetBaseManager.h"
//FIXME: 生产环境
#ifdef YHProduction
//生产
#define SERVER_JAVA_URL "https://chnrulerapi.lenovo.com.cn"//生产地址

#endif
//TODO: 生产demo
#ifdef YHProduction_Demo
//生产demo
#define SERVER_JAVA_URL "https://pvtruler.lenovo.com.cn"//测试ip

#endif
//MARK: 测试环境
#ifdef YHTest
//测试环境
#define SERVER_JAVA_URL "https://pvtruler.lenovo.com.cn"//测试ip

#endif
//FIXME: 开发环境
#ifdef YHDev
//开发环境
#define SERVER_JAVA_URL "https://pvtruler.lenovo.com.cn"//测试ip

#endif

#ifdef YHLocation

#define SERVER_JAVA_URL "https://pvtruler.lenovo.com.cn"//测试ip

#endif

@class PCPersonModel,PCReportModel,YHModelItem,PCPostureModel,PCMusculatureModel,PCTestRecordModel,PCMessageModel;

NS_ASSUME_NONNULL_BEGIN
@interface YHNetworkManager : YHNetBaseManager
DEFINE_SINGLETON_FOR_HEADER(YHNetworkManager);
/**
 * 登陆
 *
 **/
- (void)login:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 1.2.5. 刷新token接口
 *
 **/
- (void)refreshToken:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 1.2.4. 账号退出接口
 *
 **/
- (void)logout:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 1.1.1. 获取首页引导图接口
 *
 **/
- (void)guideOnComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 1.6.2. 获取体态测量数据
 *
 **/
- (void)posturesDetail:(nonnull NSString*)personId postureId:(nonnull NSString*)postureId :(nonnull NSString*)accountId OnComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

//FIXME:  -  1.3.成员管理

//测量成员列表
- (void)getPersonsOnComplete:(void (^)(NSMutableArray <PCPersonModel *>*models))onComplete onError:(void(^)(NSError *error))onError;
//删除测量成员
//@{@"personId":@""}
- (void)deletePerson:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError;

//修改测量成员
//@{@"personId":@"",@"personName":@"",@"age":@"",@"sex":@"",@"weight":@"",@"height":@"",@"headImg":@""}
- (void)modifyPerson:(NSDictionary *)parameters onComplete:(void (^)(PCPersonModel *model))onComplete onError:(void(^)(NSError *error))onError;

//添加测量成员
//@{@"personName":@"",@"age":@"",@"sex":@"",@"weight":@"",@"height":@"",@"headImg":@""}
- (void)addPerson:(NSDictionary *)parameters onComplete:(void (^)(PCPersonModel *model))onComplete onError:(void(^)(NSError *error))onError;


//测量次数趋势报表
//@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@""}
//- (void)frequencyReport:(NSDictionary *)parameters onComplete:(void (^)(PCReportModel *model))onComplete onError:(void(^)(NSError *error))onError;


//胸围数据趋势报表
//@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@""}
//- (void)bustReport:(NSDictionary *)parameters onComplete:(void (^)(PCReportModel *model))onComplete onError:(void(^)(NSError *error))onError;

//FIXME:  -  1.4.趋势报告

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

//@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@"",@"at":@""}
- (void)getReport:(NSDictionary *)parameters onComplete:(void (^)(PCReportModel *model))onComplete onError:(void(^)(NSError *error))onError;

//FIXME:  -  1.5.标准模型管理

//获取增肌标准模型
- (void)shaping:(NSDictionary *)parameters onComplete:(void (^)(YHModelItem *model))onComplete onError:(void(^)(NSError *error))onError;
//获取塑性标准模型
- (void)muscleGrowth:(NSDictionary *)parameters onComplete:(void (^)(YHModelItem *model))onComplete onError:(void(^)(NSError *error))onError;

//FIXME:  -  1.6.体态管理
//体态测量数据列表
//@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@""}
- (void)posturesList:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray <PCPostureModel *>*models))onComplete onError:(void(^)(NSError *error))onError;

//获取体态测量数据
//@{@"personId":@"",@"postureId":@"",@"accountId":@""}
- (void)getPostures:(NSDictionary *)parameters onComplete:(void (^)(PCPostureModel *model))onComplete onError:(void(^)(NSError *error))onError;

//1.6.3. 体态测量获取最后一次测量成功记录
/*
 rulerToken    必选    String    Header     通行令牌标识
 personId    必选    int    Path     测试成员Id
 accountId    必选    int    Param    账户id
 
 */
- (void)lastPosture:(NSDictionary *)parameters onComplete:(void (^)(PCPostureModel *model))onComplete onError:(void(^)(NSError *error))onError;

//删除体态记录
//@{@"personId":@"",@"postureId":@""}
- (void)deletePostures:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError;

//FIXME:  -  1.7.肌肉组织
//获取肌肉组织
//bodyParts部位类型: 左上臂:leftUpperArm 右上臂:rightUpperArm 左下臂:leftLowerArm 右下臂:rightLowerArm 胸围:bust 臀围:hipline 腰围:waist 左⼩小腿:leftLeg 左⼤大腿:leftThigh 右⼩小腿:rightLeg 右⼤大腿:rightThigh 肩宽:shoulder
//@{@"bodyParts":@""}
- (void)getMusculature:(NSDictionary *)parameters onComplete:(void (^)(PCMusculatureModel *model))onComplete onError:(void(^)(NSError *error))onError;

//FIXME:  -  1.8.测量报告管理
//1.8.1.测量记录列表
//@{@"personId":@"",@"startTime":@"",@"endTime":@"",@"offset":@""}
//- (void)getReports:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray < PCTestRecordModel *>*models))onComplete onError:(void(^)(NSError *error))onError;
//1.8.1.测量记录列表
//@{@"personId":@"",@"accountId":@"",@"startTime":@"",@"endTime":@"",@"offset":@""}
- (void)getReports:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray < PCTestRecordModel *>*models ,BOOL hasMore))onComplete onError:(void(^)(NSError *error))onError;

//1.8.2.部位测量记录列表
//部位类型: 左上臂:leftUpperArm 右上臂:rightUpperArm 左下臂:leftLowerArm 右下臂:rightLowerArm 胸围:bust 臀围:hipline 腰围:waist 左⼩小腿:leftLeg 左⼤大腿:leftThigh 右⼩小腿:rightLeg 右⼤大腿:rightThigh 肩宽:shoulder
//@{@"personId":@"",@"startTime":@"",@"endTime":@"",@"bodyParts":@""}
- (void)getBodyReports:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray < PCTestRecordModel *>*models))onComplete onError:(void(^)(NSError *error))onError;

//1.8.3.按天查询部位测量记录列表
//部位类型: 左上臂:leftUpperArm 右上臂:rightUpperArm 左下臂:leftLowerArm 右下臂:rightLowerArm 胸围:bust 臀围:hipline 腰围:waist 左⼩小腿:leftLeg 左⼤大腿:leftThigh 右⼩小腿:rightLeg 右⼤大腿:rightThigh 肩宽:shoulder
//@{@"personId":@"",@"reportDate":@"",@"bodyParts":@"",@"accountId":@""}
- (void)getReportDate:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray < PCTestRecordModel *>*models))onComplete onError:(void(^)(NSError *error))onError;
//1.8.4.获取指定测量记录
//@{@"personId":@"",@"reportId":@"",@"accountId":@""}
- (void)getReportId:(NSDictionary *)parameters onComplete:(void (^)(  PCTestRecordModel *model,id info))onComplete onError:(void(^)(NSError *error))onError;
//1.8.5.获取最后一次测量记录(含对比上一次各个部位的差值)
//@{@"personId":@"",@"accountId":@""}
- (void)lastReport:(NSDictionary *)parameters onComplete:(void (^)(  PCTestRecordModel *model, id info))onComplete onError:(void(^)(NSError *error))onError;
//1.8.6.测量数据确认接又
//@{@"personId":@"",@"reportId":@"",@"accountId":@""}
- (void)confirmReport:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError;

//1.8.7.删除测量记录
//@{@"personId":@"",@"reportId":@"",@"accountId":@""}
- (void)deleteFigureRecordId:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError;


//FIXME:  -  1.9.OTA升级
//1.9.1.APP OTA
//@{@"appId":@"",@"accountId":@""}
- (void)appOTA:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary*))onComplete onError:(void(^)(NSError *error))onError;

//1.9.2.获取设备版本号
//@{@"deviceVersionBaseNum":@"",@"deviceMac":@""}
- (void)deviceType:(NSDictionary *)parameters onComplete:(void (^)(NSDictionary*))onComplete onError:(void(^)(NSError *error))onError;


//FIXME:  -  1.10.消息推送列表
//1.10.1.获取用户消息列表
//@{@"accountId":@"",@"offset":@"",@"limit":@""}
- (void)getMessages:(NSDictionary *)parameters onComplete:(void (^)(NSMutableArray < PCMessageModel *>*models))onComplete onError:(void(^)(NSError *error))onError;


//1.10.2.消息未读数量
//@{@"accountId":@""}
- (void)unreadMessageCount:(NSDictionary *)parameters onComplete:(void (^)(NSInteger count))onComplete onError:(void(^)(NSError *error))onError;


//1.10.3.设置消息为已读
//@{@"accountId":@"",@"msgType":@"",@"businessId":@""} //体形或体态Id 消息类型(figure_result:体形消 息; posture_result:体态消 息)
- (void)readMessages:(NSDictionary *)parameters onComplete:(void (^)(void))onComplete onError:(void(^)(NSError *error))onError;

@end
NS_ASSUME_NONNULL_END
