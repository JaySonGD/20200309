//
//  YHLoginViewController.m
//  YHOnline
//
//  Created by Zhu Wensheng on 16/8/8.
//  Copyright © 2016年 Zhu Wensheng. All rights reserved.
//

#import "YHLoginViewController.h"
#import "YHNetworkManager.h"
#import "YHNetworkWeiXinManager.h"
#import "UIAlertView+Block.h"
#import "YHCommon.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
#import "YHTools.h"
#import "YHCommon.h"
#import "YHNetworkManager.h"
#import "SVProgressHUD.h"
#import "YHNetworkManager.h"
#import "TTTAttributedLabel.h"
#import "Masonry.h"
#import "WXApi.h"
#import "Constant.h"
#import "WXApiManager.h"

#import "YHPassWordTextField.h"
#import "YHRegisterController.h" // 注册
#import "UIButton+YHNetWorkLoad.h"

#import "YHWebFuncViewController.h"
#import "YHMainViewController.h"
#import "RegisterViewController.h" // 忘记密码

#import "YHRichesController.h"

NSString *const notificationUpdataUserinfo = @"YHNotificationUpdataUserinfo";
@interface YHLoginViewController () <UITextFieldDelegate,TTTAttributedLabelDelegate, WXApiManagerDelegate>
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *iphoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordFT;
@property (strong, nonatomic)TTTAttributedLabel *registerL;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPawssword;
@property (weak, nonatomic) IBOutlet UIView *acountViewBox;
@property (weak, nonatomic) IBOutlet UIView *passwordViewBox;

/**************************** van_make *****************************/

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

@property (nonatomic, weak) UIButton *showOrHidePwsBtn;

@end

@implementation YHLoginViewController

- (void)loadView{
    [super loadView];

    UIView *controllerView = [[UIView alloc] init];
    controllerView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    controllerView.backgroundColor = [UIColor whiteColor];
    self.view = controllerView;
}

- (void)initLoginControllerView{
    
    CGFloat topMargin = IphoneX ? 88 : 64;
    
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
    
    //手机号
    YHPassWordTextField *phoneNumberTft = [[YHPassWordTextField alloc] init];
//    phoneNumberTft.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberTft.delegate = self;
    phoneNumberTft.secureTextEntry = NO;
    phoneNumberTft.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    phoneNumberTft.placeholder = @"点击输入";
    self.phoneNumberTft = phoneNumberTft;
    [self.view addSubview:phoneNumberTft];
    [phoneNumberTft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumberL.mas_bottom).offset(10);
        make.left.equalTo(@20);
        make.width.equalTo(phoneNumberTft.superview).offset(-40);
        make.height.equalTo(@57);
    }];
    
    
    [self.phoneNumberTft addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self textChange:self.phoneNumberTft];
    
    
    UIButton *clearBtn = [[UIButton alloc] init];
    self.clearBtn = clearBtn;
    clearBtn.hidden = YES;
    [clearBtn addTarget:self action:@selector(clearBtnTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setImage:[UIImage imageNamed:@"clean_login"] forState:UIControlStateNormal];
    [phoneNumberTft addSubview:clearBtn];
    
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clearBtn.superview);
        make.centerY.equalTo(clearBtn.superview);
        make.height.equalTo(clearBtn.superview);
        make.width.equalTo(clearBtn.superview.mas_height);
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
    passwordTft.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
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
    self.showOrHidePwsBtn = showOrHidePwsBtn;
    [showOrHidePwsBtn addTarget:self action:@selector(showOrHidePwsBtnTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    [showOrHidePwsBtn setImage:[UIImage imageNamed:@"noSee_pw_login"] forState:UIControlStateNormal];
    [self.view addSubview:showOrHidePwsBtn];
    [showOrHidePwsBtn sizeToFit];
    [showOrHidePwsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(passwordTft).offset(-20);
        make.centerY.equalTo(passwordTft);
    }];
    // 记住密码
    UIButton *rememberPassWordBtn = [[UIButton alloc] init];
    self.rememberPassWordBtn = rememberPassWordBtn;
    [rememberPassWordBtn addTarget:self action:@selector(rememberPassWordBtnTouchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    [rememberPassWordBtn setImage:[UIImage imageNamed:@"noSelect_login"] forState:UIControlStateNormal];
    [rememberPassWordBtn setImage:[UIImage imageNamed:@"selected_new"] forState:UIControlStateSelected];
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
//    UILabel *agreeProtocolLeft = [[UILabel alloc] init];
//    agreeProtocolLeft.textAlignment = NSTextAlignmentRight;
//    agreeProtocolLeft.font = [UIFont systemFontOfSize:16.0];
//    agreeProtocolLeft.textColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0];
//    agreeProtocolLeft.text = @"登录即视为同意";
//    [self.view addSubview:agreeProtocolLeft];
//    [agreeProtocolLeft sizeToFit];
    
//    CGFloat width = [@"登录即视为同意《用户服务协议》" boundingRectWithSize:CGSizeMake(MAXFLOAT, 16.0) options:nil attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil].size.width;
//
//    [agreeProtocolLeft mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(loginBtn.mas_bottom).offset(10);
//        make.left.equalTo(@((self.view.frame.size.width - width)/2.0));
//    }];
    
//    UILabel *agreeProtocolRight = [[UILabel alloc] init];
//    agreeProtocolRight.userInteractionEnabled = YES;
//    agreeProtocolRight.textAlignment = NSTextAlignmentLeft;
//    agreeProtocolRight.font = [UIFont systemFontOfSize:16.0];
//    agreeProtocolRight.textColor = YHNaviColor;
//    agreeProtocolRight.text = @"《用户服务协议》";
//    [self.view addSubview:agreeProtocolRight];
//    [agreeProtocolRight sizeToFit];
//    [agreeProtocolRight mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(agreeProtocolLeft);
//        make.left.equalTo(agreeProtocolLeft.mas_right);
//    }];
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProtocolTapEvent)];
//    [agreeProtocolRight addGestureRecognizer:tapGes];
    
    // 注册
    CGFloat bottonMargin = IphoneX ? 34 : 0;
    UIButton *registerBTn = [[UIButton alloc] init];
    registerBTn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [registerBTn setTitleColor:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [registerBTn addTarget:self action:@selector(registerTouchUpInsideEvent) forControlEvents:UIControlEventTouchUpInside];
    [registerBTn setTitle:@"注册账号" forState:UIControlStateNormal];
    [self.view addSubview:registerBTn];
    [registerBTn sizeToFit];
    [registerBTn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(registerBTn.superview).offset(-(25 + bottonMargin));
        make.centerX.equalTo(registerBTn.superview);
    }];
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
        self.loginBtn.userInteractionEnabled = YES;
    }else{
        loginBtn.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
        self.loginBtn.userInteractionEnabled = NO;
    }
}

- (void)viewDidLoad {
    self.isHideLeftButton = YES;
    [super viewDidLoad];
  
//    CGRect frame =  _contentView.frame;
//    frame.size.width = screenWidth;
//    frame.size.height = 550;
//    _contentView.frame = frame;
//    [_scrollV addSubview:_contentView];
//    [_scrollV setContentSize:CGSizeMake(screenWidth, 550)];
//    YHLayerBorder(_acountViewBox, YHLineColor, 1);
//    YHLayerBorder(_passwordViewBox, YHLineColor, 1);
    
    [self initLoginControllerView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChange:) name:@"UITextFieldTextDidChangeNotification" object:self.phoneNumberTft];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChange:) name:@"UITextFieldTextDidChangeNotification" object:self.passwordTft];
    
}
- (void)textFieldContentChange:(NSNotification *)noti{
    
//    UITextField *textField = (UITextField *)noti.object;
    //    NSString *toBeString = textField.text;
    if (self.phoneNumberTft.text.length > 0 && self.passwordTft.text.length > 0) {
        self.loginBtn.backgroundColor = YHNaviColor;
        self.loginBtn.userInteractionEnabled = YES;
    }else{
        self.loginBtn.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
        self.loginBtn.userInteractionEnabled = NO;
    }
    
//    if (textField == self.phoneNumberTft) {
//        self.errorView.hidden = YES;
//        [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.phoneNumberTft.mas_bottom);
//            make.left.equalTo(@28);
//            make.width.equalTo(self.errorView.superview).offset(-28);
//            make.height.equalTo(@0);
//        }];
//    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
   
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}
#pragma mark - 用户协议 ----
- (void)userProtocolTapEvent{
    
    
}

#pragma mark - 忘记密码 ----
- (void)forgetPassWordBtnTouchUpInsideEvent{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    RegisterViewController *regVC = [sb instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:regVC animated:YES];
}
#pragma mark - 记住密码 ----
- (void)rememberPassWordBtnTouchUpInsideEvent:(UIButton *)remmeberButton{
    
    remmeberButton.selected = !remmeberButton.selected;
    NSNumber *isRemember  = [NSNumber numberWithBool:remmeberButton.selected];
    [YHTools setUserRemember:isRemember];
}

#pragma mark - ----------登录(点击事件)----------
- (void)loginAccount{
    
    NSLog(@"------====%@====-------账号:%@-------",[YHTools getName],_phoneNumberTft.text);

    if (self.phoneNumberTft.text.length == 0 ) {
        [MBProgressHUD showError:@"请输入账号"];
        return;
    }
    
    if (self.passwordTft.text == nil|| [self.passwordTft.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    //MWF
    NSString *userName;
    if ([_phoneNumberTft.text containsString:@" "]) {
        userName = [_phoneNumberTft.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else{
        userName = _phoneNumberTft.text;
    }
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkManager sharedYHNetworkManager]login:userName
                                           password:[[YHTools md5:[NSString stringWithFormat:@"%@",  _passwordTft.text]]lowercaseString]//MWF
                                           //password:[YHTools md5:[NSString stringWithFormat:@"%@%@", _phoneNumberTft.text, _passwordTft.text]]
                                         onComplete:^(NSDictionary *info)
    {
        NSLog(@"----------======密码明文：%@====%@======%@======---------",[[YHTools md5:[NSString stringWithFormat:@"%@",  _passwordTft.text]]lowercaseString],info,info[@"retMsg"]);
        
         [SVProgressHUD dismiss];
         if ([info[@"retCode"] isEqualToString:@"0"]) {
             NSDictionary *result = info[@"result"];
             
             //access_token
             [YHTools setAccessToken:result[@"token"]];
             
             //用户名(MWF)
             [YHTools setName:userName];
             
             //用户密码
             [YHTools setPassword:weakSelf.passwordTft.text];
             
             //用户名子名称
             [YHTools setSubName:result[@"userName"]];
             
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             appDelegate.isLogining = NO;
             [MBProgressHUD showSuccess:@"登录成功！" toView:self.navigationController.view];
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
             
             if ([YHTools getReportJumpCode]) {
                 // token失效
                 YHWebFuncViewController *webVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
                 NSString *urlString =  [NSString stringWithFormat:@SERVER_PHP_URL_Statements_H5@SERVER_PHP_H5_Trunk"/enquiryPrice.html?code=%@&token=%@",[YHTools getReportJumpCode],[YHTools getAccessToken]];
                 webVC.urlStr = urlString;
                 [YHTools setIsReportJump:YES];
                  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 YHMainViewController *mainVc = (YHMainViewController *)appDelegate.window.rootViewController;
                 UINavigationController *mainNaViVc = (UINavigationController *)mainVc.contentViewController;
                 [mainNaViVc pushViewController:webVC animated:YES];
                 
                 [YHTools setReportJumpCode:nil];
             }
             
         }else{
             YHLogERROR(@"");
             [weakSelf showErrorInfo:info];
         }
     } onError:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];
    
}
#pragma mark - 注册 ----
- (void)registerTouchUpInsideEvent{
    
//    UIStoryboard *needStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YHRegisterController *registerVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YHRegisterController"];
    [self.navigationController pushViewController:registerVc animated:YES];
}

- (void)showOrHidePwsBtnTouchUpInsideEvent:(UIButton *)sender{
    
    if (self.passwordTft.secureTextEntry) {
        [sender setImage:[UIImage imageNamed:@"see_pw_login"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"noSee_pw_login"] forState:UIControlStateNormal];
    }
    self.passwordTft.secureTextEntry = !self.passwordTft.secureTextEntry;
    
}
#pragma mark - 清除手机号码按钮 -----
- (void)clearBtnTouchUpInsideEvent:(UIButton *)clearButton{
    
    self.phoneNumberTft.text = nil;
    self.clearBtn.hidden = YES;
}

#pragma mark - mark - --------------登录(拖拽)--------------
- (IBAction)loginAction:(id)sender {

    //MWF
    if (![[self.iphoneNumberTF.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"] || self.iphoneNumberTF.text.length != 11) {
        [MBProgressHUD showError:@"请输入正确手机号码"];
        return;
    }
    
    if (self.passwordFT.text == nil|| [_passwordFT.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    __weak __typeof__(self) weakSelf = self;
    [[YHNetworkManager sharedYHNetworkManager]login:_iphoneNumberTF.text
                                           password:[[YHTools md5:[NSString stringWithFormat:@"%@",_passwordFT.text]]lowercaseString]//MWF
     //[YHTools md5:[NSString stringWithFormat:@"%@%@", _iphoneNumberTF.text, _passwordFT.text]]
                                         onComplete:^(NSDictionary *info)
    {
         [SVProgressHUD dismiss];
         if ([info[@"retCode"] isEqualToString:@"0"]) {
             NSDictionary *result = info[@"result"];
             [YHTools setAccessToken:result[@"token"]];
             [YHTools setName:weakSelf.iphoneNumberTF.text];
             [YHTools setPassword:weakSelf.passwordFT.text];
             [YHTools setSubName:result[@"userName"]];
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             appDelegate.isLogining = NO;
             [MBProgressHUD showSuccess:@"登录成功！" toView:self.navigationController.view];
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
         }else{
             YHLogERROR(@"");
             [weakSelf showErrorInfo:info];
         }
     } onError:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneNumberTft) {
        self.inputStr = string;
        if (string.length > 0) {
            self.clearBtn.hidden = NO;
        }else{
            self.clearBtn.hidden = range.location == 0 ? YES : NO;
        }

        self.previousTextFieldContent = textField.text;
        self.previousSelection = textField.selectedTextRange;
    }

    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    if (_iphoneNumberTF == textField) {
        if ([textField.text length]>=11)
            return NO;
    }
    return YES;
}

//MWF
- (void)textChange:(UITextField *)phoneTF{
    if (phoneTF.hasText) {
//        self.nextButton.enabled = YES;
//        self.nextButton.backgroundColor = YHNaviColor;
    }else{
//        self.nextButton.enabled = NO;
//        self.nextButton.backgroundColor = YHColor(209, 209, 209);
    }
    
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
