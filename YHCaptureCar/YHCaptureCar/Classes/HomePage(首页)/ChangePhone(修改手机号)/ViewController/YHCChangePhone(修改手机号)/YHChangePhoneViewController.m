//
//  YHChangePhoneViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/10/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHChangePhoneViewController.h"
#import "YHTools.h"
#import "YHNetworkManager.h"
#import "YHHomeViewController.h"

@interface YHChangePhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *newlyPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;

//记录后台返回验证码
@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, copy) NSString *previousTextFieldContent;
@property (nonatomic, strong) UITextRange *previousSelection;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger countTime;
@property (nonatomic, copy) NSString *inputStr;

@end

@implementation YHChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.newlyPhoneTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self textChange:self.newlyPhoneTF];
}

#pragma mark - 获取验证码
- (IBAction)getVerificationCode:(UIButton *)sender {
    NSString *mobile;
    if ([self.newlyPhoneTF.text containsString:@" "]) {
        mobile = [self.newlyPhoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else{
        mobile = self.newlyPhoneTF.text;
    }
    
    if (mobile.length != 11) {
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        return;
    }else{
        if (![[mobile substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"请输入正确的手机号码"];
            return;
        }
    }
    
    WeakSelf;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] sendVerifyCodeWithToken:[YHTools getAccessToken]
                                                                  Type:@"3"
                                                                mobile:mobile
                                                            onComplete:^(NSDictionary *info)
     {
         NSLog(@"-----===%@+++%@===------",info,info[@"retMsg"]);
         [MBProgressHUD hideHUDForView:weakSelf.view];
         if ([info[@"retCode"]isEqualToString:@"0"]) {
             [MBProgressHUD showSuccess:@"获取验证码成功"];
             weakSelf.verifyCode = [NSString stringWithFormat:@"%@",info[@"result"][@"verifyCode"]];
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

#pragma mark - 提交
- (IBAction)commit:(UIButton *)sender {
    
    NSString *mobile;
    if ([self.newlyPhoneTF.text containsString:@" "]) {
        mobile = [self.newlyPhoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else{
        mobile = self.newlyPhoneTF.text;
    }
    
    if (mobile.length != 11) {
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        return;
    }else{
        if (![[mobile substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"请输入正确的手机号码"];
            return;
        }else{
            if (![self.verificationCodeTF.text isEqualToString:self.verifyCode]) {
                [MBProgressHUD showError:@"请输入正确的验证码"];
                return;
            }
        }
    }
    
    WeakSelf;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager]updatePhoneWithToken:[YHTools getAccessToken]
                                                            mobile:mobile
                                                        verifyCode:self.verificationCodeTF.text
                                                        onComplete:^(NSDictionary *info)
    {
        NSLog(@"-----===%@+++%@===------",info,info[@"retMsg"]);
        
        [MBProgressHUD hideHUDForView:weakSelf.view];

        if ([info[@"retCode"]isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [YHTools setName:mobile];
            for (UIViewController *VC in weakSelf.navigationController.viewControllers) {
                if ([VC isKindOfClass:[YHHomeViewController class]]) {
                    [weakSelf.navigationController popToViewController:VC animated:YES];
                }
            }
        }else{
            [MBProgressHUD showError:info[@"result"][@"msg"]];
        }
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - ---------------------------代理方法----------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.newlyPhoneTF) {
        self.inputStr = string;
        self.previousTextFieldContent = textField.text;
        self.previousSelection = textField.selectedTextRange;
        if (self.newlyPhoneTF.text.length <= 13) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)textChange:(UITextField *)phoneTF{
    [self formatPhoneNumber:phoneTF];
}

- (void)formatPhoneNumber:(UITextField*)textField
{
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSLog(@"targetCursorPosition:%li", (long)targetCursorPosition);
    // nStr表示不带空格的号码
    NSString* nStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* preTxt = [self.previousTextFieldContent stringByReplacingOccurrencesOfString:@" "
                                                                                withString:@""];
    char editFlag = 0;// 正在执行删除操作时为0，否则为1
    
    if (nStr.length <= preTxt.length) {
        editFlag = 0;
    }
    else {
        editFlag = 1;
    }
    
    // textField设置text
    if (nStr.length > 11)
    {
        textField.text = self.previousTextFieldContent;
        textField.selectedTextRange = self.previousSelection;
        return;
    }
    
    // 空格
    NSString* spaceStr = @" ";
    
    NSMutableString* mStrTemp = [NSMutableString new];
    int spaceCount = 0;
    if (nStr.length < 3 && nStr.length > -1)
    {
        spaceCount = 0;
    }else if (nStr.length < 7 && nStr.length >2)
    {
        spaceCount = 1;
        
    }else if (nStr.length < 12 && nStr.length > 6)
    {
        spaceCount = 2;
    }
    
    for (int i = 0; i < spaceCount; i++)
    {
        if (i == 0) {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(0, 3)], spaceStr];
        }else if (i == 1)
        {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(3, 4)], spaceStr];
        }else if (i == 2)
        {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
        }
    }
    
    if (nStr.length == 11)
    {
        [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
    }
    
    if (nStr.length < 4)
    {
        [mStrTemp appendString:[nStr substringWithRange:NSMakeRange(nStr.length-nStr.length % 3,
                                                                    nStr.length % 3)]];
    }else if(nStr.length > 3)
    {
        NSString *str = [nStr substringFromIndex:3];
        [mStrTemp appendString:[str substringWithRange:NSMakeRange(str.length-str.length % 4,
                                                                   str.length % 4)]];
        if (nStr.length == 11)
        {
            [mStrTemp deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    NSLog(@"=======mstrTemp=%@",mStrTemp);
    
    textField.text = mStrTemp;
    // textField设置selectedTextRange
    NSUInteger curTargetCursorPosition = targetCursorPosition;// 当前光标的偏移位置
    if (editFlag == 0)
    {
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4)
        {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }
    else {
        //添加
        if (nStr.length == 8 || (nStr.length == 3 && [self.inputStr isEqualToString:@""] && preTxt.length == 2) || (nStr.length == 4 && ![self.inputStr isEqualToString:@""] && preTxt.length == 3))
        {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
        
    }
    
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument]
                                                              offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition
                                                         toPosition :targetPosition]];
}

@end
