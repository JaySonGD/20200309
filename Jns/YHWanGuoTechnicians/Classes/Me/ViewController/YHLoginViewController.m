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
//#import "MBProgressHUD+MJ.h"

#import "YHTools.h"
#import "YHCommon.h"
#import "YHNetworkPHPManager.h"

#import "YHNetworkManager.h"
#import "TTTAttributedLabel.h"
#import "Masonry.h"
#import "WXApi.h"
#import "Constant.h"
#import "WXApiManager.h"
#import "AppDelegate.h"
#import "YHUserProtocolViewController.h"

NSString *const notificationUpdataUserinfo = @"YHNotificationUpdataUserinfo";
@interface YHLoginViewController () <TTTAttributedLabelDelegate, WXApiManagerDelegate,UITextFieldDelegate>
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *codeFT;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *iphoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordFT;
@property (strong, nonatomic)TTTAttributedLabel *registerL;
- (IBAction)rememberAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *otherLogin;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *weixinLogin;
@property (weak, nonatomic) IBOutlet UIButton *forgetPawssword;
- (IBAction)agreementSelAction:(id)sender;
- (IBAction)agreementDetailAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *agreementDetail;
@property (weak, nonatomic) IBOutlet UIButton *agreementSel;
- (IBAction)weixinAction:(id)sender;
@property (strong, nonatomic)NSString *state;
@property (weak, nonatomic) IBOutlet UIButton *rememberButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBackLC;
@end

@implementation YHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.codeFT.delegate = self;
    self.iphoneNumberTF.delegate = self;
    self.passwordFT.delegate = self;
    
    // Do any additional setup after loading the view.
    _loginBackLC.constant =  (screenWidth) * 994. / 1242;
    CGRect frame =  _contentView.frame;
    frame.size.width = screenWidth;
    frame.size.height = 550;
    _contentView.frame = frame;
    [_scrollV addSubview:_contentView];
    [_scrollV setContentSize:CGSizeMake(screenWidth, 550)];
    
    _line.hidden = _isRegister;
    _otherLogin.hidden = _isRegister;
    _weixinLogin.hidden = _isRegister;
    _agreementSel.hidden = !_isRegister;
    _agreementDetail.hidden = !_isRegister;
    _forgetPawssword.hidden= YES;
    _rememberButton.hidden = _isRegister;
    
    [_loginButton setTitle:((_isRegister)? (@"注册") : (@"登录")) forState:UIControlStateNormal];
    NSNumber *isRemember = [YHTools getUserRemember];
    _rememberButton.selected = isRemember.boolValue;
    if (isRemember.boolValue) {
        self.iphoneNumberTF.text = [YHTools getName];
        self.passwordFT.text = [YHTools getPassword];
        self.codeFT.text = [YHTools getServiceCode];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_iphoneNumberTF resignFirstResponder];
    [_passwordFT resignFirstResponder];
    [_codeFT resignFirstResponder];

    return YES;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if (_isRegister) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        YHLoginViewController *controller = [board instantiateViewControllerWithIdentifier:@"YHLoginViewController"];
        controller.isRegister = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}



- (IBAction)loginAction:(id)sender {
    if (self.iphoneNumberTF.text.length == 0 ) {
        
        [MBProgressHUD showError:@"请输入正确手机号码"];
        return;
    }
    
    if (self.passwordFT.text == nil|| [_passwordFT.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    
    if (self.codeFT.text == nil|| [_codeFT.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输入站点编码"];
        return;
    }
    [MBProgressHUD showMessage:@"登录中..." toView:self.view];
     __weak __typeof__(self) weakSelf = self;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     loginTest:OrgId
     vtrId:VtrId
     username:_iphoneNumberTF.text
     password:[YHTools md5:_passwordFT.text]
     verifyCode:@""
     urlCode:_codeFT.text
     onComplete:^(NSDictionary *info) {
         
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             
             [YHTools setAccessToken:info[@"token"]];
             NSLog(@"%s--token---%@", __func__,info[@"token"]);
             [YHTools setName:weakSelf.iphoneNumberTF.text];
             [YHTools setPassword:weakSelf.passwordFT.text];
             [YHTools setServiceCode:weakSelf.codeFT.text];
             [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsFirstLogin:YES];
             [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsManualLogin:YES];
             [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLoginInfo:nil];
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLogERROR(@"");
                 [weakSelf showErrorInfo:info];
             }
         }
         
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];;
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
    return YES;
}

- (IBAction)rememberAction:(id)sender {
    
    NSNumber *isRemember  = [NSNumber numberWithBool:!_rememberButton.selected];
    _rememberButton.selected = isRemember.boolValue;
    [YHTools setUserRemember:isRemember];
}

- (IBAction)weixinAction:(id)sender {
    [WXApiManager sharedManager].delegate = self;
    self.state = [NSString stringWithFormat:@"%d", (arc4random() % 501) + 500];
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = _state;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}


- (void)managerDidRecvAuthResponse:(SendAuthResp *)response{
    if (response.errCode == 0 && [_state isEqualToString:response.state]) {
        [[YHNetworkWeiXinManager sharedYHNetworkWeiXinManager]getAccessTokenByCode:response.code onComplete:^(NSDictionary *info) {
            [YHTools setWeixinAccessInfo:info];
        } onError:^(NSError *error) {
            ;
        }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"授权失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        __block typeof(self) weakSelf = self;
        [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        }];
    }
}


- (IBAction)agreementSelAction:(id)sender {
    
    NSNumber *isRemember  = [NSNumber numberWithBool:!_agreementSel.selected];
    _agreementSel.selected = isRemember.boolValue;
    [YHTools setUserRemember:isRemember];
}

- (IBAction)agreementDetailAction:(id)sender {
}

#pragma mark - 用户协议
- (IBAction)agreeProtocol:(UIButton *)sender
{
    YHUserProtocolViewController *VC = [[UIStoryboard storyboardWithName:@"YHUserProtocol" bundle:nil] instantiateViewControllerWithIdentifier:@"YHUserProtocolViewController"];
//    [self.parentViewController.childViewControllers.lastObject pushViewController:VC animated:YES];

    [self.navigationController pushViewController:VC animated:YES];
}


@end
