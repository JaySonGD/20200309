//
//  VerifyCodeController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 31/7/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "VerifyCodeController.h"
#import "SetPassWordController.h"
#import "VerifyImageController.h"
#import "YHCarPhotoService.h"
#import "VerCodeView.h"

@interface VerifyCodeController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *codeContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verCodeMegLabelHeight;
@property (weak, nonatomic) IBOutlet UIButton *sendSmsBtn;
@property (weak, nonatomic) IBOutlet UILabel *cutDownLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cutDownWidth;
@property (nonatomic, weak) VerCodeView *codeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;

@end

@implementation VerifyCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setUI];

    [self initData];
}

//FIXME:  -  自定义方法
- (void)setUI{
    
    self.titleTop.constant = kStatusBarAndNavigationBarHeight + 25;

    CGFloat topMargin = iPhoneX ? 44 : 20;
    UIButton *backBtn = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"left_login"];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    CGFloat backY = topMargin;
    backBtn.frame = CGRectMake(10, backY, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];

    
    VerCodeView *codeView = [[VerCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    [self.codeContentView addSubview:codeView];
    _codeView = codeView;
    codeView.maxLenght = 4;
    codeView.pointColor = YHNaviColor;
    codeView.keyBoardType = UIKeyboardTypeNumberPad;
    [codeView verCodeViewWithMaxLenght];
     __weak typeof(self) weakSelf = self;
    codeView.block = ^(NSString *text){
        NSLog(@"text = %@",text);
        if (text.length == 4) {
            [weakSelf checkVerifyCode:text];
        }
    };
}


- (void)checkVerifyCode:(NSString *)code{
     __weak typeof(self) weakSelf = self;
    [[YHCarPhotoService new] checkVerifyCode:code
                                       phone:self.mobile
                                     success:^{
                                         [weakSelf jumpSetPassWord];
                                     }
                                     failure:^(NSError *error) {
                                             [weakSelf.codeView resetCode];
                                             weakSelf.verCodeMegLabelHeight.constant = 18;
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                 weakSelf.verCodeMegLabelHeight.constant = 0;
                                             });
                                     }];
}

- (void)initData{
    
    NSString *text =  [NSString stringWithFormat:@"我们已向 %@ 发送短信验证码",self.mobile];
    self.mobile = [self.mobile stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:14.0]
                    range:NSMakeRange(0, text.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:YHColor(199, 199, 199)
                    range:NSMakeRange(0, text.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:YHColor(51, 51, 51)
                    range:[text rangeOfString:self.mobile]];
    self.titleLB.attributedText = attrStr;
    
    self.verCodeMegLabelHeight.constant = 0;

    [self openCountdown];
}
- (IBAction)sendSmsAction:(UIButton *)sender {
    
     __weak typeof(self) weakSelf = self;
    // code 图片验证码
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] sendSms:self.mobile
                                code:nil
                             success:^( NSString *intervalTime, NSString *imgCodeURL) {
                                 [MBProgressHUD hideHUDForView:self.view];
                                 
                                 if (imgCodeURL) {
                                     
                                     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
                                     VerifyImageController *codeVC = [sb instantiateViewControllerWithIdentifier:@"VerifyImageController"];
                                     codeVC.imgCodeURL = imgCodeURL;
                                     codeVC.phone = weakSelf.mobile;
                                     codeVC.callBack = ^(NSInteger t){

                                         weakSelf.expire = t;
                                         [MBProgressHUD showError:@"发送成功"];
                                         [weakSelf openCountdown];

                                         
                                     };
                                     codeVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                                     [weakSelf presentViewController:codeVC animated:NO completion:nil ];
                                     return ;
                                 }
                                 

                                 
                                 weakSelf.expire = [intervalTime integerValue];
                                 [MBProgressHUD showError:@"发送成功"];
                                 [weakSelf openCountdown];
                             }
                             failure:^(NSError *error) {
                                 [MBProgressHUD hideHUDForView:self.view];
                                 
                                 [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                             }];

}

//FIXME:  -  开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = self.expire; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                self.sendSmsBtn.enabled = YES;
                self.cutDownWidth.constant = 0;
            });
            
        }else{
            
            NSInteger seconds = time % self.expire;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                self.sendSmsBtn.enabled = NO;
                self.cutDownWidth.constant = 32.0;
                self.cutDownLabel.text = [NSString stringWithFormat:@"%ld秒",seconds];

            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)jumpSetPassWord{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    SetPassWordController *pwdVC = [sb instantiateViewControllerWithIdentifier:@"SetPassWordController"];
    pwdVC.mobile = self.mobile;
    [self.navigationController pushViewController:pwdVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
