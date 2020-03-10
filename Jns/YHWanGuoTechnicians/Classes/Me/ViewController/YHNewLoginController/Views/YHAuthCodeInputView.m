//
//  YHAuthCodeInputView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAuthCodeInputView.h"
#import "YHAuthCodeTextFiled.h"
//#import "MBProgressHUD+MJ.h"

static NSString *authCodeSuccess_notification = @"authCodeSuccess_notification";

@interface YHAuthCodeInputView () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *authCodeTextFieldArr;

@property (nonatomic, copy) NSString *codeStr;

@end

@implementation YHAuthCodeInputView

- (instancetype)init{
    if (self = [super init]) {
        [self initAuthCodeDownView];
    }
    return self;
}
- (void)initAuthCodeDownView{
    
    NSMutableArray *authCodeArr = [NSMutableArray array];
    self.authCodeTextFieldArr = authCodeArr;
    for (int i = 0; i< 4; i++) {
        
        YHAuthCodeTextFiled *authCodeTft = [[YHAuthCodeTextFiled alloc] init];
        authCodeTft.textAlignment = NSTextAlignmentCenter;
        authCodeTft.layer.cornerRadius = 10.0;
        authCodeTft.layer.masksToBounds = YES;
        authCodeTft.layer.borderColor = [UIColor blackColor].CGColor;
        authCodeTft.layer.borderWidth = 1.0;
        [self addSubview:authCodeTft];
        [authCodeTft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(authCodeTft.superview);
            make.top.equalTo(@0);
            make.left.equalTo(@(i*(50 + 13)));
        }];
        authCodeTft.delegate = self;
        [self.authCodeTextFieldArr addObject:authCodeTft];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
   BOOL isComplete = [self checkIsInputComplete];
    if (isComplete) {
        // 去验证
        [self goToCheckAuthCodeIsTure:self.codeStr];
    }
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
- (void)clearAuthCode{
    
    for (YHAuthCodeTextFiled *textFiled in self.authCodeTextFieldArr) {
        textFiled.text = nil;
    }
}
- (BOOL)checkIsInputComplete{
    
    NSMutableString *codeStr = [NSMutableString string];
    BOOL isComplete = YES;
    for (YHAuthCodeTextFiled *textFiled in self.authCodeTextFieldArr) {
        if (textFiled.text.length == 0) {
            isComplete = NO;
            codeStr = nil;
            break;
        }
        [codeStr appendString:textFiled.text];
    }
    self.codeStr = [codeStr copy];
    return isComplete;
}
@end
