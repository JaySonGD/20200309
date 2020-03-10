//
//  YHNetworkPHPManager.h
//  FTBOCOpSdk
//
//  Created by 朱文生 on 15-1-30.
//  Copyright (c) 2015年 FTSafe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YHCommon.h"
#import "YHNetBaseManager.h"

#import "SynthesizeSingleton.h"

#ifdef YHProduction
//生产正式
#ifdef LearnVersion
#if isSmallTigerCheck == 1
// 小虎检车
#define OrgId @"12C38087D56E43C6BAFD97843FCF5295"// 机构ID 维修厂
#else
// 烟台工贸技师学院
#define OrgId @"B2A145D6A69D4EE184227519CEEA61AF"// 机构ID 维修厂
#endif
#define webUrl [NSString stringWithFormat:@"https://s.laijingedu.cn/eduWeb/#/?orgId=%@",OrgId]

#else
// JNS
#define OrgId @"6D22BB5DAE0D45D0825F4C39C7A48654"// 机构ID 维修厂
#endif

//#define OrgId @"8483CA963C3B42488859FECB0FBD0FF2"// 机构ID 中心站
#define VtrId @"99e40ec93f2d7440761769ccf5a382bc"// 访问标识
#define TestOpenId @"402881fb5aa652f7015aa67a64560006"// openID

#define SERVER_PHP_URL @"https://api.wanguoqiche.com"
#define SERVER_PHP_Trunk @""
#define SERVER_PHP_H5_Trunk @"/intro/docDev"
#define SERVER_PHP_GoodFor_Trunk @"/yougong" //优供 H5 trunk 目录
#define SERVER_PHP_Good_Trunk @"/youcai" //优才 H5 trunk 目录
#define SERVER_PHP_URL_Good_H5 @"https://www.wanguoqiche.com" //优供 H5 访问地址
#define SERVER_PHP_URL_Statements_Trunk @"/cloud"
#define SERVER_PHP_URL_Statements_H5 @"https://www.wanguoqiche.com"
#define SERVER_PHP_URL_Statements_H5_Vue @"https://www.wanguoqiche.com/jns"//前端vue新项目工程目录
#define SERVER_PHP_URL_H5 @"https://www.wanguoqiche.com"
#endif

#ifdef YHProduction_Demo
//生产demo
#define SERVER_PHP_URL @"https://www.wanguoqiche.cn"
#define SERVER_PHP_Trunk @"/mfb_demo"
#define SERVER_PHP_URL_H5 @"http://dev.demo.com/chezhu"
#endif

// 测试
#ifdef YHTest
#ifdef LearnVersion
#if isSmallTigerCheck == 1
// 小虎检车
#define OrgId @"093AFCDD73AA42F3AD1EA56980F07A5D"// 机构ID 维修厂
#define webUrl [NSString stringWithFormat:@"http://192.168.1.220/eduWeb/#/?orgId=%@",OrgId]
#else
//  烟台工贸技师学院
#define webUrl [NSString stringWithFormat:@"http://192.168.1.200/eduWeb"]
#endif

#else
// JNS
#define OrgId @"118F79242B4B4FAA89B900A2DF7462E4"// 机构ID
#endif

#define VtrId @"99e40ec93f2d7440761769ccf5a382bc"// 访问标识
#define TestOpenId @"402881fb5aa652f7015aa67a64560006"// openID
//测试环境
//#define SERVER_PHP_URL @"http://api.demo.com"\
//http://192.168.1.243:8091
//http://192.168.1.115:8001
//http://devapi.demo.com
//192.168.1.245:8001
//@[@"生产",@"本地",@"开发",@"测试"]
#define SERVER_PHP_URL (@[@"https://api.wanguoqiche.com",@"http://192.168.1.243:8091",@"http://devapi.demo.com",@"http://api.demo.com"][kHttpEnvInt])

#define SERVER_PHP_Trunk @""

//#define SERVER_PHP_H5_Trunk @"/app"
#define SERVER_PHP_H5_Trunk (@[@"/intro/docDev",@"/app",@"/app",@"/app"][kHttpEnvInt])

//#define SERVER_PHP_GoodFor_Trunk @"/yougongTest" //优供 H5 trunk 目录
#define SERVER_PHP_GoodFor_Trunk (@[@"/yougong",@"/yougongDev",@"/yougongDev",@"/yougongTest"][kHttpEnvInt])

//#define SERVER_PHP_Good_Trunk @"/youcaiTest" //优才 H5 trunk 目录
#define SERVER_PHP_Good_Trunk (@[@"/youcai",@"/yougongDev",@"/youcaiDev",@"/youcaiTest"][kHttpEnvInt])

//#define SERVER_PHP_URL_Good_H5 @"http://192.168.1.200" //优供 H5 访问地址
#define SERVER_PHP_URL_Good_H5 (@[@"https://www.wanguoqiche.com",@"http://192.168.1.200",@"http://192.168.1.200",@"http://192.168.1.200"][kHttpEnvInt])

//#define SERVER_PHP_URL_Statements_Trunk @"/shopSys"
#define SERVER_PHP_URL_Statements_Trunk (@[@"/cloud",@"/shopSys",@"/shopSys",@"/shopSys"][kHttpEnvInt])

//#define SERVER_PHP_URL_H5 @"http://static.demo.com/"
#define SERVER_PHP_URL_H5 (@[@"https://www.wanguoqiche.com",@"http://dev.demo.com",@"http://dev.demo.com",@"http://static.demo.com"][kHttpEnvInt])

//#define SERVER_PHP_URL_Statements_H5 @"http://static.demo.com"
#define SERVER_PHP_URL_Statements_H5 (@[@"https://www.wanguoqiche.com",@"http://dev.demo.com",@"http://dev.demo.com",@"http://static.demo.com"][kHttpEnvInt])

//前端vue新项目工程目录
#define SERVER_PHP_URL_Statements_H5_Vue \
(@[@"https://www.wanguoqiche.com/jns",@"http://192.168.1.10:8080/jnsDev",@"http://www.mhace.cn/jnsDev",@"http://www.mhace.cn/jnsTest"][kHttpEnvInt])

//(@[@"https://www.wanguoqiche.com/jns",@"http://dev.demo.com/jns",@"http://dev.demo.com/jns",@"http://static.demo.com/jns"][kHttpEnvInt])
#endif

// 开发
#ifdef YHDev
#ifdef LearnVersion

#define OrgId @""
#if isSmallTigerCheck == 1
// 小虎检车
#define webUrl [NSString stringWithFormat:@"http://192.168.1.200/eduWeb/index.html"]
#else
// 烟台
#define webUrl [NSString stringWithFormat:@"http://192.168.1.200/eduWeb"]
#endif
#else
// JNS
#define OrgId @"E33619F027084B2AB4AA3D4333C41C18"// 机构ID 维修厂
#endif

//#define OrgId @"8483CA963C3B42488859FECB0FBD0FF2"// 机构ID 中心站
#define VtrId @"99e40ec93f2d7440761769ccf5a382bc"// 访问标识
#define TestOpenId @"402881fb5aa652f7015aa67a64560006"// openID
// 开发
//#define SERVER_PHP_URL @"http://jy.mhdev.com"
//#define SERVER_PHP_URL @"http://shopsys.way.com"
//#define SERVER_PHP_URL @"http://192.168.1.244:8080"//
#define SERVER_PHP_URL @"http://devapi.demo.com"
//#define SERVER_PHP_URL @"http://192.168.1.200"

//#define SERVER_PHP_URL @"http://192.168.1.225:8001"
//#define SERVER_PHP_URL @"http://shopSys.tao.com"
//#define SERVER_PHP_URL @"http://shopSys.lgj.com"
//#define SERVER_PHP_URL @"http://192.168.1.150"//啊宙
//#define SERVER_PHP_URL @"http://shopsys.hua.com"//啊华
//#define SERVER_PHP_Trunk @"/csc_dev"
//#define SERVER_PHP_Trunk @"/csc"
#define SERVER_PHP_Trunk @""
#define SERVER_PHP_H5_Trunk @"/app"
#define SERVER_PHP_GoodFor_Trunk @"/yougongDev" //优供 H5 trunk 目录
#define SERVER_PHP_Good_Trunk @"/youcaiDev" //优才 H5 trunk 目录
#define SERVER_PHP_URL_Good_H5 @"http://192.168.1.200" //优供 H5 访问地址
#define SERVER_PHP_URL_H5 @"http://dev.demo.com"
#define SERVER_PHP_URL_Statements_Trunk @"/shopSys"
#define SERVER_PHP_URL_Statements_H5 @"http://dev.demo.com"

#define SERVER_PHP_URL_Statements_H5_Vue @"http://www.mhace.cn/jnsDev"//前端vue新项目工程目录
#endif

// 本地
#ifdef YHLocation
#ifdef LearnVersion
#define webUrl [NSString stringWithFormat:@"http://192.168.1.200/eduWeb"]
#else
// JNS
#define OrgId @"E33619F027084B2AB4AA3D4333C41C18"// 机构ID 维修厂
#endif
//#define OrgId @"8483CA963C3B42488859FECB0FBD0FF2"// 机构ID 中心站
#define VtrId @"99e40ec93f2d7440761769ccf5a382bc"// 访问标识
#define TestOpenId @"402881fb5aa652f7015aa67a64560006"// openID
// 开发
//#define SERVER_PHP_URL @"http://jy.mhdev.com"
//#define SERVER_PHP_URL @"http://shopsys.way.com"

//#define SERVER_PHP_URL @"http://192.168.1.225:8001"  //van_mr
//#define SERVER_PHP_URL @"http://192.168.1.245:8001"
/**蹲街、浅浅笑 ip:http://192.168.1.243:8091**/
//#define SERVER_PHP_URL @"http://192.168.1.243:8091"
//#define SERVER_PHP_URL @"http://192.168.1.235:8080"//涛
//#define SERVER_PHP_URL @"http://192.168.1.243:8081"//涛
//#define SERVER_PHP_URL @"http://192.168.1.115:8001" //伟新
//#define SERVER_PHP_URL @"http://192.168.1.224:8001"//桂键
//#define SERVER_PHP_URL @"http://192.168.1.245:8001"//丘
//#define SERVER_PHP_URL @"http://192.168.1.208:8003"
//http://192.168.1.243:8091
#define SERVER_PHP_URL @"http://192.168.1.115:8001"
//#define SERVER_PHP_URL @"http://shopSys.tao.com"
//#define SERVER_PHP_URL @"http://shopSys.lgj.com"
//#define SERVER_PHP_URL @"http://192.168.1.150"//啊宙
//#define SERVER_PHP_URL @"http://shopsys.hua.com"//啊华
//#define SERVER_PHP_URL @"http://192.168.1.208:8001" //兴华
//#define SERVER_PHP_Trunk @"/csc_dev"
//#define SERVER_PHP_Trunk @"/csc"
#define SERVER_PHP_Trunk @""
#define SERVER_PHP_H5_Trunk @"/app"
#define SERVER_PHP_Good_Trunk @"/yougongDev" //优供 H5 trunk 目录
#define SERVER_PHP_GoodFor_Trunk @"/yougongDev" //优供 H5 trunk 目录
#define SERVER_PHP_URL_Good_H5 @"http://192.168.1.200" //优供 H5 访问地址
#define SERVER_PHP_URL_H5 @"http://dev.demo.com"
#define SERVER_PHP_URL_Statements_Trunk @"/shopSys"
#define SERVER_PHP_URL_Statements_H5 @"http://dev.demo.com"//@"http://192.168.1.235:8080"

#define SERVER_PHP_URL_Statements_H5_Vue @"https://www.mhace.cn/jnsDev"//前端vue新项目工程目录
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
    YHOrderExtrend ,//延长保修
    YHOrderModelK ,//新全车检测
    YHOrderModelE001 ,//帮检单
    YHOrderModelJ002 ,//安检
    YHOrderModelNone ,//无
};

typedef NS_ENUM(NSInteger, YHExtendImg) {
    YHExtendImgIdFront ,//身份证正面
    YHExtendImgIdBack ,//身份证背
    YHExtendImgDrving ,//驾驶证主
    YHExtendImgDrvingBack ,//驾驶证副
    YHExtendImgWarrantyPact ,//延长保修协议
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
/**
 小虎安检删除维修报告方案
 *
 **/
- (void)removeRepairCaseBillId:(NSString *)billId caseId:(NSString *)maintain_id onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 提交深度诊断检测数据
 *
 **/
- (void)submitDepthDiagnoseReport:(NSDictionary *)resultDict onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 获取深度诊断检测数据
 *
 **/
- (void)getDepthDiagnoseWithToken:(NSString *)token billId:(NSString *)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
  根据code获取全车报告接口
 *
 **/
- (void)getCarCheckReportWithCode:(NSString *)code version:(NSString *)version onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 保存推送AI空调检测报告接口
 *
 **/
- (void)savePushIntelligentCheckReport:(NSDictionary *)param onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 获取AI空调检测报告（技师端）
 * token String Y  登录标识
 * order_id  String Y 订单ID
 **/
- (void)getIntelligentCheckReport:(NSString *)token order_id:(NSString *)order_id onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 获取机构余额余额页面信息接口
 * token String Y 登录标识
 **/
- (void)getOrganizationPointNumber:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 * 工单 - 获取工单扣除余额详情
 * token String Y 登录标识
 * billId String Y 工单ID
 *
 **/
- (void)getOrderDeductNumber:(NSString *)token billId:(int)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 * 工单 - 保存工单扣除机构余额
 * token String Y 登录标识
 * billId String Y 工单ID
 *
 **/
- (void)saveOrderDeductNumber:(NSString *)token billId:(int)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 解决方案W001 - 选择方案接口
 * token String Y 登录标识
 * billId String Y 工单ID
 * repairModelId String Y 维修方式id
 * isTechnique BOOL Y YES—>技术方 NO—>需求方
 **/
- (void)requireToChoiceCase:(NSString *)token billId:(int)billId repairModelId:(NSString *)repairModelId isTechnique:(BOOL)isTechnique onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 提交保存维修方案-for->J004
 *
 **/
- (void)submitRepairCaseDataForJ004:(NSDictionary *)param onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 * 提交保存维修方案
 *
 **/
- (void)submitRepairCaseData:(NSDictionary *)param onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 获取模糊搜索维修项目接口
 * token String Y 登录标识
 * itemName String Y 搜索字符串
 * car_cc String Y 排量
 **/
- (void)getRepairProjectWithDark:(NSString *)token itemName:(NSString *)itemName car_cc:(NSString *)car_cc onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 * 获取配件类型接口
 * token String Y 登录标识
 **/
- (void)getPartTypeList:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 * 获取解决方案站点列表
 * token String Y 登录标识
 * name String Y 站点搜索
 **/
- (void)getSolutionStationList:(NSString *)token name:(NSString *)name onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 获取模糊搜索耗材接口
 * token String Y 登录标识
 * itemName String Y 耗材名称
 **/
- (void)getConsumableWithDarkWay:(NSString *)token itemName:(NSString *)itemName onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 *获取精准搜索配件接口
 * token String Y 登录标识
 *  partName String Y 配件名称
 *  brandId String Y 品牌ID
 *  lineId String Y 车系ID
 *  car_cc String Y 排量（带单位：L/T）
 *  carYear String Y 年份
 **/
- (void)getPartsWithExactWay:(NSString *)token partName:(NSString *)partName  brandId:(int)brandId lineId:(int)lineId car_cc:(NSString *)car_cc carYear:(int)carYear onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 获取模糊搜索配件接口
 * token String Y 登录标识
 *  partName String Y 配件名称
 **/
- (void)getPartsWithDarkWay:(NSString *)token partName:(NSString *)partName onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 *  J003专项检测
 *  token String Y 登录标识
 *  billId int Y  工单ID
 *  sysIds String Y 系统id，多个英文逗号拼接
 **/
- (void)professionalExamine:(NSString *)token billId:(int)billId sysIds:(NSString *)sysIds onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 *  获取预约单详情数据
 *  token  String Y 登录标识
 *  billId int Y 工单ID
 **/
- (void)getAppointmentOrderDetailInfo:(NSString *)token billId:(int)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 *  小虎预约单推送接口
 *  token  String Y 登录标识
 *  billId int Y 工单ID
 *  arrivalTimeStart  date  Y 到店开始时间
 *  arrivalTimeEnd  date  Y  到店结束时间
 **/
- (void)appointmentOrderPush:(NSString *)token billId:(int)billId arrivalTimeStart:(NSString *)arrivalTimeStart arrivalTimeEnd:(NSString *)arrivalTimeEnd onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 * 验证码登录验证
 * codeStr String Y 验证码
 */
- (void)checkAuthCodeIsTure:(NSString *)codeStr onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 * 获取验证码
 */
- (void)getAuthCodeImageOnComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 * 新登录接口
 * userName String Y 用户名
 * passWord String Y 密码
 * org_id String Y 渠道ID
 * isConfirm_bind String 是否绑定
 */
- (void)newLoginUserName:(NSString *)userName passWord:(NSString *)passWord org_id:(NSString *)org_id confirm_bind:(BOOL)isConfirm_bind onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 退出登录接口
 *
 **/
- (void)LogoutOnComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 暂存维修方式
 * token String Y 登录标识
 * oldPasswd String Y 旧密码
 * newPassword String Y 新密码
 */
- (void)modifyPassword:(NSString *)token oldPasswd:(NSString *)oldPasswd newPassword:(NSString *)newPassword onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 暂存维修方式
 * token String Y 登录标识
 * name String Y 配件名称
 */
- (void)saveModifyPattern:(NSString *)token billId:(NSString *)billId checkResult:(NSDictionary *)checkResult repairModeData:(NSArray *)repairModeData onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 保存诊断结果/诊断思路
 *
 **/
- (void)saveEditResultToken:(NSString *)token billId:(NSString *)billId editResult:(NSString *)editResult editType:(NSInteger)type onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 * 根据配件耗材名获取维修项目列表（上限5条
 * token String Y 登录标识
 * name String Y 配件名称
 */
- (void)getRepairItemList:(NSString *)token partsName:(NSString *)name onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
/**
 微信授权登录 (测试模拟使用)
 
 **/

- (void)addParts:(NSString*)token
          billId:(NSString*)billId
       partsName:(NSString*)partsName
            type:(NSString*)type
       partsUnit:(NSString*)partsUnit
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;

- (void)loginTest:(NSString*)orgId onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;

/**
 技师登录
 
 vtrId    String    Y    访问来源id:【accessSys表中的accessId】
 orgId    String    Y    站点id
 username    String    Y    用户登录账号
 password    String    Y    用户登录密码
 verifyCode    String    Y    图形验证码
 urlCode 站点标示
 
 **/

- (void)loginTest:(NSString*)orgId vtrId:(NSString*)vtrId  username:(NSString*)username  password:(NSString*)password   verifyCode:(NSString*)verifyCode urlCode:(NSString*)urlCode onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;


/**
 4.1.    服务人员 – 个人信息详情
 
 token    String    Y
 **/

- (void)userInfo:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;
/**
 微信授权登录
 
 orgId    String    机构ID
 vtrId    String    访问标识
 
 **/

- (void)getAppId:(NSString*)orgId vtrId:(NSString*)vtrId  onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;


/**
 微信登录-车主端
 
 orgId    String    机构ID
 vtrId    String    访问标识
 Appid    String    微信appid
 Code    String    微信授权成功返回的code
 
 **/

- (void)login:(NSString*)orgId vtrId:(NSString*)vtrId  appid:(NSString*)appid code:(NSString*)code onComplete:(void (^)(NSDictionary *info))onComplete
      onError:(void (^)(NSError *error))onError;



/**
 微信绑定手机短信发送
 
 token    String    登录标识
 phone    String    手机号
 isCreate    String    短信发送类型 绑定账号，默认为修改手机号码
 
 
 **/

- (void)sms:(NSString*)token phone:(NSString*)phone type:(bool)isCreate onComplete:(void (^)(NSDictionary *info))onComplete
    onError:(void (^)(NSError *error))onError;

/**
 微信绑定手机短信发送
 
 token    String    登录标识
 phone    String    手机号
 verifyCode    String    短信验证码
 
 **/

- (void)checkOldphone:(NSString*)token phone:(NSString*)phone verifyCode:(NSString*)verifyCode onComplete:(void (^)(NSDictionary *info))onComplete
              onError:(void (^)(NSError *error))onError;

/**
 绑定或修改新手机并验证code操作
 
 token    String    登录标识
 phone    String    手机号
 isCreate    String    短信发送类型 绑定账号，默认为修改手机号码
 verifyCode    String    短信验证码
 
 **/

- (void)bundingSms:(NSString*)phone token:(NSString*)token type:(BOOL)isCreate verifyCode:(NSString*)verifyCode  onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError;


/**
 车主端工单添加
 
 token    String    登录标识
 username    String    用户姓名
 phone    String    电话
 usersCarId    String    车主爱车id
 appointmentDate    String    格式：2016-3-20 13:30:50
 
 **/

- (void)makeAppointment:(NSString*)token username:(NSString*)username phone:(NSString*)phone usersCarId:(NSString*)usersCarId appointmentDate:(NSString*)appointmentDate onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError;

/**
 车主端列表
 
 token    String    登录标识
 page    String    第几页默认为1
 pagesize    String    每页显示多少条默认为10
 
 
 **/

- (void)makApoointList:(NSString*)token page:(NSString*)page pagesize:(NSString*)pagesize onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;

/**
 登录账号修改
 
 token    String    登录标识
 mobile    String    手机号
 
 
 **/

- (void)setAcount:(NSString*)mobile token:(NSString*)token  onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;

/**
 站点海报列表
 
 orgId    String 站点标识
 
 
 **/

- (void)getAd:(NSString*)orgId onComplete:(void (^)(NSDictionary *info))onComplete
      onError:(void (^)(NSError *error))onError;

/**
 站点详情
 
 orgId    String 站点标识
 
 
 **/

- (void)getServiceDetail:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;


/**
 添加工单
 
 userName
 phone
 vin
 appointmentDate
 
 
 **/

- (void)addOrder:(NSString*)token userName:(NSString*)userName phone:(NSString*)phone vin:(NSString*)vin appointmentDate:(NSString*)appointmentDate onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;


/**
 添加和修改用户车辆信息
 
 token    String    token
 carLineId    Int    车系ID
 carLineName    String    车系名称
 carBrandId    Int    车辆品牌ID
 carBrandName    String    车辆品牌名称
 carCc    String    排量
 vin    String    车辆唯一识别代码
 plateNumber    String    车牌号码 不含第一位中文
 plateNumberP    String    车辆区域识别 如：粤
 produceYear    String    车生产年份
 mileage    Int    行车里程，单位km
 carCardTime    String    上牌时间：Y-m
 carType    Int    车类型 0估车网 1自己库
 gearboxType    String    变速箱类型
 carModelId    Int    车型ID
 carModelName    String    车型名称
 
 **/

- (void)usersCar:(NSString*)token
       carLineId:(NSNumber*)carLineId
     carLineName:(NSNumber*)carLineName
      carBrandId:(NSNumber*)carBrandId
    carBrandName:(NSNumber*)carBrandName
           carCc:(NSString*)carCc
             vin:(NSString*)vin
     plateNumber:(NSString*)plateNumber
    plateNumberP:(NSString*)plateNumberP
     produceYear:(NSString*)produceYear
         mileage:(NSNumber*)mileage
     carCardTime:(NSString*)carCardTime
         carType:(NSNumber*)carType
           carId:(NSString*)carId
     gearboxType:(NSString*)gearboxType
      carModelId:(NSNumber*)carModelId
    carModelName:(NSString*)carModelName
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;

/**
 获取用户车辆信息
 
 token    String    token
 vin    String    车辆唯一识别代码
 
 
 **/

- (void)getUsersCarInfo:(NSString*)token
                    vin:(NSString*)vin onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError;

/**
 获取用户车辆列表
 
 token    String    token
 
 
 **/

- (void)getUsersCarList:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError;

/**
 设置用户默认车辆
 
 token    String    token
 id    Int    车辆ID
 
 
 **/

- (void)setUsersCarDefault:(NSString*)token
                     carId:(NSString*)carId onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;



/**
 删除用户车辆
 
 token    String    token
 id    Int    车辆ID
 
 
 **/

- (void)deleteUsersCar:(NSString*)token
                  carId:(NSString*)carId onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError;


/**
 获取车主个人信息
 
 token    String    token
 
 
 **/

- (void)getCustomerInfo:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError;

/**
 修改车主个人信息
 
 token    String    token
 nickname    String    姓名
 
 **/

- (void)editUserNickname:(NSString*)token
                nickname:(NSString*)nickname
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;

/**
 修改车主个人信息
 
 token    String    token
 headUrl    String    头像地址
 nickname    String    姓名
 phone    String    手机号
 
 **/

- (void)editCustomerInfo:(NSString*)token
                 headUrl:(NSString*)headUrl
                nickname:(NSString*)nickname
                   phone:(NSString*)phone
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;

/**
 获取车辆品牌列表
 
 token    String    token
 
 
 **/

- (void)getCarBrandListOnComplete:(void (^)(NSDictionary *info))onComplete
                          onError:(void (^)(NSError *error))onError;

/**
 获取车辆车系列表
 
 brandId    Int    车辆品牌ID
 
 
 **/

- (void)getCarLineList:(NSString*)brandId onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;



/**
 获取车辆信息
 vin    Sting    vin号
 
 
 **/

- (void)getCarInfoByVin:(NSString*)vin onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError;


/**
 获取店铺信息
 
 token    String    token
 
 
 **/

- (void)myShopDetail:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;

/**
 获取全车检测报告
 
 token    String    token
 billId    String    工单号
 
 
 
 **/

- (void)getFullReport:(NSString*)token billId:(NSString*)billId onComplete:(void (^)(NSDictionary *info))onComplete
              onError:(void (^)(NSError *error))onError;


/**
 订单列表
 
 token     是     string     会话标识token
 page     否     int     页码
 pagesize     否     string     每页数
 keyword     否     string     关键字，用于搜索
 isHistory 是否是历史工单
 
 
 **/

- (void)getOrderList:(NSString*)token keyword:(NSString*)keyword page:(NSString*)page pagesize:(NSString*)pagesize isHistory:(BOOL)isHistory  onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;

/**
 理列表
 
 search    string    N    搜索字符
 isPending   是否 待处理
 page    int    N    页码
 pagesize    int    N    数据条数
 isHistory 是否是历史工单
 
 
 **/

- (void)getWorkOrderList:(NSString*)token searchKey:(NSString*)searchKey page:(NSString*)page pagesize:(NSString*)pagesize isHistory:(BOOL)isHistory isPending:(BOOL)isPending onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;
/**
 工单详情
 
 billId    int    Y    工单id
 isHistory 是否是历史工单
 **/

- (void)getBillDetail:(NSString*)token billId:(NSString*)billId isHistory:(BOOL)isHistory onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError;

/**
 根据系统获取故障现象信息
 
 sysClassId    int    Y    系统id
 **/

- (void)getFaultPhenomenon:(NSString*)token sysClassId:(NSString*)sysClassId onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;

/**
 获取新建工单数据
 **/

- (void)createNew:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;
    
/**
 保存新建工单数据
 billType    string    Y    W 维修 B 保养 J 全车检测 如果多选则拼接type
 如 WB 或WBJ
 baseInfo    object    Y
 carLineId    int    Y    车系id
 carLineName    string    Y    车系名称
 carBrandId    int    Y    车型id
 carBrandName    string    Y    车型名称
 carCc    string    Y    排量
 carModelId    int    N    车辆版本id，如果carType 为1不用此字段
 carModelName    string    N    车辆版本，如果carType 为1不用此字段
 gearboxType    string    Y    变速箱类型
 carType    int    Y    0估车网 1系统和车主填写信息
 vin    string    Y    车架号
 plateNumberP    string    Y    车辆区域识别 如：粤
 plateNumberC    string    Y    车辆区域识别 如：A
 plateNumber    string    Y    车牌号码
 userName    string    N    用户名
 phone    string    Y    联系方式
 tripDistance    string    Y    行驶里程，公里数
 fuelMeter    int    N    燃油表
 carYear    int    Y    汽车生产年份：年
 startTime    string    Y    开始时间
 consultingVal    array    N    数据列表
 projectId    int    Y    项目id
 projectVal    string    Y    项目值
 descs    string    N    备注
 faultPhenomenon    array    N    故障现象
 id    int    Y    故障现象id
 faultPhenomenonDescs    string    N    故障现象其他补充
 
 **/

- (void)saveCreateBill:(NSString*)token billInfo:(NSDictionary*)billInfo onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onErro;


/**
 保存检测车信息
 billId    int    Y    工单id
 checkCarVal    object    Y    检测车数据，
 assign    array    Y    分配技师
 userOpenId    int    N    指派的技师id，如果为转派中心站，无此字段
 billType    int    Y    工单类型
 
 **/

- (void)saveCheckCar:(NSString*)token checkCarVal:(NSArray*)checkCarVal  assign:(NSArray*)assign billId:(NSArray*)billId onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;

/**
 获取新全车检测录入数据详情
 token     是     string     token
 billId     是     int     工单id
 
 **/

- (void)getNewWholeCarLoggingData:(NSString*)token billId:(NSString*)billId isHistory:(BOOL)isHistory onComplete:(void (^)(NSDictionary *info))onComplete
                          onError:(void (^)(NSError *error))onError;
/**
 保存初检信息
 billId    int    Y    工单id
 checkProjectType     是     array     选择的检测数据类型projectCheckType
 initialSurveyVal    Array    初检项目数据列表    Y
    projectId    Int    项目id    Y
    projectVal    String    项目值    Y
    projectOptionName    String    项目选项名    N
    descs    String    备注    N
 
 model 初检单类型
 isReplace 是否是代录
 **/

- (void)saveInitialSurvey:(NSString*)token billId:(NSString*)billId  checkProjectType:(NSArray*)checkProjectType initialSurveyVal:(NSArray*)initialSurveyVal orderModel:(YHOrderModel)model
                isReplace:(BOOL)isReplace onComplete:(void (^)(NSDictionary *info))onComplete
                  onError:(void (^)(NSError *error))onError;

/**
 请求协助
 
 billId    int    Y    工单id
 isAssist 是请求协助还是转派中心站
 
 **/

- (void)orderEdit:(NSString*)token billId:(NSString*)billId isAssist:(BOOL)Assist onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;

/**
 获取维修厂出维修方式数据
 
 billId    int    Y    工单id
 
 **/

- (void)getStoreMakeModeData:(NSString*)token billId:(NSString*)billId onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError;


/**
 添加细检项目
 
 token     是     string     token
 projectName     是     string     细检项目名称
 unit     否     string     单位
 sysClassId     是     int     归属系统ID
 
 
 **/

- (void)addShopCheckReportDepthItem:(NSString*)token projectName:(NSString*)projectName unit:(NSString*)unit  sysClassId:(NSString*)sysClassId onComplete:(void (^)(NSDictionary *info))onComplete
                            onError:(void (^)(NSError *error))onError;

/**
 获取细检诊断项目
 
 search    string    post    no    搜索字符串
 
 **/

- (void)getDepthItemToCloudForSysId:(NSString*)token
                        projectName:(NSString*)search
                         onComplete:(void (^)(NSDictionary *info))onComplete
                            onError:(void (^)(NSError *error))onError;

/**
 云平台保存细检方案 || 保存细检方案报价
 
 billId    int    post    yes    工单ID
 requestData    array    post    yes    诊断数据列表
 - | projectId    int    post    yes    诊断项目ID
 - | type    string    post    yes    使用类型 system、user
 - | price    float    post    yes    诊断项目报价
 
 
 isPrice 是否是 保存细检方案报价 || 云平台保存细检方案
 
 **/

- (void)saveWriteDepthToCloud:(NSString*)token
                       billId:(NSString*)billId
                  requestData:(NSArray*)requestData
                      isPrice:(BOOL)isPrice
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError;

/**
 保存细检方案项目值
 维修厂发起协助 - 中心站出细检方案 - 维修厂采用中心站出的细检方案后 - 填入项目值
 
 billId    Int    工单ID
 requestData    Array    项目数组
    projectId    Int    项目ID
    type    String    类型 system系统 user用户
    projectVal    String    项目值
 
 **/

- (void)saveWriteDepthToCloud:(NSString*)token billId:(NSString*)billId  requestData:(NSArray*)requestData onComplete:(void (^)(NSDictionary *info))onComplete
                  onError:(void (^)(NSError *error))onError;
    
/**
 本地保存细检方案报价
 
 billId    int    Y    工单id
 depthQuote    array    Y    细检项目报价数据
 sysClassId    int    Y    系统id
 sellingPrice
 float    Y    售价
 
 
 **/

- (void)saveStoreDepthQuote:(NSString*)token
                     billId:(NSString*)billId
                 depthQuote:(NSArray*)depthQuote
                 onComplete:(void (^)(NSDictionary *info))onComplete
                    onError:(void (^)(NSError *error))onError;

/**
 维修厂推送细检方案
 
 billId    int    Y    工单id
 phone 手机号
 YHOrderPush 推送类型
 
 **/

- (void)saveStorePushDepth:(NSString*)token
                    billId:(NSString*)billId
               phoneNumber:(NSString*)phone
                orderModel:(YHOrderPush)model
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;

/**
 保存维修厂制定的细检方案
 
 billId    int    Y    工单id
 depthType    string    Y    store:维修厂本地数据;cloud:云端细检数据;
 storeDepth    array    N    细检项目，如果为云端数据，无此字段
 id    int    Y    本地细检，为projectId
 type    string    Y    细检系统类型 user,system
 desc    string    N    备注
 
 
 **/

- (void)saveStoreMakeDepth:(NSString*)token
                    billId:(NSString*)billId
                 depthType:(NSString*)depthType
                storeDepth:(NSArray*)storeDepth
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;
    
    
///**
// 保存维修厂制定的细检方案
//
// billId    int    Y    工单id
// depthProject    array    Y    细检项目
// sysClassId    int    Y    系统id
// quote    float    N    报价
//
//
// **/
//
//- (void)saveStoreMakeDepth:(NSString*)token
//                    billId:(NSString*)billId
//               checkResult:(NSString*)checkResult
//               requestData:(NSArray*)requestData
//                onComplete:(void (^)(NSDictionary *info))onComplete
//                   onError:(void (^)(NSError *error))onError;




/**
 保存维修方式
 
 billId     是     int     工单id
 token     是     string     token
 checkResult     否     object     诊断结果
 —makeResult     是     string     诊断结果内容
 —makeIdea     是     string     诊断思路内容
 repairModeData     是     array     维修方式
 -repairItem     是     array     检测与维修项目
 —repairProjectId     是     string     检测与维修项目id
 —repairProjectName     是     string     检测与维修项目名称
 -parts     否     array     配件与耗材
 —partsNameId     是     string     配件与耗材id
 —partsName     是     string     配件与耗材名称
 —modelNumber     是     string     型号
 —partsUnit     是     string     单位
 —partsDesc     是     string     配件与耗材备注
 —scalar     是     string     数量
 —type     是     string     类型 1配件 2耗材
 -scheme     否     object     解决方案
 —schemeContent     是     string     解决方案内容
 isStoreModel 是否是本地维修方案
 
 **/

- (void)saveMakeMode:(NSString*)token
              billId:(NSString*)billId
         checkResult:(NSDictionary*)checkResult
         requestData:(NSArray*)requestData
        isStoreModel:(BOOL)isStoreModel
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;
    
/**
 本地编辑-修改报价
 
 billId     是     int     工单id
 token     是     string     token
 repairModeData     是     array     维修方式
 -preId     是     string     方案id
 -repairItem     是     array     检测与维修项目
 —repairProjectId     是     string     检测与维修项目id
 —repairProjectName     是     string     检测与维修项目名称
 —quote     是     string     检测与维修项目报价
 -parts     否     array     配件与耗材
 —partsId     是     string     配件与耗材属性id
 —scalar     是     int     配件与耗材数量
 —shopPrice     是     string     配件与耗材售价
 -warrantyTime     否     array     质保
 —warrantyDay     是     string     质保（质保五万公里/1年）
 —warrantyDayDesc     否     string     质保备注（忽略）
 -giveBack    否    object    交车数据
 —giveBackTime    否    string    交车时间
 
 isTiger 是否是小虎检车
 **/

- (void)updateRepairMode:(NSString*)token
                  billId:(NSString*)billId
             requestData:(NSArray*)requestData
                 isTiger:(BOOL)isTiger
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;
/**
 
 配件搜索 - 编辑维修方式页
 
 token     是     string     登录标识
 step     是     string     步骤码，固定值：maintenance_mode
 billId     是     int     工单ID
 type     是     int     类型 0：全部 1：配件 2：耗材 （APP才有0）
 searchField     是     string     搜索字段
 p/Users/liangtaoyu/YHWanGuoTechnician/YHWanGuoTechnicians/Classes/Other/YHNetworkManager/YHNetworkPHPManager.m:- (void)searchPartInfo:(NSString*)tokenartsName：配件名称
 modelNumber：型号
 partsUnit：单位
 partsName     否     string     配件名称
 modelNumber     否     string     型号
 partsUnit     否     string     单位
 **/

- (void)searchPartInfo:(NSString*)token
                  keys:(NSDictionary*)keys
                billId:(NSString*)billId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;

/**
 
 配件新搜索 - 编辑维修方式页
 
 token     是     string     登录标识
 type     是     int     类型 1-配件 2-耗材
 keyword     是     string    搜索关键字
 brand_id       int    车系ID(无值传0)
 line_id int    车型ID(无值传0)
 **/

- (void)searchNewPartInfo:(NSString*)token
                     keys:(NSDictionary*)keys
               onComplete:(void (^)(NSDictionary *info))onComplete
                  onError:(void (^)(NSError *error))onError;

/**
 维修项目搜索
 
 page    Int    页数    N
 keyword    String    搜索内容    N
 billId     是     int     工单id
 **/

- (void)searchPartClass:(NSString*)token
                   page:(NSString*)page
                 billId:(NSString*)billId
         partsClassName:(NSString*)partsClassName
             onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError;

/**
 修理厂关闭工单
 
 token    String    用户标识    Y
 billId    Int    工单id    Y
 closeTheReason     是     string     关闭原因
 **/

- (void)endBill:(NSString*)token
         billId:(NSString*)billId
 closeTheReason:(NSString*)closeTheReason
     onComplete:(void (^)(NSDictionary *info))onComplete
        onError:(void (^)(NSError *error))onError;


/**
 修理厂确认细检
 
 token    String    用户标识    Y
 billId    Int    工单id    Y
 
 **/

- (void)saveCarAffirmDepth:(NSString*)token
                    billId:(NSString*)billId
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;
    
/**
 获取细检项目选择项
 pId 参数
 **/

- (void)getProjectList:(NSString*)url
                   pId:(NSString*)pId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;
    
/**
 检测图片提交
 
 token    String    用户标识    Y
 billId    String    工单id    Y
 picPathData    Array    图片文件名数组    N
 
 model 初检单类型
 
 isReplace 是否是代录
 **/

- (void)uploadWholeCarDetectivePicture:(NSString*)token
                                billId:(NSString*)billId
                           picPathData:(NSArray*)picPathData
                            orderModel:(YHOrderModel)model
                             isReplace:(BOOL)isReplace
                            onComplete:(void (^)(NSDictionary *info))onComplete
                               onError:(void (^)(NSError *error))onError;

/**
 修理厂确认选择维修方案
 
 token    String    用户标识    Y
 billId    Int    工单id    Y
 giveBackTime    否    string    交车时间
 repairModelId    String    维修方案标识id    Y
 repairModeText    String    备注    N
 
 **/

- (void)saveAffirmModel:(NSString*)token
                 billId:(NSString*)billId
          repairModelId:(NSString*)repairModelId
         repairModeText:(NSString*)repairModeText
             onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError;

/**
 保存提交渠道维修方案
 
 token     是     string     token
 billId     是     int     工单id
 repairModeText     否     string     维修方式备注
 
 **/

- (void)saveChannelSubmitMode:(NSString*)token
                       billId:(NSString*)billId
               repairModeText:(NSString*)repairModeText
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError;

/**
 申请领料
 
 token    String    用户标识    Y
 billId    Int    工单id    Y
 
 **/

- (void)savePartsApply:(NSString*)token
                billId:(NSString*)billId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;

/**
 保存领料确认完工
 
 token    String    用户标识    Y
 billId    Int    工单id    Y
 overdueReason     否     string     逾期原因（逾期了才必须填）
 **/

- (void)saveAffirmComplete:(NSString*)token
                    billId:(NSString*)billId
             overdueReason:(NSString*)overdueReason
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;

/**
 结算
 
 token    String    用户标识    Y
 billId    Int    工单id    Y
 。。。
 
 **/

- (void)saveEndBill:(NSString*)token
                    billId:(NSString*)billId
                   payMode:(NSString*)payMode
             receiveAmount:(NSString*)receiveAmount
                    remark:(NSString*)remark
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError;


/**
 获取视频播放凭证
 
 token     是     string     用户标识
 videoId     是     string     视频ID
 
 **/

- (void)getMediaPlayAuth:(NSString*)token
          videoId:(NSString*)videoId
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;

/**
 获取设备图片列表
 
 token     是     string     用户标识
 projectId     是     int     项目ID
 billId     是     int     工单ID
 
 **/

- (void)getVideoList:(NSString*)token
           projectId:(NSString*)projectId
              billId:(NSString*)billId
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;
    
/**
 添加维修项目
 
 token     是     string     token
 repairProjectName     是     string     个项名称
 
 
 **/

- (void)addRepairProject:(NSString*)token
       repairProjectName:(NSString*)repairProjectName
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;


/**
 配件添加其他
 
 token     是     string     token
 billId     是     string     工单ID
 partsName     是     string     配件名
 type     是     string     类型（配件 1 耗材 2）
 partsTypeId     是     string     类别ID 1-品牌件 2-原厂件 3-副厂件 4-二手件
 
 **/

- (void)addParts:(NSString*)token
          billId:(NSString*)billId
       partsName:(NSString*)partsName
            type:(NSString*)type
     partsTypeId:(NSString*)partsTypeId
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;



/**
 获取电路图标题列表
 
 token     是     string     token
 billId     是     string     工单ID
 
 **/

- (void)getCircuitryList:(NSString*)token
                  billId:(NSString*)billId
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;

/**
 根据标题ID获取电路图图片地址
 
 token     是     string     token
 Id     是     int     标题ID
 
 **/

- (void)getCircuitryPic:(NSString*)token
                     id:(NSString*)id
onComplete:(void (^)(NSDictionary *info))onComplete
onError:(void (^)(NSError *error))onError;

/**
 转派工单
 
 billId     是     int     工单id
 token     是     string     token
 userOpenId     是     string     技师ID
 
 **/

- (void)turnToSendBill:(NSString*)token
                billId:(NSString*)billId
            userOpenId:(NSString*)userOpenId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;
    
/**
 获取系统列表
 
 **/

- (void)getSysClassListOnComplete:(void (^)(NSDictionary *info))onComplete
                          onError:(void (^)(NSError *error))onError;

/**
 生成购买检测报告订单
 
 token    String    用户标识    Y
 billId    Int    工单id    Y
 
 **/

- (void)addCheckReportOrder:(NSString*)token
                     billId:(NSString*)billId
                 onComplete:(void (^)(NSDictionary *info))onComplete
                    onError:(void (^)(NSError *error))onError;

/**
 支付订单
 
 token     是     string     会话标识Token
 orderId     是     string     订单ID
 
 **/

- (void)orderPay:(NSString*)token
         orderId:(NSString*)orderId
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError;

/**
 获取未完成订单详情  (查询支付状态)
 
 token     是     string     会话标识Token
 orderId     是     string     订单ID
 
 **/

- (void)getOrderDetail:(NSString*)token
               orderId:(NSString*)orderId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;

/**
 
 保存质检
 
 token     是     string     会话标识Token
 billId     是     int     工单id
 reqAct     是     string     固定值：pass通过和noPass不通过
 overdueReason    否    string    逾期原因（只有逾期了才必须填）
 remarks     否     string     质检备注
 
 **/

- (void)saveQualityInspection:(NSString*)token
                      orderId:(NSString*)orderId
                       reqAct:(NSString*)reqAct
                overdueReason:(NSString*)overdueReason
                      remarks:(NSString*)remarks
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError;

/**
 
 app调用微信下单接口，返回待支付ID
 userId    账户ID
 vin    车架号
 type    购买类型：1 检测结果， 2,：维修方式
 
 **/

- (void)prepay:(NSString*)userId type:(YHBuyType)type byVin:(NSString*)vin onComplete:(void (^)(NSDictionary *info))onComplete
       onError:(void (^)(NSError *error))onError;

/**
 小虎检车--保存接单
 
 token     是     string     token
 billId     是     int     工单id
 
 **/

- (void)saveChannelReceiveBill:(NSString*)token billId:(NSString*)billId  onComplete:(void (^)(NSDictionary *info))onComplete
                       onError:(void (^)(NSError *error))onError;

/**
 获取未完成订单详情
 
 token     是     string     token
 billId     是     int     工单id
 
 **/

- (void)getOrderDetail:(NSString*)token orderId:(NSString*)orderId isHistory:(BOOL)isHistory onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;

/**
 忽略订单
 
 token     是     string     会话标识Token
 orderId     是     string     订单ID
 
 **/

- (void)loseOrder:(NSString*)token orderId:(NSString*)orderId onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;

/**
 工单初检-故障码获取检测项目列表
 
 token     是     string     会话标识Token
 billId     是     string     工单ID
 sysClassId     是     string     系统ID
 faultCode     是     string     故障码，多个逗号拼接
 
 **/

- (void)getElecCtrlInspectionProjectList:(NSString*)token billId:(NSString*)billId sysClassId:(NSString*)sysClassId faultCode:(NSString*)faultCode onComplete:(void (^)(NSDictionary *info))onComplete
                                 onError:(void (^)(NSError *error))onError;


/**
 获取/搜索保单数据列表
 
 token     是     string     token
 status     否     string     状态 1已审核，0未审核 2审核不通过 3待审核 默认不传为 待审核
 searchText     否     string     搜索字 仅限 客户名，手机号 部分匹配
 addTime     否     string     保单生成时间 格式为 YYYY-mm-dd 部分匹配
 warrantyPackageTitle     否     string     延长保修套餐名称 比如 套餐1 全匹配
 validTimeName     否     string     有效期 字符串 比如 6个月、1年 全匹配
 page     否     string     页码
 pagesize     否     string     页面条数
 
 **/

- (void)blockPolicy:(NSString*)token status:(NSString*)status searchText:(NSString*)searchText addTime:(NSString*)addTime warrantyPackageTitle:(NSString*)warrantyPackageTitle validTimeName:(NSString*)validTimeName  page:(NSString*)page  pagesize:(NSString*)pagesize onComplete:(void (^)(NSDictionary *info))onComplete
            onError:(void (^)(NSError *error))onError;

/**
 获取保单数据详情
 
 token     是     string     token
 blockPolicyId     是     string     保单id
 
 **/
- (void)getBlockPolicyDetail:(NSString*)token blockPolicyId:(NSString*)blockPolicyId onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError;

/**
 提交保单管理审核
 
 token     是     string     token
 blockPolicyId     是     string     保单id
 idImg     是     array     身份证 2张 限制
 warrantyPactImg     是     array     保险合同 <= 4张
 drivingImg     是     array     行驶证 2张 限制
 carImg     是     array     车辆图片 <= 20张 限制
 
 //others 其他参数
 cardNumber     否     string     证件号码
 agreementNumer     否     string     保单号
 invoiceTitle     否     string     发票抬头
 carKm     否     int     公里数(km)
 taxCode     否     string     纳税人识别号
 emailAddress     否     string     电子邮箱
 validTime     否     string     有效期限 只可以提交 3,6,12 单位：月
 **/

- (void)supplementBlockPolicy:(NSString*)token
                blockPolicyId:(NSString*)blockPolicyId
                        idImg:(NSArray*)idImg
              warrantyPactImg:(NSArray*)warrantyPactImg
                   drivingImg:(NSArray*)drivingImg
                       carImg:(NSArray*)carImg
                       others:(NSDictionary*)others
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError;

/**
延长保修服务管理-恢复已关闭保单

token     是     string     token
blockPolicyId     是     string     保单id
**/

- (void)recoveryBlockPolicy:(NSString*)token
              blockPolicyId:(NSString*)blockPolicyId
                 onComplete:(void (^)(NSDictionary *info))onComplete
                    onError:(void (^)(NSError *error))onError;

/**
 延长保修服务管理-恢复已关闭保单
 
 token     是     string     token
 blockPolicyId     是     string     保单id
 billId     是     string     工单id
 **/

- (void)closeBlockPolicy:(NSString*)token
           blockPolicyId:(NSString*)blockPolicyId
                  billId:(NSString*)billId
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;

/**
 搜索延长保修套餐数据
 
 token     是     string     token
 blockPolicyId     是     string     保单id
 **/

- (void)getBlockPolicyNoPasslog:(NSString*)token
                  blockPolicyId:(NSString*)blockPolicyId
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError;

/**
 质量延长工单初检-故障码获取检测项目
 
 token     是     string     会话标识Token
 billId     是     string     工单ID
 sysClassId     是     string     系统ID
 faultCode     是     string     故障码，多个逗号拼接
 **/

- (void)getElecCtrlProjectListByY:(NSString*)token
                         billId:(NSString*)billId
                     sysClassId:(NSString*)sysClassId
                      faultCode:(NSString*)faultCode
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError;

/**
 获取详情列表
 
 token     是     string     标识
 page     否     int     页码
 pagesize     否     int     每页数（默认10）
 startDate     是     string     时间1
 endDate     是     string     时间2（两个时间段间隔不能大于三个月）
 type     是     int     类型1:未返现2:部分返现3:全返现
 keyword     否     string     关键字
 warrantyName     否     string     套餐名
 selectShopOpenId     否     string     选择的站点open
 **/

- (void)cashBackGetDetail:(NSString*)token
                startDate:(NSString*)startDate
                  endDate:(NSString*)endDate
                     type:(NSString*)type
                     page:(NSString*)page
                 pagesize:(NSString*)pagesize
                  keyword:(NSString*)keyword
             warrantyName:(NSString*)warrantyName
         selectShopOpenId:(NSString*)selectShopOpenId
               onComplete:(void (^)(NSDictionary *info))onComplete
                  onError:(void (^)(NSError *error))onError;

/**
 获取套餐名列表
 
 token     是     string     标识
 **/

- (void)getWarrantyNames:(NSString*)token
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;

/**
 新增工作板
 token     是     string     登录标识
 serviceType     是     int     业务类型 1:维修 2:保养 3:检测
 appointmentDate     是     date     预约日期 如：2017-10-12
 plateNumberP     是     string     车牌号区域号 如：粤
 plateNumberC     是     string     车牌号第二位 如：A
 plateNumber     是     string     车牌号后五位 如：88888
 name     是     string     客户名称
 phone     是     string     手机号码
 customerId     否     int     客户ID 从客户养车管理添加时必填
 vin     否     string     车架号 从客户养车管理添加时必填
 **/

- (void)addWorkboard:(NSString*)token
         serviceType:(NSString*)serviceType
     appointmentDate:(NSString*)appointmentDate
        plateNumberP:(NSString*)plateNumberP
        plateNumberC:(NSString*)plateNumberC
         plateNumber:(NSString*)plateNumber
                name:(NSString*)name
               phone:(NSString*)phone
          customerId:(NSString*)customerId
                 vin:(NSString*)vin
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;

/**
获取未完成工单单数
 
 token     是     string     标识
 **/

- (void)getUnfinishedBillNum:(NSString*)token
              onComplete:(void (^)(NSDictionary *info))onComplete
onError:(void (^)(NSError *error))onError;

/**
获取JNS下级菜单列表
 
 token     是     string     标识
 **/

- (void)getJnsChildMenuList:(NSString*)token
              onComplete:(void (^)(NSDictionary *info))onComplete
onError:(void (^)(NSError *error))onError;

/**
 获取工作板列表
 
 token     是     string     标识
 **/

- (void)getWorkboardList:(NSString*)token
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;

/**
 删除工作板
 
 token     是     string     标识
 id     是     int     工作板ID
 **/

- (void)deleteWorkboard:(NSString*)token
                     id:(NSString*)workboardId
             onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError;

/**
 根据工作板ID获取工单基本信息
 
 token     是     string     标识
 workBoardId     是     int     工作板ID
 **/

- (void)getBaseInfoByWorkBoardId:(NSString*)token
                     workBoardId:(NSString*)workBoardId
                      onComplete:(void (^)(NSDictionary *info))onComplete
                         onError:(void (^)(NSError *error))onError;

/**
 工作板进来的用户详情接口
 
 token     是     string     标识
 workBoardId     是     int     工作板ID
 **/

- (void)workboardCustomerDetail:(NSString*)token
                    workBoardId:(NSString*)workBoardId
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError;


- (void)workboardCustomerDetail:(NSString*)token
                            vin:(NSString*)vin
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError;
/**
 最近工单
 
 token     是     string     登录标识
 vin     是     string     车架号
 customerId     否     string     客户ID ，有值时（大于0）：客户详情使用
 **/

- (void)recentlyBill:(NSString*)token
                            vin:(NSString*)vin
                     customerId:(NSString*)customerId
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError;

/**
 回访列表
 
 token     是     string     登录标识
 customerId     是     string     客户ID
 page     否     int     页码
 pagesize     否     int     条/页，默认10条
 **/

- (void)followUpList:(NSString*)token
                     customerId:(NSString*)customerId
                           page:(NSString*)page
                       pagesize:(NSString*)pagesize
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError;

/**
 添加回访
 
 token     是     string     登录标识
 customerId     是     int     客户ID
 result     是     string     回访结果
 **/

- (void)addCustomerFollowUp:(NSString*)token
                 customerId:(NSString*)customerId
                     result:(NSString*)result
                 onComplete:(void (^)(NSDictionary *info))onComplete
                    onError:(void (^)(NSError *error))onError;

/**
 回访列表删除
 
 token     是     string     登录标识
 followUpId     是     string     回访ID
 **/

- (void)delFollowUp:(NSString*)token
         followUpId:(NSString*)followUpId
         onComplete:(void (^)(NSDictionary *info))onComplete
            onError:(void (^)(NSError *error))onError;

/**
 微信发送提醒信息接口
 
 token     是     string     登录标识
 name     是     string     客户名称
 carLineName     是     string     车系名称
 tipsItems     是     string     项目提醒
 customerId     是     string     客户ID
 partnerCustomerId     是     string     微信openId
 repairBillId     是     string     工单ID
 **/

- (void)sendWechatTips:(NSString*)token
                  name:(NSString*)name
           carLineName:(NSString*)carLineName
             tipsItems:(NSString*)tipsItems
            customerId:(NSString*)customerId
     partnerCustomerId:(NSString*)partnerCustomerId
          repairBillId:(NSString*)repairBillId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError;

/**
 客户养车提醒取消接口
 
 token     是     string     登录标识
 notifyId     是     int     养车ID
 **/

- (void)notifyDel:(NSString*)token
         notifyId:(NSString*)notifyId
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;

/**
 恢复客户养车已取消提醒接口
 
 token     是     string     登录标识
 ids     是     string     养车ID(多个数据格式为：“11,22,33”)
 **/

- (void)recoverNotify:(NSString*)token
                  ids:(NSString*)ids
           onComplete:(void (^)(NSDictionary *info))onComplete
              onError:(void (^)(NSError *error))onError;

/**
 新增工作板
 
 token     是     string     登录标识
 serviceType     是     int     业务类型 1:维修 2:保养 3:检测
 appointmentDate     是     date     预约日期 如：2017-10-12
 plateNumberP     是     string     车牌号区域号 如：粤
 plateNumberC     是     string     车牌号第二位 如：A
 plateNumber     是     string     车牌号后五位 如：88888
 name     是     string     客户名称
 phone     是     string     手机号码
 customerId     否     int     客户ID 从客户养车管理添加时必填
 vin     否     string     车架号 从客户养车管理添加时必填
 **/

- (void)addWorkboard:(NSString*)token
         serviceType:(NSString*)serviceType
     appointmentDate:(NSString*)appointmentDate
        plateNumberP:(NSString*)plateNumberP
        plateNumberC:(NSString*)plateNumberC
         plateNumber:(NSString*)plateNumber
               phone:(NSString*)phone
                name:(NSString*)name
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;
/*
 上传保单补充的图片
 
 token     是     string     token
 idImg     是     file     文件名 (‘idImg’,’drivingImg’,’warrantyPactImg’,’carImg’)
 
 */
- (void)uploadBlockPolicyFile:(NSArray*)images
                        token:(NSString*)token
                blockPolicyId:(NSString*)blockPolicyId
                   orderModel:(YHExtendImg)model
                   onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;
/*
 检测图片上传
 
 token    String    用户标识
 reqAct    String    操作类型，固定为：upload
 billId    String    工单id
 picFile    Imge    图片文件类型
 
 model 初检单类型
 
 isReplace 是否是代录
 http://192.168.1.248/btlmch/index.php
 */
- (void)updatePictureImageDate:(NSArray*)images
                         token:(NSString*)token
                        billId:(NSString*)billId
                    orderModel:(YHOrderModel)model
                     isReplace:(BOOL)isReplace
                    onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

//梅文峰
/*
 token      String    用户标识
 keyword    String    店铺名称或联系人
 sort       String    1-预约时间正序；0-预约时间反序（默认倒序）
 page       int       页数【默认1】
 pageSize   int       每页显示条数【默认20条】
 */
- (void)queryCheckListWithToken:(NSString *)token WithKeyword:(NSString *)keyword WithSort:(NSString *)sort WithPage:(int)page WithPageSize:(int)pageSize type:(NSInteger)type onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

/*
 token         String    用户标识
 bucheId       int       捕车列表ID
 amount        float     结算金额
 */
- (void)balanceAmountWithToken:(NSString *)token WithBucheId:(int)bucheId WithAmount:(float)amount onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

/*
 token      String   是   用户标识
 keyword    String   否   关键字 车架号、车系车型
 partnerId  int      是   检测单id
 page       int      否   页数【默认1】
 pageSize   int      否   每页显示条数【默认10条】
 */
- (void)queryWorkOrderListWithToken:(NSString *)token WithKeyword:(NSString *)keyword WithPartnerId:(int)partnerId WithPage:(int)page WithPageSize:(int)pageSize WithTag:(NSInteger)tag onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

/*
 获取二手车评估信息接口
 token      String   是   登录标识
 billId     String   是   工单id
 */
- (void)getAssessInfoWithToken:(NSString *)token
                        billId:(NSString *)billId
                    onComplete:(void (^)(NSDictionary *info))onComplete
                       onError:(void (^)(NSError *error))onError;

/*
 保存二手车评估报告推送接口
 token      String   是   登录标识
 billId     String   是   工单id
 billId     String   是   工单id
 */
- (void)saveAssessReportPushWithToken:(NSString *)token
                               billId:(NSString *)billId
                                phone:(NSString *)phone
                                price:(NSString *)price
                           onComplete:(void (^)(NSDictionary *info))onComplete
                              onError:(void (^)(NSError *error))onError;

/*
 获取解决方案站点列表
 token      String   是   登录标识
 name       String   否   站点搜索
 */
- (void)getSolutionOrgListWithToken:(NSString *)token
                               name:(NSString *)name
                         onComplete:(void (^)(NSDictionary *info))onComplete
                            onError:(void (^)(NSError *error))onError;

/*
 解决方案W001 - 门店预约接口
 token      String   是   登录标识
 solution_org_id     String   是   解决方案站点id
 */
- (void)getBookingInfoWithToken:(NSString *)token
                 solutionOrgiId:(NSString *)solution_org_id
                            vin:(NSString *)vin
                   car_brand_id:(NSString *)car_brand_id
                    car_line_id:(NSString *)car_line_id
                   car_model_id:(NSString *)car_model_id
            car_model_full_name:(NSString *)car_model_full_name
                         car_cc:(NSString *)car_cc
                    car_cc_unit:(NSString *)car_cc_unit
                      nian_kuan:(NSString *)nian_kuan
                   produce_year:(NSString *)produce_year
                   gearbox_type:(NSString *)gearbox_type
                 plate_number_p:(NSString *)plate_number_p
                 plate_number_c:(NSString *)plate_number_c
                   plate_number:(NSString *)plate_number
                  customer_name:(NSString *)customer_name
                 customer_phone:(NSString *)customer_phone
               appointment_time:(NSString *)appointment_time
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError;

/*
 解决方案W001 - 门店预约时页面信息接口
 token      String   是   登录标识
 solution_org_id     String   是   解决方案站点id
 */
- (void)getBookingInfoWithToken:(NSString *)token
                 solutionOrgiId:(NSString *)solution_org_id
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError;

/*
 解决方案工单列表:未完成
 解决方案工单列表:已完成
 需求方列表:未完成
 需求方列表:已完成
 token      String   是   登录标识
 */
- (void)getSolutionListOrDemanderWithToken:(NSString *)token
                                      page:(NSString *)page
                                  pagesize:(NSString *)pagesize
                                       tag:(NSInteger)tag
                                onComplete:(void (^)(NSDictionary *info))onComplete
                                   onError:(void (^)(NSError *error))onError;


#pragma mark - 刘松   二手车检测基本信息
/**
 检车新建工单
 
 token   string    token
 vin     string    vin号
 */
-(void)checkTheCarCreateNewWorkOrderWithToken:(NSString *)token Vin:(NSString *)vin onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

/**
获取品牌列表
 
 无参post
 */
-(void)queryCarBrandListonComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

/**
 获取车系列表

brandId int 品牌ID
 */
-(void)queryCarSeriesTableWithBrandId:(NSString *)brandId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;


/**
 提交基本信息
 token                   是    string    token
 bucheBookingId          是    int       捕车id
 baseInfo                是    object    基本信息
 
 —vin                    是    string    车架号
 —carBrandId             是    int       车型id
 —carBrandName           是    string    车型名称
 —carLineId              是    int       车系id
 —carLineName            是    string    名称
 —carModelId             否    int       车辆版本id，如果carType 为1不用此字段
 —carModelName           否    string    车辆版本，如果carType 为1不用此字段
 
 —carType                是    int       0估车网 1系统和车主填写信息（就是vin号能检测出来0否则1）
 
 —carStyle               是    string    年款
 —dynamicParameter       是    string    动力参数
 —model                  是    string    型号
 
 —plateNumberP           是    string    车辆区域识别 如：粤
 —plateNumberC           是    string    车辆区域识别 如：A
 
 —emissionsStandards     是    string    排放标准（国Ⅰ,国Ⅱ,国Ⅲ，国Ⅳ，国Ⅴ）
 —tripDistance           是    string    行驶里程
 —productionDate         是    date      出厂日期（年+月）
 —registrationDate       是    date      注册日期（年+月+日）
 —issueDate              是    date      发证日期（年+月+日）
 —carNature              是    string    车辆性质（运营/非运营）
 —userNature             是    string    车辆所有者性质（私户/公户）
 —endAnnualSurveyDate    是    date      年检到期时间（年+月）
 —trafficInsuranceDate   否    date      交强险到期时间（年+月）
 —businessInsuranceDate  否    date      商业险到期时间（年+月+日）
 —carAddress             是    string    看车地址
 —userName              否    string    用户名
 —phone                 是    string    联系方式
 
 isHelp  创建帮检单
 */
-(void)submitBasicInformationWithDictionary:(NSDictionary *)dict isHelp:(BOOL)isHelp onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

/**
 工单-暂存保存接口
 
 token                   是    string    token
 bucheBookingId          否    int       捕车id
 baseInfo                是    object    基本信息-baseInfo信息同上面提交基本信息接口
 isHelp 是否是帮检单
 */
-(void)temporaryDepositBasicInformationWithDictionary:(NSDictionary *)dict isHelp:(BOOL)isHelp onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError;

- (void)getVideoList:(NSString*)token
           projectId:(NSString*)projectId
            carBrand:(NSString*)car_brand
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;


/**
 提交Ai检测数据
 *
 **/
- (void)submitAirConditionerReport:(NSDictionary *)resultDict onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 延长保修 - 报告保存方案报价
 *
 **/
- (void)saveStoreExtWarrantyReportQuote:(NSDictionary *)resultDict onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 提交Ai空调检测数据
 *
 **/
- (void)submitJ009Report:(NSDictionary *)resultDict onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 Ai删除维修报告方案
 *
 **/
- (void)delReportMaintainBillId:(NSString *)billId caseId:(NSString *)maintain_id onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;

/**
 获取机油复位教程

 */
-(void)getOilReset:(NSDictionary *)dict onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError;


/**
 根据上牌时间获取评估价格
 
 token                   是    string    token
 bill_id               否    string       工单id
 car_license_time                是    string    上牌时间 格式：yyyy-mm-dd
 */
-(void)getPriceByCarLicenseTime:(NSDictionary *)dict onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError;


- (void)getReportByBillIdV2:(NSString *)token billId:(NSString *)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError;
@end
