//
//  YHTestOldPhoneViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/10/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHTestOldPhoneViewController.h"
#import "YHChangePhoneViewController.h"
#import "YHTools.h"
#import "YHNetworkManager.h"

@interface YHTestOldPhoneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *msgRemindL;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *getAgainL;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

//记录后台返回验证码
@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger countTime;

@end

@implementation YHTestOldPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - mark - 初始化UI
- (void)initUI{
    NSString *phone = [YHTools getName];
    if (!IsEmptyStr(phone)&&(phone.length >= 11)) {
        self.msgRemindL.text = [NSString stringWithFormat:@"短信将发送至%@****%@",[phone substringWithRange:NSMakeRange(0, 3)],[phone substringWithRange:NSMakeRange(7, 4)]];
    }
    
    self.getAgainL.hidden = YES;
}

#pragma mark - 获取验证码
- (IBAction)getVerificationCode:(UIButton *)sender {
    WeakSelf;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] sendVerifyCodeWithToken:[YHTools getAccessToken]
                                                                  Type:@"2"
                                                                mobile:[YHTools getName]
                                                            onComplete:^(NSDictionary *info)
     {
         NSLog(@"-----===%@+++%@===------",info,info[@"retMsg"]);
         [MBProgressHUD hideHUDForView:weakSelf.view];

         if ([info[@"retCode"]isEqualToString:@"0"]) {
             weakSelf.verifyCode = [NSString stringWithFormat:@"%@",info[@"result"][@"verifyCode"]];
             [MBProgressHUD showSuccess:@"获取验证码成功"];
             [weakSelf setUpTimer];
         }else{
             [MBProgressHUD showError:info[@"retMsg"]];
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:weakSelf.view];
     }];
}

- (void)setUpTimer{
    self.getVerificationCodeBtn.enabled = NO;
    self.countTime = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(backCountTime) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)backCountTime{
    self.countTime -= 1;
    if (self.countTime == 0) {
        self.getVerificationCodeBtn.enabled = YES;
        [self.getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getVerificationCodeBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    self.getVerificationCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%ld)",(long)self.countTime];
    [self.getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ld)",(long)self.countTime] forState:UIControlStateDisabled];
}

#pragma mark - 下一步
- (IBAction)nextStep:(UIButton *)sender {
    if ([self.verificationCodeTF.text isEqualToString:self.verifyCode]) {
        YHChangePhoneViewController *controller = [[UIStoryboard storyboardWithName:@"YHChangePhone" bundle:nil] instantiateViewControllerWithIdentifier:@"YHChangePhoneViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        self.getAgainL.hidden = NO;
        [MBProgressHUD showError:@"验证码有误，请重新填写"];
    }
}

#pragma mark - ---------------------------代理方法----------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.verificationCodeTF) {
        if (textField.text.length >= 0) {
            self.nextStepBtn.backgroundColor = YHNaviColor;
        }else{
            self.nextStepBtn.backgroundColor = YHLightGrayColor;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.verificationCodeTF) {
        if (textField.text.length != 0 ) {
            self.nextStepBtn.backgroundColor = YHNaviColor;
        }else{
            self.nextStepBtn.backgroundColor = YHLightGrayColor;
        }
    }
}

@end
