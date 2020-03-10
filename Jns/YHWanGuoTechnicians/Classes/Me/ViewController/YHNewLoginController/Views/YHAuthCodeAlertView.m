//
//  YHAuthCodeAlertView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAuthCodeAlertView.h"
#import "YHAuthCodeUpView.h"
#import "YHAuthCodeDownView.h"

@implementation YHAuthCodeAlertView

- (instancetype)init{
    if (self = [super init]) {
        [self initBase];
        [self initAuthCodeAlertView];
    }
    return self;
}
- (void)initBase{
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.masksToBounds = YES;
    
}
- (void)initAuthCodeAlertView{
    
    YHAuthCodeUpView *upView = [[YHAuthCodeUpView alloc] init];
    [self addSubview:upView];
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(upView.superview);
        make.height.equalTo(@58);
    }];
    
    YHAuthCodeDownView *downView = [[YHAuthCodeDownView alloc] init];
    [self addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_bottom);
        make.width.equalTo(upView);
        make.left.equalTo(@0);
        make.bottom.equalTo(downView.superview);
    }];
    
}
@end
