//
//  YHPayResultController.m
//  YHCaptureCar
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHPayResultController.h"

#import "YHCommon.h"

#import <Masonry.h>

@interface YHPayResultController ()

@end

@implementation YHPayResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"微信支付";
    
    UIImageView *payLogo = [[UIImageView alloc] init];
    //payLogo.backgroundColor = [UIColor orangeColor];
    payLogo.image = [UIImage imageNamed:@"微信支付"];
    [self.view addSubview:payLogo];
    
    [payLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(100);
        make.centerX.mas_equalTo(self.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 113));
    }];
    
    UILabel *statusLB = [[UILabel alloc] init];
    statusLB.textAlignment = NSTextAlignmentCenter;
    //statusLB.backgroundColor = [UIColor redColor];
    statusLB.font = [UIFont systemFontOfSize:17.0];
    statusLB.text = @"已支付成功";
    [self.view addSubview:statusLB];
    [statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payLogo.mas_bottom).offset(5);
        make.left.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *payMoney = [UILabel new];
    payMoney.textAlignment = NSTextAlignmentCenter;
    //payMoney.backgroundColor = [UIColor orangeColor];
    payMoney.font = [UIFont systemFontOfSize:37.0];
    payMoney.text = self.payMoneyString;//@"¥500元";

    [self.view addSubview:payMoney];
    [payMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusLB.mas_bottom).offset(5);
        make.left.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(44);
    }];

    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    doneBtn.backgroundColor = YHNaviColor;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [doneBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payMoney.mas_bottom).offset(75);
        make.left.mas_equalTo(self.view.mas_left).offset(44);
        make.right.mas_equalTo(self.view.mas_right).offset(-44);
        make.height.mas_equalTo(52);
    }];
    
    YHViewRadius(doneBtn, 6);

    [doneBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)back{
    !(_doAction)? : _doAction();
    [self dismissViewControllerAnimated:YES completion:nil];
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
