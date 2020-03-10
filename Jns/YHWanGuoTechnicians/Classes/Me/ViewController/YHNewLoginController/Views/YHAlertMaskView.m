//
//  YHAlertMaskView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAlertMaskView.h"
#import "YHAuthCodeAlertView.h"
#import "AppDelegate.h"
#import "YHAlertViewBackGroundView.h"

@interface YHAlertMaskView ()

@property (nonatomic, weak) UIView *baseView;

@end

@implementation YHAlertMaskView

static UIView *baseView_;

+ (void)showToView:(UIView *)view{
    
    [YHAlertMaskView dismisssView];
    
    baseView_ = view;
    YHAlertViewBackGroundView *maskBackGroundView = [[YHAlertViewBackGroundView alloc] init];
    [view addSubview:maskBackGroundView];
}

+ (void)dismisssView{
    
    if (!baseView_) {
        return;
    }
    
    for (int i = 0; i<baseView_.subviews.count; i++) {
        UIView *subView = baseView_.subviews[i];
        if ([subView isKindOfClass:NSClassFromString(@"YHAlertViewBackGroundView")]) {
            [subView removeFromSuperview];
        }
    }
    baseView_ = nil;
}
@end
