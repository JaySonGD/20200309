//
//  RegisterViewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 31/7/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "RegisterViewController.h"
#import "VerifyCodeController.h"
#import "YHSVProgressHUD.h"
#import "YHCommon.h"
#import "YHNetworkManager.h"
#import "VerifyImageController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorMsgHeight;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIView *phoneBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;

/** 登录者账户 */
@property(nonatomic,copy) NSString *accName;

@property (nonatomic, copy) NSString *previousTextFieldContent;
@property (nonatomic, strong) UITextRange *previousSelection;

@property (nonatomic, copy) NSString *inputStr;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI{
    self.titleTop.constant = kStatusBarAndNavigationBarHeight + 25;
    self.phoneTF.delegate = self;
    
    [self.phoneTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];

    [self textChange:self.phoneTF];
    
    self.errorMsgHeight.constant = 0;

   // [self.phoneTF becomeFirstResponder];
    
    CGFloat topMargin = IphoneX ? 44 : 20;
    UIButton *backBtn = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"left_login"];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    CGFloat backY = topMargin;
    backBtn.frame = CGRectMake(10, backY, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)isMatchPhone:(NSString *)phoneNum{
    //正则表达式匹配11位手机号码
    //NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *regex = @"^1\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    return isMatch;
}
- (void)popViewController:(UIButton *)backBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//FIXME:  -  事件监听
- (IBAction)nextAction:(UIButton *)sender {
    
    [self checkMobileIsRegister:sender];
}

- (void)checkMobileIsRegister:(UIButton *)sender{
    
    NSString *phone = [self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (![self isMatchPhone:phone]) {
        self.errorMsgHeight.constant = 18;
        self.phoneBgView.backgroundColor = [UIColor whiteColor];
        kViewBorderRadius(self.phoneBgView, 10, 0.5, YHColor(230, 81, 75));
        return;
    }
    
    sender.userInteractionEnabled = NO;
    [[YHNetworkManager sharedYHNetworkManager] checkMobileRepeatType:@"1"
                                                              mobile:phone
                                                          onComplete:^(NSDictionary *info)
    {
        NSLog(@"--------😁：%@===%@--------",info,info[@"retMsg"]);
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        sender.userInteractionEnabled = YES;

        if ([retCode isEqualToString:@"0"]) {
            
            NSDictionary *result = info[@"result"];
            self.accName = result[@"accName"];
            NSString *flag = result[@"flag"];
           
            if ([flag isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"手机号不存在"];
            }
            
            if ([flag isEqualToString:@"1"]) {
                // 已注册
                [self sendVercodeMethod:phone];
            }
        }
    } onError:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        sender.userInteractionEnabled = YES;

    }];
}

- (void)sendVercodeMethod:(NSString *)phone{
   
    // 发送验证码
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[YHNetworkManager sharedYHNetworkManager] sendVerifyCodeType:@"1" mobile:phone onComplete:^(NSDictionary *info) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",info);
        NSString *retCode = [NSString stringWithFormat:@"%@",info[@"retCode"]];
        if ([retCode isEqualToString:@"0"]) {
            // 验证码发送成功
            UIStoryboard *registerStoryboard = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
            VerifyCodeController *vercodeVc = [registerStoryboard instantiateViewControllerWithIdentifier:@"VerifyCodeController"];
            vercodeVc.expire = 60;
            vercodeVc.accName = self.accName;
            vercodeVc.mobile = phone;
            [self.navigationController pushViewController:vercodeVc animated:YES];
        }else{

            NSString *msg = info[@"retMsg"];
            [MBProgressHUD showError:msg];
        }
        
    } onError:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)jumpVerifyCodeVC:(NSInteger)intervalTime{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    VerifyCodeController *codeVC = [sb instantiateViewControllerWithIdentifier:@"VerifyCodeController"];
    codeVC.mobile = self.phoneTF.text;
    codeVC.expire = intervalTime;
    [self.navigationController pushViewController:codeVC animated:YES];

}

- (void)textChange:(UITextField *)pwdTF{
    if (pwdTF.hasText) {
        self.nextButton.enabled = YES;
        self.nextButton.backgroundColor = YHNaviColor;
    }else{
        self.nextButton.enabled = NO;
        self.nextButton.backgroundColor = YHColor(209, 209, 209);
    }
    
    if (self.errorMsgHeight.constant) {
        self.phoneBgView.backgroundColor = YHColor(242, 242, 242);
        kViewBorderRadius(self.phoneBgView, 10, 0, YHColor(230, 81, 75));
        self.errorMsgHeight.constant = 0;
    }

    [self formatPhoneNumber:pwdTF];
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



//FIXME:  -  UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *phone = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self isMatchPhone:phone]) {
        self.errorMsgHeight.constant = 0;
        self.phoneBgView.backgroundColor = YHColor(242, 242, 242);
        kViewBorderRadius(self.phoneBgView, 10, 0, YHColor(230, 81, 75));
    }else{
        self.errorMsgHeight.constant = 18;
        self.phoneBgView.backgroundColor = [UIColor whiteColor];
        kViewBorderRadius(self.phoneBgView, 10, 0.5, YHColor(230, 81, 75));
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.inputStr = string;
    self.previousTextFieldContent = textField.text;
    self.previousSelection = textField.selectedTextRange;
    
    return YES;
}


@end
