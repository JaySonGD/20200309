//
//  YHRegisterController.m
//  YHCaptureCar
//
//  Created by Zhu Wensheng on 2018/1/9.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHRegisterController.h"
#import "YHCommon.h"
#import "SVProgressHUD.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "YHExamineStateController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "YHWebFuncViewController.h"
#import "YHSVProgressHUD.h"

#import "ZZCityListViewController.h"
#import "ZZCityModel.h"

@interface YHRegisterController ()


//账户名称
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;




//手机号
@property (weak, nonatomic) IBOutlet UITextField *iphoneNumberTF;

//验证码
@property (weak, nonatomic) IBOutlet UIView *verCodeBox;
@property (weak, nonatomic) IBOutlet UITextField *verCodeTF;

//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

//确认密码
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTF;

//商户名称
@property (weak, nonatomic) IBOutlet UITextField *userInfo1TF;

@property (weak, nonatomic) IBOutlet UITextField *userInfo2TF;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLHeight;

@property (weak, nonatomic) IBOutlet UIView *userNameBox;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameBoxHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userAndPhoneHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountInfoViewHeight;


@property (weak, nonatomic) IBOutlet UIView *phoneNumberBox;
@property (weak, nonatomic) IBOutlet UIView *passwordBox;
@property (weak, nonatomic) IBOutlet UIView *repasswordBox;
@property (weak, nonatomic) IBOutlet UIView *userInfo1Box;
@property (weak, nonatomic) IBOutlet UIView *userInfo2Box;
@property (weak, nonatomic) IBOutlet UIView *userInfo3Box;

@property (weak, nonatomic) IBOutlet UIButton *companyB;
@property (weak, nonatomic) IBOutlet UIButton *personB;
- (IBAction)typeActions:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *typeTiyleL;
@property (weak, nonatomic) IBOutlet UILabel *userInfo1FL;
@property (weak, nonatomic) IBOutlet UILabel *userInfo2FL;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreementLB;

@property (weak, nonatomic) IBOutlet UIButton *getVerCodeBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger countTime;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoBoxHeight;
@property (nonatomic, strong) ZZCityModel *cityModel;
@end

@implementation YHRegisterController

#pragma mark - -----------------获取验证码-------------------
- (IBAction)getRegisterVerCode:(id)sender {
    
    if (self.iphoneNumberTF.text.length == 0) {
        [MBProgressHUD showError:_iphoneNumberTF.placeholder];
        return;
    }
    // 检测手机号是否已注册
    [[YHNetworkManager sharedYHNetworkManager] checkMobileRepeatType:@"0" mobile:self.iphoneNumberTF.text onComplete:^(NSDictionary *info) {
        NSLog(@"-------获取验证码😁：%@--%@-------",info,info[@"retMsg"]);
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        if ([retCode isEqualToString:@"0"]) {
            NSDictionary *result = info[@"result"];
            NSString *flag = result[@"flag"];
            if ([flag isEqualToString:@"0"]) {
                [self getVerCodeMethod];
            }
            
            if ([flag isEqualToString:@"1"]) {
                // 已注册
                [MBProgressHUD showError:@"手机号码已存在"];
            }
        }if ([retCode isEqualToString:@"COMMON005"]) {
            [MBProgressHUD showError:@"手机号格式不正确"];
        }else{
            YHLogERROR(@"");
            [self showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)getVerCodeMethod{
    
    [SVProgressHUD showWithStatus:@"获取中..."];
    [[YHNetworkManager sharedYHNetworkManager] sendVerifyCodeType:@"0" mobile:self.iphoneNumberTF.text onComplete:^(NSDictionary *info) {
        [SVProgressHUD dismiss];
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        if ([retCode isEqualToString:@"0"]) { // 发送成功
            [self setUpTimer];
        }else{
            YHLogERROR(@"");
            [self showErrorInfo:info];
        }
        NSLog(@"----%@",info);
        
    } onError:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}

- (void)setUpTimer{
    
    self.getVerCodeBtn.enabled = NO;
    _countTime = 60;
    [self.getVerCodeBtn setTitle:[NSString stringWithFormat:@"%ldS",self.countTime] forState:UIControlStateDisabled];
    self.getVerCodeBtn.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    [self.getVerCodeBtn setTitleColor:[UIColor colorWithRed:0 green:173.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateDisabled];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(backCountTime) userInfo:nil repeats:YES];
    [self.timer fire];
}
#pragma mark - 倒计时 -----
- (void)backCountTime{
    _countTime--;
    if (_countTime == 0) {
        self.getVerCodeBtn.enabled = YES;
        [self.getVerCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getVerCodeBtn.backgroundColor =[UIColor colorWithRed:0 green:173.0/255.0 blue:1.0 alpha:1.0];
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    [self.getVerCodeBtn setTitle:[NSString stringWithFormat:@"%ldS",_countTime] forState:UIControlStateDisabled];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    CGRect frame =  _contentView.frame;
    frame.size.width = screenWidth;
//    frame.size.height = 500;
    _contentView.frame = frame;
    [_scrollV addSubview:_contentView];
    [_scrollV setContentSize:CGSizeMake(screenWidth, 540)];
    [@[_userNameBox, _phoneNumberBox,_verCodeBox, _passwordBox, _repasswordBox, _userInfo1Box, _userInfo2Box,_userInfo3Box]
     enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
         YHLayerBorder(view, YHLineColor, 1);
     }];
    
    NSString *text = @"我已阅读并同意《用户协议》";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:12.0]
                    range:NSMakeRange(0, text.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:YHColor0X(0x676767, 1.0)
                    range:NSMakeRange(0, text.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:YHNaviColor
                    range:[text rangeOfString:@"《用户协议》"]];

    self.agreementLB.attributedText = attrStr;
    [self.agreementLB yb_addAttributeTapActionWithStrings:@[@"《用户协议》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        NSLog(@"%s", __func__);
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YHWebFuncViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        controller.urlStr = [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk@"/registerProtocol.html"];
        controller.barHidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    
    
    self.userNameL.hidden = YES;
    self.userNameLHeight.constant = 0;

    self.userNameBox.hidden = YES;
    self.userNameBoxHeight.constant = 0;
    
    self.userAndPhoneHeight.constant = 0;
    
    self.accountInfoViewHeight.constant = 260;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)agreeAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

#pragma mark - -----------------提交-------------------
- (IBAction)loginAction:(id)sender {
    if (!self.agreeBtn.isSelected) {
        [MBProgressHUD showError:@"请勾选用户协议"];
        return;
    }
    
//    if (self.userNameTF.text.length == 0 ) {
//        [MBProgressHUD showError:_userNameTF.placeholder];
//        return;
//    }
    
    if (self.iphoneNumberTF.text.length == 0 ) {
        [MBProgressHUD showError:_iphoneNumberTF.placeholder];
        return;
    }
    if (self.verCodeTF.text.length == 0 ) {
        [MBProgressHUD showError:_verCodeTF.placeholder];
        return;
    }
    
    if (self.passwordTF.text.length == 0 ) {
        [MBProgressHUD showError:_passwordTF.placeholder];
        return;
    }
    
    //MWF
    if (![self isMatchPassWord:self.passwordTF.text]) {
        [MBProgressHUD showError:@"密码要求8-16位数字和字母组成"];
        return;
    }
    
    if (self.rePasswordTF.text.length == 0 ) {
        [MBProgressHUD showError:_rePasswordTF.placeholder];
        return;
    }
    
    //MWF
    if (![self isMatchPassWord:self.rePasswordTF.text]) {
        [MBProgressHUD showError:@"密码要求8-16位数字和字母组成"];
        return;
    }
    
    if (![self.passwordTF.text isEqualToString:self.rePasswordTF.text]) {
        [MBProgressHUD showError:@"密码不一致"];
        return;
    }
    if (self.userInfo1TF.text.length == 0 ) {
        [MBProgressHUD showError:_userInfo1TF.placeholder];
        return;
    }
    if (self.userInfo2TF.text.length == 0 ) {
        [MBProgressHUD showError:_userInfo2TF.placeholder];
        return;
    }
    
    //self.infoBoxHeight.constant = 155; 个人。
    if(self.infoBoxHeight.constant > 155 && self.addressTF.text.length == 0){
        //shang hu
        [MBProgressHUD showError:_addressTF.placeholder];
        return;
    }
    
    NSString *cityId = self.cityModel.Id;
    NSString *address = (self.infoBoxHeight.constant > 155)? [NSString stringWithFormat:@"%@%@",_userInfo2TF.text,_addressTF.text] : _userInfo2TF.text;
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkManager sharedYHNetworkManager] newAcount:_iphoneNumberTF.text//MWF
                                               userPhone:_iphoneNumberTF.text
                                                 verCode:_verCodeTF.text
                                                 userPwd:[[YHTools md5:[NSString stringWithFormat:@"%@",  _passwordTF.text]]lowercaseString]//MWF
                                                    type:((_companyB.selected)? (@"0") : (@"1"))
                                                    name:_userInfo1TF.text
                                                    city:cityId
                                                 address:address//_userInfo2TF.text
                                              userHeadId:@"123"
                                              onComplete:^(NSDictionary *info)
    {
        NSLog(@"----------注册提交😁：%@----------",info);
        [SVProgressHUD dismiss];
        if ([info[@"retCode"] isEqualToString:@"0"]) {
            NSDictionary *result = info[@"result"];
            [YHTools setAccessToken:result[@"token"]];
            [YHTools setName:_iphoneNumberTF.text];//MWF
            [YHTools setPassword:_passwordTF.text];
            [YHTools setSubName:_userInfo1TF.text];
            [MBProgressHUD showSuccess:@"注册成功！" toView:weakSelf.navigationController.view];
            
            //直接返回首页界面
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            return;
            
            //跳转到审核状态界面
            YHExamineStateController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHExamineStateController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            YHLogERROR(@"");
            [weakSelf showErrorInfo:info];
        }
    } onError:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    if (_iphoneNumberTF == textField) {
        if ([textField.text length]>=11)
            return NO;
    }
    if (_userInfo1TF == textField) {
        if ([textField.text length]>=100)
            return NO;
    }
    return YES;
}

//MWF
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ((textField == self.passwordTF) || (textField == self.rePasswordTF)) {
        if (![self isMatchPassWord:textField.text]) {
            [MBProgressHUD showError:@"密码要求8-16位数字和字母组成"];
        }else{
            
        }
    }
}

// 判断长度大于8位后，再接着判断是否同时包含数字和字符
- (BOOL)isMatchPassWord:(NSString *)pwd{
    BOOL result = false;
    if ([pwd length] >= 8 && [pwd length] <= 16){
        //NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSString *regex = @"^[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pwd];
    }
    return result;
}
- (IBAction)choseCity:(UIButton *)sender {
    
    ZZCityListViewController *vc = [ZZCityListViewController new];
    vc.selectCityBlock = ^(ZZCityModel * _Nonnull city) {
        self.userInfo2TF.text = city.regionName;
        self.cityModel = city;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)typeActions:(UIButton*)button {
    if (button.tag == 0) {//企业
        _companyB.selected = YES;
        _personB.selected = NO;
        _userInfo1FL.text = @"商户名称";
        _userInfo2FL.text = @"商户地址";
        _userInfo1TF.placeholder = @"请输入商户名称";
        _userInfo2TF.placeholder = @"请选择所在城市";
        _typeTiyleL.text = @"企业车商";
        self.infoBoxHeight.constant = 213;
    }
    if (button.tag == 1) {//个人
        _companyB.selected = NO;
        _personB.selected = YES;
        _userInfo1FL.text = @"联系人姓名";
        _userInfo2FL.text = @"所在城市";
        _userInfo1TF.placeholder = @"请输入联系人姓名";
        _userInfo2TF.placeholder = @"请选择所在城市";
        _typeTiyleL.text = @"个人车商";
        self.infoBoxHeight.constant = 155;

    }
}
@end
