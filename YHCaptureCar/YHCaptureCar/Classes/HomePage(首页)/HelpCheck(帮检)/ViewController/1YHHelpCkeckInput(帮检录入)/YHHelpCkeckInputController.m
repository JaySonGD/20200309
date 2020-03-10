//
//  YHHelpCkeckInputController.m
//  YHCaptureCar
//
//  Created by Jay on 2018/4/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHHelpCkeckInputController.h"
#import "YHHelpCheckMapController.h"
#import "YHBrandChooseTC.h"
#import "YHPayResultController.h"
#import "YHHelpCheckViewController.h"

#import "YHPayServiceFeeView.h"
#import "YHInPutCell.h"
#import "YHReservationModel.h"

#import "YHCarVersionModel.h"

#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>


#import "YHCommon.h"
#import "YHHelpSellService.h"
#import "MBProgressHUD+MJ.h"

@implementation TTZInPutModel
@end
@interface YHHelpCkeckInputController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <TTZInPutModel *>*models;
@property (nonatomic, strong) UIView *payContentView;
@property (nonatomic, weak) YHPayServiceFeeView *payServiceFeeView;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *payMoneyString;//"¥500元";
@end

@implementation YHHelpCkeckInputController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
}

- (void)setModel:(YHCarVersionModel *)model
{
    WeakSelf;
    _model = model;
//    self.models[1].text = self.carType;
    
    self.models[1].carLineId = model.carLineId;//[info valueForKey:@"lineId"];
    self.models[1].carBrandId = model.carBrandId;//[info valueForKey:@"brandId"];
    
    if ([model.carLineName containsString:model.carBrandName]) {
        self.models[1].text = model.carLineName;
    }else{
        self.models[1].text = [NSString stringWithFormat:@"%@%@",model.carBrandName,model.carLineName];
    }
    
    [YHHelpSellService detectionFeeForCarModelId:nil
                                       carLineId:self.model.carLineId
                                      carBrandId:self.model.carBrandId
                                             vin:self.vinStr
                                      onComplete:^(NSString *free) {
                                          weakSelf.models[2].text = [NSString stringWithFormat:@"%@元",free];
                                          weakSelf.payMoneyString = [NSString stringWithFormat:@"金额:%@元",free];
                                          [weakSelf.tableView reloadData];
                                      } onError:^(NSError *error) {
                                          [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
                                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



////FIXME:  -  正则匹配手机号
//- (BOOL)checkTelNumber:(NSString *) telNumber
//{
//    NSString *pattern = @"^1+[3578]+\\d{9}";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:telNumber];
//    return isMatch;
//}

//判断是否为手机号
- (BOOL)checkTelNumber:(NSString *)telNumber{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:telNumber];
}



//FIXME:  -  事件监听
- (void)appointmentAction{
    
    //    [self showPayView];
    //    return;
    
    NSString *vin = self.models.firstObject.text;
    if (vin.length < 1) {
        [MBProgressHUD showError:@"车架号不能为空"];
        return;
    }
    
    NSString *carFullName = self.models[1].text;
    if (carFullName.length < 1) {
        [MBProgressHUD showError:@"车系车型不能为空"];
        return;
    }
    NSString *contactUser = self.models[3].text;
    if (contactUser.length < 1) {
        [MBProgressHUD showError:@"联系人不能为空"];
        return;
    }
    NSString *contactTel = self.models[4].text;
    if (contactTel.length < 1) {
        [MBProgressHUD showError:@"请填写联系人电话"];
        return;
    }
    
    if (![self checkTelNumber:contactTel]) {
        [MBProgressHUD showError:@"联系人电话有误"];
        return;
    }

    
    NSString *bookDate = self.models[5].text;
    if (bookDate.length < 1) {
        [MBProgressHUD showError:@"请选择预约时间"];
        return;
    }
    
    NSString *orgName = self.models.lastObject.org_Name;
    if (orgName.length < 1) {
        [MBProgressHUD showError:@"检测站点不能为空"];
        return;
    }
    
    NSString *org_id = self.models.lastObject.org_id;
    if (org_id.length < 1) {
        [MBProgressHUD showError:@"检测站ID不能为空"];
        return;
    }
    
    NSString *smsNotifyPhone = self.models.lastObject.smsNotifyPhone;
    if (smsNotifyPhone.length < 1) {
        [MBProgressHUD showError:@"短信发送号码不能为空"];
        return;
    }
    
    
    
    if (self.models[1].carLineId.length < 1) {
        [MBProgressHUD showError:@"车系ID不能为空"];
        return;
    }
    if (self.models[1].carBrandId.length < 1) {
        [MBProgressHUD showError:@"品牌ID不能为空"];
        return;
    }
    [self showPayView];
}


- (void)loadPayment{
    
    NSString *vin = self.models.firstObject.text;
    NSString *carFullName = self.models[1].text;
    NSString *contactUser = self.models[3].text;
    NSString *contactTel = self.models[4].text;
    NSString *bookDate = self.models[5].text;
    
    NSString *org_id = self.models.lastObject.org_id;
    
    NSString *orgName = self.models.lastObject.org_Name;
    NSString *smsNotifyPhone = self.models.lastObject.smsNotifyPhone;

    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showMessage:nil toView:[UIApplication sharedApplication].keyWindow];
    [YHHelpSellService inputWithVin:vin
                        carFullName:carFullName
                        contactUser:contactUser
                         contactTel:contactTel
                     smsNotifyPhone:smsNotifyPhone
                           bookDate:bookDate
                             org_id:org_id
                            orgName:orgName
                          carLineId:self.models[1].carLineId
                         carBrandId:self.models[1].carBrandId
                         onComplete:^(NSString *Id){
                             weakSelf.Id = Id;
                             //[MBProgressHUD hideHUDForView:self.view];
                             //[weakSelf showPayView];
                             [weakSelf wxPay];
                         }
                            onError:^(NSError *error) {
                                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
                                [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:[UIApplication sharedApplication].keyWindow];
                            }];

}

- (void)showPayView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.payContentView];
    self.payServiceFeeView.moneyLabel.text = self.payMoneyString;
    
}

- (void)jump2Map{
    __weak typeof(self) weakSelf = self;
    YHHelpCheckMapController *mapVC = [YHHelpCheckMapController new];
    mapVC.chooseAddr = ^(YHReservationModel *model) {
        weakSelf.models.lastObject.text = model.name;
        weakSelf.models.lastObject.org_id = model.ID;
        weakSelf.models.lastObject.smsNotifyPhone = model.smsNotifyPhone;
        weakSelf.models.lastObject.org_Name = model.name;

        
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:mapVC animated:YES];
}
//FIXME:   -  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //     __weak typeof(self) weakSelf = self;
    YHInPutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHInPutCell"];
    cell.model = self.models[indexPath.row];
    //    cell.jump2Map = ^{
    //        [weakSelf jump2Map];
    //    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
        {
            YHBrandChooseTC *brandTC = [[YHBrandChooseTC alloc]init];
            [self.navigationController pushViewController:brandTC animated:YES];
            
        }
            break;
        case 6:
        {
            [self jump2Map];
        }
            break;
            
        default:
            break;
    }
}

//FIXME:  -  自定义方法
- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"预约帮捡";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(0);
    }];
    
    
    UIButton *appointmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    appointmentBtn.backgroundColor = YHNaviColor;
    [appointmentBtn setTintColor:[UIColor whiteColor]];
    appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [appointmentBtn setTitle:@"预 约" forState:UIControlStateNormal];
    [appointmentBtn addTarget:self action:@selector(appointmentAction) forControlEvents:UIControlEventTouchUpInside];
    YHViewRadius(appointmentBtn, 10);
    [self.view addSubview:appointmentBtn];
    [appointmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(8);
        make.right.mas_equalTo(self.view).offset(-8);
        make.bottom.mas_equalTo(self.view).offset(-15-kTabbarSafeBottomMargin);
        make.height.mas_equalTo(64);
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpPayResult) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brandName:) name:@"brandName" object:nil];
}

- (void)brandName:(NSNotification *)noti{
    NSDictionary *info = noti.userInfo;
    NSString *brandName = [info valueForKey:@"brandName"];
    NSString *lineName = [info valueForKey:@"lineName"];
    self.models[1].carLineId = [info valueForKey:@"lineId"];
    self.models[1].carBrandId = [info valueForKey:@"brandId"];
    
    __weak typeof(self) weakSelf = self;
    [YHHelpSellService detectionFeeForCarModelId:nil
                                       carLineId:[info valueForKey:@"lineId"]
                                      carBrandId:[info valueForKey:@"brandId"]
                                             vin:self.vinStr
                                      onComplete:^(NSString *free) {
                                          weakSelf.models[2].text = [NSString stringWithFormat:@"%@元",free];
                                          weakSelf.payMoneyString = [NSString stringWithFormat:@"金额:%@元",free];
                                          [weakSelf.tableView reloadData];
                                      } onError:^(NSError *error) {
                                          [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:self.view];
                                      }];
    self.models[1].text = [NSString stringWithFormat:@"%@%@",brandName,lineName];
    [self.tableView reloadData];
}

#pragma mark  -  get/set 方法
- (NSArray<TTZInPutModel *> *)models{
    if (!_models) {
        
        NSArray *dics = @[
                          @{@"name":@"车架号",@"placeholder":@"车架号",@"image":@"",@"text":self.vinStr?self.vinStr:@""},
                          @{@"name":@"车系车型",@"placeholder":@"请选择车系车型",@"image":@"进入选择"},
                          @{@"name":@"检测费",@"placeholder":@"",@"image":@""},
                          @{@"name":@"联系人",@"placeholder":@"请输入联系人",@"image":@""},
                          @{@"name":@"联系人电话",@"placeholder":@"请输入联系人电话",@"image":@""},
                          @{@"name":@"预约时间",@"placeholder":@"请选择预约时间",@"image":@"",@"isCusKeyboard" : @(1)},
                          @{@"name":@"检测站",@"placeholder":@"请选择检测站",@"image":@"定位"},
                          ];
        
        _models = [TTZInPutModel mj_objectArrayWithKeyValuesArray:dics];
    }
    
    return _models;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YHInPutCell" bundle:nil] forCellReuseIdentifier:@"YHInPutCell"];
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.rowHeight = 60;//UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = YHBackgroundColor;
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64+15, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        
        
        
    }
    return _tableView;
}


- (UIView *)payContentView{
    if (!_payContentView) {
        __weak typeof(self) weakSelf = self;
        _payContentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        YHPayServiceFeeView *payServiceFeeView = [YHPayServiceFeeView payServiceFeeView];
        [_payContentView addSubview:payServiceFeeView];
        payServiceFeeView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 200);
        payServiceFeeView.layer.cornerRadius = 5;
        payServiceFeeView.layer.masksToBounds = YES;
        payServiceFeeView.payRemindLabel.text = @"支付检测费";
        _payServiceFeeView = payServiceFeeView;
        payServiceFeeView.btnClickBlock = ^(UIButton *button) {
            [weakSelf buttonClick:button];
            
        };
        _payContentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _payContentView;
}

//FIXME:  -  支付事件
- (void)buttonClick:(UIButton *)sender{
    
    if (sender.tag == 1) {
        [self.payContentView removeFromSuperview];
        return;
    }
    
    if (sender.tag == 3) {
        [MBProgressHUD showError:@"后期开通,敬请期待"];
        return;
    }
    
    
    //[self submitBtnClick:nil];
    //[self wxPay];
    
    
    [self loadPayment];
    
}

//FIXME:  -  微信支付
- (void)wxPay{
    __weak typeof(self) weakSelf = self;
    [YHHelpSellService payHelpTradeWithId:self.Id
                               onComplete:^(NSString *wxPrepayId, NSString *orderId) {
                                   weakSelf.orderId = orderId;
                                   [weakSelf payByPrepayId:wxPrepayId];
                                   [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
                                   [weakSelf.payContentView removeFromSuperview];

                               } onError:^(NSError *error) {
                                   [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
                                   [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:[UIApplication sharedApplication].keyWindow];
                               }];
    
}
//FIXME:  -  微信支付结果回调
- (void)tongzhi:(NSNotification *)text{
    
//    NSString * success = text.userInfo[@"Success"];
    
//    if ([success isEqualToString:@"YES"]) {
        //[MBProgressHUD showSuccess:@"支付成功！" toView:self.view];
//        [self jumpPayResult];
//    }else{
        //[MBProgressHUD showError:@"支付错误"];
//        [self jumpCheckView];
    
//    }
}

- (void)jumpCheckView{
    
//    if(!self.orderId) return;
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHHelpCheckViewController class]]) {
            ((YHHelpCheckViewController *)obj).isPop = YES;
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

//FIXME:  -  支付结果页面
- (void)jumpPayResult{
    
    if (!self.orderId) return;
    
    NSString *orderId = self.orderId;
    self.orderId = nil;
#if 1
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService payCallBackWithId:orderId
                              onComplete:^{
                                  [MBProgressHUD hideHUDForView:weakSelf.view];
                                  YHPayResultController *resultVC = [YHPayResultController new];
                                  resultVC.payMoneyString = weakSelf.payMoneyString;
                                  
                                  resultVC.doAction = ^{
                                      
                                      [weakSelf jumpCheckView];
                                      
                                  };
                                  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:resultVC];
                                  [self presentViewController:navVC animated:YES completion:nil];
                                  
                              } onError:^(NSError *error) {
                                  [MBProgressHUD hideHUDForView:weakSelf.view];
                                  [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
                                  [weakSelf jumpCheckView];
                              }];
    
#else
    
    YHPayResultController *resultVC = [YHPayResultController new];
    resultVC.payMoneyString = self.payMoneyString;
    resultVC.doAction = ^{
        
        [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YHHelpCheckViewController class]]) {
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
        
    };
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:resultVC];
    [self presentViewController:navVC animated:YES completion:nil];
    
    
#endif
    
}


@end


