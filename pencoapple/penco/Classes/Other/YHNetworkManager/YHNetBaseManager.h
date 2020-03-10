//
//  YHNetBaseManager.h
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/29.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "YHCommon.h"
#define arId @"ios"

@interface YHNetBaseManager : AFHTTPSessionManager

/**
 
 **/
- (void)YHBasePOST:(NSString *)URLString
             param:(NSDictionary *)param
        onComplete:(void (^)(NSDictionary *info))onComplete
           onError:(void (^)(NSError *error))onError;


/**
 get
 **/
- (void)YHBaseGet:(NSString *)URLString
            param:(NSDictionary *)param
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;


- (void)YHBasePUT:(NSString *)URLString
            param:(NSDictionary *)param
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;


- (void)YHBaseDELETE:(NSString *)URLString
               param:(NSDictionary *)param
          onComplete:(void (^)(NSDictionary *info))onComplete
             onError:(void (^)(NSError *error))onError;

@end
