//
//  CheckNetwork.h
//  iphone.network1
//
//  Created by wangjun on 10-12-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//  检查网络是否存在

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "Reachability.h"
#import "YHCommon.h"
#ifdef YHProduction
//生产
#define NETWORK_URL_V1 @"www.baidu.com"
#define NETWORK_URL_V2 @"www.wanguoqiche.com"
#endif

#ifdef YHProduction_Demo
//生产demo

#define NETWORK_URL_V1 @"http://192.168.1.200"
#define NETWORK_URL_V2 @"http://192.168.1.200"
#endif

#ifdef YHTest
//测试环境

#define NETWORK_URL_V1 @"www.baidu.com"
#define NETWORK_URL_V2 @"www.wanguoqiche.com"
#endif
#ifdef YHDev
//开发环境
#define NETWORK_URL_V1 @"devapi.demo.com"
#define NETWORK_URL_V2 @"devapi.demo.com"
#endif

#ifdef YHLocation

#define NETWORK_URL_V1 @"devapi.demo.com"
#define NETWORK_URL_V2 @"devapi.demo.com"
#endif
@interface CheckNetwork : NSObject
{
	
}

DEFINE_SINGLETON_FOR_HEADER(CheckNetwork);

@property (nonatomic)BOOL isUseViaWWAN;

-(BOOL)isExistenceNetwork;
-(BOOL)isExistenceNetworkAndWarning;
- (NetworkStatus)currntNetworkType;
- (void)registerNetworkNotice;
- (NSString *)getIsUse3G;
- (void)setIsUse3G:(NSNumber *)isUse3G;

@end
