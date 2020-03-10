//
//  YHHelpSellService.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/22.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHHelpSellService.h"
#import "ApiService.h"

#import "YHNetworkManager.h"
#import "YHTools.h"

#import "TTZCarModel.h"
#import "YHReservationModel.h"
#import "ZZCityModel.h"


#import <MJExtension/MJExtension.h>

@implementation YHHelpSellService



#pragma mark -    APP支付回调接口
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 rptPayCallBack
 accId    是    string    接入者账号
 token    是    string    token
 id    是    string    支付订单号(支付接口返回的orderId)
 time    是    string    yyyy-MM-dd HH:mm:ss
 sign    是    string    MD5签名
 **/
+(void)rptPayCallBackWithId:(NSString *)Id
              onComplete:(void (^)(NSString *))success
                 onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"rptPayCallBack",
                                 @"token" : token,
                                 @"id":Id,
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.rptTradeURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 NSInteger payStatus = [[[info valueForKey:@"result"] valueForKey:@"payStatus"] integerValue];
                                                 
                                                 if (payStatus == 1) {
                                                     !(success)? : success([[info valueForKey:@"result"] valueForKey:@"url"]);
                                                 }else{
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : @"支付失败"}]);
                                                 }
                                                 
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}


#pragma mark -支付报告费接口


//reqAct    是    string    请求方法，固定填写 toHelpRptPay
//accId    是    string    接入者账号
//token    是    string    token
//code    是    string    前端返给app的code
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名

+(void)toHelpRptPayCode:(NSString *)code
                 onComplete:(void (^)(NSDictionary *))success
                    onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"toHelpRptPay",
                                 @"token" : token,
                                 @"code" : code,
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.rptTradeURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 NSDictionary *obj = [info valueForKey:@"result"];
                                                 
                                                 if (![retCode isEqualToString:@"0"] || !obj) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 
                                                 
                                                 !(success)? : success(obj);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}



#pragma mark -根据VIN获取报告信息

//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 findVinReport
//accId    是    string    接入者账号
//token    是    string    用户会话标识
//vin    是    string    车架号
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名

+(void)findVinReportWithVin:(NSString *)vin
                 onComplete:(void (^)(NSDictionary *))success
                     onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"findVinReport",
                                 @"token" : token,
                                 @"vin" : vin,
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.findVinReportURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 NSDictionary *obj = [info valueForKey:@"result"];
                                                 if (![retCode isEqualToString:@"0"] || !obj || !(obj.allKeys.count)) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 
                                                 
                                                 !(success)? : success(obj);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}


#pragma mark -    检测车商是否是关联车商

//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 checkDealer
//accId    是    string    接入者账号
//token    是    string    用户会话标识
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)checkDealerOnComplete:(void (^)(YHReservationModel *))success
                 onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"checkDealer",
                                 @"token" : token,
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.checkDealerURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 
                                                 
                                                 !(success)? : success([YHReservationModel mj_objectWithKeyValues:[info valueForKey:@"result"]]);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}


#pragma mark -    捕车广告列表

//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 advList
//accId    是    string    接入者账号
//token    是    string    用户会话标识
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)advListOnComplete:(void (^)(NSDictionary *))success
                   onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"advList",
                                 @"token" : token,
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.advListURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                
                                                 
                                                 !(success)? : success(info);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}


#pragma mark -    支付报告费接口
//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 toRptPay
//accId    是    string    接入者账号
//token    是    string    token
//code    是    string    前端返给app的code
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)payRptTradeWithCode:(NSString *)code
               onComplete:(void (^)(NSString *wxPrepayId,NSString *orderId))success
                  onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"toRptPay",
                                 @"token" : token,
                                 @"code":code,
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.rptTradeURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }

                                                 NSString *wxPrepayId = [info[@"result"] valueForKey:@"wxPrepayId"];
                                                 NSString *orderId = [info[@"result"] valueForKey:@"orderId"];
                                                 
                                                 !(success)? : success(wxPrepayId,orderId);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}

#pragma mark -    支付报告费接口(梅文峰)
//参数名    必选    类型    说明
//reqAct    是    string    请求方法，固定填写 toRptPay
//accId    是    string    接入者账号
//token    是    string    token
//code    是    string    前端返给app的code
//time    是    string    yyyy-MM-dd HH:mm:ss
//sign    是    string    MD5签名
+(void)payRptTradeVersionTwoWithCode:(NSString *)code
                          onComplete:(void (^)(NSDictionary *info))success
                             onError:(void (^)(NSError *error))failure
{    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    
    NSDictionary *parameters = @{@"reqAct" : @"toRptPay",
                                 @"token" : token,
                                 @"code":code};

    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.rptTradeURL param:parameters onComplete:^(NSDictionary *info) {
         if (![info[@"retCode"] isEqualToString:@"0"]) {
             !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
             return ;
         }
         !(success)? : success(info);
     }onError:^(NSError *error) {
        !(failure)? : failure(error);
    }];
}

#pragma mark -    APP支付回调接口
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 payCallBack
 accId    是    string    接入者账号
 token    是    string    token
 id    是    string    帮检id
 time    是    string    yyyy-MM-dd HH:mm:ss
 sign    是    string    MD5签名
 **/
+(void)payCallBackWithId:(NSString *)Id
               onComplete:(void (^)(void))success
                  onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"payCallBack",
                                 @"token" : token,
                                 @"id":Id,
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.helpTradeURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 NSInteger payStatus = [[[info valueForKey:@"result"] valueForKey:@"payStatus"] integerValue];
                                                 
                                                 if (payStatus == 1) {
                                                     !(success)? : success();
                                                 }else{
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : @"支付失败"}]);
                                                 }
                                                 
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}


#pragma mark -    发起帮检费的支付
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 toPay
 accId     是    string    接入者账号
 token     是    string    token
 id        是    string    帮检id
 time      是    string    yyyy-MM-dd HH:mm:ss
 sign      是    string    MD5签名
 **/
+(void)payHelpTradeWithId:(NSString *)Id
               onComplete:(void (^)(NSString *wxPrepayId,NSString *orderId))success
                  onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    
    NSDictionary *parameters = @{@"reqAct" : @"toPay",
                                 @"token" : token,
                                 @"id":Id};
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.helpTradeURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s----哈哈支付回调信息:%@----", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     return ;
                                                 }
                                                 
                                                 NSString *wxPrepayId = [info[@"result"] valueForKey:@"wxPrepayId"];
                                                 NSString *orderId = [info[@"result"] valueForKey:@"orderId"];
                                                 !(success) ? : success(wxPrepayId,orderId);
                                             }onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}

#pragma mark - 发起帮检费的支付(梅文峰)
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 toPay
 accId     是    string    接入者账号
 token     是    string    token
 id        是    string    帮检id
 time      是    string    yyyy-MM-dd HH:mm:ss
 sign      是    string    MD5签名
 **/
+(void)payHelpTradeVersionTwoWithId:(NSString *)Id
                         onComplete:(void (^)(NSDictionary *info))success
                            onError:(void (^)(NSError *error))failure
{
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    
    NSDictionary *parameters = @{@"reqAct" : @"toPay",
                                 @"token" : token,
                                 @"id":Id};
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.helpTradeURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
         NSLog(@"%s----哈哈支付回调信息:%@----", __func__,info);
         
         if (![info[@"retCode"] isEqualToString:@"0"]) {
             !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
             return;
         }
         
         !(success) ? : success(info);
                                             
     }onError:^(NSError *error) {
         !(failure)? : failure(error);
     }];
}

#pragma mark -    获取检测费用
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 findDetectionFee
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 vin    是    string    车架号
 carModelId    否    string    车型车系ID
 carLineId    否    string    车系ID
 carBrandId    否    string    品牌ID
 time    是    string    请求时间，格式yyyy-MM-dd HH:mm:ss
 sign    是    string    md5签名
 **/
+(void)detectionFeeForCarModelId:(NSString *)carModelId
                       carLineId:(NSString *)carLineId
                      carBrandId:(NSString *)carBrandId
                             vin:(NSString *)vinStr
                      onComplete:(void (^)(NSString *))success
                         onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"findDetectionFee",
                                 @"token" : token,
                                 @"vin" : vinStr,

//                                 @"carModelId":carModelId,
                                 @"carLineId":carLineId?carLineId:@"",
                                 @"carBrandId":carBrandId?carBrandId:@"",
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.helpDetectionURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 NSString *detectionFee = [info[@"result"] valueForKey:@"detectionFee"];
                                                 !(success)? : success(detectionFee);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}

#pragma mark -    预约帮检
/**
 reqAct    是    string    请求方法，固定填写 input
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 vin    是    string    车架号
 carFullName    是    string    车型车系
 contactUser    是    string    联系人
 contactTel    是    string    联系人电话
 org_id    是    string    检测站ID
 orgName    是    string    检测站点名称
 time    是    string    请求时间，格式yyyy-MM-dd HH:mm:ss
 sign    是    string    md5签名
 
 **/
+(void)inputWithVin:(NSString *)vin
        carFullName:(NSString *)carFullName
        contactUser:(NSString *)contactUser
         contactTel:(NSString *)contactTel
     smsNotifyPhone:(NSString *)smsNotifyPhone
           bookDate:(NSString *)bookDate
             org_id:(NSString *)org_id
            orgName:(NSString *)orgName
          carLineId:(NSString *)carLineId
         carBrandId:(NSString *)carBrandId
         onComplete:(void (^)(NSString *Id))success
            onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"input",
                                 @"token" : token,
                                 @"vin":vin,
                                 @"carFullName":carFullName,
                                 @"contactUser":contactUser,
                                 @"contactTel":contactTel,
                                 @"smsNotifyPhone":smsNotifyPhone,
                                 @"bookDate":bookDate,
                                 @"orgId":org_id,
                                 @"orgName":orgName,
                                 @"carLineId":carLineId,
                                 @"carBrandId":carBrandId,
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.helpDetectionURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 //NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSLog(@"info: %@===retMsg: %@",info,info[@"retMsg"]);

                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 NSString *Id = [info[@"result"] valueForKey:@"id"];
                                                 !(success)? : success(Id);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}

#pragma mark -    站点列表
/**
 reqAct    是    string    请求方法，固定填写 stationList
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 addrKeyWord    否    string    站点地址关键字（如：城市名）
 **/
+(void)stationListOnComplete:(void (^)( NSMutableArray <YHReservationModel *>*models))success
                     onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"stationList",
                                 @"token" : token,
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.helpDetectionURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 NSArray *stationList = [info[@"result"] valueForKey:@"stationList"];
                                                 NSMutableArray <YHReservationModel *>*models = [YHReservationModel mj_objectArrayWithKeyValuesArray:stationList];
                                                 
                                                 !(success)? : success(models);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}





#pragma mark -    正在竞拍 或者 竞拍记录
/**
 reqAct 请求方法，固定填写 findAuctionList  Y
 accId  接入者账号   Y
 token  token串  Y
 type   0、正在竞拍  1、竞拍记录 Y
 page   当前页数    Y
 rows   每页条数    Y
 time   请求时间，格式yyyy-MM-dd HH:mm:ss  Y
 sign   md5签名   Y
 **/
+(void)findAuctionListForPage:(NSInteger)page
                 isAuctioning:(BOOL)type
                   onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models, NSInteger time))success
                      onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"findAuctionList",
                                 @"token" : token,
                                 @"type"  : @(type? 1 : 0),
                                 @"page"  : @(page),
                                 @"rows"  : @(kPageSize)
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.myCarURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 NSArray *carList = [info[@"result"] valueForKey:@"carList"];
                                                 NSString *newTime = [info[@"result"] valueForKey:@"newTime"];
                                                 
                                                 NSDateFormatter *fmt = [NSDateFormatter new];
                                                 fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                                 NSDate *serviceData = [fmt dateFromString:newTime];
                                                 NSInteger time = [serviceData timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
                                                 
                                                 
                                                 //                                                 carList = @[
                                                 //                                                             @{@"carPicture":@"helpsellcar/20180330/1522395072737LRpNCPykK5.jpg",
                                                 //                                                               @"carId":@(31943282862850048),
                                                 //                                                               @"flag":@"0",
                                                 //                                                               @"price":@(155455.000),
                                                 //                                                               @"mileage":@"455888",
                                                 //                                                               @"status":@"2",
                                                 //                                                               @"carName":@"阿尔法-罗密欧ALFA 156(进口) 2018款 八 曹老师都",
                                                 //                                                               @"orderNum":@(2),
                                                 //                                                               @"useTime":@"2018-03-3",
                                                 //                                                               @"winTime":@"2018-03-3"
                                                 //                                                               }
                                                 //                                                             ];
                                                 
                                                 NSMutableArray <TTZCarModel *>*models = [TTZCarModel mj_objectArrayWithKeyValuesArray:carList];
                                                 
                                                 !(success)? : success(models,time);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}


#pragma mark -    销售记录
/**
 reqAct 请求方法，固定填写 sellRecordList  Y
 accId  接入者账号   Y
 token  token串  Y
 page   当前页数    Y
 rows   每页条数    Y
 time   请求时间，格式yyyy-MM-dd HH:mm:ss  Y
 sign   md5签名   Y
 **/
+(void)sellRecordListForPage:(NSInteger)page
                  onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                     onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"sellRecordList",
                                 @"token" : token,
                                 @"page"  : @(page),
                                 @"rows"  : @(kPageSize)
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.myCarURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 NSArray *carList = [info[@"result"] valueForKey:@"carList"];
                                                 NSMutableArray <TTZCarModel *>*models = [TTZCarModel mj_objectArrayWithKeyValuesArray:carList];
                                                 
                                                 !(success)? : success(models);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}



#pragma mark -    在库车辆
/**
 reqAct 请求方法，固定填写 inventoryList  Y
 accId  接入者账号   Y
 token  token串  Y
 page   当前页数    Y
 rows   每页条数    Y
 time   请求时间，格式yyyy-MM-dd HH:mm:ss  Y
 sign   md5签名   Y
 **/
+(void)inventoryListForPage:(NSInteger)page
                 onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                    onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"inventoryList",
                                 @"token" : token,
                                 @"page"  : @(page),
                                 @"rows"  : @(kPageSize)
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.myCarURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 NSArray *carList = [info[@"result"] valueForKey:@"carList"];
                                                 NSMutableArray <TTZCarModel *>*models = [TTZCarModel mj_objectArrayWithKeyValuesArray:carList];
                                                 
                                                 !(success)? : success(models);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}


#pragma mark -    我的收藏
/**
 reqAct 请求方法，固定填写 collectList  Y
 accId  接入者账号   Y
 token  token串  Y
 page   当前页数    Y
 rows   每页条数    Y
 time   请求时间，格式yyyy-MM-dd HH:mm:ss  Y
 sign   md5签名   Y
 **/
+(void)myCollectListForPage:(NSInteger)page
                 onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                    onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"collectList",
                                 @"token" : token,
                                 @"page"  : @(page),
                                 @"rows"  : @(kPageSize)
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.helpSellCarURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 NSArray *carList = [info[@"result"] valueForKey:@"carList"];
                                                 NSMutableArray <TTZCarModel *>*models = [TTZCarModel mj_objectArrayWithKeyValuesArray:carList];
                                                 
                                                 !(success)? : success(models);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}


#pragma mark -    车商联盟搜索
/**
 reqAct 请求方法，固定填写 findEntrustTradeList Y
 accId  接入者账号   Y
 token  token串  Y
 searchContent  搜索的内容   N
 page   当前页数    Y
 rows   每页条数    Y
 **/
+(void)searchEntrustTradeForPage:(NSInteger)page
                   searchContent:(NSString *)keyword
                         carType:(NSInteger)type
                      onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                         onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"findEntrustTradeList",
                                 @"token" : token,
                                 @"carType"  : @(type),
                                 @"page"  : @(page),
                                 @"rows"  : @(kPageSize),
                                 @"searchContent":keyword
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.helpSellCarURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 NSArray *carList = [info[@"result"] valueForKey:@"carList"];
                                                 NSMutableArray <TTZCarModel *>*models = [TTZCarModel mj_objectArrayWithKeyValuesArray:carList];
                                                 
                                                 !(success)? : success(models);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}


#pragma mark -    车商联盟
/**
 reqAct 请求方法，固定填写 findEntrustTradeList Y
 accId  接入者账号   Y
 token  token串  Y
 searchContent  搜索的内容   N
 page   当前页数    Y
 rows   每页条数    Y
 **/
+(void)getEntrustTradeListForPage:(NSInteger)page
                          carType:(NSInteger)type
                       onComplete:(void (^)( NSMutableArray <TTZCarModel *>*models))success
                          onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"findEntrustTradeList",
                                 @"token" : token,
                                 @"page"  : @(page),
                                 @"carType" : @(type),
                                 @"rows"  : @(kPageSize)
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.helpSellCarURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 NSArray *carList = [info[@"result"] valueForKey:@"carList"];
                                                 
                                                 NSMutableArray <TTZCarModel *>*models = [TTZCarModel mj_objectArrayWithKeyValuesArray:carList];
                                                 
                                                 !(success)? : success(models);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}



#pragma mark -    报价咨询
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 findSuggestPrice
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 type    是    string    类型 0 查询价格 1 询价
 carId    是    string    车辆ID
 **/
+(void)findSuggestPriceWithCarId:(NSString *)carId
                          type:(NSInteger)type
                       onComplete:(void (^)( NSString *suggestPrice ,BOOL isEnquiry))success
                          onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"findSuggestPrice",
                                 @"token" : token,
                                 @"type" : @(type),
                                 @"carId"  : carId
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.findSuggestPriceURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
//                                                 -suggestPrice    String    建议价格 例 12-18
//                                                 -isEnquiry    String    是否已询价 0 未询价 1 已询价

                                                 NSString *suggestPrice = [info[@"result"] valueForKey:@"suggestPrice"];
                                                 suggestPrice = IsEmptyStr(suggestPrice)? nil : suggestPrice;
                                                 BOOL isEnquiry = [[info[@"result"] valueForKey:@"isEnquiry"] boolValue];

                                           
                                                 
                                                 !(success)? : success(suggestPrice,isEnquiry);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}

#pragma mark -    买家出价列表
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 findOfferList
 accId    是    string    接入者账号
 token    是    string    用户会话标识
 carId    是    string    车辆id
 startTime    否    string    开始时间 yyyy-MM-dd
 endTime    否    string    结束时间 yyyy-MM-dd
 **/
+(void)findOfferListWithCarId:(NSString *)carId
                    startTime:(NSString *)startTime
                     endTime:(NSString *)endTime
                      onComplete:(void (^)( NSMutableArray <offerModel *>*models))success
                         onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"findOfferList",
                                 @"token" : token,
//                                 @"startTime" : startTime,
//                                 @"endTime" : endTime,
                                 @"carId"  : carId
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.findSuggestPriceURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 //                                                 -suggestPrice    String    建议价格 例 12-18
                                                 //                                                 -isEnquiry    String    是否已询价 0 未询价 1 已询价
                                                 
                                                 NSArray *offerList = [info[@"result"] valueForKey:@"offerList"];
                                                 NSMutableArray <offerModel *>*models = [offerModel mj_objectArrayWithKeyValuesArray:offerList];

                                                 
                                                 
                                                 !(success)? : success(models);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}



#pragma mark -    保存买家报价
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 saveBuyerOffer
 accId    是    string    接入者账号
 carId    是    string    车辆ID
 price    是    string    报价
 brokerage    是    string    佣金
 **/
+(void)saveBuyerOfferWithCarId:(NSString *)carId
                    price:(NSString *)price
                      brokerage:(NSString *)brokerage
                   onComplete:(void (^)(void))success
                      onError:(void (^)(NSError *error))failure{
    
    NSString *token = [YHTools getAccessToken];
    
    if (!token) {
        !(failure)? : failure([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"saveBuyerOffer",
                                 @"token" : token,
                                 @"price" : price,
                                 @"brokerage" : brokerage,
                                 @"carId"  : carId
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.findSuggestPriceURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 !(success)? : success();
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}



#pragma mark -    城市列表
/**
 参数名    必选    类型    说明
 reqAct    是    string    请求方法，固定填写 findCityList
 accId    是    string    接入者账号
 token    是    string    token
 time    是    string    yyyy-MM-dd HH:mm:ss
 sign    是    string    MD5签名
 **/
+(void)findCityListOnComplete:(void (^)(ZZCity*))success
                      onError:(void (^)(NSError *error))failure{
    

    NSDictionary *parameters = @{
                                 @"reqAct" : @"findCityList",
                                 //@"token" : token
                                 };
    
    [YHNetworkManager.sharedYHNetworkManager YHBasePOST:ApiService.sharedApiService.findCityListURL
                                                  param:parameters
                                             onComplete:^(NSDictionary *info) {
                                                 
                                                 NSLog(@"%s--%@", __func__,info);
                                                 
                                                 NSString *retCode = info[@"retCode"];
                                                 if (![retCode isEqualToString:@"0"]) {
                                                     
                                                     
                                                     !(failure)? : failure([NSError errorWithDomain:@"" code:20000 userInfo:@{@"message" : info[@"retMsg"]}]);
                                                     
                                                     return ;
                                                 }
                                                 
                                                 NSArray * cityList = [[info valueForKey:@"result"] valueForKey:@"cityList"];
                                                 NSArray * hotCityList = [[info valueForKey:@"result"] valueForKey:@"hotCityList"];
                                                 NSMutableDictionary *regionListDict = [NSMutableDictionary dictionary];
                                                 NSMutableArray *regionList = [NSMutableArray array];

                                                 [cityList enumerateObjectsUsingBlock:^(NSDictionary  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                     NSString *key = [obj valueForKey:@"initial"];//A
                                                     NSMutableArray *list = [regionListDict valueForKey:key];
                                                     if (!list) {
                                                         list = [NSMutableArray array];
                                                         [regionListDict setObject:list forKey:key];
                                                         [regionList addObject:@{@"initial":key,@"cityList":list}];
                                                     }
                                                     
                                                     [list addObject:obj];
                                                 }];

                                                 ZZCity *city = [ZZCity mj_objectWithKeyValues:@{@"hotCityList":hotCityList,@"regionList":regionList}];
                                                 !(success)? : success(city);
                                             }
                                                onError:^(NSError *error) {
                                                    !(failure)? : failure(error);
                                                }];
}



@end
