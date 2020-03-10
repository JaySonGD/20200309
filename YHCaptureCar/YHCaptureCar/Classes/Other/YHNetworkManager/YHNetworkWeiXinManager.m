//
//  YHNetworkPHPManager.m
//  FTBOCOpSdk
//
//  Created by 朱文生 on 15-1-30.
//  Copyright (c) 2015年 FTSafe. All rights reserved.
//

#import "YHNetworkWeiXinManager.h"

#import "YHTools.h"
#import "MBProgressHUD+MJ.h"
#import "CheckNetwork.h"
#import "YHCommon.h"
#import "Constant.h"
#define arId @"ios"
#define arIdCsc @"ios_mfb"
//#define AppCode @"6627ed9c7b7f404f8bfe3d142fa43081"
#define AppCode @"944a5013e98c459e80d33d3474c4f9b6"
static NSString * const AFAppDotNetAPIBaseURLString = @SERVER_URL;
//#define NetworkTest
#define TestError
@interface YHNetworkWeiXinManager ()

@end


@implementation YHNetworkWeiXinManager
DEFINE_SINGLETON_FOR_CLASS(YHNetworkWeiXinManager);

+ (void)analysisVin:(NSData*)image onComplete:(void (^)(NSDictionary *info))onComplete
            onError:(void (^)(NSError *error))onError{
    
    NSString *appcode = AppCode;
    NSString *host = @"https://dm-53.data.aliyun.com";
    NSString *path = @"/rest/160601/ocr/ocr_vehicle.json";
    NSString *method = @"POST";
    NSString *querys = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    NSString *bodys = [NSString stringWithFormat:@"{\"inputs\":[{\"image\":{\"dataType\":50,\"dataValue\":\"%@\"}}]}", [image base64EncodedStringWithOptions: 0]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    //根据API的要求，定义相对应的Content-Type
    [request addValue: @"application/json; charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    NSData *data = [bodys dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: data];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       if (body) {
                                                           NSDictionary*dcit=[NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableLeaves error:nil];
                                                           if (onComplete) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   // 更UI
                                                                   onComplete(dcit);
                                                               });
                                                           }
                                                       }else{
                                                           if (onError) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   // 更UI
                                                                   onError(nil);
                                                               });
                                                           }
                                                       }
                                                   }];
    
    [task resume];
}



/**
 
 获取access_token
 
 **/

- (void)getAccessTokenByCode:(NSString*)code onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError{
    if (code == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"appid":kAppID, @"secret":kAppSecret,@"code":code,@"grant_type":@"authorization_code"};
    
    [self YHBasePOST:@"/sns/oauth2/access_token"param:parameters onComplete:onComplete onError:onError];
}

/**
 
刷新access_token
 
 **/

- (void)reAccessTokenByToken:(NSString*)refreshToken onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError{
    if (refreshToken == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    NSDictionary *parameters = @{@"appid":kAppID,@"refresh_token":refreshToken,@"grant_type":@"refresh_token"};
    
    [self YHBasePOST:@"/sns/oauth2/refresh_token"param:parameters onComplete:onComplete onError:onError];
}


/**
 
检查access_token
 
 **/

- (void)checkAccessToken:(NSString*)token byOpenid:(NSString*)openid onComplete:(void (^)(NSDictionary *info))onComplete
                     onError:(void (^)(NSError *error))onError{
    if (token == nil || openid == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSDictionary *parameters = @{@"access_token":token, @"openid":openid};
    
    [self YHBasePOST:@"/sns/auth"param:parameters onComplete:onComplete onError:onError];
}
/**
 
 获取微信用户个人信息
 
 **/

- (void)getWeixinUserInfo:(NSString*)token byOpenid:(NSString*)openid onComplete:(void (^)(NSDictionary *info))onComplete
                 onError:(void (^)(NSError *error))onError{
    if (token == nil || openid == nil) {
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0x00000001 userInfo:@{@"message" : @"参数非法！"}]);
        }
        return;
    }
    
    NSDictionary *parameters = @{@"access_token":token, @"openid":openid};
    
    [self YHBasePOST:@"/sns/userinfo"param:parameters onComplete:onComplete onError:onError];
}



#pragma mark Init
- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
    if (self) {
        //        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    return self;
}

@end
