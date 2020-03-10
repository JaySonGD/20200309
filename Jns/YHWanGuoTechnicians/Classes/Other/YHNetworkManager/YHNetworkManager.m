//
//  YHNetworkPHPManager.m
//  FTBOCOpSdk
//
//  Created by 朱文生 on 15-1-30.
//  Copyright (c) 2015年 FTSafe. All rights reserved.
//

#import "YHNetworkManager.h"

#import "YHTools.h"
//#import "MBProgressHUD+MJ.h"
#import "CheckNetwork.h"
#import "YHCommon.h"
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

/*
 上传图片
 请求方式   POST
 
 http://192.168.1.248/btlmch/index.php
 */
- (void)updatePictureImageDate:(NSArray*)images onComplete:(void (^)(NSDictionary *info))onComplete onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
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
