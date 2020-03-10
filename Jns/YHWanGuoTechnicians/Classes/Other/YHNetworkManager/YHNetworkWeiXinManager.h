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

#ifdef YHProduction
//生产
#define SERVER_URL "https://api.weixin.qq.com"

#endif

#ifdef YHProduction_Demo
//生产demo
#define SERVER_URL "https://api.weixin.qq.com"

#endif

#ifdef YHTest
//测试环境
#define SERVER_URL "https://api.weixin.qq.com"

#endif

#ifdef YHDev
#define SERVER_URL "https://api.weixin.qq.com"

#endif

#ifdef YHLocation
#define SERVER_URL "https://api.weixin.qq.com"

#endif

@interface YHNetworkWeiXinManager : YHNetBaseManager
DEFINE_SINGLETON_FOR_HEADER(YHNetworkWeiXinManager);


+ (void)analysisVin:(NSData*)image onComplete:(void (^)(NSDictionary *info))onComplete
            onError:(void (^)(NSError *error))onError;


/**
 
 获取access_token
 
 **/

- (void)getAccessTokenByCode:(NSString*)code onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError;


/**
 
 刷新access_token
 
 **/

- (void)reAccessTokenByToken:(NSString*)refreshToken onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError;


/**
 
 检查access_token
 
 **/

- (void)checkAccessToken:(NSString*)token byOpenid:(NSString*)openid onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError;

/**
 
 获取微信用户个人信息
 
 **/

- (void)getWeixinUserInfo:(NSString*)token byOpenid:(NSString*)openid onComplete:(void (^)(NSDictionary *info))onComplete
                  onError:(void (^)(NSError *error))onError;
@end
