//
//  YHReceiveMsgViewController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/10/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHReceiveMsgViewController.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "YHTestOldPhoneViewController.h"

@interface YHReceiveMsgViewController ()

@property (weak, nonatomic) IBOutlet UIView *upperLimitView;

@property (weak, nonatomic) IBOutlet UIView *modifiableView;

@property (weak, nonatomic) IBOutlet UIButton *receiveMsgBtn;

@end

@implementation YHReceiveMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    [self initData];
}

- (void)initUI{
    self.upperLimitView.hidden = YES;
    self.modifiableView.hidden = YES;
}

- (void)initData{
    WeakSelf;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] checkUpdatePhoneNumWithToken:[YHTools getAccessToken]
                                                                 onComplete:^(NSDictionary *info)
     {
         NSLog(@"---==%@--%@--%@==---",info,info[@"retMsg"],info[@"result"][@"msg"]);
         [MBProgressHUD hideHUDForView:self.view];
         if (IsEmptyStr(info[@"result"][@"msg"])) {
             weakSelf.upperLimitView.hidden = YES;
             weakSelf.modifiableView.hidden = NO;
             [weakSelf refreshUI];
         }else{
             weakSelf.upperLimitView.hidden = NO;
             weakSelf.modifiableView.hidden = YES;
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:weakSelf.view];
     }];
}

- (void)refreshUI{
    NSString *phone = [YHTools getName];
    if (!IsEmptyStr(phone)&&(phone.length >= 11)) {
        [self.receiveMsgBtn setTitle:[NSString stringWithFormat:@"手机%@****%@能接收信息",[phone substringWithRange:NSMakeRange(0, 3)],[phone substringWithRange:NSMakeRange(7, 4)]] forState:UIControlStateNormal];
    }
}

#pragma mark - 检测用户手机本月是否还有修改次数
- (IBAction)receiveMsg:(UIButton *)sender {
    YHTestOldPhoneViewController *VC = [[UIStoryboard storyboardWithName:@"YHChangePhone" bundle:nil] instantiateViewControllerWithIdentifier:@"YHTestOldPhoneViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
