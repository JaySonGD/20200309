//
//  RRHttp.h
//  test
//
//  Created by Jay on 25/2/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRHttp : NSObject

+ (instancetype)shareHttp;

- (void)getRequest:(NSString *)urlStr
        parameters:(id)parameters
           success:(void(^)(id respones))success
           failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
