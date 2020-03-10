//
//  YHCaptureCarAlertView.m
//  YHCaptureCar
//
//  Created by Jay on 15/5/18.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCaptureCarAlertView.h"

#import "YHCommon.h"

//#import "YHHelpSellService.h"

#import <Masonry.h>

@interface YHCaptureCarAlertView ()
@property (nonatomic, weak) UITextField *priceTF;
@property (nonatomic, weak) UITextField *commissionTF;
@property (nonatomic, weak) UIButton *submitBtn;
@end

@implementation YHCaptureCarAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeClick];
}

- (void)closeClick{
    [self dismissViewControllerAnimated:nil completion:nil];
}
- (void)submitClick{
    !(_submitBlock)? : _submitBlock(_priceTF.text,_commissionTF.text);
    [self closeClick];
}
- (void)enquirieAction:(UIButton *)sender{
    !(_enquirieBlock)? : _enquirieBlock();
    
//    [YHHelpSellService fin];
//    [MBProgressHUD showMessage:@"正在询价中，请稍后再查看" toView:[UIApplication sharedApplication].keyWindow];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
//    });
    [self closeClick];
}
- (void)setUI{
    
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    YHViewRadius(contentView, 5);
    contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat contentH = self.isHelpBuy? 285 : 255;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
        make.centerY.mas_equalTo(self.view).offset(-100);
        make.height.mas_equalTo(contentH);  //255 + 30
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(0);
        make.right.mas_equalTo(contentView).offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        
    }];
    
    UILabel *titleLB = [[UILabel alloc] init];
    [contentView addSubview:titleLB];
    titleLB.text = self.isOffer? @"出价": self.isHelpBuy?@"找帮买":@"找帮卖";
    titleLB.textAlignment = NSTextAlignmentCenter;
    
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(39);
        make.right.mas_equalTo(contentView).offset(-39);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(contentView).offset(11);
        
    }];
    
    UIView *line =[[UIView alloc] init];
    line.backgroundColor = YHBackgroundColor;
    [contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(0);
        make.right.mas_equalTo(contentView).offset(-0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(titleLB.mas_bottom).offset(6);
        
    }];
    
    
    if (self.isHelpBuy) {
        
        //询价btn
        UIButton *enquirieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contentView addSubview:enquirieBtn];

        [enquirieBtn setTitle:@"点击询价" forState:UIControlStateNormal];
        enquirieBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [enquirieBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        enquirieBtn.backgroundColor = YHNaviColor;
        YHViewRadius(enquirieBtn, 5);
        [enquirieBtn addTarget:self action:@selector(enquirieAction:) forControlEvents:UIControlEventTouchUpInside];
        [enquirieBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(contentView).offset(-16);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(62);
            make.top.mas_equalTo(line.mas_bottom).offset(10); //10 + 30
        }];
        
        UILabel *enquiriePriceLB = [[UILabel alloc] init];
        [contentView addSubview:enquiriePriceLB];
        [enquiriePriceLB setText: self.suggestPrice? [NSString stringWithFormat:@"建议报价%@万",self.suggestPrice] : @"正在询价"];
        enquiriePriceLB.textColor = YHColor0X(0xaaaaaa, 1.0);
        enquiriePriceLB.textAlignment = NSTextAlignmentCenter;
        [enquiriePriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            if(self.suggestPrice) make.centerX.mas_equalTo(contentView.mas_centerX);
            else make.right.mas_equalTo(enquirieBtn.mas_right);
            make.centerY.mas_equalTo(enquirieBtn.mas_centerY);
        }];
      
        enquiriePriceLB.hidden = !self.isEnquiry;
        enquirieBtn.hidden = self.isEnquiry;

    }
    
    
    UILabel *priceLB = [[UILabel alloc] init];
    [contentView addSubview:priceLB];
    [priceLB setText:self.isOffer? @"车价": @"价格"];
    priceLB.textColor = YHColor0X(0xaaaaaa, 1.0);
    CGFloat priceLBTop = self.isHelpBuy? 40 : 10;
    [priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(16);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(52);
        make.top.mas_equalTo(line.mas_bottom).offset(priceLBTop); //10 + 30
        
    }];
    
    UITextField *priceTF = [[UITextField alloc] init];
    priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    UILabel *priceUnit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    priceUnit.text = @"万元";
    priceUnit.textColor = YHColor0X(0xaaaaaa, 1.0);
    
    priceTF.rightViewMode = UITextFieldViewModeAlways;
    priceTF.rightView = priceUnit;
    [contentView addSubview:priceTF];
    priceTF.font = [UIFont systemFontOfSize:15];
    
    priceTF.placeholder = self.isOffer? @"请输入车价" : self.isHelpBuy?@"请输入帮买价格":@"请输入帮卖价格";
    [priceTF setBorderStyle:UITextBorderStyleRoundedRect];
    //priceLB.textAlignment = NS3TextAlignmentCenter;
    _priceTF = priceTF;
    
    [priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(16);
        make.right.mas_equalTo(contentView).offset(-16);
        
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(priceLB.mas_bottom).offset(10);
        
    }];
    
    
    /////
    UILabel *commissionLB = [[UILabel alloc] init];
    [contentView addSubview:commissionLB];
    commissionLB.textColor = YHColor0X(0xaaaaaa, 1.0);
    [commissionLB setText:@"佣金"];
    //priceLB.textAlignment = NSTextAlignmentCenter;
    
    [commissionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(16);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(52);
        make.top.mas_equalTo(priceTF.mas_bottom).offset(10);
        
    }];
    
    UITextField *commissionTF = [[UITextField alloc] init];
    UILabel *commissionUnit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    commissionUnit.text = @"元";
    commissionUnit.textColor = YHColor0X(0xaaaaaa, 1.0);
    commissionTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    commissionTF.rightView = commissionUnit;
    commissionTF.rightViewMode = UITextFieldViewModeAlways;
    commissionTF.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:commissionTF];
    [commissionTF setPlaceholder:@"请输入佣金"];
    //priceLB.textAlignment = NSTextAlignmentCenter;
    [commissionTF setBorderStyle:UITextBorderStyleRoundedRect];
    _commissionTF = commissionTF;
    
    [commissionTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(16);
        make.right.mas_equalTo(contentView).offset(-16);
        
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(commissionLB.mas_bottom).offset(10);
        
    }];
    
    
    UIView *lineB =[[UIView alloc] init];
    lineB.backgroundColor = YHBackgroundColor;
    [contentView addSubview:lineB];
    
    [lineB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(0);
        make.right.mas_equalTo(contentView).offset(-0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(commissionTF.mas_bottom).offset(10);
        
    }];
    
    UIButton *cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cannelBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [cannelBtn setTitleColor:YHColor0X(0xaaaaaa, 1.0) forState:UIControlStateNormal];
    
    [contentView addSubview:cannelBtn];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:YHNaviColor forState:UIControlStateNormal];
    [submitBtn setTitleColor:YHColor0X(0xaaaaaa, 1.0) forState:UIControlStateDisabled];

    [contentView addSubview:submitBtn];
    _submitBtn = submitBtn;
    
    UIView *lineC =[[UIView alloc] init];
    lineC.backgroundColor = YHBackgroundColor;
    [contentView addSubview:lineC];
    
    [cannelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(0);
        make.right.mas_equalTo(lineC.mas_left).offset(0);
        
        make.top.mas_equalTo(lineB.mas_bottom).offset(0);
        make.bottom.mas_equalTo(contentView).offset(0);
        
    }];
    
    [lineC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(submitBtn.mas_left).offset(0);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(lineB.mas_bottom).offset(0);
        make.bottom.mas_equalTo(contentView).offset(0);
        
    }];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView).offset(0);
        make.width.mas_equalTo(cannelBtn.mas_width);
        make.top.mas_equalTo(lineB.mas_bottom).offset(0);
        make.bottom.mas_equalTo(contentView).offset(0);
        
    }];
    
    
    
}

- (void)setPrice:(NSString *)price{
    _price = price;
    self.priceTF.text = price;
    self.priceTF.userInteractionEnabled = !self.isOffer;
    self.submitBtn.enabled = self.priceTF.userInteractionEnabled;
}

- (void)setCommission:(NSString *)commission{
    _commission = commission;
    self.commissionTF.text = commission;
    self.commissionTF.userInteractionEnabled = !self.isOffer;
    self.submitBtn.enabled  = self.priceTF.userInteractionEnabled;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.priceTF.userInteractionEnabled) {
        [self.priceTF becomeFirstResponder];
    }else if (self.commissionTF.userInteractionEnabled){
        [self.commissionTF becomeFirstResponder];
    }
}

@end
