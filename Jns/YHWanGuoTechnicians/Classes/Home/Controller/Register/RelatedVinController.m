//
//  RelatedVinController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 21/8/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "RelatedVinController.h"
#import "YHWebFuncViewController.h"
#import "SmartOCRCameraViewController.h"

#import "YHCarPhotoService.h"

#import "TTZPlateTextField.h"
#import "YHCarVersionModel.h"
#import "YHDiagnosisBaseVC.h"
#import "YHOrderListController.h"
#import <MJExtension.h>

@interface RelatedVinController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet TTZPlateTextField *vinTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UIButton *doButton;
@property (weak, nonatomic) IBOutlet UIView *phoneBgView;
@property (weak, nonatomic) IBOutlet UILabel *vinTitleLB;
@property (weak, nonatomic) IBOutlet UIImageView *vimIV;
@property (weak, nonatomic) IBOutlet UITextField *carTF;
@end

@implementation RelatedVinController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
//FIXME:  -  自定义方法
- (void)setUI{
    
    self.titleTop.constant = kStatusBarAndNavigationBarHeight + 25 + 55;
    self.errorHeight.constant = 0.0;//18
    self.imgHeight.constant = 0.0 ;//90;
    
    self.carTF.text = self.carNo;
    
    CGFloat topMargin = iPhoneX ? 44 : 20;
    UIButton *backBtn = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"left_login"];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    CGFloat backY = topMargin;
    backBtn.frame = CGRectMake(10, backY, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *vinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:vinButton];
    vinButton.frame = CGRectMake(kScreenWidth - 100 - 10 , backY, 100, 44);
    [vinButton setTitle:@"扫描车架号" forState:UIControlStateNormal];
    [vinButton setTitleColor:YHColor(75, 75, 75) forState:UIControlStateNormal];
    [vinButton addTarget:self action:@selector(vinAction) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) weakSelf = self;
    self.vinTF.textChange = ^{
        [weakSelf textChange];
    };
    [self textChange];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)vinAction{
    __weak typeof(self) weakSelf = self;
    self.vinTF.text = @"";
    self.imgHeight.constant = 0;
    self.vimIV.image = nil;
    self.doButton.enabled = NO;
    self.doButton.backgroundColor = YHColor(209, 209, 209);

    SmartOCRCameraViewController *controller = [[SmartOCRCameraViewController alloc] init];
    controller.recogOrientation = RecogInVerticalScreen;//竖屏
    controller.isLocation = NO;
    controller.scanSuccessBackCall = ^(UIImage *vinImage, NSString *vinStr) {
        weakSelf.vinTF.text = vinStr;
        weakSelf.imgHeight.constant = 90;
        weakSelf.vimIV.image = vinImage;
        weakSelf.doButton.enabled = YES;
        weakSelf.doButton.backgroundColor = YHNaviColor;

    };
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)textChange{
    
    if (self.vinTF.hasText) {
        self.doButton.enabled = YES;
        self.doButton.backgroundColor = YHNaviColor;
    }else{
        self.doButton.enabled = NO;
        self.doButton.backgroundColor = YHColor(209, 209, 209);
    }
    
    if (self.errorHeight.constant) {
        self.phoneBgView.backgroundColor = YHColor(242, 242, 242);
        kViewBorderRadius(self.phoneBgView, 10, 0, YHColor(230, 81, 75));
        self.errorHeight.constant = 0;
    }
    
}
- (IBAction)doAction:(id)sender {
    
    if (![self isMatchVin:self.vinTF.text]) {
        self.errorHeight.constant = 18;
        self.phoneBgView.backgroundColor = [UIColor whiteColor];
        kViewBorderRadius(self.phoneBgView, 10, 0.5, YHColor(230, 81, 75));
        return;
    }
    
    
    [self helpOrder:self.vinTF.text];
//#pragma mark - 跳H5
//    [self jumpH5NewOpenOrder];
}


- (void)helpOrder:(NSString *)vin
{
    if (self.bill_type) {//后期统一这里跳转h5，h5自己跳转各自界面，
        WeakSelf
           [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
                   YHWebFuncViewController *webVC = (YHWebFuncViewController* )obj;
                   //[webVC vinCallback:self.vinTF.text];
                   [webVC toH5:@{@"jnsAppStep":@"vinHandle",@"plate":self.carNo,@"vin":self.vinTF.text}];
                   [weakSelf.navigationController popToViewController:obj animated:YES];
                   *stop = YES;
               }
           }];
       return;
   }
    
    __weak typeof(self) weakSelf = self;
    [self.doButton YH_showStartLoadStatus];
    [[YHCarPhotoService new] checkRestrictForVin:vin
                                         Success:^(NSDictionary *obj) {
                                                                                      [weakSelf.doButton YH_showEndLoadStatus];
                                                                                      
                                                                                     
                                                                                      NSString *allowBillType = [obj valueForKey:@"allowBillType"];
                                                                                      if([allowBillType isEqualToString:@"E001"]){
                                                                                      //if([self.bill_type isEqualToString:@"E001"] && [allowBillType isEqualToString:self.bill_type]){
                                                                                         
                                                                                          YHCarVersionModel *model = [YHCarVersionModel mj_objectWithKeyValues:[obj valueForKey:@"baseInfo"]];
                                                                                          
                                                                                          YHDiagnosisBaseVC *baseVC = [[YHDiagnosisBaseVC alloc] init];
                                                                                          baseVC.vinController = self;
                                                                                          baseVC.isHelp = YES;
                                                                                          if ([model.carModelFullName isEqualToString:@"其它"]) {//判断这个字段是否为其它  或者判断是否为数组最后一个
                                                                                              baseVC.isOther = 1;
                                                                                          }else{
                                                                                              baseVC.checkCustomerModel = model;
                                                                                          }
                                                                                          baseVC.carType = 1;   //vin号识别不出来传1
                                                                                          baseVC.vinStr = vin;
                                                                                          NSString *amount = [obj valueForKey:@"amount"];
                                                                                          if (amount) {
                                                                                              baseVC.amount = amount;
                                                                                          }
                                                                                          
                                                                                          [weakSelf.navigationController pushViewController:baseVC animated:YES];
                                                                                          return ;
                                                                                      }

                                                                                      NSArray <NSDictionary *>*billType_list = [obj valueForKey:@"billType_list"];
                                                                                      NSArray <NSString *>*billTypes = [billType_list valueForKey:@"billTypeKey"];
                                                                                      
                                                                                      
                                                                                      
                                                                                      //if (!IsEmptyStr(self.reportType) && ![billTypes containsObject:self.reportType]){
                                                                                      if (
                                                                                          ([self.bill_type isEqualToString:@"A"] && ![billTypes containsObject:@"A"])
                                                                                         ||
                                                                                          ([self.bill_type isEqualToString:@"E001"] && IsEmptyStr(allowBillType))
                                         //                                                 ||
                                         //                                                 (billTypes && ![billTypes containsObject:@"A"] && !IsEmptyStr(self.bill_type) && ![billTypes containsObject:self.bill_type]
                                         //                                                  )
                                                                                          ){
                                                                                          [MBProgressHUD showError:@"该车未预约此业务，请选择其它业务类型"];
                                                                                          return ;
                                                                                      }
                                                                                      
                                                                                      
                                         //                                             if ( ![allowBillType isEqualToString:@"E001"]) {
                                                                                          [weakSelf jumpH5NewOpenOrder];
                                         #pragma mark - 跳H5
                                                                                          return ;
                                         //                                             }
                                                                                      
                                                                                      
                                                                                      
                                                                                  }
                                         failure:^(NSError *error) {
                                             [weakSelf.doButton YH_showEndLoadStatus];
                                             [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                             
                                         }];
    
}

- (void)jumpH5NewOpenOrder{
//    __weak typeof(self) weakSelf = self;
   
    if (self.billId == nil) {
        [self scanVinCallback];
    }else{
            //原生未完成列表预约单开单跳转至h5地址
        //车牌 plate 可不传
        //车架号 vin 必须传
        // index.html?token=xxx&status=ios&plate=xxx&vin=xxx
        NSString *carNo = self.carNo;
        NSString *vinNo = self.vinTF.text;

        
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@/index.html?token=%@&status=ios&plate=%@&vin=%@&billId=%@", SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk,[YHTools getAccessToken],carNo,vinNo,IsEmptyStr(self.billId)? @"":self.billId];
        NSString * url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        controller.urlStr = url;
        controller.barHidden = YES;
            WeakSelf
        UINavigationController *navi = self.navigationController;
//        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YHOrderListController class]]) {
                YHOrderListController *webVC = (YHOrderListController* )obj;
                [weakSelf.navigationController popToViewController:obj animated:NO];
                *stop = YES;
            }
        }];
        [navi pushViewController:controller animated:YES];
    }
   
}


-(void)scanVinCallback{//后期统一这里跳转h5，h5自己跳转各自界面，
    WeakSelf
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
            YHWebFuncViewController *webVC = (YHWebFuncViewController* )obj;
            [webVC toH5:@{@"jnsAppStep":@"vinHandle",@"plate":self.carNo,@"vin":self.vinTF.text}];
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

- (BOOL)isMatchVin:(NSString *)Id{
    BOOL result = false;
    
    if ([Id length] == 17){
        NSString * regex = @"^[A-Z0-9]{1,17}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:Id];
    }
    
    return result;
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
