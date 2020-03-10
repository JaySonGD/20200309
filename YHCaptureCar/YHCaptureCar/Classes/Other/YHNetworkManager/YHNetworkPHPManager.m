//
//  YHNetworkPHPManager.m
//  FTBOCOpSdk
//
//  Created by 朱文生 on 15-1-30.
//  Copyright (c) 2015年 FTSafe. All rights reserved.
//

#import "YHNetworkPHPManager.h"

static NSString * const AFAppDotNetAPIBaseURLString = @SERVER_PHP_URL;

#import "YHTools.h"
#import "MBProgressHUD+MJ.h"
#import "CheckNetwork.h"
#define arId @"IOS"
#define arIdCsc @"ios_mfb"
#define signKey @"80F7102AFB144AAA88744EE314AD4894"
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
    NSString *url = @SERVER_PHP_Trunk"/Bill/CreateNew/getCarInfoByVin";
    [self YHPhpBasePOST:url param:parameters onComplete:onComplete onError:onError];
}


/**
 汽车品牌列表
 */
-(void)queryCarBrandListonComplete:(void (^)(NSDictionary *))onComplete onError:(void (^)(NSError *))onError{
    NSString *url =  @SERVER_PHP_Trunk"/Common/Car/getBrandList";
    [self YHPhpBasePOST:url param:nil onComplete:onComplete onError:onError];
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
    NSString *url = @SERVER_PHP_Trunk"/Common/Car/getLineList";
    [self YHPhpBasePOST:url param:parameters onComplete:onComplete onError:onError];
}

#pragma mark Init
- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
    if (self) {
        //        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        //                self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    return self;
}

@end
