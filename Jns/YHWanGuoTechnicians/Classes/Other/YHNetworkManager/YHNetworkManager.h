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
//#define SERVER_JAVA_URL "http://www.wanguoqiche.cn"
#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
//#define SERVER_JAVA_URL "http://192.168.1.42:8080"
//#define SERVER_JAVA_URL "http://192.168.1.56:8080"
//#define SERVER_JAVA_URL "http://119.29.10.240"
#define SERVER_JAVA_Trunk @"/csc"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"44676A3E62E4489DB209D6AC6F291FEF"

#endif

#ifdef YHProduction_Demo
//生产demo

#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
//#define SERVER_JAVA_URL "https://www.wanguoqiche.com"
#define SERVER_JAVA_Trunk @"/csc-demo"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"4028816455dcd8ad0asdfddd7f89006a"

#endif

#ifdef YHTest
//测试环境

//#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
#define SERVER_JAVA_URL "http://192.168.1.220"
//#define SERVER_JAVA_URL "http://www.wanguoqiche.com"
#define SERVER_JAVA_Trunk @"/csc"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"4028816455dcd8ad0155dddd7f89006a"

#endif
#ifdef YHDev

//#define SERVER_JAVA_URL "http://www.wanguoqiche.cn"
#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
//#define SERVER_JAVA_URL "http://192.168.1.42:8080"
//#define SERVER_JAVA_URL "http://192.168.1.56:8080"
//#define SERVER_JAVA_URL "http://119.29.10.240"
#define SERVER_JAVA_Trunk @"/csc"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"44676A3E62E4489DB209D6AC6F291FEF"

#endif

#ifdef YHLocation

//#define SERVER_JAVA_URL "http://www.wanguoqiche.cn"
#define SERVER_JAVA_URL "https://vin.wanguoqiche.com"
//#define SERVER_JAVA_URL "http://192.168.1.42:8080"
//#define SERVER_JAVA_URL "http://192.168.1.56:8080"
//#define SERVER_JAVA_URL "http://119.29.10.240"
#define SERVER_JAVA_Trunk @"/csc"
#define signKeyBoss @"mafubang@mh.Key"
#define signKeyManager @"44676A3E62E4489DB209D6AC6F291FEF"

#endif
@interface YHNetworkManager : YHNetBaseManager
DEFINE_SINGLETON_FOR_HEADER(YHNetworkManager);

/*
 上传图片
 请求方式   POST
 
 http://192.168.1.248/btlmch/index.php
 */
- (void)updatePictureImageDate:(NSArray*)images onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError;

@end
