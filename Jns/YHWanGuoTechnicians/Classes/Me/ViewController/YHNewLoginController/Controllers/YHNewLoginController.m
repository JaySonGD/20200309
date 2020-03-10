//
//  YHNewLoginController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/7/30.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHNewLoginController.h"
#import "YHCommon.h"
#import "YHPassWordTextField.h"
#import "YHNewLoginStationListController.h"
#import "YHAlertMaskView.h"
#import "YHStoreTool.h"
#import "AppDelegate.h"

#import "YHBaseNetWorkError.h"
#import "YHUserProtocolViewController.h"
#import "RegisterViewController.h"

#import "YHMarginMutableButton.h"
#import "YHWebFuncViewController.h"

static NSString *authCodeSuccess_notification = @"authCodeSuccess_notification";

@interface YHNewLoginController () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *loginL;

@property (nonatomic, weak) UILabel *phoneNumberL;

@property (nonatomic, weak) YHPassWordTextField *phoneNumberTft;

@property (nonatomic, weak) UILabel *passwordL;

@property (nonatomic, weak) UIView *errorView;

@property (nonatomic, weak) YHPassWordTextField *passwordTft;

@property (nonatomic, weak) UIButton *rememberPassWordBtn;

@property (nonatomic, weak) UIButton *forgetPassWordBtn;

@property (nonatomic, weak) UIButton *loginBtn;

@property (nonatomic, weak) UIButton *clearBtn;

@property (nonatomic, copy) NSString *previousTextFieldContent;
@property (nonatomic, strong) UITextRange *previousSelection;

@property (nonatomic, copy) NSString *inputStr;

@end

@implementation YHNewLoginController

#pragma mark - 禁用侧滑返回手势
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self popGestureClose:self];
}

- (void)popGestureClose:(UIViewController *)VC
{
    // 禁用侧滑返回手势
    if ([VC.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势禁用
        for (UIGestureRecognizer *popGesture in VC.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = NO;
        }
        
        //若开启全屏右滑，不能再使用下面方法，请对数组进行处理
        //VC.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark - 启用侧滑返回手势
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self popGestureOpen:self];
}

- (void)popGestureOpen:(UIViewController *)VC
{
    // 启用侧滑返回手势
    if ([VC.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势启用
        for (UIGestureRecognizer *popGesture in VC.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = YES;
        }
        
        //若开启全屏右滑，不能再使用下面方法，请对数组进行处理
        //VC.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLoginControllerView];
    
    [self initBase];
}
- (void)initBase{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authCodeSuccessEvent) name:authCodeSuccess_notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChange:) name:@"UITextFieldTextDidChangeNotification" object:self.phoneNumberTft];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChange:) name:@"UITextFieldTextDidChangeNotification" object:self.passwordTft];
    
}
- (void)initLoginControllerView{
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    
    UILabel *loginL = [[UILabel alloc] init];
    loginL.font = [UIFont boldSystemFontOfSize:26];
    loginL.textAlignment = NSTextAlignmentLeft;
    loginL.textColor = [UIColor blackColor];
    loginL.text = @"登录";
    self.loginL = loginL;
    [self.view addSubview:loginL];
    [loginL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@26);
        make.left.equalTo(@20);
        make.width.equalTo(loginL.superview).offset(-20);
        make.top.equalTo(@(topMargin + 25));
    }];
    
    UILabel *phoneNumberL = [[UILabel alloc] init];
    phoneNumberL.text = @"手机号";
    phoneNumberL.font = [UIFont systemFontOfSize:18.0];
    phoneNumberL.textAlignment = NSTextAlignmentLeft;
    phoneNumberL.textColor = [UIColor blackColor];
    self.phoneNumberL = phoneNumberL;
    [self.view addSubview:phoneNumberL];
    [phoneNumberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginL.mas_bottom).offset(35);
        make.left.equalTo(@28);
        make.width.equalTo(phoneNumberL.superview).offset(-28);
        make.height.equalTo(@18);
    }];
    
    YHPassWordTextField *phoneNumberTft = [[YHPassWordTextField alloc] init];
    phoneNumberTft.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberTft.delegate = self;
    phoneNumberTft.secureTextEntry = NO;
    phoneNumberTft.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    phoneNumberTft.placeholder = @"点击输入";
    self.phoneNumberTft = phoneNumberTft;
    [self.view addSubview:phoneNumberTft];
    [phoneNumberTft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumberL.mas_bottom).offset(10);
        make.left.equalTo(@20);
        make.width.equalTo(phoneNumberTft.superview).offset(-40);
        make.height.equalTo(@57);
    }];
    
    UIButton *clearBtn = [[UIButton alloc] init];
    self.clearBtn = clearBtn;
    clearBtn.hidden = YES;
    [clearBtn addTarget:self action:@selector(clearBtnTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setImage:[UIImage imageNamed:@"clean_login"] forState:UIControlStateNormal];
    [phoneNumberTft addSubview:clearBtn];
    [clearBtn sizeToFit];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clearBtn.superview).offset(-20);
        make.centerY.equalTo(clearBtn.superview);
    }];
    
    UIView *errorView = [[UIView alloc] init];
    self.errorView = errorView;
    errorView.hidden = YES;
    [self.view addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumberTft.mas_bottom);
        make.left.equalTo(@28);
        make.width.equalTo(errorView.superview).offset(-28);
        make.height.equalTo(@0);
    }];
    
    UIButton *errorBtn = [[UIButton alloc] init];
    [errorBtn setImage:[UIImage imageNamed:@"redWarning_login"] forState:UIControlStateNormal];
    [errorBtn setTitle:@"手机号格式不正确" forState:UIControlStateNormal];
    [errorBtn setTitleColor:[UIColor colorWithRed:243.0/255.0 green:39.0/255.0 blue:50.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    errorBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [errorView addSubview:errorBtn];
    [errorBtn sizeToFit];
    [errorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@0);
        make.height.equalTo(@16);
    }];
    
    UILabel *passwordL = [[UILabel alloc] init];
    passwordL.text = @"密码";
    passwordL.font = [UIFont systemFontOfSize:18.0];
    passwordL.textAlignment = NSTextAlignmentLeft;
    passwordL.textColor = [UIColor blackColor];
    self.passwordL = passwordL;
    [self.view addSubview:passwordL];
    [passwordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(errorView.mas_bottom).offset(20);
        make.left.equalTo(phoneNumberL);
        make.height.equalTo(phoneNumberL);
        make.width.equalTo(phoneNumberL);
    }];
    
    YHPassWordTextField *passwordTft = [[YHPassWordTextField alloc] init];
    passwordTft.delegate = self;
    passwordTft.secureTextEntry = YES;
    passwordTft.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    passwordTft.placeholder = @"点击输入";
    self.passwordTft = passwordTft;
    [self.view addSubview:passwordTft];
    [passwordTft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(phoneNumberTft);
        make.height.equalTo(phoneNumberTft);
        make.left.equalTo(phoneNumberTft);
        make.top.equalTo(passwordL.mas_bottom).offset(10);
    }];
    UIButton *showOrHidePwsBtn = [[UIButton alloc] init];
    [showOrHidePwsBtn addTarget:self action:@selector(showOrHidePwsBtnTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    [showOrHidePwsBtn setImage:[UIImage imageNamed:@"noSee_pw_login"] forState:UIControlStateNormal];
    [passwordTft addSubview:showOrHidePwsBtn];
    [showOrHidePwsBtn sizeToFit];
    [showOrHidePwsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(showOrHidePwsBtn.superview).offset(-20);
        make.centerY.equalTo(showOrHidePwsBtn.superview);
    }];
    // 记住密码
    UIButton *rememberPassWordBtn = [[UIButton alloc] init];
    self.rememberPassWordBtn = rememberPassWordBtn;
    [rememberPassWordBtn addTarget:self action:@selector(rememberPassWordBtnTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    [rememberPassWordBtn setImage:[UIImage imageNamed:@"noSelect_login"] forState:UIControlStateNormal];
    [rememberPassWordBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    rememberPassWordBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [rememberPassWordBtn setTitleColor:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rememberPassWordBtn setTitle:@"记住账号密码" forState:UIControlStateNormal];
    CGFloat rememberWidth = [@"记住账号密码" boundingRectWithSize:CGSizeMake(MAXFLOAT, 16.0) options:nil attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil].size.width;
    CGFloat margin = 8;
    [self.view addSubview:rememberPassWordBtn];
    rememberPassWordBtn.titleEdgeInsets = UIEdgeInsetsMake(0, margin, 0, 0);
    [rememberPassWordBtn sizeToFit];
    [rememberPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordTft.mas_bottom).offset(10);
        make.left.equalTo(@(35));
        make.width.equalTo(@(rememberWidth + margin + 19));
    }];
    
    // 忘记密码
    UIButton *forgetPassWordBtn = [[UIButton alloc] init];
    [forgetPassWordBtn addTarget:self action:@selector(forgetPassWordBtnTouchUpInsideEvent) forControlEvents:UIControlEventTouchUpInside];
    forgetPassWordBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [forgetPassWordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPassWordBtn setTitleColor:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:forgetPassWordBtn];
    [forgetPassWordBtn sizeToFit];
    [forgetPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rememberPassWordBtn);
        make.right.equalTo(forgetPassWordBtn.superview).offset(-35);
    }];
    // 登录
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.YH_normalTitle = @"登 录";
    loginBtn.YH_loadStatusTitle = @"信息提交中";
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [loginBtn addTarget:self action:@selector(loginAccount) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(forgetPassWordBtn.mas_bottom).offset(35);
        make.height.equalTo(phoneNumberTft);
        make.width.equalTo(phoneNumberTft);
    }];

    // 服务协议
    UILabel *agreeProtocolLeft = [[UILabel alloc] init];
    agreeProtocolLeft.textAlignment = NSTextAlignmentRight;
    agreeProtocolLeft.font = [UIFont systemFontOfSize:16.0];
    agreeProtocolLeft.textColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0];
    agreeProtocolLeft.text = @"登录即视为同意";
    [self.view addSubview:agreeProtocolLeft];
    [agreeProtocolLeft sizeToFit];
    
    CGFloat width = [@"登录即视为同意《用户服务协议》" boundingRectWithSize:CGSizeMake(MAXFLOAT, 16.0) options:nil attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil].size.width;
    
    [agreeProtocolLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(10);
        make.left.equalTo(@((self.view.frame.size.width - width)/2.0));
    }];
    
    UILabel *agreeProtocolRight = [[UILabel alloc] init];
    agreeProtocolRight.userInteractionEnabled = YES;
    agreeProtocolRight.textAlignment = NSTextAlignmentLeft;
    agreeProtocolRight.font = [UIFont systemFontOfSize:16.0];
    agreeProtocolRight.textColor = YHNaviColor;
    agreeProtocolRight.text = @"《用户服务协议》";
    [self.view addSubview:agreeProtocolRight];
    [agreeProtocolRight sizeToFit];
    [agreeProtocolRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreeProtocolLeft);
        make.left.equalTo(agreeProtocolLeft.mas_right);
    }];
    
//    // 注册体验账号
//    UIButton *RegisterTestBtn = [[UIButton alloc] init];
//    [RegisterTestBtn setTitle:@"注册体验账号" forState:UIControlStateNormal];
//    [RegisterTestBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    RegisterTestBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
//    [RegisterTestBtn addTarget:self action:@selector(RegisterTestBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:RegisterTestBtn];
//    [RegisterTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(25);
//        make.width.mas_equalTo(150);
//    }];

    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProtocolTapEvent)];
    [agreeProtocolRight addGestureRecognizer:tapGes];
    
//    CGFloat bottonMargin = iPhoneX ? 34 : 0;
//    UIButton *registerBTn = [[UIButton alloc] init];
//    registerBTn.titleLabel.font = [UIFont systemFontOfSize:20.0];
//    [registerBTn setTitleColor:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [registerBTn setTitle:@"注册账号" forState:UIControlStateNormal];
//    [self.view addSubview:registerBTn];
//    [registerBTn sizeToFit];
//    [registerBTn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(registerBTn.superview).offset(-(25 + bottonMargin));
//        make.centerX.equalTo(registerBTn.superview);
//    }];
    // 记住密码
    NSNumber *isRemember = [YHTools getUserRemember];
    if (isRemember) {
        BOOL isRemem = isRemember.boolValue;
        self.rememberPassWordBtn.selected = isRemem;
        if (isRemem) {
            NSMutableString *phoneStr = [[YHTools getName] mutableCopy];
            if (phoneStr.length > 10) {
                [phoneStr insertString:@" " atIndex:3];
                [phoneStr insertString:@" " atIndex:8];
            }
            self.phoneNumberTft.text = phoneStr;
            self.passwordTft.text = [YHTools getPassword];
            if (phoneStr.length > 0) {
                self.clearBtn.hidden = NO;
            }else{
                self.clearBtn.hidden = YES;
            }
        }
    }else{
        // 用户从没设置过
         self.rememberPassWordBtn.selected = YES;
        [YHTools setUserRemember:[NSNumber numberWithBool:YES]];
    }
    
    // 设置登录按钮颜色
    if (self.phoneNumberTft.text.length > 0 && self.passwordTft.text.length > 0) {
        loginBtn.backgroundColor = YHNaviColor;
    }else{
        loginBtn.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    }
}

#pragma mark - 注册体验账号
- (void)RegisterTestBtn{
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    controller.title = @"注册体验账号";
    controller.urlStr = [NSString stringWithFormat:@"%@%@/registered.html?status=ios",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk];
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)textFieldContentChange:(NSNotification *)noti{
    
    UITextField *textField = (UITextField *)noti.object;
//    NSString *toBeString = textField.text;
    if (self.phoneNumberTft.text.length > 0 && self.passwordTft.text.length > 0) {
        self.loginBtn.backgroundColor = YHNaviColor;
    }else{
        self.loginBtn.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    }
    
    if (textField == self.phoneNumberTft) {
        self.errorView.hidden = YES;
        [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneNumberTft.mas_bottom);
            make.left.equalTo(@28);
            make.width.equalTo(self.errorView.superview).offset(-28);
            make.height.equalTo(@0);
        }];
        
        [self formatPhoneNumber:self.phoneNumberTft];
    }
}

#pragma mark - 验证码验证成功 ------
- (void)authCodeSuccessEvent{
    
    [YHAlertMaskView dismisssView];
    [self loginAccount];
}
- (void)showOrHidePwsBtnTouchUpInsideEvent:(UIButton *)sender{
    
    if (self.passwordTft.secureTextEntry) {
        [sender setImage:[UIImage imageNamed:@"see_pw_login"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"noSee_pw_login"] forState:UIControlStateNormal];
    }
     self.passwordTft.secureTextEntry = !self.passwordTft.secureTextEntry;
    
}
- (void)clearBtnTouchUpInsideEvent:(UIButton *)sender{
    self.phoneNumberTft.text = nil;
    self.clearBtn.hidden = YES;
}
#pragma mark - 用户协议跳转 ------
- (void)userProtocolTapEvent{
    
    YHUserProtocolViewController *VC = [[UIStoryboard storyboardWithName:@"YHUserProtocol" bundle:nil] instantiateViewControllerWithIdentifier:@"YHUserProtocolViewController"];
    //VC.text = [self protocolText];
    VC.name = @"用户服务协议";
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark - 忘记密码 ----
- (void)forgetPassWordBtnTouchUpInsideEvent{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    RegisterViewController *regVC = [sb instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:regVC animated:YES];
}
#pragma mark - 记住账号密码 -----
- (void)rememberPassWordBtnTouchUpInsideEvent:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    NSNumber *isRemember  = [NSNumber numberWithBool:btn.selected];
    [YHTools setUserRemember:isRemember];
    
}

- (void)setErrorMsg:(NSString *)errorMsg{
    _errorMsg = errorMsg;
    [MBProgressHUD showError:errorMsg];
}

#pragma mark - 登录 ---
- (void)loginAccount{
    
    NSString *phoneStr = [self.phoneNumberTft.text mutableCopy];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (phoneStr.length == 0) {
        [MBProgressHUD showError:@"手机号码不能为空" toView:self.view];
        return;
    }
    if (![self isMatchPhone:phoneStr]) {
        [MBProgressHUD showError:@"您输入的手机号码无效，请重新输入" toView:self.view];
        self.errorView.hidden = NO;
        [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneNumberTft.mas_bottom);
            make.left.equalTo(@28);
            make.width.equalTo(self.errorView.superview).offset(-28);
            make.height.equalTo(@26);
        }];
        return;
    }

    if (self.passwordTft.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空" toView:self.view];
        return;
    }
    
    [self.loginBtn YH_showStartLoadStatus];
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] newLoginUserName:phoneStr passWord:[YHTools md5:self.passwordTft.text] org_id:@"" confirm_bind:NO onComplete:^(NSDictionary *info) {
    
        NSLog(@"----------------->>>>1.😁:%@<<<<----------------",info);
        
        [self.loginBtn YH_showEndLoadStatus];
        
        int code = [info[@"code"] intValue];
        // 登录成功绑定一家店铺
        if (code == 20000) {
            NSDictionary *data = info[@"data"];
            [YHTools setAccessToken:data[@"token"]];
            [[YHStoreTool ShareStoreTool] setOrg_id:data[@"org_id"]];
            [YHTools setName:phoneStr];
            [YHTools setPassword:self.passwordTft.text];
            [YHTools setServiceCode:data[@"url_code"]];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsFirstLogin:YES];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsManualLogin:YES];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLoginInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
             return;
        }
        
        // 登录成功绑定多家店铺
        if (code == 30100) {
            NSDictionary *data = info[@"data"];
            NSArray *stationList = data[@"list"];
            YHNewLoginStationListController *stationListVC = [[YHNewLoginStationListController alloc] init];
            stationListVC.stationListArr = stationList;
            stationListVC.userName = phoneStr;
            stationListVC.passWord = self.passwordTft.text;
            [self.navigationController pushViewController:stationListVC animated:YES];
             return;
        }
        // 需要验证
        if (code == 40800) {
            [self getAuthCodeImage];
             return;
        }
        
        if(![self networkServiceCenter:info[@"code"]]){
            YHLogERROR(@"");
            [self showErrorInfo:info];
        }
        
    } onError:^(NSError *error) {

         [self.loginBtn YH_showEndLoadStatus];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
        
}

- (BOOL)isMatchPhone:(NSString *)phoneNum{
    //正则表达式匹配11位手机号码
    //NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *regex = @"^1\\d{10}$";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    return isMatch;
}
#pragma mark -- 登录过期 ----
- (bool)networkServiceCenter:(NSNumber*)retCode{
    return [[[YHBaseNetWorkError alloc]init] networkServiceCenter:retCode];
}

#pragma mark --展示返回错误提示----
- (void)showErrorInfo:(NSDictionary*)info{
    NSDictionary *msg = info[@"msg"];
    if ([msg isKindOfClass:[NSDictionary class]]) {
        NSArray *strs = msg.allValues;
        if (strs.count != 0) {
            [MBProgressHUD showError:strs[0]];
        }
    }else{
        [MBProgressHUD showError:info[@"msg"]];
    }
}
- (void)getAuthCodeImage{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getAuthCodeImageOnComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view];
        int code = [info[@"code"] intValue];
        if (code == 20000) {
            NSDictionary *data = info[@"data"];
            NSString *verify_img = data[@"verify_img"];
            NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:verify_img options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
            // 将NSData转为UIImage
            UIImage *decodedImage = [UIImage imageWithData: decodeData];
            [[YHStoreTool ShareStoreTool] setAuthCodeImage:decodedImage];
            [YHAlertMaskView showToView:self.view];
            
        }else{
            [MBProgressHUD showError:@"获取验证码图片失败" toView:self.view];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
     [self.phoneNumberTft setRounded:self.phoneNumberTft.bounds corners:UIRectCornerAllCorners radius:10];
     [self.passwordTft setRounded:self.passwordTft.bounds corners:UIRectCornerAllCorners radius:10];
     [self.loginBtn setRounded:self.loginBtn.bounds corners:UIRectCornerAllCorners radius:10];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
#pragma mark - UITextFieldDelegate -----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    self.inputStr = string;
    if (textField == self.phoneNumberTft) {

        if (string.length > 0) {
            self.clearBtn.hidden = NO;
        }else{
          self.clearBtn.hidden = range.location == 0 ? YES : NO;
        }
        
        self.previousTextFieldContent = textField.text;
        self.previousSelection = textField.selectedTextRange;
    }

    return YES;
}

//- (NSRange)selectedRange{
//
//    UITextPosition* beginning = self.phoneNumberTft.beginningOfDocument;
//    UITextRange* selectedRange = self.phoneNumberTft.selectedTextRange;
//
//    UITextPosition* selectionStart = selectedRange.start;
//    UITextPosition* selectionEnd = selectedRange.end;
//
//    const NSInteger location = [self.phoneNumberTft offsetFromPosition:beginning toPosition:selectionStart];
//
//    const NSInteger length = [self.phoneNumberTft offsetFromPosition:selectionStart toPosition:selectionEnd];
//
//    return NSMakeRange(location, length);
//
//}
//- (void) setSelectedRange:(NSRange) range{ // 备注：UITextField必须为第一响应者才有效
//
//    UITextPosition *beginning = self.phoneNumberTft.beginningOfDocument;
//
//    UITextPosition* startPosition = [self.phoneNumberTft positionFromPosition:beginning offset:range.location];
//
//    UITextPosition* endPosition = [self.phoneNumberTft positionFromPosition:beginning offset:range.location + range.length];
//
//    UITextRange* selectionRange = [self.phoneNumberTft textRangeFromPosition:startPosition toPosition:endPosition];
//
//    [self.phoneNumberTft setSelectedTextRange:selectionRange];
//
//}

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

- (NSString *)protocolText{
    

    NSString *text = @"1、本协议仅适用于JNS信息平台的用户。JNS信息平台（以下简称“JNS”）由广州万国汽车技术有限公司，借助于基础信息平台业务，向平台中的用户提供包括但不限于AI智汽车能检测服务、AI汽车智能诊断服务、维修厂业务系统服务、汽车技术信息查询及附属信息交互服务。\
    2、本用户协议适用于用户访问JNS，以及在通过JNS发布或接受其他用户发布的信息，享受JNS提供的信息、建议及服务。\
    3、在此特别提醒您，登陆JNS平台之前，请先仔细阅读本用户协议，确保您充分理解本用户协议各条款。请您审慎阅读并选择接受或不接受本用户协议。除非您接受本协议所有条款，否则您无权登录或使用本用户协议所涉服务。您的登录、使用等行为将视为对本用户协议的接受，并同意接受本用户协议的约束。\
    4、本用户协议系约定JNS平台运营方与用户之间关于JNS平台服务的权利义务。本用户协议可由JNS平台运营方随时更新，更新后的用户协议条款一旦公布即代替原来的用户协议条款，恕不再另行通知，用户可在JNS平台中查阅最新版用户协议条款。在修改用户协议条款后，如用户不接受修改后的条款，请立即停止使用JNS平台提供的服务；用户继续使用JNS平台提供的服务将被视为接受修改后的用户协议。\
    5、JNS平台仅作为信息服务平台，平台所提供的资料信息仅供参考，不做为维修凭证。\
    6、如无特别说明，下列术语在本协议中作如下释义：\
    （1）“用户”是指名在JNS平台拥有登陆账号的个人或企业。\
    （2）“检测站”是指与JNS平台通过直接或间接形式签订合作协议的具备车辆检测资质的企业。\
    第一条   服务内容\
    JNS平台向用户提供以下服务（包括但不限于）：\
    1.1 JNS平台向用户提供AI汽车检车服务，用户可以在线提交车辆检测数据，并获得电子检测报告。\
    1.2 JNS平台向用户提供AI汽车诊断服务，用户可以在线提交车辆检测数据，并获得电子诊断报告。\
    1.3 NS平台向用户提供业务系统服务，用户可以通过业务系统进行员工管理、业务管理、配件耗材管理、客户管理等。\
    1.4 JNS平台向用户提供汽车技术信息查询服务，用户可以通过车系车型，查询相关车辆的汽车资料、维修技术资料等。\
    \
    第二条  用户的权利与义务\
    2.1 用户通过申请后，在JNS平台获得一个用户账号及相应的密码后，该用户账号和密码由用户负责保管；用户应当合法合理使用平台账号，不得从事违反法律法规、政策及公序良俗、社会公德等的行为；用户应当对以其用户账号进行的所有活动和事件负法律责任；一旦用户行为违反相关法律法规，JNS平台有权追究其法律责任及赔偿平台损失。\
    2.2用户账号的所有权属于JNS平台运营方，用户获得用户账号的使用权后，不得赠与、借用、租用、转让或售卖账号或者以其他方式许可非初始申请人使用账号。非初始申请人不得通过受赠、继承、承租、受让或者其他任何方式使用账号。\
    2.3用户有责任妥善保管账户信息及账户密码的安全，用户同意在任何情况下不向他人透露账户及密码信息。当用户怀疑他人在使用自己账号及密码时，应立即通知JNS平台。\
    第三条  JNS平台的权利义务\
    3.1 JNS平台为用户提供本协议第一条所列的服务内容，并保留根据市场反馈和实际需要等情况适时对服务内容进行变更的权利。\
    3.2 为更好地向JNS平台用户提供服务，在一方需求与另一方供给不能匹配时，JNS平台可能将该共享信息传输至合作的第三方网络服务平台，并按照JNS平台的规则完成发起方的信息撮合，在此过程中可能存在部分必要信息在不同平台中的共享与使用，JNS平台将监督合作平台以不低于JNS平台的信息安全和用户信息保护制度的标准，使用和维护从JNS平台获取的数据。\
    3.3 鉴于网络服务的特殊性，JNS平台无法保证其所提供的信息中没有任何错误、缺陷、恶意软件或病毒。对于因使用（或无法使用）信息平台导致的任何损害，包括但不限于因电子通信传达失败或延时、第三方或用于电子通信的计算机程序对电子通信的拦截或操纵，以及病毒传输导致的损害，JNS平台不承担责任（除非此类损害是由JNS平台故意或重大疏忽造成的）。\
    3.4 JNS平台受理用户的投诉，并对投诉内容进行核实、调解，在争议得到合理解决前，JNS平台有权暂时禁止受投诉用户使用JNS平台的服务。\
    3.5JNS平台有权随时审核或删除用户发布/传播的涉嫌违法或违反社会主义精神文明，或平台认为不妥当的内容（包括但不限于文字、语音、图片、视频、图文等）。\
    3.6用户如果长期不登录账号、在多台终端设备上同时使用、显示、运行同一账号或涉嫌违反本协议及相关服务条款的有关规定，JNS平台运营方有权回收该账号，由此带来的任何损失均由用户自行承担。\
    第四条   收费标准及收费方式\
    4.1 JNS平台为提高车辆检测效率、质量，在系统中设置有检测费用，该费用标准根据各地成本或车型的区别有所不同。JNS平台有权根据实际需要对收费服务的收费标准、方式进行修改和变更，具体收费标准以JNS平台公布的情况为准。\
    第五条  投诉处置规则\
    5.1 如用户在使用JNS平台过程中，与服务提供方产生纠纷，双方应进行友好协商，无法协商一致的，可向JNS平台进行反馈，由JNS平台进行居中斡旋。\
    5.2 因用户的原因，JNS平台遭受任何损失的，JNS平台的经营方有权向用户要求全额赔偿。如因用户违反本用户协议或相关服务条款的规定，导致或产生第三方主张的任何索赔、要求或损失，用户应当独立承担责任。\
    第六条  不可抗力\
    “不可抗力”是指本用户协议中各方不能控制、不可预见或即使预见亦无法避免的事件，且该事件足以妨碍、影响或延误任何一方根据本用户协议履行其全部或部分义务。该事件包括但不限于自然灾害、战争、政策变化、计算机病毒、黑客攻击或电信机构服务中断。遭受不可抗力的一方可中止履行本用户协议项下的义务直至不可抗力事件的影响消除，并且无需为此承担违约责任。但该方应尽最大努力克服该事件，防止或减少损失的扩大。\
    第七条  违约责任及协议的解除和终止\
    7.1 如果用户有以下行为，JNS平台有权随时终止本用户协议（即禁止用户使用JNS平台及相应服务）：\
    a. 违反本用户协议中的任何条款；\
    b. 经技术判定滥用JNS平台服务或损害JNS平台的合法权益；\
    c. 因政策变化、行业限制、经营调整导致本用户协议相关义务不能履行。\
    JNS平台因上述原因而终止本用户协议的，将通过平台向用户发出相关通知，通知后即解除协议。\
    7.2 用户有权随时通过删除其智能终端上安装的JNS平台程序以终止用户协议。用户终止用户协议的，应对使用JNS平台期间所产生的相关费用进行结算；若用户未结算完毕的，JNS平台有权要求用户支付拖欠的款项；若因用户原因导致损失的，平台有权要求用户赔偿损失。\
    7.3如用户协议终止的，JNS平台有权永久地删除用户的数据。在服务终止后，JNS平台没有义务向用户返还数据。\
    第八条  知识产权保护及声明\
    8.1JNS平台运营方是JNS平台APP软件的知识产权权利人，享有与本软件相关的一切著作权、商标权、专利权、商业秘密等知识产权，但相关权利人依照法律规定应享有的权利除外。\
    8.2未经JNS平台运营方或相关权利人书面同意，用户不得为任何商业或非商业目的自行或许可任何第三方实施、利用、转让上述知识产权。\
    8.3如因本软件使用的第三方软件或技术引发的任何纠纷，应由该第三方负责解决，JNS平台运营方不承担任何责任。JNS平台运营方不对第三方软件或技术提供客服支持，若用户需要获取支持，请与第三方联系。\
    第九条  争议解决\
    本用户协议适用中国法律。关于本用户协议的违约、终止、履行、解释或有效性，或者JNS信息服务平台使用所产生的或与其相关的任何冲突、赔偿或纠纷（统称为“争议”），均应由协议的各方进行友好协商，协商不成的，应交由JNS平台运营方住所地有管辖权的法院予以审理。\
    第十条  其他\
    10.1因业务变化或调整，JNS平台有权随时修改或替换本用户协议之条款，用户可访问本页面以了解最新的条款；同时，基于市场变化或业务调整，JNS平台经营方享有更改、暂停或中断服务或应用程序（包括但不限于任何功能、数据库或内容的可用性）的权利。如因此类情况造成网络服务在合理时间内中断的，运营方无需为此承担任何责任。\
    10.2所有发给用户的通告及其他信息均通过JNS平台APP或用户提供的手机号码发送。\
    10.3本协议的任何条款无论因何种原因无效或不具可执行性，其余条款仍有效，对协议各方具有约束力。\
    10.4JNS平台郑重提醒用户注意本协议中免除JNS平台和限制用户用户权利的条款，请用户仔细阅读，自主考虑风险。\
    10.5本协议最终解释权归广州万国汽车技术有限公司所有，并且保留一切解释和修改的权利。";
    
    return text;
}
@end
