//
//  AppDelegate.h
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/8.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)NSDictionary *loginInfo;
@property (nonatomic)BOOL isLogining;
@property (strong, nonatomic)NSDictionary *userInfo;
@property (nonatomic)BOOL allowRotation;

@property (nonatomic, copy) void(^handler)(void);

/** 推送信息 */
@property (nonatomic, strong) NSDictionary * remoteNotificationInfo;

@end

