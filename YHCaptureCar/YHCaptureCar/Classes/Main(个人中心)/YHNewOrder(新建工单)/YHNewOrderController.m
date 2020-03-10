//
//  YHNewOrderController.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/4/12.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
// 

#import <MJExtension.h>
#import "YHNewOrderController.h"
#import "YHCommon.h"
#import "YHSVProgressHUD.h"
#import "YHNetworkPHPManager.h"
#import "YHCarSelCell.h"
#import "YHNetworkManager.h"
#import "YHCarVersionVC.h"   //车辆版本VC
#import "SmartOCRCameraViewController.h"  //扫描识别VIN码控制器
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "MBProgressHUD+MJ.h"
#import "YHDiagnosisBaseVC.h"

#import "YHHelpCkeckInputController.h"
#import "YHHelpSellService.h"

#import "YHDetailViewController.h"
#import "YHPayServiceFeeView.h"

#import "WXPay.h"

NSString *const notificationCarSel = @"YHNnotificationCarSel";
@interface YHNewOrderController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *showView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vinBackLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carSelC;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (strong, nonatomic)NSNumber *carSel;
@property (strong, nonatomic)NSArray *checkCars;
@property (weak, nonatomic) IBOutlet UITextField *vinTF;
@property (strong, nonatomic)NSMutableDictionary *result;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagHLC;
/**
 扫描识别Vin码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *ScanVinBtn;

@property (weak, nonatomic) IBOutlet UIButton *viewReportButton;

@property (weak, nonatomic) IBOutlet UIView *reportContentView;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carFullNameLabel;

@property (nonatomic, strong) NSDictionary *reportInfo;



//功能视图
@property (nonatomic, strong) UIView *functionView;
//支付服务费视图
@property (nonatomic, weak) YHPayServiceFeeView *payServiceFeeView;

@end

@implementation YHNewOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _vinBackLC.constant =   screenWidth * 750. / 1334;
    _showView.image = _image;
    _vinTF.text = _vin;
    self.vinTF.delegate = self;
    if (!_isCar) {
        _imageLC.constant =  _imageLC.constant -  100 + 60;
        _imagHLC.constant = 200;
    }
    
    self.ScanVinBtn.layer.cornerRadius = 25;
    self.ScanVinBtn.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loaddata:(NSString*)vin image:(UIImage*)image
{
    self.vin = vin;
    self.image = image;
    _showView.image = _image;
    _vinTF.text = _vin;
    //    if (!_isCar) {
    //        _imageLC.constant =  _imageLC.constant -  200 + 60;
    //        _imagHLC.constant = 200;
    //    }
}

//FIXME:  -  发起重捡
- (IBAction)againTest {
    
    [self getCarInfoByVin];
}

- (void)showPayFreeView{
    
    WeakSelf;
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.functionView.backgroundColor = YHColorA(127, 127, 127, 0.5);
    [self.view addSubview:self.functionView];
    
    if (!self.payServiceFeeView) {
        self.payServiceFeeView = [[NSBundle mainBundle]loadNibNamed:@"YHPayServiceFeeView" owner:self options:nil][0];
        self.payServiceFeeView.frame = CGRectMake(30, (screenHeight-200)/2, screenWidth-60, 200);
        self.payServiceFeeView.layer.cornerRadius = 5;
        self.payServiceFeeView.layer.masksToBounds = YES;
        self.payServiceFeeView.payRemindLabel.text = @"报告费";
        [self.functionView addSubview:self.payServiceFeeView];
    }
    
    //刷新UI
    self.payServiceFeeView.moneyLabel.text = [NSString stringWithFormat:@"%@元",[self.reportInfo valueForKey:@"payAmt"]];
    
    //点击事件
    self.payServiceFeeView.btnClickBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 1://关闭
                [weakSelf.functionView removeFromSuperview];
                break;
            case 2://微信支付
            {
                [weakSelf wxPay];
                
            }
                break;
            case 3://支付宝支付
            {
                [MBProgressHUD showError:@"后期开通,敬请期待"];
            }
                break;
            default:
                break;
        }
    };
    
    
}

//FIXME:  -  detail

- (void)jumpDetail:(NSString *)code{
    
    
    
    YHDetailViewController *VC = [[UIStoryboard storyboardWithName:@"YHDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDetailViewController"];
    VC.rptCode = [NSString stringWithFormat:@"%@&type=2",code];
    VC.jumpString = @"帮检详情";
    [self.navigationController pushViewController:VC animated:YES];
    
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [viewControllers removeObjectAtIndex:viewControllers.count-2];  
    self.navigationController.viewControllers = viewControllers;
    

}

//FIXME:  -  wxPay
- (void)wxPay{
    
     __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:nil toView:self.view];
    [YHHelpSellService toHelpRptPayCode:[self.reportInfo valueForKey:@"rptCode"]
                             onComplete:^(NSDictionary *info) {
                                 [MBProgressHUD hideHUDForView:weakSelf.view];
                                 [weakSelf.functionView removeFromSuperview];
                                 NSInteger payStatus = [[info valueForKey:@"payStatus"] integerValue];
                                 if (payStatus == 1) {
                                     
                                     NSString *code = [info valueForKey:@"url"];
                                     [weakSelf jumpDetail:code];
                                     return ;
                                 }
                                 
                                [[WXPay sharedWXPay] payByParameter:info
                                                            success:^{
                                                                
                                                                [YHHelpSellService rptPayCallBackWithId:[info valueForKey:@"orderId"] onComplete:^(NSString *code) {
                                                                    [weakSelf jumpDetail:code];
                                                                } onError:^(NSError *error) {
                                                                    [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
                                                                }];
                                                            }
                                                            failure:^{
                                                                [MBProgressHUD showError:@"支付失败" toView:weakSelf.view];
                                                            }];
                             }
                                onError:^(NSError *error) {
                                    [MBProgressHUD hideHUDForView:weakSelf.view];
                                    [MBProgressHUD showError:[error.userInfo valueForKey:@"message"] toView:weakSelf.view];
                                }];
}

- (IBAction)reportAction:(UIButton *)sender {

    
    NSInteger status = [[self.reportInfo valueForKey:@"status"] integerValue];
    //支付状态 0 - 未支付 1 - 已支付，未支付时要拿 rptCode 请求支付接口，已支付可以直接用 rptCode 查看报告
    
    if (!status) {
        
        [self showPayFreeView];
        
        return;
    }
    
    [self jumpDetail:[self.reportInfo valueForKey:@"rptCode"]];
}

//FIXME:  -  处理最近报告
- (void)setReportView:(NSDictionary *)info{
    self.reportInfo = info;
    self.reportContentView.hidden = NO;
    self.orgNameLabel.text = [NSString stringWithFormat:@"%@ %@",[info valueForKey:@"addTime"],[info valueForKey:@"orgName"]];//;
    self.carFullNameLabel.text = [NSString stringWithFormat:@"检测%@",[info valueForKey:@"carFullName"]];
    
    NSInteger status = [[info valueForKey:@"status"] integerValue];
    //支付状态 0 - 未支付 1 - 已支付，未支付时要拿 rptCode 请求支付接口，已支付可以直接用 rptCode 查看报告
    
    
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:status? @"查看报告详情 >>":[NSString stringWithFormat: @"查看报告详情 (￥%@) >>",[info valueForKey:@"payAmt"]]];
    
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    [tncString addAttribute:NSForegroundColorAttributeName value:YHNaviColor  range:NSMakeRange(0,[tncString length])];
    [tncString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0,[tncString length])];
    
    [tncString addAttribute:NSUnderlineColorAttributeName value:YHNaviColor range:(NSRange){0,[tncString length]}];
    [self.viewReportButton setAttributedTitle:tncString forState:UIControlStateNormal];



}


#pragma mark - -----------扫描识别Vin码-----------
/**
 扫描识别Vin码
 */
- (IBAction)scanToIdentifyTheVINCode:(UIButton *)sender {
    SmartOCRCameraViewController *smartVC = [[SmartOCRCameraViewController alloc]init];
    // 设置竖屏扫描
    smartVC.recogOrientation = RecogInVerticalScreen;
    smartVC.preController = self;
    [self.navigationController pushViewController:smartVC animated:YES];
}

#pragma mark - ------------箭头------------
/**
 之前就是pop回原来的网页, 修改:
 1.成请求车型接口如果有数据跳转至选择车辆版本控制
 2.如果没有请求接口没有数据那么就跳转至 检测信息控制器
 */
- (IBAction)vinNextAction:(id)sender
{
    __weak __typeof__(self) weakSelf = self;

    if (_webController != nil) {
        
        [self.webController pushVin:_vinTF.text];
        
        NSArray *controllers = self.navigationController.viewControllers;
        for(NSInteger i = controllers.count - 1; i >= 0; i--) {
            UIViewController *controller = controllers[i];
            if ([controller isKindOfClass:[YHWebFuncViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
    }else{
        //self.vinTF.text = @"LFV3A23C6D3120328";//调试专用

        //if (NULLString(self.vinTF.text) && !self.isHelpCheck) {
        if (NULLString(self.vinTF.text)) {
            [MBProgressHUD showError:@"车架号VIN不能为空" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        
        
        //if (self.vinTF.text.length < 17 && !self.isHelpCheck) {
        if (self.vinTF.text.length < 17) {
            [MBProgressHUD showError:@"请检查车架号位数" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        
        
        if (self.isHelpCheck && NULLString(self.vinTF.text)) {
            YHHelpCkeckInputController *vc = [YHHelpCkeckInputController  new];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        if (self.isHelpCheck && ![self.vin isEqualToString:self.vinTF.text]) {
            self.vin = self.vinTF.text;
            
            [YHSVProgressHUD showWithStatus:nil];
            [YHHelpSellService findVinReportWithVin:self.vinTF.text onComplete:^(NSDictionary *obj) {
                [weakSelf setReportView:obj];
                [YHSVProgressHUD dismiss];
            } onError:^(NSError *error) {
                ////
                weakSelf.reportContentView.hidden = YES;
                [weakSelf getCarInfoByVin];
                [YHSVProgressHUD dismiss];
                /////
            }];
            return;
        }
        
        [self getCarInfoByVin];
        return;
        //有数据的车架号   LFV3A23C6D3120328
        [YHSVProgressHUD showWithStatus:@"加载中..."];
        [[YHNetworkManager sharedYHNetworkManager] getCarInfoByVin:[YHTools getAccessToken] vin:self.vinTF.text onComplete:^(NSDictionary *info) {
            
            [YHSVProgressHUD dismiss];
            
            //如果请求网络成功
            if ([info[@"retCode"]longLongValue] == 0) {//   进行汽车版本列表
                
                NSArray *result = info[@"result"];
                
                if (result.count != 0 && result) {
                    YHCarVersionVC *carVersionVC = [[UIStoryboard storyboardWithName:@"diagnosis" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCarVersionVC"];
                    
                    carVersionVC.vinStr =  weakSelf.vinTF.text;
                    carVersionVC.isHelpCheck = weakSelf.isHelpCheck;
                    
                    NSMutableArray *tmpCarVersionModels = [@[]mutableCopy];
                    for (NSDictionary *dict in result) {
                        YHCarVersionModel *model = [YHCarVersionModel mj_objectWithKeyValues:dict];
                        [tmpCarVersionModels addObject:model];
                    }
                    
                    YHCarVersionModel *lastModel = [YHCarVersionModel new];
                    lastModel.carModelFullName = @"其它";
                    [tmpCarVersionModels addObject:lastModel];
                    
                    carVersionVC.carVersionArray = tmpCarVersionModels;
                    [weakSelf.navigationController pushViewController:carVersionVC animated:YES];
                    
                } else {
                    
                    if (self.isHelpCheck) {
                        YHHelpCkeckInputController *vc = [YHHelpCkeckInputController  new];
                        vc.vinStr = weakSelf.vinTF.text;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        return;
                    }
                    
                    YHDiagnosisBaseVC *baseVC = [[UIStoryboard storyboardWithName:@"diagnosis" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDiagnosisBaseVC"];
                    baseVC.vinStr = weakSelf.vinTF.text;
                    baseVC.carType = 1;   //vin号识别不出来传1
                    [weakSelf.navigationController pushViewController:baseVC animated:YES];
                }
            } else {//弹出错误提示信息
                [MBProgressHUD showError:info[@"retMsg"] toView:[UIApplication sharedApplication].keyWindow];
            }
            
        } onError:^(NSError *error) {
            [YHSVProgressHUD dismiss];
        }];
    }
}

//FIXME:  -
- (void)getCarInfoByVin{
    
     __weak typeof(self) weakSelf = self;
    //有数据的车架号   LFV3A23C6D3120328
    [YHSVProgressHUD showWithStatus:@"加载中..."];
    [[YHNetworkManager sharedYHNetworkManager] getCarInfoByVin:[YHTools getAccessToken] vin:self.vinTF.text onComplete:^(NSDictionary *info) {
        
        [YHSVProgressHUD dismiss];
        
        //如果请求网络成功
        if ([info[@"retCode"]longLongValue] == 0) {//   进行汽车版本列表
            
            NSArray *result = info[@"result"];
            
            if (result.count != 0 && result) {
                YHCarVersionVC *carVersionVC = [[UIStoryboard storyboardWithName:@"diagnosis" bundle:nil] instantiateViewControllerWithIdentifier:@"YHCarVersionVC"];
                
                carVersionVC.vinStr =  weakSelf.vinTF.text;
                carVersionVC.isHelpCheck = weakSelf.isHelpCheck;
                
                NSMutableArray *tmpCarVersionModels = [@[]mutableCopy];
                for (NSDictionary *dict in result) {
                    YHCarVersionModel *model = [YHCarVersionModel mj_objectWithKeyValues:dict];
                    [tmpCarVersionModels addObject:model];
                }
                
                YHCarVersionModel *lastModel = [YHCarVersionModel new];
                lastModel.carModelFullName = @"其它";
                [tmpCarVersionModels addObject:lastModel];
                
                carVersionVC.carVersionArray = tmpCarVersionModels;
                [weakSelf.navigationController pushViewController:carVersionVC animated:YES];
                
            } else {
                
                if (self.isHelpCheck) {
                    YHHelpCkeckInputController *vc = [YHHelpCkeckInputController  new];
                    vc.vinStr = weakSelf.vinTF.text;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    return;
                }
                
                YHDiagnosisBaseVC *baseVC = [[UIStoryboard storyboardWithName:@"diagnosis" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDiagnosisBaseVC"];
                baseVC.vinStr = weakSelf.vinTF.text;
                baseVC.carType = 1;   //vin号识别不出来传1
                [weakSelf.navigationController pushViewController:baseVC animated:YES];
            }
        } else {//弹出错误提示信息
            [MBProgressHUD showError:info[@"retMsg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        
    } onError:^(NSError *error) {
        [YHSVProgressHUD dismiss];
    }];
}

/**
 判断字符串是否为空
 */
+ (BOOL)judgeIsEmptyWithString:(NSString *)string
{
    if (string.length == 0 || [string isEqualToString:@""] || string == nil || string == NULL || [string isEqual:[NSNull null]])
    {
        return YES;
    }
    return NO;
}

- (IBAction)carNextAction:(id)sender
{
    
    //    _alertView.hidden = YES;
    //    NSMutableDictionary *carInfo = [_checkCars[_carSel.integerValue] mutableCopy];
    //    [carInfo setObject:_vinTF.text forKey:@"vin"];
    //    [[NSNotificationCenter
    //      defaultCenter]postNotificationName:notificationCarSel
    //     object:Nil
    //     userInfo:carInfo];
    //    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return _checkCars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHCarSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDatasource:_checkCars[indexPath.row] isSel:((_carSel) && indexPath.row == _carSel.integerValue)];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _carSel = [NSNumber numberWithLong:indexPath.row];
    NSDictionary *item = _checkCars[indexPath.row];
    if (_result) {
        
        __weak __typeof__(self) weakSelf = self;
        [item.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.result setObject:item[key] forKey:key];
        }];
    }else{
        self.result = [item mutableCopy];
    }
    // 车信息展示
    //    _alertView.hidden = YES;
    [_tableVIew reloadData];
}

-(void)dealloc
{
    NSLog(@"2323");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //敲删除键
    if ([string length]==0) {
        return YES;
    }
    if (_vinTF == textField) {
        if ([textField.text length]>=17)
            return NO;
    }
    
    //小写转大写
    char commitChar = [string characterAtIndex:0];
    if (commitChar > 96 && commitChar < 123){
        NSString * uppercaseString = string.uppercaseString;
        NSString * str1 = [textField.text substringToIndex:range.location];
        NSString * str2 = [textField.text substringFromIndex:range.location];
        textField.text = [NSString stringWithFormat:@"%@%@%@",str1,uppercaseString,str2].uppercaseString;
        return NO;
    }
    
    return YES;
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
