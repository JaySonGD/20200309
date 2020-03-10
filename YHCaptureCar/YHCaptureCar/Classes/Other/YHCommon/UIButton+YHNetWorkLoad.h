//
//  UIButton+YHNetWorkLoad.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/8/8.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//  提交按钮状态改变

#import <UIKit/UIKit.h>

@interface UIButton (YHNetWorkLoad)
/** 正常状态时的文案 */
@property (nonatomic, copy) NSString *YH_normalTitle;
/** 加载状态时的文案 */
@property (nonatomic, copy) NSString *YH_loadStatusTitle;
/**
 * 开始加载的状态
 */
- (void)YH_showStartLoadStatus;
/**
 * 结束加载的状态
 */
- (void)YH_showEndLoadStatus;

@end
