//
//  SetPassWordController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 31/7/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "SetPassWordController.h"
#import "RegisterViewController.h"

#import "YHCarPhotoService.h"
#import "AppDelegate.h"

@interface SetPassWordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *doButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorMsgHeight;
@property (weak, nonatomic) IBOutlet UIView *pwdBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;

@end

@implementation SetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//FIXME:  -  自定义方法、
- (void)setUI{
    
    self.titleTop.constant = kStatusBarAndNavigationBarHeight + 25;

    UIButton * rightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.pwdTF.rightView = rightView;
    self.pwdTF.rightViewMode = UITextFieldViewModeAlways;
    
    [rightView addTarget:self action:@selector(seePwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView  setImage:[UIImage imageNamed:@"see_pw_a"] forState:UIControlStateNormal];
    [rightView  setImage:[UIImage imageNamed:@"see_pw_b"] forState:UIControlStateSelected];
    
    [self.pwdTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self textChange:self.pwdTF];
    self.pwdTF.delegate = self;
    self.errorMsgHeight.constant = 0;
    [self.pwdTF becomeFirstResponder];
    
    CGFloat topMargin = iPhoneX ? 44 : 20;
    UIButton *backBtn = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"left_login"];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    CGFloat backY = topMargin;
    backBtn.frame = CGRectMake(10, backY, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];

    
}

- (BOOL)isMatchPassWord:(NSString *)pwd{
    BOOL result = false;
    if ([pwd length] >= 8 && [pwd length] <= 16){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        //NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSString * regex = @"^[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pwd];
    }
    return result;
}

//FIXME:  -  事件监听

- (void)seePwdAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    self.pwdTF.secureTextEntry = !self.pwdTF.secureTextEntry;
}
- (IBAction)finishAction:(UIButton *)sender {
    
    if(![self isMatchPassWord:self.pwdTF.text]) {
        self.errorMsgHeight.constant = 18;
        self.pwdBgView.backgroundColor = [UIColor whiteColor];
        kViewBorderRadius(self.pwdBgView, 10, 0.5, YHColor(230, 81, 75));
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] resetPassword:[YHTools md5:self.pwdTF.text]
                                     phone:self.mobile
                                   success:^{
                                       [MBProgressHUD hideHUDForView:self.view];
                                       [MBProgressHUD showError:@"修改成功"];
                                       
#pragma mark - 修改成功，记得跳转
                                       AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
                                       app.isFirstLogin = YES;
                                       app.isManualLogin = YES;
                                       app.loginInfo = nil;
                                       [self.navigationController popToRootViewControllerAnimated:YES];


                                   }
                                   failure:^(NSError *error) {
                                       [MBProgressHUD hideHUDForView:self.view];
                                       [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                   }];
}

- (void)popViewController:(id)sender{
    
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[RegisterViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

- (void)textChange:(UITextField *)pwdTF{
    if (pwdTF.hasText) {
        self.doButton.enabled = YES;
        self.doButton.backgroundColor = YHNaviColor;
    }else{
        self.doButton.enabled = NO;
        self.doButton.backgroundColor = YHColor(209, 209, 209);
    }
    if (self.errorMsgHeight.constant) {
        self.pwdBgView.backgroundColor = YHColor(242, 242, 242);
        kViewBorderRadius(self.pwdBgView, 10, 0, YHColor(230, 81, 75));
        self.errorMsgHeight.constant = 0;
    }

}


//FIXME:  -UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{            // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    if ([self isMatchPassWord:textField.text]) {
        self.errorMsgHeight.constant = 0;
        self.pwdBgView.backgroundColor = YHColor(242, 242, 242);
        kViewBorderRadius(self.pwdBgView, 10, 0, YHColor(230, 81, 75));
        
    }else{
        self.errorMsgHeight.constant = 18;
        self.pwdBgView.backgroundColor = [UIColor whiteColor];
        kViewBorderRadius(self.pwdBgView, 10, 0.5, YHColor(230, 81, 75));
    }
}

@end
