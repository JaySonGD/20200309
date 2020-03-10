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
NSString *const notificationReloadLoginInfo = @"YHNnotificationReloadLoginInfo";
@implementation YHNetBaseManager


/**
 PHP
 post
 **/
- (void)YHPhpBasePOST:(NSString *)URLString
             param:(NSDictionary *)param
        onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
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
                     onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"登录过期！"}]);
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
         NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
#endif
         if (onError) {
             onError(error);
         }
     }];
#endif
}


/**
 php
 get
 **/
- (void)YHPhpBaseGet:(NSString *)URLString
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查网络！",@"info" : @"请检查网络！"}]);
            [MBProgressHUD showError:@"请检查网络！"];
        }
        return;
    }
#ifdef NetworkTest
    if (onComplete) {
        onComplete(@{@"retCode" : @"0"});
    }
#else
    [self GET:URLString
   parameters:nil
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
                      onError([NSError errorWithDomain:@"" code:0xFFFF userInfo:@{@"message" : @"登录过期！"}]);
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
          NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
#endif
          if (onError) {
              onError(error);
          }
      }];
#endif
}


#pragma mark POST
/**
 
 **/
- (void)YHBasePOST:(NSString *)URLString
             param:(NSDictionary *)param
        onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查您网络！",@"info" : @"请检查您网络！"}]);
            [MBProgressHUD showError:@"请检查您网络！"];
        }
        return;
    }
#ifdef NetworkTest
    if (onComplete) {
        onComplete(@{@"retCode" : @"0"});
    }
#else
    
    NSString *buildTimeStr = buildTime;
    NSMutableDictionary *paramMu = [param mutableCopy];
    [paramMu setObject:arId forKey:@"accId"];
    [paramMu setObject:buildTimeStr forKey:@"time"];
    NSString *data = [YHTools data2jsonString:paramMu];
    NSString *contentStr = [NSString stringWithFormat:@"%@%@", data, signKey];
    NSString *MD5Sign = [YHTools md5:contentStr];
    YHLog(@"parameters : %@", [NSString stringWithFormat:@"%@%@", data, MD5Sign]);
    
    NSLog(@"==========>%@<==========>%@<=================",URLString,@{@"reqData" : [NSString stringWithFormat:@"%@%@", data, MD5Sign]});
    
    [self
     POST:URLString
     parameters:@{@"reqData" : [NSString stringWithFormat:@"%@%@", data, MD5Sign]}
     progress:nil
     success:^(NSURLSessionDataTask * __unused task, NSDictionary *responseObject) {
         if (responseObject == nil) {
             if (onError) {
                 onError([NSError errorWithDomain:@"" code:0x2 userInfo:@{@"message" : @"请求Error"}]);
             }
         }else{
             [self networkServiceCenter:responseObject];
             if (onComplete) {
                 onComplete(responseObject);
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
         NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
#endif
         if (onError) {
             onError(error);
         }
     }];
#endif
}


/**
 get
 **/
- (void)YHBaseGet:(NSString *)URLString
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    if(![[CheckNetwork sharedCheckNetwork] isExistenceNetwork]){
        if (onError) {
            onError([NSError errorWithDomain:@"" code:0xFFFFFFF8 userInfo:@{@"message" : @"请检查您网络！",@"info" : @"请检查您网络！"}]);
            [MBProgressHUD showError:@"请检查您网络！"];
        }
        return;
    }
#ifdef NetworkTest
    if (onComplete) {
        onComplete(@{@"retCode" : @"0"});
    }
#else
    [self GET:URLString
   parameters:nil
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
          NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
#endif
          if (onError) {
              onError(error);
          }
      }];
#endif
}


//登录过期
- (bool)networkServiceCenter:(NSDictionary*)responseObject{
    NSString *retCode = responseObject[@"retCode"];
    if (!retCode) {
        retCode = responseObject[@"code"];
    }
    
    if ([retCode isKindOfClass:[NSNumber class]]) {
        if (((NSNumber*)retCode).integerValue == 40100
            ){
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
            return YES;
        }
    }
    if ([retCode isKindOfClass:[NSString class]]) {
        if ([((NSString*)retCode) isEqualToString:LoginTimeout] || [((NSString*)retCode) isEqualToString:UserException]){
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
            return YES;
        }
    }
    return NO;
}

@end
