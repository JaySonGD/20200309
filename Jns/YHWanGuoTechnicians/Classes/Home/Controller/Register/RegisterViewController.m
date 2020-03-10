//
//  RegisterViewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 31/7/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "RegisterViewController.h"
#import "VerifyCodeController.h"
#import "VerifyImageController.h"
#import "YHCarPhotoService.h"


@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorMsgHeight;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIView *phoneBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;

@property (nonatomic, copy) NSString *previousTextFieldContent;
@property (nonatomic, strong) UITextRange *previousSelection;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI{
    self.titleTop.constant = kStatusBarAndNavigationBarHeight + 25;
    self.phoneTF.delegate = self;
    
    [self.phoneTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];

    [self textChange:self.phoneTF];
    self.errorMsgHeight.constant = 0;

    [self.phoneTF becomeFirstResponder];
    
    
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

- (BOOL)isMatchPhone:(NSString *)phoneNum{
    //正则表达式匹配11位手机号码
    //NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *regex = @"^1\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    return isMatch;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//FIXME:  -  事件监听
- (IBAction)nextAction:(UIButton *)sender {
    
    NSString *phone = [self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (![self isMatchPhone:phone]) {
        self.errorMsgHeight.constant = 18;
        self.phoneBgView.backgroundColor = [UIColor whiteColor];
        kViewBorderRadius(self.phoneBgView, 10, 0.5, YHColor(230, 81, 75));
        return;
    }
     __weak typeof(self) weakSelf = self;
    // code 图片验证码
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] sendSms:phone
                                code:nil
                             success:^(NSString *intervalTime, NSString *imgCodeURL) {
                                 [MBProgressHUD hideHUDForView:self.view];

                                 if (imgCodeURL) {
                                     
                                     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
                                     VerifyImageController *codeVC = [sb instantiateViewControllerWithIdentifier:@"VerifyImageController"];
                                     codeVC.imgCodeURL = imgCodeURL;
                                     codeVC.phone = phone;
                                     codeVC.callBack = ^(NSInteger t){
                                         [weakSelf jumpVerifyCodeVC:t];
                                     };
                                     codeVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                                     [weakSelf presentViewController:codeVC animated:NO completion:nil ];
                                     return ;
                                 }
                                 
                                 [weakSelf jumpVerifyCodeVC:[intervalTime integerValue]];
                                 
                             }
                             failure:^(NSError *error) {
                                 [MBProgressHUD hideHUDForView:self.view];

                                 [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
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
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
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
        if (nStr.length == 8 || nStr.length == 3)
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

- (void)textFieldDidEndEditing:(UITextField *)textField{            // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

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
    self.previousTextFieldContent = textField.text;
    self.previousSelection = textField.selectedTextRange;
    
    return YES;
}



@end
