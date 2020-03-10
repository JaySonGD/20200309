//
//  YHJspathAndVersionManager.h
//  YHTechnician
//
//  Created by Zhu Wensheng on 16/11/23.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHCommon.h"
#import "YHNetBaseManager.h"
#import "SynthesizeSingleton.h"
#ifdef YHProduction
//生产

#define SERVER_JAVA_APP_VERSION_URL "https://www.wanguoqiche.com"
#define SERVER_JAVA_APP_VERSION_Trunk @"/csc"

#endif

#ifdef YHProduction_Demo
//生产demo

#define SERVER_JAVA_APP_VERSION_URL "http://192.168.1.200:8080"
#define SERVER_JAVA_APP_VERSION_Trunk @"/csc-demo"

#endif

#ifdef YHTest
//测试环境

#define SERVER_JAVA_APP_VERSION_URL "http://192.168.1.200:8080"
#define SERVER_JAVA_APP_VERSION_Trunk @"/csc"

#endif
#ifdef YHDev

//#define SERVER_JAVA_APP_VERSION_URL "http://www.wanguoqiche.cn"
#define SERVER_JAVA_APP_VERSION_URL "http://192.168.1.200:8080"

#define SERVER_JAVA_APP_VERSION_Trunk @"/csc"

#endif

#ifdef YHLocation

//#define SERVER_JAVA_APP_VERSION_URL "http://www.wanguoqiche.cn"
#define SERVER_JAVA_APP_VERSION_URL "http://192.168.1.200:8080"

#define SERVER_JAVA_APP_VERSION_Trunk @"/csc"

#endif
@interface YHJspathAndVersionManager : YHNetBaseManager

DEFINE_SINGLETON_FOR_HEADER(YHJspathAndVersionManager);

- (void)versionManage:(NSString*)appUrl;
@end
