//
//  YHNewOrderController.m
//  YHWanGuoOwner
//
//  Created by Zhu Wensheng on 2017/4/12.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
// 

#import <MJExtension/MJExtension.h>
#import "YHNewOrderController.h"
#import "YHCommon.h"

#import "YHNetworkPHPManager.h"
#import "YHCarSelCell.h"
#import "YHNetworkManager.h"
#import "YHCarVersionVC.h"   //车辆版本VC
#import "SmartOCRCameraViewController.h"  //扫描识别VIN码控制器
#import "YHNetworkPHPManager.h"
#import "YHTools.h"
//#import "MBProgressHUD+MJ.h"
#import "YHDiagnosisBaseVC.h"
#import "YHCarPhotoService.h"


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

@end

@implementation YHNewOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _vinBackLC.constant =  screenWidth * 750. / 1334;
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
    
    if (self.isPushByOrderList == YES) {
        SmartOCRCameraViewController *smartVC = [[SmartOCRCameraViewController alloc]init];
        smartVC.recogOrientation = RecogInVerticalScreen;//竖屏
        smartVC.preController = self;
        [self.navigationController pushViewController:smartVC animated:NO];
    }
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
//    [self checkCustomer];
    
}

#pragma mark - 1.点击“箭头”按钮
/**
 之前就是pop回原来的网页
 修改:
 1.成请求车型接口如果有数据跳转至选择车辆版本控制
 2.如果没有请求接口没有数据那么就跳转至 检测信息控制器
 */
- (IBAction)vinNextAction:(id)sender
{
    kPreventRepeatClickTime(1); //防止重复点击
    
    WeakSelf;
    
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

        if (NULLString(self.vinTF.text)) {
            [MBProgressHUD showError:@"车架号不能为空" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        
        if (self.vinTF.text.length < 17 ) {
            [MBProgressHUD showError:@"请检查车架号位数" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }

        //有数据的车架号   LFV3A23C6D3120328
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]checkTheCarCreateNewWorkOrderWithToken:[YHTools getAccessToken] Vin:self.vinTF.text onComplete:^(NSDictionary *info) {
            
            NSLog(@"===1.车架号数据:%@===",info);

            //如果请求网络成功
            //(1)进行汽车版本列表
            if ([info[@"code"]longLongValue] == 20000) {
                
                NSMutableArray *modelArr = [NSMutableArray array];
                for (NSDictionary *dict in info[@"data"]) {
                    YHCarVersionModel *model = [YHCarVersionModel mj_objectWithKeyValues:dict];
                    [modelArr addObject:model];
                }
                
                YHDiagnosisBaseVC *baseVC = [[YHDiagnosisBaseVC alloc]init];
                baseVC.isHelp = NO;
                
                if (!modelArr.count) { // 没有数据
                    baseVC.isOther = 1;
                }else{
                    baseVC.model = [modelArr firstObject];
                }
                baseVC.vinStr = self.vinTF.text;
                baseVC.bucheBookingId = self.bucheBookingId;
                [self.navigationController pushViewController:baseVC animated:YES];
            //(2)进行工单基本信息控制器
            }else if([info[@"code"]longLongValue] == 20400){
                
                YHDiagnosisBaseVC *VC = [[YHDiagnosisBaseVC alloc] init];
                VC.vinController = self;
                VC.vinStr = self.vinTF.text;
                VC.bucheBookingId = self.bucheBookingId;
                VC.carType = 1;   //vin号识别不出来传1
                [weakSelf.navigationController pushViewController:VC animated:YES];
                
            //(3)弹出错误提示信息
            }else{
                [MBProgressHUD showError:info[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            }
            
        } onError:^(NSError *error) {
            
        }];

    }
}

#pragma mark - 2.点击“扫描识别Vin码”按钮
- (IBAction)scanToIdentifyTheVINCode:(UIButton *)sender
{
    SmartOCRCameraViewController *smartVC = [[SmartOCRCameraViewController alloc]init];
    smartVC.recogOrientation = RecogInVerticalScreen;//竖屏
    smartVC.preController = self;
    [self.navigationController pushViewController:smartVC animated:YES];
}

//    [self getDetailByVin:_vinTF.text];
/*    pop回原来的网页功能
 [self.webController pushVin:_vinTF.text];
 __weak __typeof__(self) weakSelf = self;
 NSArray *controllers = self.navigationController.viewControllers;
 for(NSInteger i = controllers.count - 1; i >= 0; i--) {
 UIViewController *controller = controllers[i];
 if ([controller isKindOfClass:[YHWebFuncViewController class]]) {
 [weakSelf.navigationController popToViewController:controller animated:YES];
 return;
 }
 }
 */

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _checkCars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCarSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDatasource:_checkCars[indexPath.row] isSel:((_carSel) && indexPath.row == _carSel.integerValue)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

//- (void)checkCustomer{
//    [[YHCarPhotoService new] checkCustomerForVin:self.vin Success:^(NSDictionary *obj) {
//
//    } failure:^(NSError *error) {
//
//    }];
//}

-(void)dealloc
{
    NSLog(@"2323");
}

@end
