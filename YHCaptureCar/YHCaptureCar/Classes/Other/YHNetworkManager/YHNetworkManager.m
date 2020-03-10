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
#import "YHJSONResponseSerializer.h"
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
 * 提现
 *
 **/
- (void)getCash:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"withdraw" forKey:@"reqAct"];
    [parameters setValue:token forKey:@"token"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/finance" param:parameters onComplete:onComplete onError:onError];
}
/**
 * 银行卡信息
 *
 **/
- (void)getBankCardInfo:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"cardInfo" forKey:@"reqAct"];
    [parameters setValue:token forKey:@"token"];

    [self YHBasePOST:SERVER_JAVA_Trunk"/finance" param:parameters onComplete:onComplete onError:onError];
}
/**
 * 新增/修改银行卡
 *
 **/
- (void)addOrModifyBindBankCard:(NSString *)token bankCardId:(NSString *)bankCardid bank:(NSString *)bank accountName:(NSString *)accountName cardNum:(NSString *)cardNum onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil || bankCardid == nil || bank == nil || accountName == nil || cardNum == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"bindCard" forKey:@"reqAct"];
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:bankCardid forKey:@"id"];
    [parameters setValue:bank forKey:@"bank"];
    [parameters setValue:accountName forKey:@"accountName"];
    [parameters setValue:cardNum forKey:@"cardNum"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/finance" param:parameters onComplete:onComplete onError:onError];
}
/**
 * 账户余额信息
 *
 **/
- (void)surplusAccountInfo:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"balance" forKey:@"reqAct"];
    [parameters setValue:token forKey:@"token"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/finance" param:parameters onComplete:onComplete onError:onError];
}
/**
 * 提现列表
 *
 **/
- (void)getProfitDetailList:(NSString *)token startTime:(NSString *)startTime endTime:(NSString *)endTime page:(NSString *)page pageSize:(NSString *)pageSize onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil || startTime == nil || endTime == nil || page == nil || pageSize == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@"withdrawList" forKey:@"reqAct"];
    [parameters setValue:startTime forKey:@"startTime"];
    [parameters setValue:endTime forKey:@"endTime"];
    [parameters setValue:page forKey:@"page"];
    [parameters setValue:pageSize forKey:@"pageSize"];
    [parameters setValue:token forKey:@"token"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/finance" param:parameters onComplete:onComplete onError:onError];
}
/**
 * 获取收益明细列表
 *
 **/
- (void)getProfitDetailList:(NSString *)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@"list" forKey:@"reqAct"];
    [parameters setValue:token forKey:@"token"];
    [self YHBasePOST:SERVER_JAVA_Trunk"/finance" param:parameters onComplete:onComplete onError:onError];
}
/**
 * 返现数据接口
 *
 **/
- (void)backCash:(NSString *)fullName vin:(NSString *)vin cbDate:(NSString *)cbDate totalPrice:(NSString *)totalPrice onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (fullName == nil || vin == nil || cbDate == nil || totalPrice == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
     [parameters setValue:@"checkMobile" forKey:@"reqAct"];
     [parameters setValue:fullName forKey:@"fullName"];
     [parameters setValue:vin forKey:@"vin"];
     [parameters setValue:cbDate forKey:@"cbDate"];
     [parameters setValue:totalPrice forKey:@"totalPrice"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/finance" param:parameters onComplete:onComplete onError:onError];
}

/**
 * 检测手机号码是否重复
 *
 **/
- (void)checkMobileRepeatType:(NSString *)type mobile:(NSString *)mobile onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (mobile == nil || type == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@"checkMobile" forKey:@"reqAct"];
    [parameters setValue:type forKey:@"type"];
    [parameters setValue:mobile forKey:@"mobile"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

/**
 * 发送验证码
 *
 **/
- (void)sendVerifyCodeType:(NSString *)type mobile:(NSString *)mobile onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (mobile == nil || type == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@"sendCode" forKey:@"reqAct"];
    [parameters setValue:type forKey:@"type"];
    [parameters setValue:mobile forKey:@"mobile"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

/**
 * 发送验证码(MWF修改)
 *
 **/
- (void)sendVerifyCodeWithToken:(NSString *)token
                           Type:(NSString *)type
                         mobile:(NSString *)mobile
                     onComplete:(void (^)(NSDictionary *info))onComplete
                        onError:(void(^)(NSError *error))onError{
    
    if (token == nil || mobile == nil || type == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@"sendCode" forKey:@"reqAct"];
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:type forKey:@"type"];
    [parameters setValue:mobile forKey:@"mobile"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

/**
 * 验证码校验(MWF修改)
 *
 **/
- (void)verifyCodeCheck:(NSString *)verifyCode type:(NSString *)type mobile:(NSString *)mobile onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (mobile == nil || verifyCode == nil || type == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@"checkVerifyCode" forKey:@"reqAct"];
    [parameters setValue:verifyCode forKey:@"verifyCode"];
    [parameters setValue:type forKey:@"type"];
    [parameters setValue:mobile forKey:@"mobile"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

/**
 * 重置密码
 *
 **/
- (void)reSetPasswordVerifyCode:(NSString *)verifyCode newPassword:(NSString *)newPassword mobile:(NSString *)mobile userName:(NSString *)userName onComplete:(void (^)(NSDictionary *info))onComplete onError:(void(^)(NSError *error))onError{
    
    if (mobile == nil || verifyCode == nil || newPassword == nil || userName == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@"changePwd" forKey:@"reqAct"];
    [parameters setValue:verifyCode forKey:@"verifyCode"];
    [parameters setValue:mobile forKey:@"mobile"];
    [parameters setValue:[[YHTools md5:[NSString stringWithFormat:@"%@",newPassword]]lowercaseString] forKey:@"newPwd"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
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
    
    [parameters setValue:@"modPwd" forKey:@"reqAct"];
    [parameters setValue:token forKey:@"token"];
    
    //MWF
    [parameters setValue:[YHTools md5:[NSString stringWithFormat:@"%@",oldPasswd]].lowercaseString forKey:@"oldPwd"];
    [parameters setValue:[YHTools md5:[NSString stringWithFormat:@"%@",newPassword]].lowercaseString forKey:@"newPwd"];
    [parameters setValue:[YHTools md5:[NSString stringWithFormat:@"%@",newPassword]].lowercaseString forKey:@"newPwdConfirm"];
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

/**
 登录
 userName    用户登录账号
 password    密码     MD5(登录账号+密码明文) 并转为大写
 
 **/

- (void)login:(NSString*)userName
     password:(NSString*)password
   onComplete:(void (^)(NSDictionary *info))onComplete
      onError:(void (^)(NSError *error))onError{
    
    if (userName == nil || password == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"login",
                                 @"userName" : userName,
                                 @"password" : password};
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}


/**
 注册
 userName    用户登录账号
 userPhone    用户手机号
 verCode      验证码
 userPwd    用户密码   MD5(登录账号+密码明文) 并转为大写
 type    商户类型 0 企业  1 个人
 name    商铺名称/ 联系人名称
 address    商户地址/ 所在城市
 userHeadId    图片ID
 **/

- (void)newAcount:(NSString*)userName
        userPhone:(NSString*)userPhone
        verCode:(NSString*)verCode
          userPwd:(NSString*)userPwd
             type:(NSString*)type
             name:(NSString*)name
             city:(NSString*)cityId
          address:(NSString*)address
       userHeadId:(NSString*)userHeadId
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    
    if (userName == nil
        || userPhone == nil
        || userPwd == nil
        || type == nil
        || name == nil
        || address == nil
        || userHeadId == nil
        || verCode == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"register",
                                 @"userName" : userName,
                                 @"userPhone" : userPhone,
                                 @"userPwd" : userPwd,
                                 @"type" : type,
                                 @"userName" : userName,
                                 @"name" : name,
                                 @"address" : address,
                                 @"userHeadId" : userHeadId,
                                 @"verifyCode":verCode,
                                 @"city":cityId
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

/**
 获取个人/企业车商认证信息
 token    token    Y
 
 **/

- (void)userInfo:(NSString*)token
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError{
    
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"info",
                                 @"token" : token};
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}


/**
 缴纳保证金
 token    token
 account    汇款账号
 bankName    开户行名称
 name    汇款人名称
 number    汇款流水号
 remittingTime    汇款时间
 isNew    是否是 新注册
 
 **/

- (void)paymentPledgeMoney:(NSString*)token
                   account:(NSString*)account
                  bankName:(NSString*)bankName
                      name:(NSString*)name
                    number:(NSString*)number
             remittingTime:(NSString*)remittingTime
                     isNew:(BOOL)isNew
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError{
    if (token == nil
        || account == nil
        || bankName == nil
        || name == nil
        || number == nil
        || remittingTime == nil
        ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"paymentPledgeMoney",
                                 @"token" : token,
                                 @"account" : account,
                                 @"bankName" : bankName,
                                 @"name" : name,
                                 @"number" : number,
                                 @"remittingTime" : remittingTime,
                                 @"type" : ((isNew)? (@"0") : (@"1"))};
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

/**
 车源信息—支付接口
 token    token串
 auctionId    竞价id
 payType     是     string     支付类型 1买家支付 2卖家支付
 
 **/

- (void)getPayId:(NSString*)token
       auctionId:(NSString*)auctionId
       payType:(NSString*)payType
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError{
    if (token == nil
        || auctionId == nil
        || payType == nil
        ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"toPay",
                                 @"token" : token,
                                 @"auctionId" : auctionId,
                                 @"payType" : payType
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/carInfo" param:parameters onComplete:onComplete onError:onError];
}

/*
 上传图片
 请求方式   POST
 
 http://192.168.1.248/btlmch/index.php
 */
- (void)updatePictureImageDate:(NSArray*)images
                    onComplete:(void (^)(NSDictionary *info))onComplete
                       onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查您网络！",@"info" : @"请检查您网络！"}]);
            [MBProgressHUD showError:@"请检查您网络！"];
        }
        return;
    }
    
    NSString *buildTimeStr = buildTime;
    NSString * sign = [YHTools md5:[NSString stringWithFormat:@"%@%@", buildTimeStr, signKeyManager]];
    
    NSString *url = [NSString stringWithFormat:@"/image2Word/preLoadPic.do?time=%@&sign=%@", buildTimeStr, sign];
    //    self.responseSerializer = [AFJSONResponseSerializer serializer];
    if (images != nil) {
        //        /Image2Word
        [self
         POST:url
         //         POST:@"/EasyOCR-master/preLoadPic.do"
         //         POST:@"/image2Word/preLoadPic.do"
         //         POST:@url
         parameters:nil
         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             [formData appendPartWithFileData :images[0] name:@"pic" fileName:@"upload.png" mimeType:@"image/png"];
             
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

//===================================================================================================
#pragma mark - 1.汽车列表
/**
 汽车列表
 menuType  是否是竞价现场 0 不是  1 是
 type      类型 0 参与的竞价 1 竞价意向 2 竞价中 3 即将开拍 4 竞价成功 5 竞价记录
 page      页数
 rows      每页条数
 **/
- (void)requestCarListWithMenuType:(NSString *)menuType
                              Type:(NSString *)type
                              page:(NSString *)page
                              rows:(NSString *)rows
                        onComplete:(void (^)(NSDictionary *info))onComplete
                           onError:(void (^)(NSError *error))onError
{
    if ( IsEmptyStr(menuType) || IsEmptyStr(type) || IsEmptyStr(page) || IsEmptyStr(rows)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"findCarList",
                                 @"token" : [YHTools getAccessToken],
                                 @"menuType":menuType,
                                 @"type" : type,
                                 @"page" : page,
                                 @"rows" : rows};
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 2.车辆详情
/**
 汽车列表
 auctionId    竞价id
 **/
- (void)requestCarDetailsWithAuctionId:(NSString *)auctionId
                            onComplete:(void (^)(NSDictionary *info))onComplete
                               onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(auctionId)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"findCarDetail",
                                 @"token" : [YHTools getAccessToken],
                                 @"auctionId" : auctionId};
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 3.车源信息—获取状态和价格
/**
 用户进入车源信息页面时，页面最下方展示的价格、状态或其他信息
 auctionId    竞价id
 **/
- (void)getStatusInfoAndPriceWithAuctionId:(NSString *)auctionId
                                onComplete:(void (^)(NSDictionary *info))onComplete
                                   onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(auctionId)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"getStatusInfo",
                                 @"token" : [YHTools getAccessToken],
                                 @"auctionId" : auctionId};
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/carInfo" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 4.车源信息—(竞价中)获取出价信息
/**
 汽车列表
 auctionId    竞价id
 **/
- (void)getBidInfo:(NSString *)auctionId
        onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(auctionId)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"getBidInfo",
                                 @"token" : [YHTools getAccessToken],
                                 @"auctionId" : auctionId};
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 5.车源信息——(竞价中)保存出价
/**
 汽车列表
 auctionId    竞价id
 bidPrice     用户出价
 **/
- (void)saveBidPriceWithAuctionId:(NSString *)auctionId
                         bidPrice:(NSString *)bidPrice
                       onComplete:(void (^)(NSDictionary *info))onComplete
                          onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(auctionId) || IsEmptyStr(bidPrice)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"saveBidPrice",
                                 @"token" : [YHTools getAccessToken],
                                 @"auctionId" : auctionId,
                                 @"bidPrice" : bidPrice};
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/carInfo" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 6.车源信息—竞价意向
/**
 汽车列表
 auctionId    竞价id
 FavStatus    竞价意向状态 1收藏 2取消
 **/
- (void)auctionInatentionWithAuctionId:(NSString *)auctionId
                             FavStatus:(NSString *)favStatus
                            onComplete:(void (^)(NSDictionary *info))onComplete
                               onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(auctionId) || IsEmptyStr(favStatus)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"favorite",
                                 @"token" : [YHTools getAccessToken],
                                 @"auctionId" : auctionId,
                                 @"favStatus" : favStatus};
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/carInfo" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 7.车辆详情
/**
 accId    接入者账号
 token    token
 carId    车辆ID
 **/
- (void)requestCarDetailsWithToken:(NSString *)token carId:(NSString *)carId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if ( IsEmptyStr(token) || IsEmptyStr(carId)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"carDetail",
                                 @"token" : token,
                                 @"carId" : carId};
    NSLog(@"<<<------------------->%@<------------------->>>",parameters);
    [self YHBasePOST:SERVER_JAVA_Trunk"/carSource/myCar" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 8.设置帮卖价
/**
 token    token
 carId    车辆ID
 price    价格(万)
 **/
- (void)setHelpSellPriceWithToken:(NSString *)token carId:(NSString *)carId price:(NSString *)price onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if ( IsEmptyStr(token) || IsEmptyStr(carId) || IsEmptyStr(price)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"setPrice",
                                 @"token" : token,
                                 @"carId" : carId,
                                 @"price" : price};
    [self YHBasePOST:SERVER_JAVA_Trunk"/carSource/myCar" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 9.找帮卖/上捕车
/**
 token    token
 carId    车辆ID
 price    竞拍起拍价，type=1时必填
 type     0、找帮卖 1、上捕车 2 找帮买

 **/
- (void)helpSellAndUpCaptureCarWithToken:(NSString *)token
                                   carId:(NSString *)carId
                                   price:(NSString *)price
                                    free:(NSString *)free
                                    type:(NSString *)type
                              onComplete:(void (^)(NSDictionary *info))onComplete
                                 onError:(void (^)(NSError *error))onError{
    if ( IsEmptyStr(token) || IsEmptyStr(carId) || IsEmptyStr(type)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"reqAct":@"entrustTrade",
                                         @"token" : token,
                                         @"carId" : carId,
                                         @"type"  : type} mutableCopy];
    
    if (!IsEmptyStr(price)) {
        [parameters setObject:price forKey:@"price"];
    }
    if (!IsEmptyStr(free)) {
        [parameters setObject:free forKey:@"helpSellPrice"];
    }

    
    [self YHBasePOST:SERVER_JAVA_Trunk"/carSource/myCar" param:parameters onComplete:onComplete onError:onError];
}

- (void)helpSellAndUpCaptureCarWithToken:(NSString *)token carId:(NSString *)carId price:(NSString *)price type:(NSString *)type onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if ( IsEmptyStr(token) || IsEmptyStr(carId) || IsEmptyStr(type)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = [@{@"reqAct":@"entrustTrade",
                                         @"token" : token,
                                         @"carId" : carId,
                                         @"type"  : type} mutableCopy];
    
    if (!IsEmptyStr(price)) {
        [parameters setObject:price forKey:@"price"];
    }
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/carSource/myCar" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 10.取消找帮卖/上捕车
/**
 token        token
 carId        车辆ID
 auctionId    竞拍ID（取消捕车时必传）
 type         类型 0、取消上帮卖  1、取消上捕车
 **/
- (void)cancelHelpSellAndUpCaptureCarWithToken:(NSString *)token carId:(NSString *)carId auctionId:(NSString *)auctionId type:(NSString *)type onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token) || IsEmptyStr(carId) || IsEmptyStr(type)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = [@{@"reqAct":@"cancelTrade",
                                         @"token" : token,
                                         @"carId" : carId,
                                         @"type"  : type} mutableCopy];
    
    if (!IsEmptyStr(auctionId)) {
        [parameters setObject:auctionId forKey:@"auctionId"];
    }
    
    NSLog(@"==============>请求参数:%@<==============",parameters);
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/carSource/myCar" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 11.下架
/**
 帮卖的随时都可以下架或者售出，竞拍的在待安排状态下可以下架或售出，已安排（待开拍）的如果需要下架需要先取消竞拍，取消竞拍或者取消帮卖后状态变成 库存
 token    token
 carId    车辆ID
 price    售出价
 type     类型 0、售出  1、下架
 **/
- (void)downShelfWithToken:(NSString *)token carId:(NSString *)carId price:(NSString *)price type:(NSString *)type onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if ( IsEmptyStr(token) || IsEmptyStr(carId) || IsEmptyStr(type)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"soldOutCar",
                                 @"token" : token,
                                 @"carId" : carId,
                                 @"price" : price,
                                 @"type"  : type};
    [self YHBasePOST:SERVER_JAVA_Trunk"/carSource/myCar" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 12.收藏/取消收藏
/**
 对车源进行收藏和取消收藏
 token        token
 carId        车辆ID
 favStatus    收藏状态 0 取消1 收藏
 **/
- (void)favoriteWithToken:(NSString *)token carId:(NSString *)carId favStatus:(NSString *)favStatus onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if ( IsEmptyStr(token) || IsEmptyStr(carId) || IsEmptyStr(favStatus)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"favorite",
                                 @"token" : token,
                                 @"carId" : carId,
                                 @"favStatus" : favStatus};
    [self YHBasePOST:SERVER_JAVA_Trunk"/entrustTrade/helpSellCar" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 13.竞拍结束
/**
 token        token
 auctionId    auctionId
 **/
- (void)auctionEndWithToken:(NSString *)token auctionId:(NSString *)auctionId onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if ( IsEmptyStr(token) || IsEmptyStr(auctionId)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"getMerchantEndInfo",
                                 @"token" : token,
                                 @"auctionId" : auctionId};
    [self YHBasePOST:SERVER_JAVA_Trunk"/carSource/myCar" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 14.帮检列表
/**
 对车源进行收藏和取消收藏
 token        用户会话标识
 page         页码 ，从1开始
 pageSize     每页数量
 **/
- (void)requestHelpCheckListWithToken:(NSString *)token Page:(NSString *)page pageSize:(NSString *)pageSize onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token) || IsEmptyStr(page) || IsEmptyStr(pageSize)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"list",
                                 @"token": token,
                                 @"page" : page,
                                 @"pageSize" : pageSize};
    [self YHBasePOST:SERVER_JAVA_Trunk"/helpDetection" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 15.申请退款
/**
 token        用户会话标识
 ID           帮检记录ID
 reason       退款原因
 **/
- (void)applyRefundWithToken:(NSString *)token ID:(NSString *)ID  reason:(NSString *)reason onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token) || IsEmptyStr(ID)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"applyRefund",
                                 @"token": token,
                                 @"id" : ID,
                                 @"reason" : reason};
    [self YHBasePOST:SERVER_JAVA_Trunk"/helpTrade" param:parameters onComplete:onComplete onError:onError];
}


#pragma mark - 16.扫一扫-获取报告列表
/**
 reqAct         请求方法，固定填写 rptList
 accId          接入者账号
 token          用户会话标识
 vin            车架号
 pageNo         页码 ，从1开始
 pageSize       每页数量
 time           请求时间，格式yyyy-MM-dd HH:mm:ss
 sign           md5签名
 **/
- (void)rptListWithToken:(NSString *)token
                     vin:(NSString *)vin
                  pageNo:(NSString *)pageNo
                pageSize:(NSString *)pageSize
              onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token) || IsEmptyStr(vin) || IsEmptyStr(pageNo) || IsEmptyStr(pageSize)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"rptList",
                                 @"token": token,
                                 @"vin" : vin,
                                 @"pageNo" : pageNo,
                                 @"pageSize" : pageSize};
    [self YHBasePOST:SERVER_JAVA_Trunk"/scan" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 17.扫一扫-获取报告详情
- (void)rptDetailWithToken:(NSString *)token
                reportCode:(NSString *)reportCode
                  billType:(NSString *)billType
                billNumber:(NSString *)billNumber
              creationTime:(NSString *)creationTime
                onComplete:(void (^)(NSDictionary *info))onComplete
                   onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token) || IsEmptyStr(reportCode) || IsEmptyStr(billType) || IsEmptyStr(billNumber) || IsEmptyStr(creationTime)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"rptDetail",
                                 @"token": token,
                                 @"reportCode": reportCode,
                                 @"billType" : billType,
                                 @"billNumber" : billNumber,
                                 @"creationTime" : creationTime};
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/scan" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 18.扫一扫-支付报告费
- (void)payReportFeeWithToken:(NSString *)token
                   reportCode:(NSString *)reportCode
                     billType:(NSString *)billType
                   billNumber:(NSString *)billNumber
                 creationTime:(NSString *)creationTime
                   onComplete:(void (^)(NSDictionary *info))onComplete
                      onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token) || IsEmptyStr(reportCode) || IsEmptyStr(billType) || IsEmptyStr(billNumber) || IsEmptyStr(creationTime)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"toPay",
                                 @"token": token,
                                 @"reportCode" : reportCode,
                                 @"billType" : billType,
                                 @"billNumber": billNumber,
                                 @"creationTime": creationTime,
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/scan" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 19.扫一扫-APP支付回调接口
- (void)payCallBackWithToken:(NSString *)token
                     orderId:(NSString *)orderId
                  onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token) || IsEmptyStr(orderId)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"payCallBack",
                                 @"token": token,
                                 @"orderId" : orderId};
    NSLog(@"======================支付结果回调传参:%@====================",parameters);
    [self YHBasePOST:SERVER_JAVA_Trunk"/scan" param:parameters onComplete:onComplete onError:onError];
}


#pragma mark - 20.修改手机号
- (void)updatePhoneWithToken:(NSString *)token
                      mobile:(NSString *)mobile
                  verifyCode:(NSString *)verifyCode
                  onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token) || IsEmptyStr(mobile) || IsEmptyStr(verifyCode)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"updatePhone",
                                 @"token":token,
                                 @"mobile" : mobile,
                                 @"verifyCode" : verifyCode};
    NSLog(@"======================修改手机号传参:%@====================",parameters);
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 21.检测用户手机本月是否还有修改次数
- (void)checkUpdatePhoneNumWithToken:(NSString *)token
                          onComplete:(void (^)(NSDictionary *info))onComplete
                             onError:(void (^)(NSError *error))onError
{
    if (IsEmptyStr(token)) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct":@"checkUpdatePhoneNum",
                                 @"token": token};
    NSLog(@"======================修改手机号传参:%@====================",parameters);
    [self YHBasePOST:SERVER_JAVA_Trunk"/auction/user" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark Init
- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
    if (self) {
        //        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //                self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [YHJSONResponseSerializer serializer];
        ((YHJSONResponseSerializer*)self.responseSerializer).removesKeysWithNullValues = YES;
        //        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    return self;
}

/************* 捕车  *************/
#pragma mark -  修理厂站点列表
/**
 修理厂站点列表 list     /buche/api/station
 token          是    string    用户会话标识
 addrKeyWord    否    string    站点地址关键字（如：城市名）
 **/
-(void)repairShopListAddrWithToken:(NSString*)token
                           keyWord:(NSString *)addrKeyWord
                        onComplete:(void (^)(NSDictionary *info))onComplete
                           onError:(void (^)(NSError *error))onError{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"reqAct" : @"usedOrgList",
                                                                                      @"token" :token,
                                                                                      }];
    if (addrKeyWord != nil) {
        [parameters setObject:addrKeyWord forKey:@"addrKeyWord"];
    }
    [self YHBasePOST:SERVER_JAVA_Trunk"/station" param:parameters onComplete:onComplete onError:onError];
    
}

#pragma mark - 预约检测
/**
 预约检测 book     /buche/api/test
 token       是    string    用户会话标识
 amount      是    string    预约数量
 addr        是    string    预约地址
 tel         是    string    联系电话
 bookDate    是    string    预约日期
 stationId   是    string    修理厂ID
 stationName 是    string    修理厂名称
 **/
-(void)appointmentInspectionWithToken:(NSString*)token
                               amount:(NSString *)amount
                                 addr:(NSString *)addr
                                  tel:(NSString *)tel
                             bookDate:(NSString *)bookDate
                            stationId:(NSString *)stationId
                          stationName:(NSString *)stationName
                           onComplete:(void (^)(NSDictionary *info))onComplete
                              onError:(void (^)(NSError *error))onError{
    if (addr == nil || tel == nil || bookDate == nil ||stationId == nil ||stationName == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"book",
                                 @"token" :token,
                                 @"amount": amount,
                                 @"addr" : addr,
                                 @"tel" : tel,
                                 @"bookDate" : bookDate,
                                 @"stationId" : stationId,
                                 @"stationName" : stationName,
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/test" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 预约检测(新)
/**
 预约检测 book     /buche/api/test
 token       是    string    用户会话标识
 amount      是    string    预约数量
 addr        是    string    预约地址
 tel         是    string    联系电话
 bookDate    是    string    预约日期
 stationId   是    string    修理厂ID
 stationName 是    string    修理厂名称
 **/
-(void)appointmentInspectionWithToken:(NSString*)token
                                 orgId:(NSString *)orgId
                                  userPhone:(NSString *)userPhone
                             orgName:(NSString *)orgName
                            userName:(NSString *)userName
                          arrivalStartTime:(NSString *)arrivalStartTime
                       arrivalEndTime:(NSString *)arrivalEndTime
                          desc:(NSString *)desc
                           onComplete:(void (^)(NSDictionary *info))onComplete
                              onError:(void (^)(NSError *error))onError{
    if (orgId == nil || userPhone == nil || orgName == nil ||userName == nil ||arrivalStartTime == nil || arrivalEndTime == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSMutableDictionary *parameters = @{@"reqAct" : @"book",
                                 @"token" :token,
                                 @"orgId" : orgId,
                                 @"userPhone" : userPhone,
                                 @"orgName" : orgName,
                                 @"userName" : userName,
                                 @"arrivalStartTime" : arrivalStartTime,
                                 @"arrivalEndTime" : arrivalEndTime,
                                 }.mutableCopy;
    if(desc){
        [parameters setObject:desc forKey:@"desc"];
    }
    [self YHBasePOST:SERVER_JAVA_Trunk"/usedCar" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark -  预约检测结果通知
/**
 预约检测结果通知 result    /buche/api/test
 bookId       是    long      预约id
 carDealerId  是    long      车商id
 vin          是    string    车架号
 brand        是    string    品牌型号
 desc         是    string    车型描述
 prodDate     是    string    生产时间
 regDate      否    string    注册日期（第一次上牌时间）
 km           是    decmial   公里数
 emisStandard 否    string    排放标准
 plateNo      否    string    车牌号
 addr         否    string    车辆所在地
 carNature    否    string    车辆性质
 useNature    否    string    使用性质
 insuDate     否    string    保险到期日
 keyAmount    否    int       钥匙数量
 pic          否    string    车辆图片（后缀）,多个图片以逗号分
 link         是    string    报告链接后缀
 techId       是    string    检测技师id
 techName     是    string    检测技师姓名
 **/
-(void)appointmentTestResultsNotification:(NSDictionary *)dict
                               onComplete:(void (^)(NSDictionary *info))onComplete
                                  onError:(void (^)(NSError *error))onError{
    
    NSDictionary *parameters = @{@"reqAct" : @"result",
                                 @"bookId" : dict[@"bookId"],
                                 @"carDealerId" : dict[@"carDealerId"],
                                 @"vin" : dict[@"vin"],
                                 @"brand" : dict[@"brand"],
                                 @"desc" : dict[@"desc"],
                                 @"prodDate" : dict[@"prodDate"],
                                 @"regDate" : dict[@"regDate"],
                                 @"km" : dict[@"km"],
                                 @"emisStandard" : dict[@"emisStandard"],
                                 @"plateNo" : dict[@"plateNo"],
                                 @"addr" : dict[@"addr"],
                                 @"carNature" : dict[@"carNature"],
                                 @"useNature" : dict[@"useNature"],
                                 @"insuDate" : dict[@"insuDate"],
                                 @"keyAmount" : dict[@"keyAmount"],
                                 @"pic" : dict[@"pic"],
                                 @"link" : dict[@"link"],
                                 @"techId" : dict[@"techId"],
                                 @"techName" : dict[@"techName"]
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/test" param:parameters onComplete:onComplete onError:onError];
    
}

#pragma mark - 检测记录列表
/**
 检测记录列表 detecList  /buche/api/test
 token     是    string    用户会话标识
 pageNo    是    int    当前页码，从1开始
 pageSize  是    int    每页显示数量
 **/
-(void)testRecordListWithToken:(NSString*)token
                        pageNo:(NSInteger)pageNo
                      pageSize:(NSInteger)pageSize
                    onComplete:(void (^)(NSDictionary *info))onComplete
                       onError:(void (^)(NSError *error))onError{
    if (pageNo <=0 || pageSize <=0 ) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"detecList",
                                 @"token" :[YHTools getAccessToken],
                                 @"pageNo" : @(pageNo),
                                 @"pageSize" : @(pageSize)
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/test" param:parameters onComplete:onComplete onError:onError];
    
}

#pragma mark - 设置车辆价格
/**
 设置车辆价格 setPrice    /buche/api/car
 token    是    string    用户会话标识
 carId    是    string    车辆id
 price    是    decimal    车辆价格（万元）
 **/
-(void)SetVehiclePricesWithToken:(NSString*)token
                           carId:(NSString*)carId
                           price:(NSString*)price
                      onComplete:(void (^)(NSDictionary *info))onComplete
                         onError:(void (^)(NSError *error))onError{
    if (carId == nil ||price <=0) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"setPrice",
                                 @"token" : token,
                                 @"carId" : carId,
                                 @"price" : price
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/car" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 车辆信息详情
/**
 车辆信息详情  detail   /buche/api/car
 token    是    string    用户会话标识
 carId    是    string    车辆id
 **/
-(void)vehicleInformationDetailsWithToken:(NSString*)token
                                    carId:(NSString*)carId
                               onComplete:(void (^)(NSDictionary *info))onComplete
                                  onError:(void (^)(NSError *error))onError{
    if (carId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"detail",
                                 @"token" : token,
                                 @"carId" : carId,
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/car" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 待检测列表
/**
 待检测列表  bookList   /buche/api/test
 token    是    string    用户会话标识
 pageNo   是    int    当前页码，从1开始
 pageSize 是    int    每页显示数量
 **/
-(void)toBeDetectedlistWithToken:(NSString*)token
                          pageNo:(NSInteger)pageNo
                        pageSize:(NSInteger)pageSize
                      onComplete:(void (^)(NSDictionary *info))onComplete
                         onError:(void (^)(NSError *error))onError{
    if (pageNo <=0 ||pageSize <= 0) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"bookList",
                                 @"token" : token,
                                 @"pageNo" : @(pageNo),
                                 @"pageSize" : @(pageSize)
                                 };
    //[self YHBasePOST:SERVER_JAVA_Trunk"/test" param:parameters onComplete:onComplete onError:onError];
    [self YHBasePOST:SERVER_JAVA_Trunk"/usedCar" param:parameters onComplete:onComplete onError:onError];

}

#pragma mark - 车辆信息详情
/**
 根据车辆id，获取车辆信息详情
 token     是     string     用户会话标识
 carId     是     string     车辆id
 **/
-(void)carDetail:(NSString*)token
           carId:(NSString*)carId
      onComplete:(void (^)(NSDictionary *info))onComplete
         onError:(void (^)(NSError *error))onError{
    if (token == nil ||carId == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"reqAct" : @"detail",
                                 @"token" : token,
                                 @"carId" : carId
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/car" param:parameters onComplete:onComplete onError:onError];
}


#pragma mark - 车源管理  检测录入
/**
 reqAct    请求方法，固定填写 input
 accId    接入者账号
 token    token串
 vin    车架号
 carBrandName    车系车型
 carStyle    年款
 dynamicParameter    动力参数
 model    型号
 plateNo    车牌号
 userName    联系人名称
 phone    联系人电话
 carAddress    看车地址
 emissionsStandards    排放标准
 tripDistance    里程
 productionDate    生产时间（出厂时间）
 registrationDate    注册时间
 issueDate    发证时间
 carNature    车辆性质 0 营运  1 非营运
 userNature    车辆所有者性质 0 私户  1 公户
 endAnnualSurveyDate    年检到期时间
 trafficInsuranceDate    交强险到期时间
 businessInsuranceDate    商业险到期时间
 offer    售价（帮卖价，页面新增的输入项，只能输入数字）
 carDesc    描述
 
 token     是     string     用户会话标识
 
 */
-(void)submitBasicInformationWithDictionary:(NSDictionary *)dict token:(NSString*)token onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError{
    
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
    NSMutableDictionary *parameters = [dict mutableCopy];
    
    [parameters addEntriesFromDictionary:@{@"reqAct" : @"input",
                                           @"token" : token,
                                           }];
    NSString *url = SERVER_JAVA_Trunk"/entrustTrade/helpSellCar";
    [self YHBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 根据VIN获取车辆信息 只有生产可测试
/**
 获取车辆信息
 token     是     string     token
 vin     是     string     vin号
 **/
-(void)getCarInfoByVin:(NSString*)token
                   vin:(NSString*)vin
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil ||vin == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    //    if (onComplete) {
    //
    //        onComplete(@{@"retCode" : @0,
    //                     @"result" : @[
    //                             @{
    //                                 @"carLineId": @"10000605",
    //                                 @"carLineName": @"景逸",
    //                                 @"carBrandId": @"2000246",
    //                                 @"carBrandName": @"风行",
    //                                 @"carModelId": @"1020112",
    //                                 @"carModelName": @"舒适型",
    //                                 @"carModelFullName": @"景逸XL 2011款 1.5 序列变速 舒适型",
    //                                 @"carCc": @"1.5L",
    //                                 @"produceYear": @"2011",
    //                                 @"gearboxType": @"序列变速器(AMT)",
    //                                 @"airAdmission": @"自然吸气",
    //                                 @"icoName": @"dffx_ico"
    //                                 },
    //                             @{
    //                                 @"carLineId": @"10000605",
    //                                 @"carLineName": @"景逸",
    //                                 @"carBrandId": @"2000246",
    //                                 @"carBrandName": @"风行3",
    //                                 @"carModelId": @"1020112",
    //                                 @"carModelName": @"舒适型",
    //                                 @"carModelFullName": @"景逸XL 2011款 1.5 序列变速 舒适型",
    //                                 @"carCc": @"1.5L",
    //                                 @"produceYear": @"2011",
    //                                 @"gearboxType": @"序列变速器(AMT)",
    //                                 @"airAdmission": @"自然吸气",
    //                                 @"icoName": @"dffx_ico"
    //                                 },
    //                             @{
    //                                 @"carLineId": @"10000605",
    //                                 @"carLineName": @"景逸",
    //                                 @"carBrandId": @"2000246",
    //                                 @"carBrandName": @"风行2",
    //                                 @"carModelId": @"1020112",
    //                                 @"carModelName": @"舒适型",
    //                                 @"carModelFullName": @"景逸XL 2011款 1.5 序列变速 舒适型",
    //                                 @"carCc": @"1.5L",
    //                                 @"produceYear": @"2011",
    //                                 @"gearboxType": @"序列变速器(AMT)",
    //                                 @"airAdmission": @"自然吸气",
    //                                 @"icoName": @"dffx_ico"
    //                                 }
    //                             ]});
    //        return;
    //    }
    
    NSDictionary *parameters = @{@"reqAct" : @"getCarInfoByVin",
                                 @"token" : token,
                                 @"vin" : vin
                                 };
    [self YHBasePOST:SERVER_JAVA_Trunk"/car" param:parameters onComplete:onComplete onError:onError];
}

#pragma mark - 补充车辆基本信息接口
/**

 **/
-(void)setCarBaseInfoBytoken:(NSString*)token
                       dic:(NSDictionary *)dict
            onComplete:(void (^)(NSDictionary *info))onComplete
               onError:(void (^)(NSError *error))onError{
    if (token == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSMutableDictionary *parameters = dict.mutableCopy;
    
    parameters[@"reqAct"] =  @"updateCarInfo";
    parameters[@"token"] = token;
    parameters[@"carType"] = nil;
    
    
    [self YHBasePOST:SERVER_JAVA_Trunk"/usedCar/car" param:parameters onComplete:onComplete onError:onError];
}
@end
