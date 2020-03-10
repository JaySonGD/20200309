//
//  WeChatManager.h
//  LeSyncDemo
//
//  Created by 柏富茯 on 2018/8/15.
//  Copyright © 2018年 winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WeChatManager : NSObject<WXApiDelegate>
+ (WeChatManager*) singleton;
@property (nonatomic,weak)UINavigationController *nav;
- (void)loginByWechat;
@end

