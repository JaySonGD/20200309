//
//  ZZSubmitDataService.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 27/11/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TTZSYSModel;
@interface ZZSubmitDataService : NSObject
+ (void)saveInitialSurveyForBillId:(NSString *)billid
                          billType:(NSString *)type
                        submitData:(NSMutableArray<TTZSYSModel *>*)data
                          baseInfo:(NSDictionary *)info
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure;

+ (NSMutableArray *)submitProjectVal:(NSMutableArray  <TTZSYSModel *>*)resultArr with:(NSString *)type;


@end

NS_ASSUME_NONNULL_END
