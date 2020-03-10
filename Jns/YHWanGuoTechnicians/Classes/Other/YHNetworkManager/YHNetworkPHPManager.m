//
//  YHNetworkPHPManager.m
//  FTBOCOpSdk
//
//  Created by 朱文生 on 15-1-30.
//  Copyright (c) 2015年 FTSafe. All rights reserved.
//

#import "YHNetworkPHPManager.h"


//static NSString * const AFAppDotNetAPIBaseURLString = SERVER_PHP_URL;
//#define AFAppDotNetAPIBaseURLString = SERVER_PHP_URL;


#import "YHTools.h"
//#import "MBProgressHUD+MJ.h"
#import "CheckNetwork.h"
#define arId @"IOS"
#define arIdCsc @"ios_mfb"
#define buildTime [YHTools stringFromDate:[NSDate date] byFormatter:@"YYYYMMddHHmmss"]

#define addCarParameter(keys, parameters, key, value)  if (value != nil && ![value isEqualToString:@""]) {\
keys = [keys stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];\
[parameters setObject:value forKey:key];\
}
//#define NetworkTest
#define TestError


@interface YHNetworkPHPManager ()
@end

@implementation YHNetworkPHPManager
DEFINE_SINGLETON_FOR_CLASS(YHNetworkPHPManager);

/**
 小虎安检删除维修报告方案
 *
 **/
- (void)removeRepairCaseBillId:(NSString *)billId caseId:(NSString *)maintain_id onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (billId == nil || maintain_id == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[YHTools getAccessToken] forKey:@"token"];
    [param setValue:@([billId intValue]) forKey:@"billId"];
    [param setValue:maintain_id forKey:@"maintain_id"];
    
    NSString *urlStr = SERVER_PHP_Trunk"/Bill/Undisposed/delReportMaintain";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}


/**
 Ai删除维修报告方案
 *
 **/
- (void)delReportMaintainBillId:(NSString *)billId caseId:(NSString *)maintain_id onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (billId == nil || maintain_id == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[YHTools getAccessToken] forKey:@"token"];
    [param setValue:@([billId intValue]) forKey:@"order_id"];
    [param setValue:maintain_id forKey:@"maintain_id"];
    
    NSString *urlStr = SERVER_PHP_Trunk"/AiMaintainSolution/AirConditioner/delReportMaintain";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}

/**
 提交深度诊断检测数据
 *
 **/
- (void)submitDepthDiagnoseReport:(NSDictionary *)resultDict onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (resultDict == nil ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSString *urlStr = SERVER_PHP_Trunk"/Bill/Undisposed/saveStoreNewWholeCarReportQuote";
    [self YHBasePOST:urlStr param:resultDict onComplete:onComplete onError:onError];
}

/**
 提交Ai检测数据
 *
 **/
- (void)submitAirConditionerReport:(NSDictionary *)resultDict onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (resultDict == nil ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSString *urlStr = SERVER_PHP_Trunk"/AiMaintainSolution/AirConditioner/saveAirConditionerReportQuote";
    [self YHBasePOST:urlStr param:resultDict onComplete:onComplete onError:onError];
}

/**
延长保修 - 报告保存方案报价
 *
 **/
- (void)saveStoreExtWarrantyReportQuote:(NSDictionary *)resultDict onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (resultDict == nil ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSString *urlStr = SERVER_PHP_Trunk"/Bill/Undisposed/saveStoreExtWarrantyReportQuote";
    [self YHBasePOST:urlStr param:resultDict onComplete:onComplete onError:onError];
}

/**
 提交Ai空调检测数据
 *
 **/
- (void)submitJ009Report:(NSDictionary *)resultDict onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (resultDict == nil ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSString *urlStr = SERVER_PHP_Trunk"/Bill/Undisposed/saveStoreNewWholeCarReportQuote";
    [self YHBasePOST:urlStr param:resultDict onComplete:onComplete onError:onError];
}


/**
 获取深度诊断检测数据
 *
 **/
- (void)getDepthDiagnoseWithToken:(NSString *)token billId:(NSString *)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:token forKey:@"token"];
    [param setValue:@([billId intValue]) forKey:@"billId"];
    NSString *urlStr = SERVER_PHP_Trunk"/Bill/Undisposed/getBillDetail";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}

/**
 根据code获取全车报告接口
 *
 **/
- (void)getCarCheckReportWithCode:(NSString *)code version:(NSString *)version onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (code == nil || version == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:code forKey:@"code"];
    [param setValue:version forKey:@"version"];
    NSString *urlStr = SERVER_PHP_Trunk"/Common/Report/getWholeCarReport";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}

/**
 保存推送AI空调检测报告接口
 *
 **/
- (void)savePushIntelligentCheckReport:(NSDictionary *)param onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (param == nil ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSString *urlStr = SERVER_PHP_Trunk"/AiMaintainSolution/AirConditioner/savePushAirConditionerReport";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}
/**
 获取AI空调检测报告（技师端）
 *
 **/
- (void)getIntelligentCheckReport:(NSString *)token order_id:(NSString *)order_id onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil || order_id == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:order_id forKey:@"order_id"];
    NSString *urlStr = SERVER_PHP_Trunk"/AiMaintainSolution/AirConditioner/getAirConditionerReport";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}

- (void)getReportByBillIdV2:(NSString *)token billId:(NSString *)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:billId forKey:@"billId"];
    NSString *urlStr = SERVER_PHP_Trunk"/Bill/Report/getReportByBillIdV2";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}


/**
 获取机构余额余额页面信息接口
 *
 **/
- (void)getOrganizationPointNumber:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    NSString *urlStr = SERVER_PHP_Trunk"/PointsDeal/PointsDeal/getOrgPointsHome";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}

/**
 工单 - 获取工单扣除余额详情
 *
 **/
- (void)getOrderDeductNumber:(NSString *)token billId:(int)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:@"BILL_REPORT" forKey:@"sort"];
    [param setValue:@(billId) forKey:@"bill_id"];
    NSString *urlStr = SERVER_PHP_Trunk"/Common/Bill/getBillExpendOrgPointsDetail";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}

- (void)saveOrderDeductNumber:(NSString *)token billId:(int)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:@"BILL_REPORT" forKey:@"sort"];
    [param setValue:@(billId) forKey:@"bill_id"];
    NSString *urlStr = SERVER_PHP_Trunk"/Common/Bill/saveBillExpendOrgPoints";
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}

/**
 解决方案W001 - 方选择方案接口
 *
 **/
- (void)requireToChoiceCase:(NSString *)token billId:(int)billId repairModelId:(NSString *)repairModelId isTechnique:(BOOL)isTechnique onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil || token == repairModelId) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:repairModelId forKey:@"repairModelId"];
    [param setValue:@(billId) forKey:@"billId"];
    
    NSString *urlStr = SERVER_PHP_Trunk"/Bill/Undisposed/saveAffirmModel";
    
    if (!isTechnique) {
        urlStr = SERVER_PHP_Trunk"/Bill/Solution/saveAffirmModel";
    }
    [self YHBasePOST:urlStr param:param onComplete:onComplete onError:onError];
}

/**
 提交保存维修方案-for->J004
 *
 **/
- (void)submitRepairCaseDataForJ004:(NSDictionary *)param onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (param == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveStoreNewWholeCarReportQuote" param:param onComplete:onComplete onError:onError];
}

/**
  提交保存维修方案
 *
 **/
- (void)submitRepairCaseData:(NSDictionary *)param onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (param == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveStoreMakeMode" param:param onComplete:onComplete onError:onError];
}

/**
 获取模糊搜索维修项目接口
 *
 **/
- (void)getRepairProjectWithDark:(NSString *)token itemName:(NSString *)itemName car_cc:(NSString *)car_cc onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (token == nil || itemName == nil || car_cc == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:itemName forKey:@"item_name"];
//    if (![car_cc containsString:@"L"]) {
    if([self isNumber:car_cc]){
        car_cc = [NSString stringWithFormat:@"%@L",car_cc];
    }
//    NSString *finalCarCc = [NSString stringWithFormat:@"%@",car_cc];
//    if (![car_cc containsString:@"L"]) {
//        finalCarCc = [NSString stringWithFormat:@"%@",car_cc];
//    }
    [param setValue:car_cc forKey:@"car_cc"];
    [self YHBasePOST:SERVER_PHP_Trunk"/AiMaintainSolution/Solution/getItemSearch" param:param onComplete:onComplete onError:onError];
}

- (BOOL)isNumber:(NSString *)strValue{
    if (strValue == nil || [strValue length] <= 0)
    {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[strValue componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![strValue isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}

/**
 获取配件类型接口
 *
 **/
- (void)getPartTypeList:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [self YHBasePOST:SERVER_PHP_Trunk"/AiMaintainSolution/Solution/getPartType" param:param onComplete:onComplete onError:onError];
}
/**
 获取解决方案站点列表
 *
 **/
- (void)getSolutionStationList:(NSString *)token name:(NSString *)name onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (token == nil || name == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:name forKey:@"name"];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/AiMaintainSolution/Solution/getSolutionOrgList" param:param onComplete:onComplete onError:onError];
}

/**
 获取模糊搜索耗材接口
 *
 **/
- (void)getConsumableWithDarkWay:(NSString *)token itemName:(NSString *)itemName onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (token == nil || itemName == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:itemName forKey:@"item_name"];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/AiMaintainSolution/Solution/getConsumableSearch" param:param onComplete:onComplete onError:onError];
}

/**
 获取精准搜索配件接口
 *
 **/
- (void)getPartsWithExactWay:(NSString *)token partName:(NSString *)partName  brandId:(int)brandId lineId:(int)lineId car_cc:(NSString *)car_cc carYear:(int)carYear onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (token == nil || partName == nil || car_cc == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:partName forKey:@"part_name"];
    [param setValue:@(brandId) forKey:@"brand_id"];
    [param setValue:@(lineId) forKey:@"line_id"];
    if([self isNumber:car_cc]){
        car_cc = [NSString stringWithFormat:@"%@L",car_cc];
    }
    NSString *finalCarCc = [NSString stringWithFormat:@"%@",car_cc];
    finalCarCc = [NSString stringWithFormat:@"%@",car_cc];
    [param setValue:finalCarCc forKey:@"car_cc"];
    [param setValue:@(carYear) forKey:@"car_year"];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/AiMaintainSolution/Solution/getPartPrecisionSearch" param:param onComplete:onComplete onError:onError];
}
/**
  获取模糊搜索配件接口
 *
 **/
- (void)getPartsWithDarkWay:(NSString *)token partName:(NSString *)partName onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (token == nil || partName == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:partName forKey:@"part_name"];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/AiMaintainSolution/Solution/getPartSearch" param:param onComplete:onComplete onError:onError];
}

/**
 J003专项检测
 *
 **/
- (void)professionalExamine:(NSString *)token billId:(int)billId sysIds:(NSString *)sysIds onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (token == nil || sysIds == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:@(billId) forKey:@"billId"];
    [param setValue:sysIds forKey:@"sysIds"];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveInitialSurveySys" param:param onComplete:onComplete onError:onError];
}

/**
  获取预约单详情数据
 *
 **/
- (void)getAppointmentOrderDetailInfo:(NSString *)token billId:(int)billId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:@(billId) forKey:@"bill_id"];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/getBookingInfoById" param:param onComplete:onComplete onError:onError];
}
/**
 小虎预约单推送接口
 *
 **/
- (void)appointmentOrderPush:(NSString *)token billId:(int)billId arrivalTimeStart:(NSString *)arrivalTimeStart arrivalTimeEnd:(NSString *)arrivalTimeEnd onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (token == nil || arrivalTimeStart == nil || arrivalTimeEnd == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:token forKey:@"token"];
    [param setValue:@(billId) forKey:@"bill_id"];
    [param setValue:arrivalTimeStart forKey:@"arrival_time_start"];
    [param setValue:arrivalTimeEnd forKey:@"arrival_time_end"];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveBooking" param:param onComplete:onComplete onError:onError];
}
/**
 登录验证
 *
 **/
- (void)checkAuthCodeIsTure:(NSString *)codeStr onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    if (codeStr == nil || codeStr.length == 0) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:codeStr forKey:@"code"];
    [self YHBasePOST:SERVER_PHP_Trunk"/Servant/Guest/checkLoginVerifyCode" param:param onComplete:onComplete onError:onError];
}
/**
 获取验证码图片
 *
 **/
- (void)getAuthCodeImageOnComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Servant/Guest/getLoginVerifyCode" param:nil onComplete:onComplete onError:onError];
}

/**
 新登录接口
 *
 **/
- (void)newLoginUserName:(NSString *)userName passWord:(NSString *)passWord org_id:(NSString *)org_id confirm_bind:(BOOL)isConfirm_bind onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (userName == nil || passWord == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:userName forKey:@"username"];
    [parameters setValue:passWord forKey:@"password"];
    
//    NSString *bindStr = isConfirm_bind ? @"1" : @"0";
//    [parameters setValue:bindStr forKey:@"confirm_bind"];
    [parameters setValue:VtrId forKey:@"vtr_id"];
    
    if (org_id.length > 0 && org_id) {
        [parameters setValue:org_id forKey:@"org_id"];
    }
    
    NSLog(@"----------------->>>>传参:%@<<<<----------------",parameters);
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Servant/Guest/jnsLogin" param:parameters onComplete:onComplete onError:onError];
}

/**
 退出登录接口
 *
 **/
- (void)LogoutOnComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[YHTools getAccessToken] forKey:@"token"];
    [self YHBasePOST:SERVER_PHP_Trunk"/Common/Member/Logout" param:parameters onComplete:onComplete onError:onError];
}

/**
 修改密码
 *
 **/
- (void)modifyPassword:(NSString *)token oldPasswd:(NSString *)oldPasswd newPassword:(NSString *)newPassword onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil || oldPasswd == nil || newPassword == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:[YHTools md5:oldPasswd] forKey:@"oldPasswd"];
    [parameters setValue:[YHTools md5:newPassword] forKey:@"newPassword"];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Servant/CommonServant/changePassword" param:parameters onComplete:onComplete onError:onError];
    
}

/**
 暂存维修方式
 *
 **/
- (void)saveModifyPattern:(NSString *)token billId:(NSString *)billId checkResult:(NSDictionary *)checkResult repairModeData:(NSMutableArray *)repairModeData onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    repairModeData = repairModeData.mutableCopy;
    NSArray *repairModes = [repairModeData valueForKeyPath:@"repairModeKey"];
    [repairModeData removeObjectsInArray:repairModes];
//    NSDictionary *parameters = @{@"billId":billId,@"token":token};
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:billId forKey:@"billId"];
    if (checkResult != nil) {
        [parameters setValue:checkResult forKey:@"checkResult"];
    }
    if (repairModeData != nil) {
        [parameters setValue:repairModeData forKey:@"repairModeData"];
    }
  
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveTempRepairMode" param:parameters onComplete:onComplete onError:onError];

}

/**
 保存诊断结果/诊断思路
 *
 **/
- (void)saveEditResultToken:(NSString *)token billId:(NSString *)billId editResult:(NSString *)editResult editType:(NSInteger)type onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil || billId == nil ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *resultData = [[NSMutableDictionary alloc]init];
    resultData[@"bill_id"] = billId;
    resultData[@"token"] = token;
    
    if(type == 1){
        resultData[@"make_idea"] = editResult;
    }else{
        resultData[@"make_result"] = editResult;
    }
    
    [self YHBasePOST:[NSString stringWithFormat:@"%@%@",SERVER_PHP_Trunk"/Bill/Undisposed/",type == 1 ? @"saveReportMakeIdea" : @"saveReportMakeResult"] param:resultData onComplete:onComplete onError:onError];
    
}

/**
 维修项目搜索 - 获取列表接口
 *
 **/
- (void)getRepairItemList:(NSString *)token partsName:(NSString *)name onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError{
    
    if (token == nil || name == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"name":name,@"token":token};
    [self YHBasePOST:SERVER_PHP_Trunk"/Common/Bill/getRepairItemListByPartsName" param:parameters onComplete:onComplete onError:onError];
    
}

/**
 微信授权登录 (测试模拟使用)

 **/
- (void)loginTest:(NSString*)orgId onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/Guest/wxloignTest?orgId=402881485aef1e86015af3cfe1b50038&vtrId=PC_WEB" param:nil onComplete:onComplete onError:onError];
}

/**
 技师登录
 vtrId	String	Y	访问来源id:【accessSys表中的accessId】
 orgId	String	Y	站点id
 username	String	Y	用户登录账号
 password	String	Y	用户登录密码
 verifyCode	String	Y	图形验证码
 urlCode 站点标示
 
 **/

- (void)loginTest:(NSString*)orgId vtrId:(NSString*)vtrId  username:(NSString*)username  password:(NSString*)password   verifyCode:(NSString*)verifyCode urlCode:(NSString*)urlCode onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    
    if (urlCode == nil || vtrId == nil || username == nil || password == nil || verifyCode == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"urlCode":urlCode,@"vtrId":vtrId,@"username":username,@"password":password,@"verifyCode":verifyCode};
    [self YHBasePOST:SERVER_PHP_Trunk"/Servant/Guest/login" param:parameters onComplete:onComplete onError:onError];
}


/**
 4.1.	服务人员 – 个人信息详情
 
 token	String	Y
 **/

- (void)userInfo:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError{
    
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token};
    [self YHBasePOST:SERVER_PHP_Trunk"/Servant/CommonServant/userInfo" param:parameters onComplete:onComplete onError:onError];
}

/**
 微信授权登录
 
 orgId	String	机构ID
 vtrId	String	访问标识
 
 **/

- (void)getAppId:(NSString*)orgId vtrId:(NSString*)vtrId  onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError{
    if (orgId == nil || vtrId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"orgId":orgId,@"vtrId":vtrId};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/Guest/wxLogin" param:parameters onComplete:onComplete onError:onError];
}


/**
 微信登录-车主端
 
 orgId	String	机构ID
 vtrId	String	访问标识
 Appid	String	微信appid
 Code	String	微信授权成功返回的code
 
 **/

- (void)login:(NSString*)orgId vtrId:(NSString*)vtrId  appid:(NSString*)appid code:(NSString*)code onComplete:(void (^)(NSDictionary *info))onComplete
      onError:(void (^)(NSError *error))onError{
    if (orgId == nil || vtrId == nil || appid == nil || code == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"orgId":orgId,@"vtrId":vtrId,@"appid":appid,@"code":code};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/Guest/wxuserInfo" param:parameters onComplete:onComplete onError:onError];
}


/**
 微信绑定手机短信发送
 
 token	String	登录标识
 phone	String	手机号
 isCreate	String	短信发送类型 绑定账号，默认为修改手机号码
 
 
 **/

- (void)sms:(NSString*)token phone:(NSString*)phone type:(bool)isCreate onComplete:(void (^)(NSDictionary *info))onComplete
    onError:(void (^)(NSError *error))onError{
    if (token == nil || phone == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"phone":phone,@"type":((isCreate)? (@"create") : (@"edit"))};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersInfo/bundingSms" param:parameters onComplete:onComplete onError:onError];
}

/**
 微信绑定手机短信发送
 
 token	String	登录标识
 phone	String	手机号
 verifyCode	String	短信验证码
 
 **/

- (void)checkOldphone:(NSString*)token phone:(NSString*)phone verifyCode:(NSString*)verifyCode onComplete:(void (^)(NSDictionary *info))onComplete
              onError:(void (^)(NSError *error))onError{
    if (token == nil || phone == nil || verifyCode == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"phone":phone,@"verifyCode":verifyCode};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersInfo/checkOldphone" param:parameters onComplete:onComplete onError:onError];
}

/**
 绑定或修改新手机并验证code操作
 
 token	String	登录标识
 phone	String	手机号
 isCreate	String	短信发送类型 绑定账号，默认为修改手机号码
 verifyCode	String	短信验证码
 
 **/

- (void)bundingSms:(NSString*)phone token:(NSString*)token type:(BOOL)isCreate verifyCode:(NSString*)verifyCode  onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError{
    if (phone == nil || token == nil || verifyCode == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"phone":phone,@"token":token,@"type":((isCreate)? (@"create") : (@"edit")),@"verifyCode":verifyCode};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersInfo/bindingWx" param:parameters onComplete:onComplete onError:onError];
}

/**
 车主端工单添加
 
 token	String	登录标识
 username	String	用户姓名
 phone	String	电话
 usersCarId	String	车主爱车id
 appointmentDate	String	格式：2016-3-20 13:30:50
 
 **/

- (void)makeAppointment:(NSString*)token username:(NSString*)username phone:(NSString*)phone usersCarId:(NSString*)usersCarId appointmentDate:(NSString*)appointmentDate onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError{
    if (token == nil || username == nil || phone == nil || usersCarId == nil || appointmentDate == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"username":username,@"token":token,@"phone":phone,@"usersCarId":usersCarId,@"appointmentDate":appointmentDate};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/CommonCustomer/makeAppointment" param:parameters onComplete:onComplete onError:onError];
}


/**
 车主端列表
 
 token	String	登录标识
 page	String	第几页默认为1
 pagesize	String	每页显示多少条默认为10
 
 
 **/

- (void)makApoointList:(NSString*)token page:(NSString*)page pagesize:(NSString*)pagesize onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil || page == nil || pagesize == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"page":page,@"token":token,@"pagesize":pagesize};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/CommonCustomer/makApoointList" param:parameters onComplete:onComplete onError:onError];
}

/**
 登录账号修改
 
 token	String	登录标识
 mobile	String	手机号
 
 
 **/

- (void)setAcount:(NSString*)mobile token:(NSString*)token  onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    if (mobile == nil || token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"mobile":mobile,@"token":token};
    [self YHBasePOST:SERVER_PHP_Trunk"/OwnShopMng/ServantInfo/loginNumSms" param:parameters onComplete:onComplete onError:onError];
}

/**
 站点海报列表
 
 orgId	String 站点标识
 
 
 **/

- (void)getAd:(NSString*)orgId onComplete:(void (^)(NSDictionary *info))onComplete
      onError:(void (^)(NSError *error))onError{
    if (orgId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"orgId":orgId};
    [self YHBasePOST:SERVER_PHP_Trunk"/OwnShopMng/ServantInfo/loginNumSms" param:parameters onComplete:onComplete onError:onError];
}

/**
 站点详情
 
 orgId	String 站点标识
 
 
 **/

- (void)getServiceDetail:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token};
    [self YHBasePOST:SERVER_PHP_Trunk"/OwnShopMng/ShopInfo/OwnShopDetail" param:parameters onComplete:onComplete onError:onError];
}


/**
 添加工单
 
 userName
 phone
 vin
 appointmentDate
 
 
 **/

- (void)addOrder:(NSString*)token userName:(NSString*)userName phone:(NSString*)phone vin:(NSString*)vin appointmentDate:(NSString*)appointmentDate onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError{
    if (userName == nil
        || phone == nil
        || vin == nil
        || appointmentDate == nil
        || token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,
                                 @"userName" : userName,
                                 @"phone" : phone,
                                 @"vin" : vin,
                                 @"appointmentDate" : appointmentDate};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/CommonCustomer/makeAppointment" param:parameters onComplete:onComplete onError:onError];
}

/**
 添加和修改用户车辆信息
 
 token	String	token
 carLineId	Int	车系ID
 carLineName	String	车系名称
 carBrandId	Int	车辆品牌ID
 carBrandName	String	车辆品牌名称
 carCc	String	排量
 vin	String	车辆唯一识别代码
 plateNumber	String	车牌号码 不含第一位中文
 plateNumberP	String	车辆区域识别 如：粤
 produceYear	String	车生产年份
 mileage	Int	行车里程，单位km
 carCardTime	String	上牌时间：Y-m
 carType	Int	车类型 0估车网 1自己库
 gearboxType	String	变速箱类型
 carModelId	Int	车型ID
 carModelName	String	车型名称
 
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
         onError:(void (^)(NSError *error))onError{
    if (token == nil
        || carLineId == nil
        || carLineName == nil
        || carBrandId == nil
        || carBrandName == nil
        //        || carCc == nil
        //        || vin == nil
        || plateNumber == nil
        || plateNumberP == nil
        //        || produceYear == nil
        //        || mileage == nil
        //        || carCardTime == nil
        || carType == nil
        ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token,
                                         @"carLineId":carLineId,
                                         @"carLineName":carLineName,
                                         @"carBrandId":carBrandId,
                                         @"carBrandName":carBrandName,
                                         @"plateNumber":plateNumber,
                                         @"plateNumberP":plateNumberP,
                                         @"carType":carType} mutableCopy];
    if (carCc && ![carCc isEqualToString:@""]) {
        [parameters setObject:carCc forKey:@"carCc"];
    }
    if (vin && ![vin isEqualToString:@""]) {
        [parameters setObject:vin forKey:@"vin"];
    }
    if (produceYear && ![produceYear isEqualToString:@""]) {
        [parameters setObject:produceYear forKey:@"produceYear"];
    }
    if (mileage && mileage.integerValue != 0) {
        [parameters setObject:mileage forKey:@"mileage"];
    }
    if (carCardTime && ![carCardTime isEqualToString:@""]) {
        [parameters setObject:carCardTime forKey:@"carCardTime"];
    }
    if (gearboxType) {
        [parameters setObject:gearboxType forKey:@"gearboxType"];
    }
    if (carModelName) {
        [parameters setObject:carModelId forKey:@"carModelId"];
    }
    if (carModelName) {
        [parameters setObject:carModelName forKey:@"carModelName"];
    }
    if (carId == nil) {
        [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersCar/addUsersCar" param:parameters onComplete:onComplete onError:onError];
    }else{
        [parameters setObject:carId forKey:@"id"];
        [self YHBasePOST:SERVER_PHP_Trunk"CarOwner/UsersCar/editUsersCar" param:parameters onComplete:onComplete onError:onError];
    }
    
}

/**
 获取用户车辆信息
 
 token	String	token
 vin	String	车辆唯一识别代码
 
 
 **/

- (void)getUsersCarInfo:(NSString*)token
                    vin:(NSString*)vin onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError{
    if (token == nil
        || vin == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,
                                 @"id" : vin};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersCar/getUsersCarInfo" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取用户车辆列表
 
 token	String	token
 
 
 **/

- (void)getUsersCarList:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersCar/getUsersCarList" param:parameters onComplete:onComplete onError:onError];
}

/**
 设置用户默认车辆
 
 token	String	token
 id	Int	车辆ID
 
 
 **/

- (void)setUsersCarDefault:(NSString*)token
                     carId:(NSString*)carId onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError{
    if (token == nil
        || carId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,
                                 @"id" : carId};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersCar/setUsersCarDefault" param:parameters onComplete:onComplete onError:onError];
}



/**
 删除用户车辆
 
 token	String	token
 id	Int	车辆ID
 
 
 **/

- (void)deleteUsersCar:(NSString*)token
                 carId:(NSString*)carId onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil
        || carId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,
                                 @"id" : carId};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersCar/deleteUsersCar" param:parameters onComplete:onComplete onError:onError];
}


/**
 获取车主个人信息
 
 token	String	token
 
 
 **/

- (void)getCustomerInfo:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersInfo/getBaseInfo" param:parameters onComplete:onComplete onError:onError];
}
/**
 修改车主个人信息
 
 token	String	token
 nickname	String	姓名
 
 **/

- (void)editUserNickname:(NSString*)token
                nickname:(NSString*)nickname
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil
        || nickname == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,
                                 @"nickname":nickname
                                 };
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersInfo/editUserNickname" param:parameters onComplete:onComplete onError:onError];
}

/**
 修改车主个人信息
 
 token	String	token
 headUrl	String	头像地址
 nickname	String	姓名
 phone	String	手机号
 
 **/

- (void)editCustomerInfo:(NSString*)token
                 headUrl:(NSString*)headUrl
                nickname:(NSString*)nickname
                   phone:(NSString*)phone
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil
        || headUrl == nil
        || nickname == nil
        || phone == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,
                                 @"headUrl":headUrl,
                                 @"nickname":nickname,
                                 @"phone":phone,};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/UsersCar/editBaseInfo" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取车辆品牌列表
 
 token	String	token
 
 
 **/

- (void)getCarBrandListOnComplete:(void (^)(NSDictionary *info))onComplete
                          onError:(void (^)(NSError *error))onError{
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/Guest/getCarBrandList" param:nil onComplete:onComplete onError:onError];
}

/**
 获取车辆车系列表
 
 brandId	Int	车辆品牌ID
 
 
 **/

- (void)getCarLineList:(NSString*)brandId onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (brandId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"brandId":brandId};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/Guest/getCarLineList" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取车辆信息
 vin	Sting	vin号
 
 
 **/

- (void)getCarInfoByVin:(NSString*)vin onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError{
    if (vin == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"vin":vin};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/Guest/getCarInfoByVin" param:parameters onComplete:onComplete onError:onError];
}


/**
 获取店铺信息
 
 shopOpenId	String	店铺ID
 
 
 **/

- (void)myShopDetail:(NSString*)orgId onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError{
    if (orgId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"shopCode" : orgId, @"advSize" : @"750x425"};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/Guest/myShopDetail" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取全车检测报告
 
 token	String	token
 billId	String	工单号
 
 
 
 **/

- (void)getFullReport:(NSString*)token billId:(NSString*)billId onComplete:(void (^)(NSDictionary *info))onComplete
              onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId};
    [self YHBasePOST:SERVER_PHP_Trunk"/CarOwner/CommonCustomer/getFullReport" param:parameters onComplete:onComplete onError:onError];
}


/**
 订单列表
 
 token 	是 	string 	会话标识token
 page 	否 	int 	页码
 pagesize 	否 	string 	每页数
 keyword 	否 	string 	关键字，用于搜索
 isHistory 是否是历史工单
 
 
 **/

- (void)getOrderList:(NSString*)token keyword:(NSString*)keyword page:(NSString*)page pagesize:(NSString*)pagesize isHistory:(BOOL)isHistory  onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError{
    if (page == nil || pagesize == nil || token == nil){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"page":page,@"pagesize":pagesize,@"token":token} mutableCopy];
    if (isHistory && keyword && ![keyword isEqualToString:@""]) {
        [parameters setObject:keyword forKey:@"keyword"]; //pending 待处理（默认） unfinished 未完成
    }
    [self YHBasePOST:((isHistory)? ((SERVER_PHP_Trunk"/Orders/HistoricalOrder/index")) : (SERVER_PHP_Trunk"/Orders/NowOrder/index")) param:parameters onComplete:onComplete onError:onError];
}

/**
 理列表
 
 search	string	N	搜索字符
 isPending   是否 待处理
 page	int	N	页码
 pagesize	int	N	数据条数
 isHistory 是否是历史工单
 
 
 **/

- (void)getWorkOrderList:(NSString*)token searchKey:(NSString*)searchKey page:(NSString*)page pagesize:(NSString*)pagesize isHistory:(BOOL)isHistory isPending:(BOOL)isPending onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (searchKey == nil || page == nil || pagesize == nil || token == nil){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"search":searchKey,@"page":page,@"pagesize":pagesize,@"token":token} mutableCopy];
    if (!isHistory) {
        [parameters setObject:((isPending)? (@"pending") : (@"unfinished")) forKey:@"type"]; //pending 待处理（默认） unfinished 未完成
    }
    [self YHBasePOST:((isHistory)? ((SERVER_PHP_Trunk"/Bill/History")) : (SERVER_PHP_Trunk"/Bill/Undisposed")) param:parameters onComplete:onComplete onError:onError];
}

/**
 工单详情
 
 billId	int	Y	工单id
 isHistory 是否是历史工单
 **/

- (void)getBillDetail:(NSString*)token billId:(NSString*)billId isHistory:(BOOL)isHistory onComplete:(void (^)(NSDictionary *info))onComplete
              onError:(void (^)(NSError *error))onError{
    if (billId == nil || token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"billId":billId,@"token":token};
    
    [self YHBasePOST:((isHistory)? ((SERVER_PHP_Trunk"/Bill/History/getBillDetail")) : (SERVER_PHP_Trunk"/Bill/Undisposed/getBillDetail")) param:parameters onComplete:onComplete onError:onError];
}

/**
 根据系统获取故障现象信息
 
 sysClassId	int	Y	系统id
 **/

- (void)getFaultPhenomenon:(NSString*)token sysClassId:(NSString*)sysClassId onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError{
    if (sysClassId == nil || token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"sysClassId":sysClassId,@"token":token};
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/CreateNew/getFaultPhenomenon" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取新建工单数据
 **/

- (void)createNew:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token};
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/createNew" param:parameters onComplete:onComplete onError:onError];
}


/**
 保存新建工单数据
 billType	string	Y	W 维修 B 保养 J 全车检测 如果多选则拼接type
 如 WB 或WBJ
 baseInfo	object	Y
 carLineId	int	Y	车系id
 carLineName	string	Y	车系名称
 carBrandId	int	Y	车型id
 carBrandName	string	Y	车型名称
 carCc	string	Y	排量
 carModelId	int	N	车辆版本id，如果carType 为1不用此字段
 carModelName	string	N	车辆版本，如果carType 为1不用此字段
 gearboxType	string	Y	变速箱类型
 carType	int	Y	0估车网 1系统和车主填写信息
 vin	string	Y	车架号
 plateNumberP	string	Y	车辆区域识别 如：粤
 plateNumberC	string	Y	车辆区域识别 如：A
 plateNumber	string	Y	车牌号码
 userName	string	N	用户名
 phone	string	Y	联系方式
 tripDistance	string	Y	行驶里程，公里数
 fuelMeter	int	N	燃油表
 carYear	int	Y	汽车生产年份：年
 startTime	string	Y	开始时间
 consultingVal	array	N	数据列表
 projectId	int	Y	项目id
 projectVal	string	Y	项目值
 descs	string	N	备注
 faultPhenomenon	array	N	故障现象
 id	int	Y	故障现象id
 faultPhenomenonDescs	string	N	故障现象其他补充
 
 **/

- (void)saveCreateBill:(NSString*)token billInfo:(NSDictionary*)billInfo onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (billInfo == nil || token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token}mutableCopy];
    [parameters  addEntriesFromDictionary:billInfo];
    //    [self DataTOjsonString:parameters]
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/createNew/saveCreateBill" param:parameters onComplete:onComplete onError:onError];
}

/**
 保存检测车信息
 billId	int	Y	工单id
 checkCarVal	object	Y	检测车数据，
 assign	array	Y	分配技师
 userOpenId	int	N	指派的技师id，如果为转派中心站，无此字段
 billType	int	Y	工单类型
 
 **/

- (void)saveCheckCar:(NSString*)token checkCarVal:(NSArray*)checkCarVal  assign:(NSArray*)assign billId:(NSArray*)billId onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError{
    if (assign == nil || checkCarVal == nil || token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"billId":billId,@"assign":assign,@"checkCarVal":checkCarVal,@"token":token};
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveCheckCar" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取新全车检测录入数据详情
 token 	是 	string 	token
 billId 	是 	int 	工单id
 
 **/

- (void)getNewWholeCarLoggingData:(NSString*)token billId:(NSString*)billId isHistory:(BOOL)isHistory onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"billId":billId,@"token":token};
    
    [self YHBasePOST:((isHistory)? (SERVER_PHP_Trunk"/Bill/History/getNewWholeCarLoggingData") : (SERVER_PHP_Trunk"/Bill/Undisposed/getNewWholeCarLoggingData"))  param:parameters onComplete:onComplete onError:onError];
}




/**
 保存初检信息
 billId	int	Y	工单id
 checkProjectType 	是 	array 	选择的检测数据类型projectCheckType
 initialSurveyVal	Array	初检项目数据列表	Y
	projectId	Int	项目id	Y
	projectVal	String	项目值	Y
	projectOptionName	String	项目选项名	N
	descs	String	备注	N
 
 model 初检单类型
 isReplace 是否是代录
 **/

- (void)saveInitialSurvey:(NSString*)token billId:(NSString*)billId  checkProjectType:(NSArray*)checkProjectType initialSurveyVal:(NSArray*)initialSurveyVal orderModel:(YHOrderModel)model
                isReplace:(BOOL)isReplace onComplete:(void (^)(NSDictionary *info))onComplete
                  onError:(void (^)(NSError *error))onError{
    if (billId == nil || token == nil || initialSurveyVal == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"billId":billId,@"token":token,@"initialSurveyVal":initialSurveyVal} mutableCopy];
    if (checkProjectType && checkProjectType.count != 0) {
        [parameters setObject:checkProjectType forKey:@"checkProjectType"];
    }
    
    NSString *url;
    if (isReplace
        && (model == YHOrderModelJ
            || model == YHOrderModelE
            || model == YHOrderModelV
            || model == YHOrderExtrend
            || model == YHOrderModelK
            || model == YHOrderModelJ002)) {
            url = SERVER_PHP_Trunk"/Bill/Undisposed/saveReplaceDetectiveInitialSurvey";
            [parameters setObject:@"initialSurvey" forKey:@"reqType"];
        }else{
            url = @[SERVER_PHP_Trunk"/Bill/Undisposed/saveInitialSurvey",
                     SERVER_PHP_Trunk"/Bill/Undisposed/saveMatchInitialSurvey",
                     SERVER_PHP_Trunk"/Bill/Undisposed/loggingWholeCarDetection",
                     SERVER_PHP_Trunk"/Bill/Undisposed/saveUsedCarInitialSurvey",
                     SERVER_PHP_Trunk"/Bill/Undisposed/saveAssessCarInitialSurvey",
                     SERVER_PHP_Trunk"/Bill/Undisposed/saveExtWarrantyInitialSurvey",
                     SERVER_PHP_Trunk"/Bill/Undisposed/saveNewWholeCarInitialSurvey",
                     @"",
                     SERVER_PHP_Trunk"/Bill/Undisposed/saveInitialSurvey",
                     ][model];
        }
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
 请求协助
 
 billId	int	Y	工单id
 isAssist 是请求协助还是转派中心站
 
 **/

- (void)orderEdit:(NSString*)token billId:(NSString*)billId isAssist:(BOOL)Assist onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId};
    [self YHBasePOST:(Assist ? (SERVER_PHP_Trunk"/Bill/Undisposed/saveAssist") :(SERVER_PHP_Trunk"/Bill/Undisposed/saveRedeploy")) param:parameters onComplete:onComplete onError:onError];
}

/**
 获取维修厂出维修方式数据
 
 billId	int	Y	工单id
 
 **/

- (void)getStoreMakeModeData:(NSString*)token billId:(NSString*)billId onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId};
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/getStoreMakeModeData" param:parameters onComplete:onComplete onError:onError];
}

/**
 添加细检项目
 
 token 	是 	string 	token
 projectName 	是 	string 	细检项目名称
 unit 	否 	string 	单位
 sysClassId 	是 	int 	归属系统ID
 
 
 **/

- (void)addShopCheckReportDepthItem:(NSString*)token projectName:(NSString*)projectName unit:(NSString*)unit  sysClassId:(NSString*)sysClassId onComplete:(void (^)(NSDictionary *info))onComplete
                            onError:(void (^)(NSError *error))onError{
    if (token == nil || projectName == nil|| sysClassId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token,@"projectName":projectName,@"sysClassId":sysClassId} mutableCopy];
    if (unit) {
        [parameters setValue:unit forKey:@"unit"];
    }
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/addShopCheckReportDepthItem" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取细检诊断项目
 
 search	string	post	no	搜索字符串
 
 **/

- (void)getDepthItemToCloudForSysId:(NSString*)token
                        projectName:(NSString*)search
                         onComplete:(void (^)(NSDictionary *info))onComplete
                            onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token} mutableCopy];
    if (search) {
        [parameters setObject:search forKey:@"search"];
    }
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/getDepthItemToCloudForSysId" param:parameters onComplete:onComplete onError:onError];
}

/**
 云平台保存细检方案 || 云平台保存细检方案报价
 
 billId	int	post	yes	工单ID
 requestData	 array	Y	细检方案
 id	int	N	细检项目id，自添加无此项目
 projectName	string	Y	细检项目名
 sysClassId	int	Y	系统id
 price	float	Y	细检报价
 
 
 
 isPrice 是否是 云平台保存细检方案报价 || 云平台保存细检方案
 
 **/

- (void)saveWriteDepthToCloud:(NSString*)token
                       billId:(NSString*)billId
                  requestData:(NSArray*)requestData
                      isPrice:(BOOL)isPrice
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil || requestData == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId,@"requestData":requestData};
    [self YHBasePOST:(isPrice ? (SERVER_PHP_Trunk"/Bill/Undisposed/saveCloudDepthQuote") :(SERVER_PHP_Trunk"/Bill/Undisposed/saveCloudMakeDepth")) param:parameters onComplete:onComplete onError:onError];
}

/**
 保存细检方案项目值
 维修厂发起协助 - 中心站出细检方案 - 维修厂采用中心站出的细检方案后 - 填入项目值
 
 billId	Int	工单ID
 requestData	Array	项目数组
	projectId	Int	项目ID
	type	String	类型 system系统 user用户
	projectVal	String	项目值
 
 **/

- (void)saveWriteDepthToCloud:(NSString*)token billId:(NSString*)billId  requestData:(NSArray*)requestData onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError{
    if (billId == nil || token == nil || requestData == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"billId":billId,@"token":token,@"requestData":requestData};
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveWriteDepthToCloud" param:parameters onComplete:onComplete onError:onError];
}

/**
 本地保存细检方案报价
 
 billId	int	Y	工单id
 storeDepth	array	Y	细检项目
 id	int	Y	系统id
 type	string	N	系统类型 user system，本地细检数据必传
 storeQuote	float	Y	维修厂报价
 
 
 **/

- (void)saveStoreDepthQuote:(NSString*)token
                     billId:(NSString*)billId
                 depthQuote:(NSArray*)depthQuote
                 onComplete:(void (^)(NSDictionary *info))onComplete
                    onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil || depthQuote == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId,@"storeDepth":depthQuote};
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveStoreDepthQuote" param:parameters onComplete:onComplete onError:onError];
}

/**
 维修厂推送方案
 
 billId	int	Y	工单id
 phone 手机号
 YHOrderPush 推送类型
 
 **/

- (void)saveStorePushDepth:(NSString*)token
                    billId:(NSString*)billId
               phoneNumber:(NSString*)phone
                orderModel:(YHOrderPush)model
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId}mutableCopy];
    
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    NSString *url =  @[
                       SERVER_PHP_Trunk"/Bill/Undisposed/saveStorePushDepth",
                        SERVER_PHP_Trunk"/Bill/Undisposed/saveStorePushMode",
                        SERVER_PHP_Trunk"/Bill/Undisposed/saveCloudPushModeScheme",
                        SERVER_PHP_Trunk"/Bill/Undisposed/saveCloudPushDepth",
                        SERVER_PHP_Trunk"/Bill/Undisposed/storePushCheckReport",
                        SERVER_PHP_Trunk"/Bill/Undisposed/storePushAssessCarReport",//3.19	推送估车检测报告
                        SERVER_PHP_Trunk"/Bill/Undisposed/storePushUsedCarCheckReport",//3.14	推送二手车检测报告
                        ][model];
    
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
 保存维修厂制定的细检方案
 
 billId	int	Y	工单id
 depthType	string	Y	store:维修厂本地数据;cloud:云端细检数据;
 storeDepth	array	N	细检项目，如果为云端数据，无此字段
 id	int	Y	本地细检，为projectId
 type	string	Y	细检系统类型 user,system
 desc	string	N	备注
 
 
 **/

- (void)saveStoreMakeDepth:(NSString*)token
                    billId:(NSString*)billId
                 depthType:(NSString*)depthType
                storeDepth:(NSArray*)storeDepth
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil || depthType == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"depthType":depthType}mutableCopy];
    if (storeDepth) {
        [parameters setObject:storeDepth forKey:@"storeDepth"];
    }
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveStoreMakeDepth" param:parameters onComplete:onComplete onError:onError];
}


/**
 保存维修方式
 
 billId 	是 	int 	工单id
 token 	是 	string 	token
 checkResult 	否 	object 	诊断结果
 —makeResult 	是 	string 	诊断结果内容
 —makeIdea 	是 	string 	诊断思路内容
 repairModeData 	是 	array 	维修方式
 -repairItem 	是 	array 	检测与维修项目
 —repairProjectId 	是 	string 	检测与维修项目id
 —repairProjectName 	是 	string 	检测与维修项目名称
 -parts 	否 	array 	配件与耗材
 —partsNameId 	是 	string 	配件与耗材id
 —partsName 	是 	string 	配件与耗材名称
 —modelNumber 	是 	string 	型号
 —partsUnit 	是 	string 	单位
 —partsDesc 	是 	string 	配件与耗材备注
 —scalar 	是 	string 	数量
 —type 	是 	string 	类型 1配件 2耗材
 -scheme 	否 	object 	解决方案
 —schemeContent 	是 	string 	解决方案内容
 isStoreModel 是否是本地维修方案
 
 **/

- (void)saveMakeMode:(NSString*)token
              billId:(NSString*)billId
         checkResult:(NSDictionary*)checkResult
         requestData:(NSArray*)requestData
        isStoreModel:(BOOL)isStoreModel
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil || requestData == nil || checkResult == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId,@"repairModeData":requestData,@"checkResult":checkResult};
    [self YHBasePOST:(isStoreModel ? (SERVER_PHP_Trunk"/Bill/Undisposed/saveStoreMakeMode") :(SERVER_PHP_Trunk"/Bill/Undisposed/saveMakeModeScheme")) param:parameters onComplete:onComplete onError:onError];
}


/**
 本地编辑-修改报价
 
 billId 	是 	int 	工单id
 token 	是 	string 	token
 repairModeData 	是 	array 	维修方式
 -preId 	是 	string 	方案id
 -repairItem 	是 	array 	检测与维修项目
 —repairProjectId 	是 	string 	检测与维修项目id
 —repairProjectName 	是 	string 	检测与维修项目名称
 —quote 	是 	string 	检测与维修项目报价
 -parts 	否 	array 	配件与耗材
 —partsId 	是 	string 	配件与耗材属性id
 —scalar 	是 	int 	配件与耗材数量
 —shopPrice 	是 	string 	配件与耗材售价
 -warrantyTime 	否 	array 	质保
 —warrantyDay 	是 	string 	质保（质保五万公里/1年）
 —warrantyDayDesc 	否 	string 	质保备注（忽略）
 -giveBack	否	object	交车数据
 —giveBackTime	否	string	交车时间
 
 isTiger 是否是小虎检车
 **/

- (void)updateRepairMode:(NSString*)token
                  billId:(NSString*)billId
             requestData:(NSArray*)requestData
                 isTiger:(BOOL)isTiger
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil || requestData == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId,@"repairModeData":requestData};
    [self YHBasePOST:((isTiger)? (SERVER_PHP_Trunk"/Bill/Undisposed/saveChannelUpdateMode") : (SERVER_PHP_Trunk"/Bill/Undisposed/updateRepairMode")) param:parameters onComplete:onComplete onError:onError];
}



/**
 
 配件搜索 - 编辑维修方式页
 
 token 	是 	string 	登录标识
 step 	是 	string 	步骤码，固定值：maintenance_mode
 billId 	是 	int 	工单ID
 type 	是 	int 	类型 0：全部 1：配件 2：耗材 （APP才有0）
 searchField 	是 	string 	搜索字段
 partsName：配件名称
 modelNumber：型号
 partsUnit：单位
 partsName 	否 	string 	配件名称
 modelNumber 	否 	string 	型号
 partsUnit 	否 	string 	单位
 **/

- (void)searchPartInfo:(NSString*)token
                  keys:(NSDictionary*)keys
                  billId:(NSString*)billId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil || keys == nil|| billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token, @"searchField" : @"partsName", @"type" : @"0", @"step" : @"maintenance_mode", @"billId":billId}mutableCopy];
    [parameters addEntriesFromDictionary:keys];
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Parts/searchParts" param:parameters onComplete:onComplete onError:onError];
}


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
               onError:(void (^)(NSError *error))onError{
    if (token == nil || keys == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = keys.mutableCopy;
    [parameters addEntriesFromDictionary:@{@"token":token}];

    [self YHBasePOST:SERVER_PHP_Trunk"/Common/Bill/searchParts" param:parameters onComplete:onComplete onError:onError];
}


/**
 维修项目搜索
 
 page	Int	页数	N
 keyword	String	搜索内容	N
 billId 	是 	int 	工单id
 **/

- (void)searchPartClass:(NSString*)token
                   page:(NSString*)page
                   billId:(NSString*)billId
         partsClassName:(NSString*)partsClassName
             onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError{
    if (token == nil || page == nil || partsClassName == nil|| billId == nil ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"page":page,@"billId":billId,@"keyword":partsClassName};
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/searchPartClass" param:parameters onComplete:onComplete onError:onError];
}

/**
 修理厂关闭工单
 
 token	String	用户标识	Y
 billId	Int	工单id	Y
 closeTheReason 	是 	string 	关闭原因
 **/

- (void)endBill:(NSString*)token
         billId:(NSString*)billId
 closeTheReason:(NSString*)closeTheReason
     onComplete:(void (^)(NSDictionary *info))onComplete
        onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil|| closeTheReason == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId,@"closeTheReason":closeTheReason};
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/endBill" param:parameters onComplete:onComplete onError:onError];
}

/**
 修理厂确认细检
 
 token	String	用户标识	Y
 billId	Int	工单id	Y
 
 **/

- (void)saveCarAffirmDepth:(NSString*)token
                    billId:(NSString*)billId
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId};
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveCarAffirmDepth" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取细检项目选择项
 pId 参数
 **/

- (void)getProjectList:(NSString*)url
                   pId:(NSString*)pId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    [self YHBasePOST:url param:((pId)? (@{@"pId" : pId}) : (nil)) onComplete:onComplete onError:onError];
}

/**
 检测图片提交
 
 token	String	用户标识	Y
 billId	String	工单id	Y
 picPathData	Array	图片文件名数组	N
 
 model 初检单类型
 
 isReplace 是否是代录
 **/

- (void)uploadWholeCarDetectivePicture:(NSString*)token
                                billId:(NSString*)billId
                           picPathData:(NSArray*)picPathData
                            orderModel:(YHOrderModel)model
                             isReplace:(BOOL)isReplace
                            onComplete:(void (^)(NSDictionary *info))onComplete
                               onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"reqAct":@"submit"}mutableCopy];
    NSString *url;
    if (isReplace) {
        url = SERVER_PHP_Trunk"/Bill/Undisposed/saveReplaceDetectiveInitialSurvey";
        if (model == YHOrderModelJ
            || model == YHOrderModelE
            || model == YHOrderModelV
            || model == YHOrderModelK) {
            [parameters setObject:@"uploadPic" forKey:@"reqType"];
        }
    }else{
        url = @[@"",
                @"",
                SERVER_PHP_Trunk"/Bill/Undisposed/uploadWholeCarDetectivePicture",
                SERVER_PHP_Trunk"/Bill/Undisposed/saveUsedCarCheckUploadPicture",
                SERVER_PHP_Trunk"/Bill/Undisposed/saveAssessCarUploadPicture",
                @"",
                SERVER_PHP_Trunk"/Bill/Undisposed/saveNewWholeCarUploadPicture",
                @""
                ][model];
    }
    if (picPathData) {
        [parameters setObject:picPathData forKey:@"picPathData"];
    }
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
 修理厂确认选择维修方案
 
 token	String	用户标识	Y
 billId	Int	工单id	Y
 giveBackTime	否	string	交车时间
 repairModelId	String	维修方案标识id	Y
 repairModeText	String	备注	N
 
 **/

- (void)saveAffirmModel:(NSString*)token
                 billId:(NSString*)billId
          repairModelId:(NSString*)repairModelId
         repairModeText:(NSString*)repairModeText
             onComplete:(void (^)(NSDictionary *info))onComplete
                onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil || repairModelId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"repairModelId":repairModelId}mutableCopy];
    if (repairModeText) {
        [parameters setObject:repairModeText forKey:@"repairModeText"];
    }
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveAffirmModel" param:parameters onComplete:onComplete onError:onError];
}

/**
 保存提交渠道维修方案
 
 token 	是 	string 	token
 billId 	是 	int 	工单id
 repairModeText 	否 	string 	维修方式备注
 
 **/

- (void)saveChannelSubmitMode:(NSString*)token
                       billId:(NSString*)billId
               repairModeText:(NSString*)repairModeText
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId}mutableCopy];
    if (repairModeText) {
        [parameters setObject:repairModeText forKey:@"repairModeText"];
    }
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveChannelSubmitMode" param:parameters onComplete:onComplete onError:onError];
}


/**
 申请领料
 
 token	String	用户标识	Y
 billId	Int	工单id	Y
 
 **/

- (void)savePartsApply:(NSString*)token
                billId:(NSString*)billId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId}mutableCopy];
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/savePartsApply" param:parameters onComplete:onComplete onError:onError];
}

/**
 保存领料确认完工
 
 token	String	用户标识	Y
 billId	Int	工单id	Y
 overdueReason 	否 	string 	逾期原因（逾期了才必须填）
 **/

- (void)saveAffirmComplete:(NSString*)token
                    billId:(NSString*)billId
                    overdueReason:(NSString*)overdueReason
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId}mutableCopy];
    if (overdueReason) {
        [parameters setObject:overdueReason forKey:@"overdueReason"];
    }
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveAffirmComplete" param:parameters onComplete:onComplete onError:onError];
}

/**
 结算
 
 token 	是 	string 	token
 billId 	是 	string 	工单id
 payMode 	是 	string 	支付方式(检测单不必传，父工单结算必传)
 receiveAmount 	是 	float 	实收金额（检测单是应收金额）
 remark 	否 	string 	备注
 repairModeText 	否 	string 	维修方案备注(PC端：父工单用，检测单不必传;技师端：不必传)
 warrantyDay 	否 	string 	质保(PC端：父工单用，检测单不必传;技师端：不必传)
 
 **/

- (void)saveEndBill:(NSString*)token
             billId:(NSString*)billId
            payMode:(NSString*)payMode
      receiveAmount:(NSString*)receiveAmount
             remark:(NSString*)remark
         onComplete:(void (^)(NSDictionary *info))onComplete
            onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil || receiveAmount == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"receiveAmount":receiveAmount}mutableCopy];
    
    if (remark) {
        [parameters setObject:remark forKey:@"remark"];
    }
    if (payMode) {
        [parameters setObject:payMode forKey:@"payMode"];
    }
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveEndBill" param:parameters onComplete:onComplete onError:onError];
}



/**
 获取视频播放凭证
 
 token 	是 	string 	用户标识
 videoId 	是 	string 	视频ID
 
 **/

- (void)getMediaPlayAuth:(NSString*)token
                 videoId:(NSString*)videoId
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil || videoId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"videoId":videoId}mutableCopy];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/getMediaPlayAuth" param:parameters onComplete:onComplete onError:onError];
}



/**
 获取设备图片列表
 
 token 	是 	string 	用户标识
 projectId 	是 	int 	项目ID
 billId 	是 	int 	工单ID
 
 **/

- (void)getVideoList:(NSString*)token
           projectId:(NSString*)projectId
              billId:(NSString*)billId
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError{
    if (token == nil || projectId == nil|| billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"projectId":projectId,@"billId":billId}mutableCopy];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/getVideoList" param:parameters onComplete:onComplete onError:onError];
}

- (void)getVideoList:(NSString*)token
           projectId:(NSString*)projectId
              carBrand:(NSString*)car_brand
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError{
    if (token == nil || projectId == nil|| car_brand == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"project_id":projectId,@"car_brand":car_brand}mutableCopy];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Helper/HelperVideo/index" param:parameters onComplete:onComplete onError:onError];
}


/**
 添加维修项目
 
 token 	是 	string 	token
 repairProjectName 	是 	string 	个项名称
 
 **/

- (void)addRepairProject:(NSString*)token
       repairProjectName:(NSString*)repairProjectName
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil || repairProjectName == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"repairProjectName":repairProjectName}mutableCopy];
    [self YHBasePOST:SERVER_PHP_Trunk"/Common/Bill/addRepairProject" param:parameters onComplete:onComplete onError:onError];
}


/**
 配件添加其他
 
 token 	是 	string 	token
 billId 	是 	string 	工单ID
 partsName 	是 	string 	配件名
 type 	是 	string 	类型（配件 1 耗材 2）
 partsTypeId 	是 	string 	类别ID 1-品牌件 2-原厂件 3-副厂件 4-二手件
 
 **/

- (void)addParts:(NSString*)token
          billId:(NSString*)billId
       partsName:(NSString*)partsName
            type:(NSString*)type
     partsTypeId:(NSString*)partsTypeId
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError{
    if (token == nil || partsName == nil || billId == nil || type == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"partsName":partsName,@"type":type,@"partsTypeId":partsTypeId}mutableCopy];
    //    if (partsTypeId != nil && [partsTypeId isEqualToString:@""]) {
    //        [parameters setObject:partsTypeId forKey:@"partsTypeId"];
    //    }
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Common/Bill/addParts" param:parameters onComplete:onComplete onError:onError];
}
#pragma mark - van_mr addParts---
- (void)addParts:(NSString*)token
          billId:(NSString*)billId
       partsName:(NSString*)partsName
            type:(NSString*)type
     partsUnit:(NSString*)partsUnit
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError{
    if (token == nil || partsName == nil || billId == nil || type == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"partsName":partsName,@"type":type,@"partsUnit":partsUnit}mutableCopy];
    //    if (partsTypeId != nil && [partsTypeId isEqualToString:@""]) {
    //        [parameters setObject:partsTypeId forKey:@"partsTypeId"];
    //    }
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Common/Bill/addParts" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取电路图标题列表
 
 token 	是 	string 	token
 billId 	是 	string 	工单ID
 
 **/

- (void)getCircuitryList:(NSString*)token
                  billId:(NSString*)billId
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId}mutableCopy];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/bill/undisposed/getCircuitryList" param:parameters onComplete:onComplete onError:onError];
}
/**
 根据标题ID获取电路图图片地址
 
 token 	是 	string 	token
 Id 	是 	int 	标题ID
 
 **/

- (void)getCircuitryPic:(NSString*)token
                     id:(NSString*)id
onComplete:(void (^)(NSDictionary *info))onComplete
onError:(void (^)(NSError *error))onError{
    if (token == nil || id == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"id":id}mutableCopy];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/bill/undisposed/getCircuitryPic" param:parameters onComplete:onComplete onError:onError];
}

/**
 转派工单
 
 billId 	是 	int 	工单id
 token 	是 	string 	token
 userOpenId 	是 	string 	技师ID
 
 **/

- (void)turnToSendBill:(NSString*)token
                billId:(NSString*)billId
            userOpenId:(NSString*)userOpenId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil || userOpenId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"userOpenId":userOpenId}mutableCopy];
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/turnToSendBill" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取系统列表
 
 **/

- (void)getSysClassListOnComplete:(void (^)(NSDictionary *info))onComplete
                          onError:(void (^)(NSError *error))onError{
    [self YHBasePOST:SERVER_PHP_Trunk"/Servant/Guest/getSysClassList" param:nil onComplete:onComplete onError:onError];
}

/**
 生成购买检测报告订单
 
 token	String	用户标识	Y
 billId	Int	工单id	Y
 
 **/

- (void)addCheckReportOrder:(NSString*)token
                     billId:(NSString*)billId
                 onComplete:(void (^)(NSDictionary *info))onComplete
                    onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId};
    [self YHBasePOST:SERVER_PHP_Trunk"/Orders/NowOrder/addCheckReportOrder" param:parameters onComplete:onComplete onError:onError];
}

/**
 支付订单
 
 token 	是 	string 	会话标识Token
 orderId 	是 	string 	订单ID
 
 **/

- (void)orderPay:(NSString*)token
         orderId:(NSString*)orderId
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError{
    if (token == nil || orderId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"orderId":orderId,@"type":@"app"};
    [self YHBasePOST:SERVER_PHP_Trunk"/Orders/NowOrder/orderPay" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取未完成订单详情  (查询支付状态)
 
 token 	是 	string 	会话标识Token
 orderId 	是 	string 	订单ID
 
 **/

- (void)getOrderDetail:(NSString*)token
               orderId:(NSString*)orderId
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil || orderId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"orderId":orderId};
    [self YHBasePOST:SERVER_PHP_Trunk"/Orders/NowOrder/getOrderDetail" param:parameters onComplete:onComplete onError:onError];
}


/**
 
 保存质检
 
 token 	是 	string 	会话标识Token
 billId 	是 	int 	工单id
 reqAct 	是 	string 	固定值：pass通过和noPass不通过
 overdueReason	否	string	逾期原因（只有逾期了才必须填）
 remarks 	否 	string 	质检备注
 
 **/

- (void)saveQualityInspection:(NSString*)token
                      orderId:(NSString*)orderId
                       reqAct:(NSString*)reqAct
                overdueReason:(NSString*)overdueReason
                      remarks:(NSString*)remarks
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError{
    if (token == nil || orderId == nil|| reqAct == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":orderId,@"reqAct":reqAct} mutableCopy];
    if (remarks != nil && ![remarks isEqualToString:@""]) {
        [parameters setObject:remarks forKey:@"remarks"];
    }
    if (overdueReason != nil && ![overdueReason isEqualToString:@""]) {
        [parameters setObject:overdueReason forKey:@"overdueReason"];
    }
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveQualityInspection" param:parameters onComplete:onComplete onError:onError];
}
/**
 
 app调用微信下单接口，返回待支付ID
 userId	账户ID
 vin	车架号
 type	购买类型：1 检测结果， 2,：维修方式
 
 **/

- (void)prepay:(NSString*)userId type:(YHBuyType)type byVin:(NSString*)vin onComplete:(void (^)(NSDictionary *info))onComplete
       onError:(void (^)(NSError *error))onError{
    if (userId == nil || vin == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
}


/**
 小虎检车--保存接单
 
 token 	是 	string 	token
 billId 	是 	int 	工单id
 
 **/

- (void)saveChannelReceiveBill:(NSString*)token billId:(NSString*)billId onComplete:(void (^)(NSDictionary *info))onComplete
                       onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId};
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Undisposed/saveChannelReceiveBill" param:parameters onComplete:onComplete onError:onError];
}



/**
 获取未完成订单详情
 
 token 	是 	string 	token
 orderId 	是 	string 	订单ID
 isHistory 是否是历史工单
 
 **/

- (void)getOrderDetail:(NSString*)token orderId:(NSString*)orderId isHistory:(BOOL)isHistory onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil || orderId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"orderId":orderId};
    [self YHBasePOST: ((isHistory)? (SERVER_PHP_Trunk"/Orders/HistoricalOrder/getOrderDetail") : (SERVER_PHP_Trunk"/Orders/NowOrder/getOrderDetail")) param:parameters onComplete:onComplete onError:onError];
}


/**
 忽略订单
 
 token 	是 	string 	会话标识Token
 orderId 	是 	string 	订单ID
 
 **/

- (void)loseOrder:(NSString*)token orderId:(NSString*)orderId onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    if (token == nil || orderId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"orderId":orderId};
    [self YHBasePOST: SERVER_PHP_Trunk"/Orders/NowOrder/loseOrder" param:parameters onComplete:onComplete onError:onError];
}

/**
工单初检-故障码获取检测项目列表

 token 	是 	string 	会话标识Token
 billId 	是 	string 	工单ID
 sysClassId 	是 	string 	系统ID
 faultCode 	是 	string 	故障码，多个逗号拼接

**/

- (void)getElecCtrlInspectionProjectList:(NSString*)token billId:(NSString*)billId sysClassId:(NSString*)sysClassId faultCode:(NSString*)faultCode onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil|| sysClassId == nil|| faultCode == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"token":token,@"billId":billId,@"sysClassId":sysClassId,@"faultCode":faultCode};
    [self YHBasePOST: SERVER_PHP_Trunk"/Bill/Undisposed/getElecCtrlInspectionProjectList" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取/搜索保单数据列表
 
 token 	是 	string 	token
 status 	否 	string 	状态 1已审核，0未审核 2审核不通过 3待审核 默认不传为 待审核
 searchText 	否 	string 	搜索字 仅限 客户名，手机号 部分匹配
 addTime 	否 	string 	保单生成时间 格式为 YYYY-mm-dd 部分匹配
 warrantyPackageTitle 	否 	string 	延长保修套餐名称 比如 套餐1 全匹配
 validTimeName 	否 	string 	有效期 字符串 比如 6个月、1年 全匹配
 page 	否 	string 	页码
 pagesize 	否 	string 	页面条数
 
 **/

- (void)blockPolicy:(NSString*)token status:(NSString*)status searchText:(NSString*)searchText addTime:(NSString*)addTime warrantyPackageTitle:(NSString*)warrantyPackageTitle validTimeName:(NSString*)validTimeName  page:(NSString*)page  pagesize:(NSString*)pagesize onComplete:(void (^)(NSDictionary *info))onComplete
            onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token} mutableCopy];
    if (status != nil && ![status isEqualToString:@""]) {
        [parameters setObject:status forKey:@"status"];
    }
    if (searchText != nil && ![searchText isEqualToString:@""]) {
        [parameters setObject:searchText forKey:@"searchText"];
    }
    if (addTime != nil && ![addTime isEqualToString:@""]) {
        [parameters setObject:addTime forKey:@"addTime"];
    }
    if (validTimeName != nil && ![validTimeName isEqualToString:@""]) {
        [parameters setObject:validTimeName forKey:@"validTimeName"];
    }
    if (warrantyPackageTitle != nil && ![warrantyPackageTitle isEqualToString:@""]) {
        [parameters setObject:warrantyPackageTitle forKey:@"warrantyPackageTitle"];
    }
    if (page != nil && ![page isEqualToString:@""]) {
        [parameters setObject:page forKey:@"page"];
    }
    if (pagesize != nil && ![pagesize isEqualToString:@""]) {
        [parameters setObject:pagesize forKey:@"pagesize"];
    }
    [self YHBasePOST: SERVER_PHP_Trunk"/ExtendWarranty/BlockPolicy" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取保单数据详情
 
 token 	是 	string 	token
 blockPolicyId 	是 	string 	保单id
 
 **/
- (void)getBlockPolicyDetail:(NSString*)token blockPolicyId:(NSString*)blockPolicyId onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError{
    if (token == nil || blockPolicyId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token, @"blockPolicyId" : blockPolicyId} mutableCopy];
    [self YHBasePOST: SERVER_PHP_Trunk"/ExtendWarranty/BlockPolicy/getBlockPolicyDetail" param:parameters onComplete:onComplete onError:onError];
}

/**
 提交保单管理审核
 
 token 	是 	string 	token
 blockPolicyId 	是 	string 	保单id
 idImg 	是 	array 	身份证 2张 限制
 warrantyPactImg 	是 	array 	保险合同 <= 4张
 drivingImg 	是 	array 	行驶证 2张 限制
 carImg 	是 	array 	车辆图片 <= 20张 限制
 
 //others 其他参数
 cardNumber 	否 	string 	证件号码
 agreementNumer 	否 	string 	保单号
 invoiceTitle 	否 	string 	发票抬头
 carKm 	否 	int 	公里数(km)
 taxCode 	否 	string 	纳税人识别号
 emailAddress 	否 	string 	电子邮箱
 validTime 	否 	string 	有效期限 只可以提交 3,6,12 单位：月
 **/

- (void)supplementBlockPolicy:(NSString*)token
                blockPolicyId:(NSString*)blockPolicyId
                        idImg:(NSArray*)idImg
              warrantyPactImg:(NSArray*)warrantyPactImg
                   drivingImg:(NSArray*)drivingImg
                       carImg:(NSArray*)carImg
                        others:(NSDictionary*)others
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError{
    if (token == nil || blockPolicyId == nil || idImg == nil|| warrantyPactImg == nil|| drivingImg == nil|| carImg == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"blockPolicyId":blockPolicyId,@"idImg":idImg,@"warrantyPactImg":warrantyPactImg,@"drivingImg":drivingImg,@"carImg":carImg}mutableCopy];
    [parameters addEntriesFromDictionary:others];
    NSString *url = SERVER_PHP_Trunk"/ExtendWarranty/BlockPolicy/supplementBlockPolicy";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}


/**
 延长保修服务管理-恢复已关闭保单
 
 token 	是 	string 	token
 blockPolicyId 	是 	string 	保单id
 **/

- (void)recoveryBlockPolicy:(NSString*)token
                blockPolicyId:(NSString*)blockPolicyId
                 onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError{
    if (token == nil || blockPolicyId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"blockPolicyId":blockPolicyId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/ExtendWarranty/BlockPolicy/recoveryBlockPolicy";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
 延长保修服务管理-恢复已关闭保单
 
 token 	是 	string 	token
 blockPolicyId 	是 	string 	保单id
 billId 	是 	string 	工单id
 **/

- (void)closeBlockPolicy:(NSString*)token
           blockPolicyId:(NSString*)blockPolicyId
           billId:(NSString*)billId
                 onComplete:(void (^)(NSDictionary *info))onComplete
                    onError:(void (^)(NSError *error))onError{
    if (token == nil || blockPolicyId == nil || billId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"blockPolicyId":blockPolicyId, @"billId":billId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/ExtendWarranty/BlockPolicy/closeBlockPolicy";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}


/**
 搜索延长保修套餐数据
 
 token 	是 	string 	token
 blockPolicyId 	是 	string 	保单id
 **/

- (void)getBlockPolicyNoPasslog:(NSString*)token
           blockPolicyId:(NSString*)blockPolicyId
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil || blockPolicyId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"blockPolicyId":blockPolicyId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/ExtendWarranty/BlockPolicy/getBlockPolicyNoPasslog";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
 质量延长工单初检-故障码获取检测项目
 
 token 	是 	string 	会话标识Token
 billId 	是 	string 	工单ID
 sysClassId 	是 	string 	系统ID
 faultCode 	是 	string 	故障码，多个逗号拼接
 **/

- (void)getElecCtrlProjectListByY:(NSString*)token
                  billId:(NSString*)billId
                  sysClassId:(NSString*)sysClassId
                  faultCode:(NSString*)faultCode
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError{
    if (token == nil || billId == nil || sysClassId == nil || faultCode == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"sysClassId":sysClassId,@"faultCode":faultCode}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/Bill/Undisposed/getElecCtrlProjectListByY";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
获取详情列表
 
 token 	是 	string 	标识
 page 	否 	int 	页码
 pagesize 	否 	int 	每页数（默认10）
 startDate 	是 	string 	时间1
 endDate 	是 	string 	时间2（两个时间段间隔不能大于三个月）
 type 	是 	int 	类型1:未返现2:部分返现3:全返现
 keyword 	否 	string 	关键字
 warrantyName 	否 	string 	套餐名
 selectShopOpenId 	否 	string 	选择的站点open
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
                          onError:(void (^)(NSError *error))onError{
    if (token == nil || startDate == nil || type == nil || endDate == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"endDate":endDate,@"type":type,@"startDate":startDate}mutableCopy];
    if (page != nil && ![page isEqualToString:@""]) {
        [parameters setObject:page forKey:@"page"];
    }
    if (pagesize != nil && ![pagesize isEqualToString:@""]) {
        [parameters setObject:pagesize forKey:@"pagesize"];
    }
    if (keyword != nil && ![keyword isEqualToString:@""]) {
        [parameters setObject:keyword forKey:@"keyword"];
    }
    if (warrantyName != nil && ![warrantyName isEqualToString:@""]) {
        [parameters setObject:warrantyName forKey:@"warrantyName"];
    }
    if (selectShopOpenId != nil && ![selectShopOpenId isEqualToString:@""]) {
        [parameters setObject:selectShopOpenId forKey:@"selectShopOpenId"];
    }    NSString *url = SERVER_PHP_Trunk"/ExtendWarranty/CashBack/getDetail";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}


/**
 获取套餐名列表
 
 token 	是 	string 	标识
 **/

- (void)getWarrantyNames:(NSString*)token
               onComplete:(void (^)(NSDictionary *info))onComplete
                  onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/ExtendWarranty/CashBack/getWarrantyNames";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

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
                 onError:(void (^)(NSError *error))onError{
    if (token == nil
        || serviceType == nil
        || appointmentDate == nil
        || plateNumberP == nil
        || plateNumberC == nil
        || plateNumber == nil
        || name == nil
        || phone == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,
                                         @"serviceType":serviceType,
                                         @"appointmentDate":appointmentDate,
                                         @"plateNumberP":plateNumberP,
                                         @"plateNumberC":plateNumberC, @"plateNumber":plateNumber,
                                         @"name":name,
                                         @"phone":phone}mutableCopy];
    if (customerId != nil && ![customerId isEqualToString:@""]) {
        [parameters setObject:customerId forKey:@"customerId"];
    }
    if (vin != nil && ![vin isEqualToString:@""]) {
        [parameters setObject:vin forKey:@"vin"];
    }
    NSString *url = SERVER_PHP_Trunk"/Workboard/Workboard/addWorkboard";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
获取工作板列表
 
 token     是     string     标识
 **/

- (void)getWorkboardList:(NSString*)token
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"version" : @(2)}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/Workboard/Workboard/index";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
获取未完成工单单数
 
 token     是     string     标识
 **/

- (void)getUnfinishedBillNum:(NSString*)token
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/Bill/CheckBill/getUnfinishedBillNum";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
获取JNS下级菜单列表
 
 token     是     string     标识
 **/

- (void)getJnsChildMenuList:(NSString*)token
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/Servant/CommonServant/getJnsChildMenuList";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
 删除工作板
 
 token     是     string     标识
 id     是     int     工作板ID
 **/

- (void)deleteWorkboard:(NSString*)token
                  id:(NSString*)workboardId
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil || workboardId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,@"id":workboardId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/Workboard/Workboard/deleteWorkboard";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
根据工作板ID获取工单基本信息
 
 token     是     string     标识
 workBoardId     是     int     工作板ID
 **/

- (void)getBaseInfoByWorkBoardId:(NSString*)token
                      workBoardId:(NSString*)workBoardId
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil || workBoardId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"workBoardId":workBoardId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/Bill/CreateNew/getBaseInfoByWorkBoardId";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
工作板进来的用户详情接口
 
 token     是     string     标识
 workBoardId     是     int     工作板ID
 **/

- (void)workboardCustomerDetail:(NSString*)token
                    workBoardId:(NSString*)workBoardId
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil || workBoardId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"workBoardId":workBoardId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/CustomerMng/Customer/workboardCustomerDetail";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
 *   http://api.mhace.com/index.php?s=/1&page_id=707
 */
- (void)workboardCustomerDetail:(NSString*)token
                            vin:(NSString*)vin
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError
{
    if (token == nil || vin == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"vin":vin}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"CustomerMng/CustomerCarMaintain/getCustomerInfoByVin";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

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
                        onError:(void (^)(NSError *error))onError{
    if (token == nil || vin == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"vin":vin}mutableCopy];
    if (customerId != nil && ![customerId isEqualToString:@""]) {
        [parameters setObject:customerId forKey:@"customerId"];
    }
    NSString *url = SERVER_PHP_Trunk"/CustomerMng/CustomerCarMaintain/recentlyBill";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

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
                        onError:(void (^)(NSError *error))onError{
    if (token == nil || customerId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"customerId":customerId}mutableCopy];
    if (page != nil && ![page isEqualToString:@""]) {
        [parameters setObject:page forKey:@"page"];
    }
    if (pagesize != nil && ![pagesize isEqualToString:@""]) {
        [parameters setObject:pagesize forKey:@"pagesize"];
    }
    NSString *url = SERVER_PHP_Trunk"/CustomerMng/CustomerCarMaintain/followUpList";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

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
             onError:(void (^)(NSError *error))onError{
    if (token == nil || customerId == nil || result == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"customerId":customerId, @"result":result}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/CustomerMng/Customer/addCustomerFollowUp";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
 回访列表删除
 
 token     是     string     登录标识
 followUpId     是     string     回访ID
 **/

- (void)delFollowUp:(NSString*)token
                 followUpId:(NSString*)followUpId
                 onComplete:(void (^)(NSDictionary *info))onComplete
                    onError:(void (^)(NSError *error))onError{
    if (token == nil || followUpId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"followUpId":followUpId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/CustomerMng/CustomerCarMaintain/delFollowUp";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

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
                    onError:(void (^)(NSError *error))onError{
    if (token == nil || name == nil || carLineName == nil || tipsItems == nil || customerId == nil || partnerCustomerId == nil || repairBillId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"name":name, @"carLineName":carLineName, @"tipsItems":tipsItems, @"customerId":customerId, @"partnerCustomerId":partnerCustomerId, @"repairBillId":repairBillId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/CustomerMng/CustomerCarMaintain/sendWechatTips";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}


/**
 客户养车提醒取消接口
 
 token     是     string     登录标识
 notifyId     是     int     养车ID
 **/

- (void)notifyDel:(NSString*)token
                  notifyId:(NSString*)notifyId
           onComplete:(void (^)(NSDictionary *info))onComplete
              onError:(void (^)(NSError *error))onError{
    if (token == nil || notifyId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"notifyId":notifyId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/CustomerMng/CustomerCarMaintain/notifyDel";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/**
恢复客户养车已取消提醒接口
 
 token     是     string     登录标识
 ids     是     string     养车ID(多个数据格式为：“11,22,33”)
 **/

- (void)recoverNotify:(NSString*)token
              ids:(NSString*)ids
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil || ids == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"ids":ids}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/CustomerMng/CustomerCarMaintain/recoverNotify";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}


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
               onError:(void (^)(NSError *error))onError{
    if (token == nil || serviceType == nil || appointmentDate == nil || plateNumberP == nil || plateNumberC == nil || plateNumber == nil || name == nil || phone == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"serviceType":serviceType, @"appointmentDate":appointmentDate, @"plateNumberP":plateNumberP, @"plateNumberC":plateNumberC, @"plateNumber":plateNumber, @"name":name, @"phone":phone}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/Workboard/Workboard/addWorkboard";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}
/*
 上传保单补充的图片
 
 token 	是 	string 	token
 blockPolicyId 	是 	string 	保单id
 idImg 	是 	file 	文件名 (‘idImg’,’drivingImg’,’warrantyPactImg’,’carImg’)
 
 */
- (void)uploadBlockPolicyFile:(NSArray*)images
                        token:(NSString*)token
                        blockPolicyId:(NSString*)blockPolicyId
                   orderModel:(YHExtendImg)model
                   onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
        }
        return;
    }
    
    if (token == nil || images == nil|| blockPolicyId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;

    }else{
        NSMutableDictionary *parameters = [@{@"token":token,@"blockPolicyId":blockPolicyId}mutableCopy];
        
        NSString *url;
        url = SERVER_PHP_Trunk"/ExtendWarranty/BlockPolicy/uploadBlockPolicyFile";
        
        [self
         POST:url
         parameters:parameters
         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             [formData appendPartWithFileData :images[0] name:@[@"idImg", @"idImg", @"drivingImg", @"drivingImg", @"warrantyPactImg", @"carImg"][model] fileName:@"picFile.png" mimeType:@"image/png"];
         }
         progress:nil
         success:^(NSURLSessionDataTask *task, NSDictionary* JSON) {
             if ((id)JSON != [NSNull null] && JSON != nil) {
                 if (onComplete) {
                     onComplete(JSON);
                 }
             }else{
                 if (onError) {
                     onError(nil);
                 }
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
#ifdef TestError
             NSDictionary *userInfo =error.userInfo;
             
             NSError *NSUnderlyingError = userInfo [@"NSUnderlyingError"];
             NSData *responseObject = error.userInfo[@"com.alamofire.serialization.response.error.data"];
             
             if (!responseObject) {
                 responseObject = NSUnderlyingError.userInfo[@"com.alamofire.serialization.response.error.data"];
             }
             NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
#endif
             if (onError) {
                 onError(error);
             }
         }];
    }
}

/*
 检测图片上传
 
 token	String	用户标识
 reqAct	String	操作类型，固定为：upload
 billId	String	工单id
 picFile	Imge	图片文件类型
 
 model 初检单类型
 
 isReplace 是否是代录
 http://192.168.1.248/btlmch/index.php
 */
- (void)updatePictureImageDate:(NSArray*)images
                         token:(NSString*)token
                        billId:(NSString*)billId
                    orderModel:(YHOrderModel)model
                     isReplace:(BOOL)isReplace
                    onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
        }
        return;
    }
    
    if (token == nil || billId == nil || images == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }else{
        NSMutableDictionary *parameters = [@{@"token":token,@"billId":billId,@"reqAct":@"upload"}mutableCopy];
        
        NSString *url;
        if (isReplace) {
            url = SERVER_PHP_Trunk"/Bill/Undisposed/saveReplaceDetectiveInitialSurvey";
            if (model == YHOrderModelJ
                || model == YHOrderModelE
                || model == YHOrderModelV
                || model == YHOrderModelK) {
                [parameters setObject:@"uploadPic" forKey:@"reqType"];
            }
        }else{
            url = @[@"",
                    @"",
                    SERVER_PHP_Trunk"/Bill/Undisposed/uploadWholeCarDetectivePicture",
                    SERVER_PHP_Trunk"/Bill/Undisposed/saveUsedCarCheckUploadPicture",
                    SERVER_PHP_Trunk"/Bill/Undisposed/saveAssessCarUploadPicture",
                    @"",
                    SERVER_PHP_Trunk"/Bill/Undisposed/saveNewWholeCarUploadPicture",
                    @""
                    ][model];
        }
        
        [self
         POST:url
         parameters:parameters
         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             [formData appendPartWithFileData :images[0] name:@"picFile" fileName:@"picFile.png" mimeType:@"image/png"];
             
             //             for(NSInteger i=0; i<images.count; i++) {
             //                 [formData appendPartWithFileData:images[i] name:[NSString stringWithFormat:@"files%ld", (long)i] fileName:[NSString stringWithFormat:@"array%ld", (long)i] mimeType:@"image/png"];
             //             }
         }
         progress:nil
         success:^(NSURLSessionDataTask *task, NSDictionary* JSON) {
             if ((id)JSON != [NSNull null] && JSON != nil) {
                 if (onComplete) {
                     onComplete(JSON);
                 }
             }else{
                 if (onError) {
                     onError(nil);
                 }
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
#ifdef TestError
             NSDictionary *userInfo =error.userInfo;
             
             NSError *NSUnderlyingError = userInfo [@"NSUnderlyingError"];
             NSData *responseObject = error.userInfo[@"com.alamofire.serialization.response.error.data"];
             
             if (!responseObject) {
                 responseObject = NSUnderlyingError.userInfo[@"com.alamofire.serialization.response.error.data"];
             }
             NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
#endif
             if (onError) {
                 onError(error);
             }
         }];
        
    }
}


//梅文峰
/*
 token      String    用户标识
 keyword    String    店铺名称或联系人
 sort       String    1-预约时间正序；0-预约时间反序（默认倒序）
 page       int       页数【默认1】
 pageSize   int       每页显示条数【默认20条】
 type    否    int    1-代售检测分类,2-二手车帮检分类(暂只用app
 */
- (void)queryCheckListWithToken:(NSString *)token
                    WithKeyword:(NSString *)keyword
                       WithSort:(NSString *)sort
                       WithPage:(int)page
                   WithPageSize:(int)pageSize
                           type:(NSInteger)type
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"keyword":keyword, @"sort":sort, @"page":@(page), @"type":@(type),@"pageSize":@(pageSize)}mutableCopy];
    
    NSLog(@"检测列表传参:%@",parameters);
    
    NSString *url = SERVER_PHP_Trunk"/UsedCarCheck/UsedCarCheck/index";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/*
 token         String    用户标识
 bucheId       int       捕车列表ID
 amount        float     结算金额
 */
- (void)balanceAmountWithToken:(NSString *)token WithBucheId:(int)bucheId WithAmount:(float)amount onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
        
    }else{
        NSMutableDictionary *parameters = [@{@"token":token, @"bucheId":@(bucheId),@"amount":@(amount)}mutableCopy];
        NSString *url = SERVER_PHP_Trunk"/UsedCarCheck/UsedCarCheck/detectioveListClearing";
        [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
    }
}

/*
 token      String   是   用户标识
 keyword    String   否   关键字 车架号、车系车型
 partnerId  int      是   检测单id
 page       int      否   页数【默认1】
 pageSize   int      否   每页显示条数【默认10条】
 */
- (void)queryWorkOrderListWithToken:(NSString *)token WithKeyword:(NSString *)keyword WithPartnerId:(int)partnerId WithPage:(int)page WithPageSize:(int)pageSize WithTag:(NSInteger)tag onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"keyword":keyword, @"partnerId":@(partnerId), @"page":@(page), @"pageSize":@(pageSize)}mutableCopy];
    
    NSLog(@"检测列表传参:%@",parameters);

    NSString *url;
    //未完成
    if (tag == 1) {
        url = SERVER_PHP_Trunk"/UsedCarCheck/UsedCarCheck/unfinished";
    //已完成
    } else {
        url = SERVER_PHP_Trunk"/UsedCarCheck/UsedCarCheck/finished";
    }
    
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

/*
 获取二手车评估信息接口
 token      String   是   登录标识
 billId     String   是   工单id
 */
- (void)getAssessInfoWithToken:(NSString *)token
                        billId:(NSString *)billId
                    onComplete:(void (^)(NSDictionary *info))onComplete
                       onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token) || IsEmptyStr(billId)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token, @"billId":billId}mutableCopy];
    NSLog(@"获取二手车评估信息:%@",parameters);
    
    [self YHBasePOST:SERVER_PHP_Trunk"/UsedCarCheck/UsedCarCheck/getAssessInfo" param:parameters onComplete:onComplete onError:onError];
}

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
                              onError:(void (^)(NSError *error))onError{
    if (IsEmptyStr(token) || IsEmptyStr(billId) || IsEmptyStr(phone) || IsEmptyStr(price)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,
                                         @"billId":billId,
                                         @"phone":phone,
                                         @"price":price}mutableCopy];
    NSLog(@"保存二手车评估报告推送:%@",parameters);
    
    [self YHBasePOST:SERVER_PHP_Trunk"/UsedCarCheck/UsedCarCheck/saveAssessReportPush" param:parameters onComplete:onComplete onError:onError];
}

/*
 获取解决方案站点列表
 token      String   是   登录标识
 name       String   否   站点搜索
 */
- (void)getSolutionOrgListWithToken:(NSString *)token
                               name:(NSString *)name
                         onComplete:(void (^)(NSDictionary *info))onComplete
                            onError:(void (^)(NSError *error))onError{
    if (IsEmptyStr(token)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,
                                         @"name":name}mutableCopy];
    NSLog(@"获取解决方案站点列表:%@",parameters);
    
    [self YHBasePOST:SERVER_PHP_Trunk"/AiMaintainSolution/Solution/getSolutionOrgList" param:parameters onComplete:onComplete onError:onError];
}
    
    
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
                              onError:(void (^)(NSError *error))onError{
    if (IsEmptyStr(token)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }

    NSMutableDictionary *parameters;
    if (tag != 2) {
        parameters = [@{@"token":token}mutableCopy];
    }else{
        parameters = [@{@"token":token,
                        @"page":page,
                        @"pagesize":pagesize}mutableCopy];
    }
    NSLog(@"-------=======%@=======--------",parameters);
    
    
    NSString *url;
    switch (tag) {
        case 1:
            url = @"/Bill/Undisposed/getSolutionList";
            break;
        case 2:
            url = @"/Bill/History/getSolutionList";
            break;
        case 3:
            url = @"/AiMaintainSolution/Solution/getUnderwayList";
            break;
        case 4:
            url = @"/AiMaintainSolution/Solution/getCompleteList";
            break;
        default:
            break;
    }
    [self YHBasePOST:[NSString stringWithFormat:@"%@%@",SERVER_PHP_Trunk,url] param:parameters onComplete:onComplete onError:onError];
}

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
                        onError:(void (^)(NSError *error))onError{
    if (IsEmptyStr(token) ||
        IsEmptyStr(solution_org_id) ||
        IsEmptyStr(vin)||
        IsEmptyStr(car_brand_id) ||
        IsEmptyStr(car_line_id) ||
        IsEmptyStr(nian_kuan)||
        IsEmptyStr(gearbox_type) ||
        IsEmptyStr(plate_number_p) ||
        IsEmptyStr(plate_number_c)||
        IsEmptyStr(plate_number) ||
        IsEmptyStr(customer_name) ||
        IsEmptyStr(customer_phone)||
        IsEmptyStr(appointment_time)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,
                                         @"solution_org_id":solution_org_id,
                                         @"vin":vin,
                                         @"car_brand_id":car_brand_id,
                                         @"car_line_id":car_line_id,
                                         @"car_model_id":car_model_id,
                                         @"car_model_full_name":car_model_full_name,
                                         @"car_cc":car_cc,
                                         @"car_cc_unit":car_cc_unit,
                                         @"nian_kuan":nian_kuan,
                                         @"produce_year":produce_year,
                                         @"gearbox_type":gearbox_type,
                                         @"plate_number_p":plate_number_p,
                                         @"plate_number_c":plate_number_c,
                                         @"plate_number":plate_number,
                                         @"customer_name":customer_name,
                                         @"customer_phone":customer_phone,
                                         @"appointment_time":appointment_time}mutableCopy];
    NSLog(@"解决方案W001-门店预约:%@",parameters);
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Solution/saveBooking" param:parameters onComplete:onComplete onError:onError];
}

/*
 解决方案W001 - 门店预约时页面信息接口
 token      String   是   登录标识
 solution_org_id     String   是   解决方案站点id
 */
- (void)getBookingInfoWithToken:(NSString *)token
                 solutionOrgiId:(NSString *)solution_org_id
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void (^)(NSError *error))onError{
    if (IsEmptyStr(token) || IsEmptyStr(solution_org_id)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"token":token,
                                         @"solution_org_id":solution_org_id}mutableCopy];
    NSLog(@"解决方案W001-门店预约时页面信息接口:%@",parameters);
    
    [self YHBasePOST:SERVER_PHP_Trunk"/Bill/Solution/getBookingInfo" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 接口(刘松)
/**
 检车新建工单
 
 token   string    token
 vin     string    vin号
 */
-(void)checkTheCarCreateNewWorkOrderWithToken:(NSString *)token Vin:(NSString *)vin onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError{
    if (token == nil ||vin == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"token":token, @"vin":vin}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/Bill/CreateNew/getCarInfoByVin";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}


/**
 汽车品牌列表
 */
-(void)queryCarBrandListonComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError{
    NSString *url =  SERVER_PHP_Trunk"/Common/Car/getBrandList";
    [self YHBasePOST:url param:nil onComplete:onComplete onError:onError];
}

/**
 汽车车系列表
 
 brandId int 品牌ID
 */
-(void)queryCarSeriesTableWithBrandId:(NSString *)brandId onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError{
    if (brandId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"brandId":brandId}mutableCopy];
    NSString *url = SERVER_PHP_Trunk"/Common/Car/getLineList";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}


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
-(void)submitBasicInformationWithDictionary:(NSDictionary *)dict isHelp:(BOOL)isHelp onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError{
    
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
        }
        return;
    }
    
    if (dict == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    ///UsedCarCheck/UsedCarCheck/saveCreateBill
    NSString *url = ((isHelp)? (SERVER_PHP_Trunk"/Bill/createNew/saveCreateBill") : (SERVER_PHP_Trunk"/UsedCarCheck/UsedCarCheck/saveCreateBill"));
    [self YHBasePOST:url param:dict.mutableCopy onComplete:onComplete onError:onError];
}

/**
 工单-暂存保存接口
 
 token                   是    string    token
 bucheBookingId          否    int       捕车id
 baseInfo                是    object    基本信息-baseInfo信息同上面提交基本信息接口
 isHelp 是否是帮检单
 */
-(void)temporaryDepositBasicInformationWithDictionary:(NSDictionary *)dict isHelp:(BOOL)isHelp onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
        }
        return;
    }
    
    if (dict == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSString *url = ((isHelp)? (SERVER_PHP_Trunk"/Bill/Undisposed/temporarySave") : (SERVER_PHP_Trunk"/UsedCarCheck/UsedCarCheck/temporarySave"));
    [self YHBasePOST:url param:dict.mutableCopy onComplete:onComplete onError:onError];
}


/**
 获取机油复位教程
 
 token                   是    string    token
 car_brand               否    string       车辆品牌
 car_line                是    string    车辆系列
 car_produceYear         是    int       车辆年款
 */
-(void)getOilReset:(NSDictionary *)dict onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError{
    
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
        }
        return;
    }
    
    if (dict == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSString *url = SERVER_PHP_Trunk"/Helper/HelperOil/getOilReset";
    [self YHBasePOST:url param:dict.mutableCopy onComplete:onComplete onError:onError];
}


/**
根据上牌时间获取评估价格
 
 token                   是    string    token
 bill_id               否    string       工单id
 car_license_time                是    string    上牌时间 格式：yyyy-mm-dd
 */
-(void)getPriceByCarLicenseTime:(NSDictionary *)dict onComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError{
    
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
        }
        return;
    }
    
    if (dict == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSString *url = SERVER_PHP_Trunk"/Bill/Undisposed/getPriceByCarLicenseTime";
    [self YHBasePOST:url param:dict.mutableCopy onComplete:onComplete onError:onError];
}


#pragma mark Init
- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:SERVER_PHP_URL]];
    if (self) {
      
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        AFJSONResponseSerializer *JSONRespone = [AFJSONResponseSerializer serializer];
        JSONRespone.removesKeysWithNullValues = YES;
        self.responseSerializer = JSONRespone;
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    return self;
}

@end
