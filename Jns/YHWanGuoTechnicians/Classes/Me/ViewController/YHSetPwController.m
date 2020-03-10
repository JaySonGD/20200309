//
//  YHSetPwController.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/9.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHSetPwController.h"
#import "YHCommon.h"
#import "TTTAttributedLabel.h"
#import "Masonry.h"
#import "YHNetworkPHPManager.h"
//#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"

#import "YHTools.h"
@interface YHSetPwController ()
extern NSString *const notificationChangeSuc;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UIView *rePawsswordB;
@property (weak, nonatomic) IBOutlet UITextField *rePawsswordTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButon;
@property (nonatomic)BOOL checkOk;
@property (nonatomic, weak)NSTimer *timer;
@property (strong, nonatomic)NSString *oldPhone;
@property (nonatomic)NSInteger times;
@property (nonatomic)BOOL isCreate;
- (IBAction)nextAction:(id)sender;

@end

@implementation YHSetPwController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *loginInfo = [(AppDelegate*)[[UIApplication sharedApplication] delegate] loginInfo];
    NSDictionary *data = loginInfo[@"data"];
    self.isCreate = [data[@"phone"] isEqualToString:@""];
    [self stepAction];
    self.title = ((_isCreate)? (@"绑定手机号") : (@"修改手机号"));
}

- (void)stepAction{
    //    _rePawsswordB.hidden = !_step;
    _phoneNumberTF.text = @"";
    _codeTF.text = @"";
    if (_isCreate) {
        
        _phoneNumberTF.placeholder = @"请输入您的手机号码";
        [_nextStepButon setTitle:@"确认提交" forState:UIControlStateNormal];
    }else{
        [_timer invalidate];
        self.codeButton.titleLabel.text = @"获取验证码";
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _times = 0;
        _phoneNumberTF.placeholder = ((_step)? (@"请输入您的新手机号码") : (@"请输入您的旧手机号码"));
        [_nextStepButon setTitle:((_step)? (@"确认提交") : (@"下一步")) forState:UIControlStateNormal];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    YHSetPwController * controller = segue.destinationViewController;
    controller.step = 1;
}


- (IBAction)getCodeAction:(id)sender {
    if ([_phoneNumberTF.text isEqualToString:@""] && !_oldPhone) {
        [MBProgressHUD showError:@"请输入手机号！"];
        return;
    }
    if (_times > 1) {
        return;
    }
    if (!_oldPhone) {
        self.oldPhone = _phoneNumberTF.text;
    }
    //
    __weak __typeof__(self) weakSelf = self;
    
    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     sms:[YHTools getAccessToken]
     phone:_phoneNumberTF.text
     type:(_isCreate || _step)
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             if (weakSelf.timer == nil) {
                 weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1. target:weakSelf selector:@selector(getCodeTime:) userInfo:nil repeats:YES];
                 weakSelf.times = Timeout;
                 [weakSelf.timer fire];
             }
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLogERROR(@"");
                 if ((((NSNumber*)info[@"code"]).integerValue == 40000)) {
                     NSDictionary *msg = info[@"msg"];
                     NSArray *values = [msg allValues];
                     [MBProgressHUD showSuccess:values[0]];
                 }else{
                     [MBProgressHUD showSuccess:info[@"msg"]];
                 }
             }
         }
         
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];;
     }];
}

- (void)getCodeTime:(id)obj{
    NSInteger count = self.times - 1;
    if (count > 0) {
        self.times -= 1;
        self.codeButton.titleLabel.text = [NSString stringWithFormat:@"%lds后重新发送", (long)count];
        [self.codeButton setTitle:[NSString stringWithFormat:@"%lds后重新发送", (long)count] forState:UIControlStateNormal];
    }else{
        [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.timer  invalidate];
    }
}

- (IBAction)nextAction:(id)sender{
    if ((_step && _checkOk) || _isCreate) {
        if ([_phoneNumberTF.text isEqualToString:@""]) {
            
            [MBProgressHUD showError:@"请输入您的新手机号"];
            return;
        }
        
        if ([_codeTF.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入验证码！"];
            return;
        }
         __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         bundingSms:_phoneNumberTF.text
         token:[YHTools getAccessToken]
         type:_isCreate
         verifyCode:_codeTF.text
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 [[NSNotificationCenter defaultCenter]postNotificationName:notificationChangeSuc object:Nil userInfo:nil];
                 [MBProgressHUD showSuccess:@"设置成功！" toView:(weakSelf.navigationController.view)];
                 [weakSelf.navigationController popViewControllerAnimated:YES];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLogERROR(@"");
                     if ((((NSNumber*)info[@"code"]).integerValue == 40000)) {
                         NSDictionary *msg = info[@"msg"];
                         NSArray *values = [msg allValues];
                         [MBProgressHUD showSuccess:values[0]];
                     }else{
                         [MBProgressHUD showSuccess:info[@"msg"]];
                     }
                 }
             }
             
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];;
         }];
        
    }else{
        
        if ([_phoneNumberTF.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入您的旧手机号"];
            return;
        }
        
        if ([_codeTF.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入验证码！"];
            return;
        }
         __weak __typeof__(self) weakSelf = self;
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]
         checkOldphone:[YHTools getAccessToken]
         phone:_phoneNumberTF.text
         verifyCode:_codeTF.text
         onComplete:^(NSDictionary *info) {
             [MBProgressHUD hideHUDForView:self.view];
             if (((NSNumber*)info[@"code"]).integerValue == 20000) {
                 weakSelf.checkOk = YES;
                 weakSelf.step = 1;
                 [weakSelf stepAction];
             }else{
                 if(![weakSelf networkServiceCenter:info[@"code"]]){
                     YHLogERROR(@"");
                     if ((((NSNumber*)info[@"code"]).integerValue == 40000)) {
                         NSDictionary *msg = info[@"msg"];
                         NSArray *values = [msg allValues];
                         [MBProgressHUD showSuccess:values[0]];
                     }else{
                         [MBProgressHUD showSuccess:info[@"msg"]];
                     }
                 }
             }
         } onError:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view];;
         }];
        
        
    }
    
}


#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    if (_phoneNumberTF == textField) {
        if ([textField.text length] >= 11)
            return NO;
    }
    
    if (_codeTF == textField) {
        if ([textField.text length] >= 6)
            return NO;
    }
    return YES;
}
@end
