//
//  YHModifyPassWordController.m
//  YHCaptureCar
//
//  Created by liusong on 2018/6/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHModifyPassWordController.h"
#import "YHModiPassWordItemView.h"

#import "YHNetworkManager.h"
#import "YHTools.h"
#import "SVProgressHUD.h"


@interface YHModifyPassWordController ()

/** 旧密码*/
@property (nonatomic, weak) YHModiPassWordItemView *originPassView;
/** 新密码*/
@property (nonatomic, weak) YHModiPassWordItemView *newestPasView;
/** 确认密码*/
@property (nonatomic, weak) YHModiPassWordItemView *surePassView;

@end

@implementation YHModifyPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initModifyPassWordBase];
    
    [self initUI];
    
}
- (void)initModifyPassWordBase{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改密码";
    
}
- (void)initUI{
    
    CGFloat viewMarginTop = IphoneX ? 88 : 64;
    
    // 原密码
    YHModiPassWordItemView *originPassView = [[YHModiPassWordItemView alloc] init];
    originPassView.viewController = self;
    self.originPassView = originPassView;
    originPassView.type = YHModiPassWordItemViewOriginPass;
    [self.view addSubview:originPassView];
    [originPassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(40 + viewMarginTop));
        make.left.equalTo(@20);
        make.right.equalTo(originPassView.superview).offset(-20);
        make.height.equalTo(@44);
    }];
    
    // 新密码
    YHModiPassWordItemView *newPassView = [[YHModiPassWordItemView alloc] init];
    newPassView.viewController = self;
    self.newestPasView = newPassView;
    newPassView.type = YHModiPassWordItemViewNewPass;
    [self.view addSubview:newPassView];
    [newPassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originPassView);
        make.top.equalTo(originPassView.mas_bottom).offset(10);
        make.height.equalTo(originPassView);
        make.width.equalTo(originPassView);
    }];
    
    // 确认密码
    YHModiPassWordItemView *surePassView = [[YHModiPassWordItemView alloc] init];
    surePassView.viewController = self;
    self.surePassView = surePassView;
    surePassView.type = YHModiPassWordItemViewSurePass;
    [self.view addSubview:surePassView];
    [surePassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originPassView);
        make.top.equalTo(newPassView.mas_bottom).offset(10);
        make.height.equalTo(newPassView);
        make.width.equalTo(newPassView);
    }];
    
    // 提交按钮
    UIButton *submitBtn = [[UIButton alloc] init];
    [self.view addSubview:submitBtn];
    submitBtn.backgroundColor = YHNaviColor;
    submitBtn.layer.cornerRadius = 5.0;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];

    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originPassView);
        make.right.equalTo(originPassView);
        make.top.equalTo(surePassView.mas_bottom).offset(35);
        make.height.equalTo(@40);
    }];
}
#pragma mark - 提交按钮点击事件 ----
- (void)submitBtnClickEvent{
    
    [self.originPassView.inputField resignFirstResponder];
    [self.newestPasView.inputField resignFirstResponder];
    [self.surePassView.inputField resignFirstResponder];
    
    if (self.originPassView.inputField.text.length == 0) {
        [MBProgressHUD showError:@"原密码不能为空" toView:self.view];
        return;
    }
    if (self.newestPasView.inputField.text.length == 0) {
        [MBProgressHUD showError:@"新密码不能为空" toView:self.view];
        return;
    }
    
    //MWF
    if (![self isMatchPassWord:self.newestPasView.inputField.text]) {
        [MBProgressHUD showError:@"新密码要求8-16位数字和字母组成"];
        return;
    }
    
    if (self.surePassView.inputField.text.length == 0) {
        [MBProgressHUD showError:@"确认密码不能为空" toView:self.view];
        return;
    }
    
    //MWF
    if (![self isMatchPassWord:self.surePassView.inputField.text]) {
        [MBProgressHUD showError:@"新密码要求8-16位数字和字母组成"];
        return;
    }
    
    if ([self.newestPasView.inputField.text isEqualToString:self.originPassView.inputField.text]) {
        [MBProgressHUD showError:@"新密码不能与旧密码相同" toView:self.view];
        return;
    }
    
    if (![self.newestPasView.inputField.text isEqualToString:self.surePassView.inputField.text]) {
        [MBProgressHUD showError:@"确认密码输入有误，请重新输入" toView:self.view];
        return;
    }
    [SVProgressHUD show];
    [[YHNetworkManager sharedYHNetworkManager] modifyPassword:[YHTools getAccessToken]
                                                    oldPasswd:self.originPassView.inputField.text
                                                  newPassword:self.newestPasView.inputField.text
                                                   onComplete:^(NSDictionary *info)
    {
        [SVProgressHUD dismiss];
        NSString *code = info[@"retCode"];
        NSString *msg = info[@"retMsg"];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"修改成功--%@",info);
            [self modifyPasswordSuccess];
        }else{
            
            [MBProgressHUD showError:msg toView:self.view];
        }
    } onError:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)modifyPasswordSuccess{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.7];
    backgroundView.alpha = 0;
    [self.view addSubview:backgroundView];
    
    UIView *middleView = [[UIView alloc] init];
    middleView.alpha = 0;
    [backgroundView addSubview:middleView];
    middleView.backgroundColor = [UIColor whiteColor];
    [middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@264);
        make.height.equalTo(@138);
        make.centerX.equalTo(backgroundView);
        make.centerY.equalTo(backgroundView);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"modifySuccess"]];
    [middleView addSubview:imgV];
    imgV.alpha = 0;
    [imgV sizeToFit];
    [imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleView);
        make.top.equalTo(middleView).offset(30);
    }];
    
    UILabel *tipL = [[UILabel alloc] init];
    tipL.font = [UIFont systemFontOfSize:17.0];
    tipL.textColor = YHNaviColor;
    tipL.text = @"修改成功";
    [tipL sizeToFit];
    [middleView addSubview:tipL];
    [tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(middleView).offset(-30);
        make.centerX.equalTo(imgV);
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        backgroundView.alpha = 1.0;
        middleView.alpha = 1.0;
        imgV.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

//MWF
- (BOOL)isMatchPassWord:(NSString *)pwd{
    BOOL result = false;
    if ([pwd length] >= 8 && [pwd length] <= 16){
        // 判断长度大于8位后，再接着判断是否同时包含数字和字符
        //NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSString *regex = @"^[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pwd];
    }
    return result;
}

@end
