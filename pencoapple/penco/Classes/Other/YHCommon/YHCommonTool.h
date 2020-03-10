//
//  YHCommonTool.h
//  YHCaptureCar
//
//  Created by liusong on 2018/5/2.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UINetLimitStatus) {
  
    UINetLimitStatusRestricted, // 拒绝状态
    UINetLimitStatusNotRestricted, // 没有拒绝
    UINetLimitStatusRestrictedStateUnknown // 未知
};


@interface YHCommonTool : NSObject


@property (nonatomic,readonly,assign) UINetLimitStatus CurrentNetLimitStatus;
/**
 * 获取单例对象
 */
+ (instancetype)ShareCommonTool;

/**
 *  根据状态初始化单例
 */
+ (instancetype)ShareCommonToolWithRestrictedStatus: (void(^)(void))restrictBlock notRestrictedStatus:(void(^)(void))notRestrictBlock unKnowStatus:(void(^)(void))unKnowBlock;
/**
 * 执行默认状态下的弹框
 */
+ (instancetype)ShareCommonToolDefaultCurrentController:(UIViewController *)currentVc;

@end
