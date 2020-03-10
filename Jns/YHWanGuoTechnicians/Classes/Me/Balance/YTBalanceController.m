//
//  YTBalanceController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 1/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTBalanceController.h"

#import "YHUserProtocolViewController.h"
#import "YTRechargeController.h"
#import "YTRecordController.h"
#import "YHStoreTool.h"

@interface YTBalanceController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *orgPointsL;


@end

@implementation YTBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orgPointsL.text = [[YHStoreTool ShareStoreTool] orgPoints];
    [self.backBtn setImage: [[UIImage imageNamed:@"newBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//白色
    [self refreshPoints];
}

- (void)refreshPoints{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] getOrganizationPointNumber:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",info[@"code"]];
        if ([code isEqualToString:@"20000"]) {
            self.orgPointsL.text = [NSString stringWithFormat:@"%@",info[@"data"][@"points"]];
        }
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//黑色
    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)pay:(UIButton *)sender {
    
    YTRechargeController *VC = [[UIStoryboard storyboardWithName:@"Balance" bundle:nil] instantiateViewControllerWithIdentifier:@"YTRechargeController"];
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)back:(UIButton *)sender {
    [self popViewController:sender];
}
- (IBAction)detail:(UIButton *)sender {
    YTRecordController *VC = [[UIStoryboard storyboardWithName:@"Balance" bundle:nil] instantiateViewControllerWithIdentifier:@"YTRecordController"];
    [self.navigationController pushViewController:VC animated:YES];

}
- (IBAction)instruction:(UIButton *)sender {
    YHUserProtocolViewController *VC = [[UIStoryboard storyboardWithName:@"YHUserProtocol" bundle:nil] instantiateViewControllerWithIdentifier:@"YHUserProtocolViewController"];
    VC.text = @"1.余额可以用来购买JNS APP里所有的收费服务；\
    \n2.余额仅能用于兑换JNS APP里直接提供的功能产品与服务，不能兑换现金，不能进行转账交易，不能兑换JNS APP外的产品和服务。";
    VC.name = @"余额说明";
    [self.navigationController pushViewController:VC animated:YES];
}

@end
