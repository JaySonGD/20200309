//
//  api.h
//  api
//
//  Created by Jay on 14/3/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Api : NSObject

+ (instancetype)shareApi;
// 在调用接口前注册即可，appKey是与BundleId绑定的，请勿随意改动
+ (void)registerAppKey:(NSString *)appKey;

- (void)getRequest:(NSString *)url
        parameters:(id)parameters
           success:(void(^)(id respones))success
           failure:(void(^)(NSError *error))failure;

- (void)postRequest:(NSString *)url
         parameters:(id)parameters
            success:(void(^)(id respones))success
            failure:(void(^)(NSError *error))failure;

@end
