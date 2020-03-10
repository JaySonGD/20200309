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
//#import "MBProgressHUD+MJ.h"
NSString *const notificationReloadLoginInfo = @"YHNnotificationReloadLoginInfo";
@implementation YHNetBaseManager
#pragma mark POST
/**
 
 **/
- (void)YHBasePOST:(NSString *)URLString
             param:(NSDictionary *)param
        onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError{

   NSLogNoTime(@"AAA-------post调用接口是----%@%@",self.baseURL,URLString);
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
 get
 **/
- (void)YHBaseGet:(NSString *)URLString
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError{
    NSLogNoTime(@"AAA-------get调用接口是----%@%@",self.baseURL,URLString);
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
        if ([((NSString*)retCode) isEqualToString:LoginTimeout]){
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
            return YES;
        }
    }
    return NO;
}
@end
