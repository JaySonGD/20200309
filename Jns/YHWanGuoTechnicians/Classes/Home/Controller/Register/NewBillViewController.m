//
//  NewBillViewController.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/8/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "NewBillViewController.h"
#import "TTZAlertViewController.h"
#import "RelatedVinController.h"
#import "YHOrderListController.h"
#import "YHWebFuncViewController.h"
#import "SmartOCRCameraViewController.h"

#import "TTZPlateTextField.h"

#import "YHCarPhotoService.h"
#import "UIButton+YHNetWorkLoad.h"
#import "YHCarVersionModel.h"
#import "YHDiagnosisBaseVC.h"
#import "UIViewController+OrderDetail.h"
#import <MJExtension.h>

extern NSString *const notificationOrderListChange;

@interface NewBillViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet TTZPlateTextField *vinTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UIButton *doButton;
@property (weak, nonatomic) IBOutlet UIView *phoneBgView;
@property (weak, nonatomic) IBOutlet UILabel *vinTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *errorMsgLB;
@property (nonatomic, copy) NSString *vinStr;
@property (weak, nonatomic) IBOutlet UIImageView *vimIV;
- (IBAction)showImageAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showImageHeight;
@property (weak, nonatomic) IBOutlet UIButton *showImageBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandHeight;
@property (weak, nonatomic) IBOutlet UILabel *carBrandNameLB;

@property (nonatomic,weak) UIButton *backBtn;

@property (nonatomic,weak) IBOutlet UIButton *repairBtn;

@end

@implementation NewBillViewController
- (IBAction)brandList:(id)sender {
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    NSString *url = @"https://www.baidu.com";
    controller.urlStr = url;
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)repairClick:(id)sender{
    
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];

    

    NSString *url = @"https://www.jns.red/intro/maintenance/index.html";
    if (![@"https://api.wanguoqiche.com" isEqualToString:SERVER_PHP_URL]) {
        url = @"http://192.168.1.201/maintenanceDev/#/";
    }
    
    controller.urlStr = url;
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.showImageBtn.hidden = !(self.isShowImageBtn);
    self.showImageHeight.constant = self.isShowImageBtn? 40: 0;
    [self setUI];
}

//FIXME:  -  自定义方法
- (void)setUI{
    
    self.titleTop.constant = kStatusBarAndNavigationBarHeight;
    self.errorHeight.constant = 0.0;//18
    self.imgHeight.constant = 0.0 ;//90;
    self.brandHeight.constant = 0.0 ;//40;

    
    CGFloat topMargin = iPhoneX ? 44 : 20;
    UIButton *backBtn = [[UIButton alloc] init];
    self.backBtn = backBtn;
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
    [vinButton addTarget:self action:@selector(vinAction) forControlEvents:UIControlEventTouchUpInside];
    [vinButton setTitleColor:YHColor(75, 75, 75) forState:UIControlStateNormal];

    __weak typeof(self) weakSelf = self;
    self.vinTF.textChange = ^{
        [weakSelf textChange];
    };
    [self textChange];
    
//    UILabel *titleView = [UILabel new];
//    NSString *titleText = @"智能保养";
//    titleView.text = titleText;
//    [self.view addSubview:titleView];
//    titleView.font = [UIFont systemFontOfSize:19.0];
//    titleView.textColor = [UIColor blackColor];
//    CGFloat width = [titleText boundingRectWithSize:CGSizeMake(MAXFLOAT, 19.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:19.0]} context:nil].size.width;
//    titleView.frame = CGRectMake((self.view.frame.size.width - width)/2.0,backBtn.centerX, width, 19.0);
    
//    if (self.type == YYNewBillStyleUsedSale ||
//        self.type == YYNewBillStyleHelpSale ||
//        self.type == YYNewBillStyleHelpHelper ||
//        self.type == YYNewBillStyleSchemaQuery ||
//        self.type == YYNewBillStyleOrderAir ||
//        self.type == YYNewBillStyleReturnRefresh ||
//        self.type == YYNewBillStyleOrderJ007 ||
//        self.type == YYNewBillStyleOrderJ005) {
//        self.vinTF.isCarNo = NO;
//        self.vinTF.punctuation = YES;
//        self.vinTF.placeholder = @"请输入车架号";
//        self.vinTitleLB.text = @"车架号";
//        //if(self.type != YYNewBillStyleHelpHelper) [self pushVin:NO];
//
//        UIView *keyBoardView = [self.vinTF.inputView valueForKey:@"_backView2"];
//        UIButton *chKey = keyBoardView.subviews[29];
//        chKey.enabled = NO;
//        //NSLog(@"%s", __func__);
//    }
    
    if (self.isOnlyVin) {
         self.vinTF.isCarNo = NO;
         self.vinTF.punctuation = YES;
         self.vinTF.placeholder = @"请输入车架号";
         self.vinTitleLB.text = @"车架号";
         
         UIView *keyBoardView = [self.vinTF.inputView valueForKey:@"_backView2"];
         UIButton *chKey = keyBoardView.subviews[29];
         chKey.enabled = NO;
    }
    
//    if([self.bill_type isEqualToString:@"repair_dismantled"]){
    if(!IsEmptyStr(self.car_brand_name)){
        self.brandHeight.constant = 40;
        self.carBrandNameLB.text = [NSString stringWithFormat:@"目前支持品牌：%@",self.car_brand_name];
        self.repairBtn.hidden  = NO;
    }
    
    self.vinTF.text = self.vin;

}
- (void)setControllerTitle:(NSString *)title{
    
    UILabel *titleView = [UILabel new];
    NSString *titleText = title;
    titleView.text = titleText;
    [self.view addSubview:titleView];
    titleView.font = [UIFont systemFontOfSize:19.0];
    titleView.textColor = [UIColor blackColor];
    CGFloat width = [titleText boundingRectWithSize:CGSizeMake(MAXFLOAT, 19.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:19.0]} context:nil].size.width;
    titleView.frame = CGRectMake((self.view.frame.size.width - width)/2.0,self.backBtn.centerY - 19.0/2, width, 19.0);
    [self.view addSubview:titleView];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)setVin:(NSString *)vin{
    _vin = vin;
    self.vinTF.text = vin;
}

-(void)pushVin:(BOOL)animated{
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
        weakSelf.vinTitleLB.text = @"车架号";
        weakSelf.vinTF.isCarNo = YES;
        
        weakSelf.doButton.enabled = YES;
        weakSelf.doButton.backgroundColor = YHNaviColor;
    };
    [self presentViewController:controller animated:animated completion:nil];
}

- (void)vinAction{
    [self pushVin:YES];
//     __weak typeof(self) weakSelf = self;
//    self.vinTF.text = @"";
//    self.imgHeight.constant = 0;
//    self.vimIV.image = nil;
//    self.doButton.enabled = NO;
//    self.doButton.backgroundColor = YHColor(209, 209, 209);
//
//    SmartOCRCameraViewController *controller = [[SmartOCRCameraViewController alloc] init];
//    controller.recogOrientation = RecogInVerticalScreen;//竖屏
//    controller.isLocation = NO;
//    controller.scanSuccessBackCall = ^(UIImage *vinImage, NSString *vinStr) {
//        weakSelf.vinTF.text = vinStr;
//        weakSelf.imgHeight.constant = 90;
//        weakSelf.vimIV.image = vinImage;
//        weakSelf.vinTitleLB.text = @"VIN号";
//        weakSelf.vinTF.isCarNo = YES;
//
//        weakSelf.doButton.enabled = YES;
//        weakSelf.doButton.backgroundColor = YHNaviColor;
//    };
//    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textChange{
    
    if (self.vinTF.hasText) {
        
        if([self isVinNumber] && self.vinTF.text.length < 17){
            self.doButton.enabled = NO;
            self.doButton.backgroundColor = YHColor(209, 209, 209);
            
        }else{
            self.doButton.enabled = YES;
            self.doButton.backgroundColor = YHNaviColor;
        }
        
        
//        if (self.type == YYNewBillStyleUsedSale || self.type == YYNewBillStyleHelpSale || self.type == YYNewBillStyleHelpHelper || self.type == YYNewBillStyleOrderAir || self.type == YYNewBillStyleReturnRefresh) {
//            return;
//        }
        if (self.isOnlyVin) {
            return;
        }
        
        if (![self isVinNumber]) {
            self.vinTitleLB.text = @"车牌号";
            self.vinTF.isCarNo = YES;
        }else{
            self.vinTitleLB.text = @"车架号";
            self.vinTF.isCarNo = NO;
        }
        
    }else{
        self.doButton.enabled = NO;
        self.doButton.backgroundColor = YHColor(209, 209, 209);
        
//        if (self.type == YYNewBillStyleUsedSale || self.type == YYNewBillStyleHelpSale || self.type == YYNewBillStyleHelpHelper) {
//            return;
//        }
//        if(self.type == YYNewBillStyleUsedSale ||
//           self.type == YYNewBillStyleHelpSale ||
//           self.type == YYNewBillStyleHelpHelper ||
//           self.type == YYNewBillStyleSchemaQuery ||
//           self.type == YYNewBillStyleOrderAir ||
//           self.type == YYNewBillStyleReturnRefresh ||
//           self.type == YYNewBillStyleOrderJ007 ||
//           self.type == YYNewBillStyleOrderJ005){
//            return;
//        }
        if (self.isOnlyVin) {
            return;
        }


        self.vinTitleLB.text = @"车牌号／车架号";
    }
    
    if (self.errorHeight.constant) {
        self.phoneBgView.backgroundColor = YHColor(242, 242, 242);
        kViewBorderRadius(self.phoneBgView, 10, 0, YHColor(230, 81, 75));
        self.errorHeight.constant = 0;
    }
    
}

- (BOOL)isVinNumber{
    if(self.vinTF.text.length < 1) {
        self.doButton.enabled = NO;
        self.doButton.backgroundColor = YHColor(209, 209, 209);
        return YES;
    }
    if ([@"京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领" containsString:[self.vinTF.text substringToIndex:1]]) {
        return NO;
    }else{
        return YES;
    }
}


#pragma mark - 1.点击“箭头”按钮
/**
 之前就是pop回原来的网页
 修改:
 1.成请求车型接口如果有数据跳转至选择车辆版本控制
 2.如果没有请求接口没有数据那么就跳转至 检测信息控制器
 */
- (void)vinNextAction//
{
         __weak typeof(self) weakSelf = self;
        //有数据的车架号   LFV3A23C6D3120328
        [[YHNetworkPHPManager sharedYHNetworkPHPManager]checkTheCarCreateNewWorkOrderWithToken:[YHTools getAccessToken] Vin:self.vinTF.text onComplete:^(NSDictionary *info) {
            
            NSLog(@"===1.车架号数据:%@===",info);
            [weakSelf.doButton YH_showEndLoadStatus];

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
                baseVC.bucheBookingId = self.billId.intValue;
                [self.navigationController pushViewController:baseVC animated:YES];
                //(2)进行工单基本信息控制器
            }else if([info[@"code"]longLongValue] == 20400){
                
                YHDiagnosisBaseVC *VC = [[YHDiagnosisBaseVC alloc] init];
                VC.vinController = self;
                VC.vinStr = self.vinTF.text;
                VC.bucheBookingId = self.billId.intValue;
                VC.carType = 1;   //vin号识别不出来传1
                [weakSelf.navigationController pushViewController:VC animated:YES];
                
                //(3)弹出错误提示信息
            }else{
                [MBProgressHUD showError:info[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            }
            
        } onError:^(NSError *error) {
            [weakSelf.doButton YH_showEndLoadStatus];
        }];
}
//- (void)pushSchemaQuery{
//
//    [self.doButton YH_showEndLoadStatus];
//    [self.webController vinCallback:self.vinTF.text];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)pushHelper{
    [self.doButton YH_showEndLoadStatus];
    YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
    
    
    NSString *encodeTitle = [YHTools encodeString:@"智能保养"];
    NSString *webURLString = [NSString stringWithFormat:@"%@%@/%@.html?token=%@&status=ios%@&menuCode=%@&menuName=%@",SERVER_PHP_URL_Statements_H5,SERVER_PHP_H5_Trunk, @"technicalAssistant/index", [YHTools getAccessToken],@"",@"menu_help",encodeTitle];
    
    controller.urlStr = [NSString stringWithFormat:@"%@&vin=%@#/",webURLString,self.vinTF.text];
    controller.barHidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)newBill{
    if (![self isMatchCarIdOrVin:self.vinTF.text]) {
        self.errorHeight.constant = 18;
        self.phoneBgView.backgroundColor = [UIColor whiteColor];
        kViewBorderRadius(self.phoneBgView, 10, 0.5, YHColor(230, 81, 75));
        if ([self isVinNumber]) {
            //车牌号或者VIN号信息不符要求
            self.errorMsgLB.text = @"车架号信息不符要求";
        }else{
            self.errorMsgLB.text = @"车牌号信息不符要求";
        }
        return;
    }
    self.doButton.YH_normalTitle = @"继续";
    self.doButton.YH_loadStatusTitle = @"加载中...";
    [self.doButton YH_showStartLoadStatus];
    __weak typeof(self) weakSelf = self;
    
    
    if (self.type == YYNewBillStyleUsedSale || self.type == YYNewBillStyleHelpSale) {
        [self vinNextAction];
        return;
    }
    
    //    if(self.type == YYNewBillStyleOrderAir ||
    //       self.type == YYNewBillStyleReturnRefresh ||
    //       self.type == YYNewBillStyleOrderJ007 ||
    //       self.type == YYNewBillStyleOrderJ005){
    //        if([self.bill_type isEqualToString:@"order_air"] ||
    //             self.type == YYNewBillStyleReturnRefresh ||
    //             [self.bill_type isEqualToString:@"J007"] ||
    //             [self.bill_type isEqualToString:@"J005"]){
    //
    //        [self.webController vinCallback:self.vinTF.text];
    //        [self popViewController:nil];
    //        return;
    //    }
    
    //    if (self.type == YYNewBillStyleHelpHelper) {
    //    if ([self.bill_type isEqualToString:@"menu_help"]) {
    //
    //        [self pushHelper];
    //        return;
    //    }
    //    if (self.type == YYNewBillStyleSchemaQuery) {//W001
    //    if ([self.bill_type isEqualToString:@"W001"]) {//W001
    //        [self pushSchemaQuery];
    //        return;
    //    }
    
    if (![self isVinNumber]) {
        //  车牌号
        [[YHCarPhotoService new] getVinByPlateNumber:self.vinTF.text
                                             success:^(NSString *vin, BOOL billStatus) {
                                                 [weakSelf.doButton YH_showEndLoadStatus];
                                                 if (!vin) {
                                                     [weakSelf jumpToRelateVC];
                                                     return ;
                                                 }
                                                 weakSelf.vinStr = vin;
                                                 if (billStatus) {//有预约
                                                     [weakSelf showAlert];
                                                     return;
                                                 }
                                                 
                                                 // 查询二手车预约单
                                                 [weakSelf helpOrder:vin];
                                             }
                                             failure:^(NSError *error) {
                                                 [weakSelf.doButton YH_showEndLoadStatus];
                                                 [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                                 
                                             }];
        return;
    }
    
    //    if ( [self.bill_type isEqualToString:@"A"]
    //         ||[self.bill_type isEqualToString:@"E001"])
    {
        
        //  Vin码
        [[YHCarPhotoService new] getBillStatusByVin:self.vinTF.text
                                            success:^(BOOL billStatus) {
                                                [weakSelf.doButton YH_showEndLoadStatus];
                                                if (billStatus) {//有预约
                                                    [weakSelf showAlert];
                                                    return;
                                                }
                                                // 查询二手车预约单
                                                [weakSelf helpOrder:weakSelf.vinTF.text];
                                                
                                            } failure:^(NSError *error) {
                                                [weakSelf.doButton YH_showEndLoadStatus];
                                                [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                                
                                            }];
        
        return;
    }
    
    if (self.bill_type){//后期统一这里跳转h5，h5自己跳转各自界面，
        if (self.textType == YYNewVinCar) {
        }else{
            [self scanVinCallback];
        }
        return;
    }
    
    //  Vin码
    //    [[YHCarPhotoService new] getBillStatusByVin:self.vinTF.text
    //                                        success:^(BOOL billStatus) {
    //                                            [weakSelf.doButton YH_showEndLoadStatus];
    //                                            if (billStatus) {//有预约
    //                                                [weakSelf showAlert];
    //                                                return;
    //                                            }
    //                                            // 查询二手车预约单
    //                                            [weakSelf helpOrder:weakSelf.vinTF.text];
    //
    //                                        } failure:^(NSError *error) {
    //                                            [weakSelf.doButton YH_showEndLoadStatus];
    //                                            [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
    //
    //                                        }];
}

- (IBAction)doAction:(id)sender {
    if(!IsEmptyStr(self.car_brand_name)){
        
        [[YHCarPhotoService new] getFlowType:self.vinTF.text
                                     success:^(NSInteger supportType) {

                                         if (supportType==1) {//现有
                                             [self newBill];
                                             return;
                                         }else if(supportType==2){//PDF
                                             
                                             return;
                                         }
                                         [MBProgressHUD showError:@"暂未支持该品牌"];
                                     }
                                     failure:^(NSError *error) {
                                         [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                     }];
      
        return;
    }
    [self newBill];
}

-(void)scanVinCallback{//后期统一这里跳转h5，h5自己跳转各自界面，
    WeakSelf
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHWebFuncViewController class]]) {
            YHWebFuncViewController *webVC = (YHWebFuncViewController* )obj;
            //[webVC vinCallback:self.vinTF.text];
            NSString *vin = weakSelf.vinStr?weakSelf.vinStr:weakSelf.vinTF.text;

            BOOL isVin = [self isVinNumber];
            
            
            [webVC toH5:@{@"jnsAppStep":@"vinHandle",@"plate":isVin? @"":weakSelf.vinTF.text,@"vin":vin}];
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

- (void)helpOrder:(NSString *)vin
{
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



- (BOOL)isMatchCarIdOrVin:(NSString *)Id{
    BOOL result = false;
    if ([Id length] >= 7 && [Id length] <= 9){
        //NSString * regex = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领]{1}[A-Z]{1}[A-Z0-9]{4,6}[A-Z0-9挂学警港澳]{1}$";
        NSString * regex = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领]{1}[A-Z]{1}[A-Z0-9]{4,6}[A-Z0-9挂学警港澳]{1}$";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:Id];
    }
    
    if (result) return result;
    
    if ([Id length] == 17){
        NSString * regex = @"^[A-Z0-9]{1,17}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:Id];
    }
    
    return result;
}

- (void)showAlert{
    __weak typeof(self) weakSelf = self;
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    TTZAlertViewController *controller = [board instantiateViewControllerWithIdentifier:@"TTZAlertViewController"];
    controller.view.backgroundColor = [UIColor clearColor];
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.checkAction = ^{//查看
        [weakSelf jumpWorkOrderList];
    };
    controller.continueAction = ^{//继续
        NSString *vin = weakSelf.vinStr?weakSelf.vinStr:weakSelf.vinTF.text;
        [weakSelf helpOrder:vin];
    };
    
    [self presentViewController:controller animated:NO completion:nil];
    
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
        
        NSString *carNo = @"";
           NSString *vinNo = self.vinTF.text;
           if (self.vinStr) {
               carNo = self.vinTF.text;
               vinNo = self.vinStr;
           }
        
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

- (void)jumpWorkOrderList{
    /*3.工单列表*///
    //    if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"workOrderList"]) {
    //        //objc://doFunc/workOrderDetail/工单类型（如：未处理 0，未完成 1，历史 2）／工单数据（JSON格式化的字符串）
    //        if (arrFucnameAndParameter.count >= 4) {
    
    NSInteger type = 0;//[arrFucnameAndParameter[2] integerValue];//工单类型（如：未处理 0，未完成 1，历史 2）
    NSString *vin = self.vinStr?self.vinStr:self.vinTF.text;//arrFucnameAndParameter[3];//vin
    
    __weak __typeof__(self) weakSelf = self;
    __block BOOL isBack = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHOrderListController class]]) {
            YHOrderListController *listVC = (YHOrderListController* )obj;
            listVC.keyWord = vin;
            listVC.functionKey = type?((type>1)? YHFunctionIdHistoryWorkOrder:YHFunctionIdUnfinishedWorkOrder):YHFunctionIdUnfinishedWorkOrder;
            [[NSNotificationCenter
              defaultCenter]postNotificationName:notificationOrderListChange
             object:Nil
             userInfo:nil];
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
            isBack = YES;
        }
    }];
    if (!isBack) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        YHOrderListController *listVC = [board instantiateViewControllerWithIdentifier:@"YHOrderListController"];
        listVC.keyWord = vin;
        listVC.functionKey = type?((type>1)? YHFunctionIdHistoryWorkOrder:YHFunctionIdUnfinishedWorkOrder):YHFunctionIdUnfinishedWorkOrder;
        
//        NSMutableArray *array = weakSelf.navigationController.childViewControllers.mutableCopy;
//        [array removeObject:self];
//        [array addObject:listVC];
//        [self.navigationController setViewControllers:array];
        [self.navigationController pushViewController:listVC animated:YES];
    }

}

- (void)jumpToRelateVC{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    RelatedVinController *controller = [board instantiateViewControllerWithIdentifier:@"RelatedVinController"];
    controller.carNo = self.vinTF.text;
    controller.reportType = self.reportType;
    controller.bill_type = self.bill_type;
    controller.billId = self.billId;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)showImageAction:(id)sender {
    [self showImageByCode:self.imageByCode];//@"specialCheck"
}
@end
