//
//  YHNetworkPHPManager.h
//  FTBOCOpSdk
//
//  Created by 朱文生 on 15-1-30.
//  Copyright (c) 2015年 FTSafe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "YHCommon.h"
#import "YHNetBaseManager.h"
#ifdef YHProduction
//生产正式
#define OrgId @"6D22BB5DAE0D45D0825F4C39C7A48654"// 机构ID 维修厂
//#define OrgId @"8483CA963C3B42488859FECB0FBD0FF2"// 机构ID 中心站
#define VtrId @"f6a9027f4e9d4c2019f28b55983db501"// 访问标识
#define TestOpenId @"402881fb5aa652f7015aa67a64560006"// openID

#define SERVER_PHP_URL "https://api.wanguoqiche.com"
#define SERVER_PHP_Trunk ""
#define SERVER_PHP_URL_Statements_Trunk "/cloud"
#define SERVER_PHP_URL_H5 "https://www.wanguoqiche.com"
#endif

#ifdef YHProduction_Demo
//生产demo
#define SERVER_PHP_URL "https://www.wanguoqiche.cn"
#define SERVER_PHP_Trunk "/mfb_demo"
#define SERVER_PHP_URL_H5 "http://dev.demo.com/chezhu"
#endif

#ifdef YHTest
#define OrgId @"118F79242B4B4FAA89B900A2DF7462E4"// 机构ID
#define VtrId @"f6a9027f4e9d4c2019f28b55983db501"// 访问标识
#define TestOpenId @"402881fb5aa652f7015aa67a64560006"// openID
//测试环境
#define SERVER_PHP_URL "http://api.demo.com"
//#define SERVER_PHP_URL "http://192.168.1.244:8082"//
#define SERVER_PHP_Trunk ""
//#define SERVER_PHP_H5_Trunk "/docTest_affirmAndPushMode"
#define SERVER_PHP_URL_Statements_Trunk "/shopSys"
//#define SERVER_PHP_URL_H5 "http://192.168.1.244:9001/"
//#define SERVER_PHP_URL_Statements_H5 "http://192.168.1.244:9001/"
#endif

#ifdef YHDev

#define OrgId @"E33619F027084B2AB4AA3D4333C41C18"// 机构ID 维修厂
//#define OrgId @"8483CA963C3B42488859FECB0FBD0FF2"// 机构ID 中心站
#define VtrId @"f6a9027f4e9d4c2019f28b55983db501"// 访问标识
#define TestOpenId @"402881fb5aa652f7015aa67a64560006"// openID
// 开发
//#define SERVER_PHP_URL "http://jy.mhdev.com"
//#define SERVER_PHP_URL "http://shopsys.way.com"
//#define SERVER_PHP_URL "http://192.168.1.244:8080"//
#define SERVER_PHP_URL "http://devapi.demo.com"
//#define SERVER_PHP_URL "http://shopSys.tao.com"
//#define SERVER_PHP_URL "http://shopSys.lgj.com"
//#define SERVER_PHP_URL "http://192.168.1.150"//啊宙
//#define SERVER_PHP_URL "http://shopsys.hua.com"//啊华
//#define SERVER_PHP_Trunk "/csc_dev"
//#define SERVER_PHP_Trunk "/csc"
#define SERVER_PHP_Trunk ""
#define SERVER_PHP_URL_Statements_Trunk "/shopSys"
#endif

#ifdef YHLocation

#define OrgId @"E33619F027084B2AB4AA3D4333C41C18"// 机构ID 维修厂
//#define OrgId @"8483CA963C3B42488859FECB0FBD0FF2"// 机构ID 中心站
#define VtrId @"f6a9027f4e9d4c2019f28b55983db501"// 访问标识
#define TestOpenId @"402881fb5aa652f7015aa67a64560006"// openID
// 开发
//#define SERVER_PHP_URL "http://jy.mhdev.com"
//#define SERVER_PHP_URL "http://shopsys.way.com"
#define SERVER_PHP_URL "http://192.168.1.243:8081"//涛
//#define SERVER_PHP_URL "http://192.168.1.246:8001"//丘
//#define SERVER_PHP_URL "http://www.localshop.com"
//#define SERVER_PHP_URL "http://shopSys.tao.com"
//#define SERVER_PHP_URL "http://shopSys.lgj.com"
//#define SERVER_PHP_URL "http://192.168.1.150"//啊宙
//#define SERVER_PHP_URL "http://shopsys.hua.com"//啊华
//#define SERVER_PHP_Trunk "/csc_dev"
//#define SERVER_PHP_Trunk "/csc"
#define SERVER_PHP_Trunk ""
#define SERVER_PHP_URL_H5 "http://dev.demo.com"
#define SERVER_PHP_URL_Statements_Trunk "/shopSys"
#endif



typedef NS_ENUM(NSInteger, YHCodeModel) {
    YHCodeModelRegister    ,//注册
    YHCodeModelFind    ,//找回密码
    YHCodeModelChange    //修改密码
};

typedef NS_ENUM(NSInteger, YHOrderModel) {
    YHOrderModelW ,//维修
    YHOrderModelP ,//匹配保养
    YHOrderModelJ ,//全车检测
    YHOrderModelE ,//二手车
    YHOrderModelV ,//估值
    YHOrderExtrend ,//延保
    YHOrderModelK ,//新全车检测
    YHOrderModelNone ,//无
};

typedef NS_ENUM(NSInteger, YHExtendImg) {
    YHExtendImgIdFront ,//身份证正面
    YHExtendImgIdBack ,//身份证背
    YHExtendImgDrving ,//驾驶证主
    YHExtendImgDrvingBack ,//驾驶证副
    YHExtendImgWarrantyPact ,//延保协议
    YHExtendImgCar //车辆图片
};



typedef NS_ENUM(NSInteger, YHOrderPush) {
    YHOrderStorePushDepth ,//维修厂推送细检方案
    YHOrderStorePushMode ,//维修厂推送维修方式
    YHOrderCloudPushModeScheme ,//中心站推送维修方式
    YHOrderCloudPushDepth ,//中心站推送细检方案给维修厂
    YHOrderPushCheckReport ,//维修厂全车检测报告推送车主
    YHOrderStorePushAssessCarReport ,//推送估车检测报告
    YHOrderStorePushUsedCarCheckReport ,//推送二手车检测报告
};

typedef NS_OPTIONS(NSUInteger, YHBuyType) {
    YHBuyTypeResult       =1,//检测结果
    YHBuyTypeMode       //维修方式
};
@interface YHNetworkPHPManager : YHNetBaseManager
DEFINE_SINGLETON_FOR_HEADER(YHNetworkPHPManager);
#pragma mark - 接口(刘松)
/**
 检车新建工单
 
 token   string    token
 vin     string    vin号
 */
-(void)checkTheCarCreateNewWorkOrderWithToken:(NSString *)token Vin:(NSString *)vin onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError;


/**
 汽车品牌列表
 */
-(void)queryCarBrandListonComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError;

/**
 汽车车系列表
 
 brandId int 品牌ID
 */
-(void)queryCarSeriesTableWithBrandId:(NSString *)brandId onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError;
@end
