//
//  YHNetBaseManager.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/29.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHNetBaseManager.h"
#import "CheckNetwork.h"
#import "YHCommon.h"
#import "MBProgressHUD+MJ.h"
#import "YHTools.h"
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
NSString *const notificationReloadLoginInfo = @"YHNnotificationReloadLoginInfo";
NSString *const notificationRefreshToken = @"notificationRefreshToken";
NSString *const notificationRefreshTokenDelegate = @"notificationRefreshTokenDelegate";
extern NSString *const notificationNoNetwork;
@implementation YHNetBaseManager


/**
 PHP
 post
 **/
- (void)YHBasePOST:(NSString *)URLString
                param:(NSDictionary *)param
           onComplete:(void (^)(NSDictionary *info))onComplete
              onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        if (onError) {
            onError(nil);
        }
        return;
    }
#ifdef NetworkTest
    if (onComplete) {
        onComplete(@{@"retCode" : @"0"});
    }
#else
    [self
     POST:URLString
     parameters:param
     progress:nil
     success:^(NSURLSessionDataTask * __unused task, NSDictionary *responseObject) {
         if (responseObject == nil) {
             if (onError) {
                 onError([NSError errorWithDomain:@"" code:0x2 userInfo:@{@"message" : @"请求Error"}]);
             }
         }else{
             
             if(![self networkServiceCenter:responseObject]){
                 if (onComplete) {
                     onComplete(responseObject);
                 }
             }else{
                 if (onError) {
//                     onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"登录过期！"}]);
                 }
             }
         }
     }
     failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         
#ifdef TestError
         NSDictionary *userInfo =error.userInfo;
         
         NSError *NSUnderlyingError = userInfo [@"NSUnderlyingError"];
         NSData *responseObject = error.userInfo[@"com.alamofire.serialization.response.error.data"];
         
         if (!responseObject) {
             responseObject = NSUnderlyingError.userInfo[@"com.alamofire.serialization.response.error.data"];
         }
         YHLog(@"url:%@ : %@ : %@", URLString, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding], error);
#endif
         if (onError) {
             [self errorTokenTimeout:error];
              onError(error);
         }
     }];
#endif
}


/**
 php
 get
 **/
- (void)YHBaseGet:(NSString *)URLString
            param:(NSDictionary *)param
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        if (onError) {
            onError(nil);
        }
        return;
    }
#ifdef NetworkTest
    if (onComplete) {
        onComplete(@{@"retCode" : @"0"});
    }
#else
    [self GET:URLString
   parameters:param
     progress:nil
      success:^(NSURLSessionDataTask * __unused task, NSDictionary *responseObject) {
          if (responseObject == nil) {
              if (onError) {
                  onError([NSError errorWithDomain:@"" code:0x2 userInfo:@{@"message" : @"请求Error"}]);
              }
          }else{
              if(![self networkServiceCenter:responseObject]){
                  if (onComplete) {
                      onComplete(responseObject);
                  }
              }else{
                  if (onError) {
//                      onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"登录过期！"}]);
                  }
              }
          }
      }
      failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
          
#ifdef TestError
          NSDictionary *userInfo =error.userInfo;
          
          NSError *NSUnderlyingError = userInfo [@"NSUnderlyingError"];
          NSData *responseObject = error.userInfo[@"com.alamofire.serialization.response.error.data"];
          
          if (!responseObject) {
              responseObject = NSUnderlyingError.userInfo[@"com.alamofire.serialization.response.error.data"];
          }
          YHLog(@"url:%@ : %@ : %@", URLString, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding], error);
#endif
          if (onError) {
              [self errorTokenTimeout:error];
              onError(error);
          }
      }];
#endif
}


//无网络通知
- (void)noNetwork{
//    [[NSNotificationCenter defaultCenter]postNotificationName:notificationNoNetwork object:Nil userInfo:nil];
}


//sdk的token过期
- (bool)networkServiceCenter:(NSDictionary*)responseObject{
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSNumber *code = responseObject[@"code"];
    if (code && (code.longLongValue == 31004
 || code.longLongValue == 31007 || code.longLongValue == 31002)) {
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
        return YES;
    }
    return NO;
}



//后台token过期
- (bool)errorTokenTimeout:(NSError*)error{
    
    
    NSDictionary *userInfo =error.userInfo;
    
    NSError *NSUnderlyingError = userInfo [@"NSUnderlyingError"];
    NSData *responseObject = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    
    if (!responseObject) {
        responseObject = NSUnderlyingError.userInfo[@"com.alamofire.serialization.response.error.data"];
    }
    
    NSDictionary *errorMsg = [YHTools dictionaryWithJsonString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
    
    
    if (![errorMsg isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSNumber *code = errorMsg[@"code"];
    if (code && (code.longLongValue == 10002 || code.longLongValue == 10001)) {
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationRefreshToken object:Nil userInfo:nil];
        return YES;
    }
    return NO;
}


/**
 PHP
 post
 **/
- (void)YHBasePUT:(NSString *)URLString
             param:(NSDictionary *)param
        onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        if (onError) {
            onError(nil);
        }
        return;
    }
#ifdef NetworkTest
    if (onComplete) {
        onComplete(@{@"retCode" : @"0"});
    }
#else
    [self
     PUT:URLString
     parameters:param
     success:^(NSURLSessionDataTask * __unused task, NSDictionary *responseObject) {
         if (responseObject == nil) {
             if (onError) {
                 onError([NSError errorWithDomain:@"" code:0x2 userInfo:@{@"message" : @"请求Error"}]);
             }
         }else{
             
             if(![self networkServiceCenter:responseObject]){
                 if (onComplete) {
                     onComplete(responseObject);
                 }
             }else{
                 if (onError) {
//                     onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"登录过期！"}]);
                 }
             }
         }
     }
     failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         
#ifdef TestError
         NSDictionary *userInfo =error.userInfo;
         
         NSError *NSUnderlyingError = userInfo [@"NSUnderlyingError"];
         NSData *responseObject = error.userInfo[@"com.alamofire.serialization.response.error.data"];
         
         if (!responseObject) {
             responseObject = NSUnderlyingError.userInfo[@"com.alamofire.serialization.response.error.data"];
         }
         YHLog(@"url:%@ : %@ : %@", URLString, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding], error);
#endif
         if (onError) {
             [self errorTokenTimeout:error];
              onError(error);
         }
     }];
#endif
}

/**
 PHP
 post
 **/
- (void)YHBaseDELETE:(NSString *)URLString
            param:(NSDictionary *)param
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        [self noNetwork];
        if (onError) {
            onError(nil);
        }
        return;
    }
#ifdef NetworkTest
    if (onComplete) {
        onComplete(@{@"retCode" : @"0"});
    }
#else
    [self
     DELETE:URLString
     parameters:param
     success:^(NSURLSessionDataTask * __unused task, NSDictionary *responseObject) {
         if (responseObject == nil) {
             if (onError) {
                 onError([NSError errorWithDomain:@"" code:0x2 userInfo:@{@"message" : @"请求Error"}]);
             }
         }else{
             
             if(![self networkServiceCenter:responseObject]){
                 if (onComplete) {
                     onComplete(responseObject);
                 }
             }else{
                 if (onError) {
//                     onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"登录过期！"}]);
                 }
             }
         }
     }
     failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         
#ifdef TestError
         NSDictionary *userInfo =error.userInfo;
         
         NSError *NSUnderlyingError = userInfo [@"NSUnderlyingError"];
         NSData *responseObject = error.userInfo[@"com.alamofire.serialization.response.error.data"];
         
         if (!responseObject) {
             responseObject = NSUnderlyingError.userInfo[@"com.alamofire.serialization.response.error.data"];
         }
         YHLog(@"url:%@ : %@ : %@", URLString, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding], error);
#endif
         if (onError) {
             [self errorTokenTimeout:error];
              onError(error);
         }
     }];
#endif
}


@end
