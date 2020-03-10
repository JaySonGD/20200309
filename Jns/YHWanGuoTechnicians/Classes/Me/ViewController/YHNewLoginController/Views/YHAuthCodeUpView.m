//
//  YHAuthCodeUpView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAuthCodeUpView.h"
#import "YHAlertMaskView.h"

@implementation YHAuthCodeUpView

- (instancetype)init{
    if (self = [super init]) {
        [self initAuthCodeUpView];
    }
    return self;
}
- (void)initAuthCodeUpView{
    
    UIImageView *promptImageV = [[UIImageView alloc] init];
    promptImageV.image = [UIImage imageNamed:@"tips_login"];
    [self addSubview:promptImageV];
    [promptImageV sizeToFit];
    [promptImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(promptImageV.superview);
    }];
    
    UILabel *promptL = [[UILabel alloc] init];
    promptL.text = @"输入验证码";
    promptL.textColor = [UIColor blackColor];
    promptL.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:promptL];
    [promptL sizeToFit];
    [promptL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(promptImageV);
        make.left.equalTo(promptImageV.mas_right).offset(15);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(closeBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"close_page_login"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    [closeBtn sizeToFit];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(closeBtn.superview).offset(-20);
        make.centerY.equalTo(closeBtn.superview);
    }];
    
    UIView *seprateLine = [[UIView alloc] init];
    seprateLine.backgroundColor = [UIColor blackColor];
    [self addSubview:seprateLine];
    [seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.width.equalTo(seprateLine.superview);
        make.bottom.equalTo(seprateLine.superview);
        make.left.equalTo(@0);
    }];
}
- (void)closeBtnEvent{
    [YHAlertMaskView dismisssView];
}
@end
