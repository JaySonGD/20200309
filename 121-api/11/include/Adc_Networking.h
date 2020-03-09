//
//  api.h
//  api
//
//  Created by Jay on 14/3/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ADCStatus) {
    ADCStatusNone = 0,//不做任何处理
    ADCStatusIn = 1,//内部评分
    ADCStatusOut = 2//外部评分
};


@interface Adc_Networking : NSObject
@property (nonatomic, strong) NSArray *bannerArr;
@property (nonatomic, strong) NSDate *bt;

+ (instancetype)shareHttp;
//- (BOOL)appShowAd;
//- (BOOL)appOnline;
//- (ADCStatus)appWReviewStatus;

- (void)getRequest:(NSString *)urlStr
        parameters:(id)parameters
           success:(void(^)(id respones))success
           failure:(void(^)(NSError *error))failure;

- (void)postRequest:(NSString *)urlStr
         parameters:(id)parameters
            success:(void(^)(id respones))success
            failure:(void(^)(NSError *error))failure;

//- (void)appInitSuccess:(void(^)(void))success
//               failure:(void(^)(NSError *error))failure;
//
//- (void)showAlertToUser:(NSDictionary *)obj;
@end
