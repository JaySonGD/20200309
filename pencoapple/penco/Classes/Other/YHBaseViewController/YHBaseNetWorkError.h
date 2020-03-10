//
//  YHBaseNetWorkError.h
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/21.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHBaseNetWorkError : NSObject

//单点登录判断
- (bool)sso:(NSString*)retCode;

//登录过期
- (bool)networkServiceCenter:(NSNumber*)retCode;
@end
