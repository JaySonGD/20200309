//
//  YHAlertViewBackGroundView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAlertViewBackGroundView.h"
#import "YHAuthCodeAlertView.h"

@implementation YHAlertViewBackGroundView

- (instancetype)init{
    if (self = [super init]) {
        [self initAlertViewBackGroundView];
    }
    return self;
}
- (void)initAlertViewBackGroundView{
    
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.backgroundColor = [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:0.7];
    
    YHAuthCodeAlertView *alertView = [[YHAuthCodeAlertView alloc] init];
    alertView.layer.cornerRadius = 10.0;
    alertView.layer.masksToBounds = YES;
    [self addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(alertView.superview);
        make.width.equalTo(@330);
        make.height.equalTo(@230);
    }];
    
}
@end
