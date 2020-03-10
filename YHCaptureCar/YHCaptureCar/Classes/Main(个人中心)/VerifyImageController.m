//
//  VerifyImageController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 31/7/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "VerifyImageController.h"

//#import "YHCarPhotoService.h"
#import "ApiService.h"

#import "VerCodeView.h"
#import "YHSVProgressHUD.h"
#import <IQKeyboardManager.h>
#import <UIImageView+WebCache.h>

@interface VerifyImageController ()
@property (weak, nonatomic) IBOutlet UIView *codeContentView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorMsgLabelHeight;
@property (nonatomic, weak) VerCodeView *codeView;
@end

@implementation VerifyImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self setUI];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

//FIXME:  -  自定义方法
- (void)setUI{
    self.errorMsgLabelHeight.constant = 0;
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:self.imgCodeURL]];
    VerCodeView *codeView = [[VerCodeView alloc] initWithFrame:self.codeContentView.bounds];
    [self.codeContentView addSubview:codeView];
    _codeView = codeView;
    codeView.maxLenght = 4;
    codeView.pointColor = YHNaviColor;
    codeView.keyBoardType = UIKeyboardTypeDefault;
    [codeView verCodeViewWithMaxLenght];
    
    __weak typeof(self) weakSelf = self;
    codeView.block = ^(NSString *text){
        NSLog(@"text = %@",text);
        if (text.length == 4) {
            [weakSelf sendSms:text];
        }
    };
}


//FIXME:  -  事件监听
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:nil completion:nil];
}

- (IBAction)refresh:(id)sender {
//    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:[ApiService sharedApiService].getFindPasswordImage] placeholderImage:nil options:SDWebImageRefreshCached];
}


- (void)sendSms:(NSString *)imgCode{
    __weak typeof(self) weakSelf = self;
    // code 图片验证码
    [YHSVProgressHUD showYH];
//    [[YHCarPhotoService new] sendSms:self.phone
//                                code:imgCode
//                             success:^( NSString *intervalTime, NSString *imgCodeURL) {
//                                 [YHSVProgressHUD dismiss];
//                                 !(weakSelf.callBack)? : weakSelf.callBack(intervalTime.integerValue);
//                                 [weakSelf dismissViewControllerAnimated:nil completion:nil];
//                                 
//                             }
//                             failure:^(NSError *error) {
//                                 [YHSVProgressHUD dismiss];
//                                 if (error) {
//                                     [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
//                                     [weakSelf refresh:nil];
//                                 }else{
//                                     weakSelf.errorMsgLabelHeight.constant = 18.0;
//                                 }
//                                 [weakSelf.codeView resetCode];
//                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                     weakSelf.errorMsgLabelHeight.constant = 0;
//                                 });
//                             }];
    

}



@end
