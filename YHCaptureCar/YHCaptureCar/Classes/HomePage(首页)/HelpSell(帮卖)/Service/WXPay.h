//
//  WXPay.h
//  YHCaptureCar
//
//  Created by Jay on 28/4/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface WXPay : NSObject
DEFINE_SINGLETON_FOR_HEADER(WXPay);

- (void)payByPrepayId:(NSString*)prepayId
              success:(void (^)(void))success
              failure:(void (^)(void))failure;

- (void)payTestSuccess:(void (^)(void))success
               failure:(void (^)(void))failure;

- (void)payByParameter:(NSDictionary*)info
               success:(void (^)(void))success
               failure:(void (^)(void))failure;
#pragma mark - 支付报告费(MWF)
/*
 partnerId   商户号
 prepayId   微信返回的预支付id
 package  商家根据财付通文档填写的数据和签名
 nonceStr  随机字符串
 timeStamp  时间戳
 sign  商家根据微信开放平台文档对数据做的签名
 */
- (void)payWithDict:(NSDictionary *)info
            success:(void (^)(void))success
            failure:(void (^)(void))failure;
@end
