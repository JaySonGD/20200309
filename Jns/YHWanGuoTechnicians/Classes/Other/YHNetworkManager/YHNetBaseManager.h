//
//  YHNetBaseManager.h
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/29.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//


#import "AFHTTPSessionManager.h"

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
       onComplete:(void (^)(NSDictionary *info))onComplete
          onError:(void (^)(NSError *error))onError;

@end
