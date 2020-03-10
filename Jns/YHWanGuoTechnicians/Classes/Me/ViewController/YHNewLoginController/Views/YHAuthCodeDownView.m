//
//  YHAuthCodeDownView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAuthCodeDownView.h"
#import "YHAuthCodeInputView.h"
#import "YHStoreTool.h"
#import "YHCommon.h"
//#import "MBProgressHUD+MJ.h"
#import "VerCodeView.h"
#import <IQKeyboardManager.h>

static NSString *authCodeSuccess_notification = @"authCodeSuccess_notification";

@interface YHAuthCodeDownView ()

@property (nonatomic, weak) UIImageView *authImageV;

//@property (nonatomic, weak) YHAuthCodeInputView *inputSourceView;
@property (nonatomic, weak) VerCodeView *codeView;

@end

@implementation YHAuthCodeDownView

- (instancetype)init{
    if (self = [super init]) {
        [self initAuthCodeDownView];
    }
    return self;
}
- (void)initAuthCodeDownView{
    
    UIImageView *authImageV = [[UIImageView alloc] init];
    self.authImageV = authImageV;
    UIImage * authCodeImage = [YHStoreTool ShareStoreTool].authCodeImage;
    if (authCodeImage) {
        authImageV.image = authCodeImage;
    }
    authImageV.backgroundColor = [UIColor greenColor];
    [self addSubview:authImageV];
    [authImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@27);
        make.centerX.equalTo(authImageV.superview);
        make.width.equalTo(@120);
        make.height.equalTo(@50);
    }];
    
    UIButton *refreshBtn = [[UIButton alloc] init];
    [refreshBtn addTarget:self action:@selector(refreshBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn setImage:[UIImage imageNamed:@"refresh_login"] forState:UIControlStateNormal];
    [self addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(authImageV.mas_centerY);
        make.left.equalTo(authImageV.mas_right).offset(15);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
//    YHAuthCodeInputView *inputSourceView = [[YHAuthCodeInputView alloc] init];
//    self.inputSourceView = inputSourceView;
//    [self addSubview:inputSourceView];
//    [inputSourceView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(authImageV.mas_bottom).offset(20);
//        make.width.equalTo(@239);
//        make.height.equalTo(@55);
//        make.centerX.equalTo(inputSourceView.superview);
//    }];
    
    
    VerCodeView *codeView = [[VerCodeView alloc] initWithFrame:CGRectMake(0, 97, 330, 55)];
    [self addSubview:codeView];
    _codeView = codeView;
    codeView.maxLenght = 4;
    codeView.pointColor = YHNaviColor;
    codeView.keyBoardType = UIKeyboardTypeDefault;
    [codeView verCodeViewWithMaxLenght];
    __weak typeof(self) weakSelf = self;
    codeView.block = ^(NSString *text){
        NSLog(@"text = %@",text);
        if (text.length == 4) {
            [weakSelf goToCheckAuthCodeIsTure:text];
        }
    };
//    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(authImageV.mas_bottom).offset(20);
//        make.width.equalTo(@239);
//        make.height.equalTo(@55);
//        make.centerX.equalTo(codeView.superview);
//    }];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

}

- (void)goToCheckAuthCodeIsTure:(NSString *)codeStr{
    
    [MBProgressHUD showMessage:@"" toView:self];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] checkAuthCodeIsTure:codeStr onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self];
        
        int code = [info[@"code"] intValue];
        NSString *msg = info[@"msg"];
        if (code == 20000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:authCodeSuccess_notification object:nil];
        }else{
            [self.codeView resetCode];
            [MBProgressHUD showError:msg toView:[UIApplication sharedApplication].keyWindow];
        }
        NSLog(@"%@",info);
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - 刷新验证码 ---
- (void)refreshBtnEvent{
    
    [self getAuthCodeImage];
}
- (void)getAuthCodeImage{
    
    [MBProgressHUD showMessage:@"" toView:self];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getAuthCodeImageOnComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self];
        int code = [info[@"code"] intValue];
        if (code == 20000) {
            NSDictionary *data = info[@"data"];
            NSString *verify_img = data[@"verify_img"];
            NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:verify_img options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
            // 将NSData转为UIImage
            UIImage *decodedImage = [UIImage imageWithData: decodeData];
            [[YHStoreTool ShareStoreTool] setAuthCodeImage:decodedImage];
             self.authImageV.image = decodedImage;
        }else{
            [MBProgressHUD showError:@"获取验证码图片失败" toView:[UIApplication sharedApplication].keyWindow];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (void)dealloc{
    
     [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

@end
