
//
//  YHDiagnosisBaseVC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Masonry.h>
#import "BRPickerView.h"
#import "YHDiagnosisBaseVC.h"
#import "YHDiagnosisBaseTC.h"
#import "UIColor+ColorChange.h"
#import "LXKTopScrollViews.h"
#import "YHCarSourceController.h"
#import "YHCarPhotoController.h"
//#import "YHDiagnosisProjectVC.h"
#import "YHNetworkManager.h"
#import "YHSVProgressHUD.h"
#import "YHCommon.h"
#import "YHTools.h"
#import "MBProgressHUD+MJ.h"
#import "YHBillStatusModel.h"
#import <MJExtension.h>
#import "YHPhotoManger.h"
#import "YHCarBaseModel.h"
#import "YHNewOrderController.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface YHDiagnosisBaseVC ()<LXKTopScrollViewsDelegate>
@property(nonatomic,strong)LXKTopScrollViews *topScrollViews;

@property(nonatomic,weak)YHDiagnosisBaseTC *vc;//基本信息控制器

@property (nonatomic, weak) YHCarPhotoController *photoVC;

@property(nonatomic,strong)YHBillStatusModel *billModel;

@property(nonatomic,strong)NSMutableDictionary *baseInfo;
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) UIView *alertViewBox;
- (IBAction)alertCancelAction:(id)sender;
- (IBAction)alertComfireAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bangMaiB;
- (IBAction)bangMaiAction:(id)sender;

@end

@implementation YHDiagnosisBaseVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E5"];
    
    //去掉返回按钮上面的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.title = @"检车信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doClick:)];
  
    [self addNavigateController];//添加导航控制器
   
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReceiveBrandName:) name:@"brandName" object:nil];
}

#pragma mark - 导航控制器切换
-(void)addNavigateController
{
    self.topScrollViews = [LXKTopScrollViews instanceViewWithFrame:CGRectMake(0, NavbarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavbarHeight) titleArr:@[@"基本信息",@"车辆图片"] selectColor:[UIColor colorWithHexString:@"#46AEF7"] unSelectColor:[UIColor colorWithHexString:@"BEBEBE"] selectFont:[UIFont systemFontOfSize:16] unSelectFont:[UIFont systemFontOfSize:14]];
    //设置滑块颜色
    self.topScrollViews.lineColor = [UIColor colorWithHexString:@"#46AEF7"];
    //设置滚动块的类型 ，线条，色块，椭圆色块
    //    self.topScrollViews.lineType = LXKScrollViewTypeAboutRectangle;
    //设置顶部的背景色
    self.topScrollViews.backgroundColor = [UIColor whiteColor];
    
    self.topScrollViews.delegate = self;
    
    [self.view addSubview:self.topScrollViews];
    //往scrollview添加的控件，由于addsub方法中重写了frame方法，所以此处初始化时可以不写frame
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"diagnosis" bundle:nil];
    YHDiagnosisBaseTC *carVersionVC = [board instantiateViewControllerWithIdentifier:@"YHDiagnosisBaseTC"];
    carVersionVC.isOther = self.isOther;
    carVersionVC.model = _baseInfoM;
    carVersionVC.carVersionModel = _carVersionModel;
    carVersionVC.vinStr = _vinStr;
  
    self.vc = carVersionVC;
    
    YHCarPhotoController * vc = [[YHCarPhotoController alloc]init];
    if (self.billId.length) {
        vc.billId = self.billId;
        vc.carPhotos = self.baseInfoM.carPhotos;
    }else{
        //self.vinStr = @"YH123456789";//self.vinStr.length? self.vinStr : [NSString stringWithFormat:@"YH:%f",[[NSDate date] timeIntervalSince1970]];
        vc.vinStr = @"YH123456789";//self.vinStr;
    }
    self.photoVC = vc;
    
    [self addChildViewController:carVersionVC];
    [self addChildViewController:vc];
    
    [self.topScrollViews addSubViewToScrollViewWithSubArr:@[carVersionVC.view,vc.view]];
}

- (IBAction)popViewController:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YHNewOrderController class]]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

#pragma mark - 接收通知返回的消息
-(void)ReceiveBrandName:(NSNotification*)notice
{
    self.carType = 1;
    self.baseInfo[@"carBrandId"] = notice.userInfo[@"brandId"];        //品牌ID
    self.baseInfo[@"carBrandName"] = notice.userInfo[@"brandName"];  //品牌名称
    self.baseInfo[@"carLineId"] = notice.userInfo[@"lineId"];      //车系id
    self.baseInfo[@"carLineName"] = notice.userInfo[@"lineName"];      //车系名称
}

//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:nil object:self];
}

//#define TestNewCar
#pragma mark  -  事件监听
- (void)doClick:(UIBarButtonItem *)btn
{
#ifndef TestNewCar
    if(![self judgeIsEmpty])return;
#else
#endif
    [self alertShow];
}

-(BOOL)judgeIsEmpty
{
#if 1
    //数据校验
    if (NULLString(self.vc.vinFT.text)) {  //车架号
        [MBProgressHUD showError:@"车架号不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    if (NULLString(self.vc.carModelsL.text)) {  //车型车系
        [MBProgressHUD showError:@"车型车系不能为空,请重新选择" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    if (NULLString(self.vc.yearTF.text)) {  //年款
        [MBProgressHUD showError:@"年款不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    if (NULLString(self.vc.powerL.text)) {  //动力参数
        [MBProgressHUD showError:@"动力参数不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    if (NULLString(self.vc.modelTF.text)) {  //型号
        [MBProgressHUD showError:@"型号不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
//    if (NULLString(self.vc.carNumberTF.text) && self.vc.carNumberTF.text.length < 2) {  //车牌号码
//        [MBProgressHUD showError:@"请输入正确车牌号" toView:[UIApplication sharedApplication].keyWindow];
//        return NO;
//    }
    
    if (NULLString(self.vc.Contact.text)) {  // 联系人
        [MBProgressHUD showError:@"联系人不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    //联系号码
    if (NULLString(self.vc.contactNumberTF.text)) {  //联系号码
        [MBProgressHUD showError:@"联系号码不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    if (![self validatePhone:self.vc.contactNumberTF.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    if (NULLString(self.vc.selectedProvince) || NULLString(self.vc.selectedCity) || NULLString(self.vc.addrFT.text)) {  //看车地址
        [MBProgressHUD showError:@"请填写完整地址" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    if (!self.photoVC.isFinished) {  //是否添加完了图片
        [MBProgressHUD showError:@"你还没有添加完车辆图片" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    if (!self.photoVC.carDesc.length) {  //是否添加完了图片
        [MBProgressHUD showError:@"你还没有填写车辆描述" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }

    
    return YES;
#endif
}

- (IBAction)alertCancelAction:(id)sender
{
    [_alertViewBox removeFromSuperview];
    _alertViewBox = nil;
}

- (IBAction)alertComfireAction:(id)sender
{
    [_alertViewBox removeFromSuperview];
    _alertViewBox = nil;
#ifndef TestNewCar
//    if(![self judgeIsEmpty])return;
    //可选的参数在baseInfo里面进行判断   判断在上面
    self.baseInfo[@"vin"] = self.vc.vinFT.text;           //vin码
    self.baseInfo[@"carBrandName"] = self.vc.carModelsL.text;        //车系车型
    self.baseInfo[@"carStyle"] = self.vc.yearTF.text;      //年款
    self.baseInfo[@"dynamicParameter"] = self.vc.powerL.text;    //动力参数
    self.baseInfo[@"model"] = self.vc.modelTF.text;      //型号
    if (!NULLString(self.vc.carNumberTF.text)) {
        self.baseInfo[@"plateNo"] = self.vc.carNumberTF.text;//车牌
    }
    self.baseInfo[@"userName"] = self.vc.Contact.text;      //用户名
    self.baseInfo[@"phone"] = self.vc.contactNumberTF.text;      //联系方式
    self.baseInfo[@"carAddress"] = [NSString stringWithFormat:@"%@%@%@", self.vc.selectedProvince, self.vc.selectedCity, self.vc.addrFT.text];      //看车地址
    
    //排放标准
    self.baseInfo[@"emissionsStandards"] = self.vc.dischargeButton.titleLabel.text;
    
    if (!NULLString(self.vc.odometerTF.text)) {
        self.baseInfo[@"tripDistance"] = self.vc.odometerTF.text;      //行驶里程
    }
    if (!NULLString(self.vc.dateOfManufactureTF.text)) {
        self.baseInfo[@"productionDate"] = self.vc.dateOfManufactureTF.text;      //出厂日期
    }
    if (!NULLString(self.vc.registerDateTF.text)) {
        self.baseInfo[@"registrationDate"] = self.vc.registerDateTF.text;      //注册日期
    }
    if (!NULLString(self.vc.certificationDateTF.text)) {
        self.baseInfo[@"issueDate"] = self.vc.certificationDateTF.text;      //发证日期
    }
    
    //车辆性质
    NSString *carPropertiesStr;
    if (self.vc.carPropertiesS.selectedSegmentIndex ==0) { //运营
        carPropertiesStr = @"0";
    }else{ //非运营
        carPropertiesStr = @"1";
    }
    
    self.baseInfo[@"carNature"] = carPropertiesStr;    //车辆性质
    //车辆所有者性质
    NSString *ownerProStr;
    if (self.vc.ownerProS.selectedSegmentIndex ==0) {//私户
        ownerProStr = @"0";
    }else{//公户
        ownerProStr = @"1";
    }
    self.baseInfo[@"userNature"] = ownerProStr;      //车辆所有者性质
    self.baseInfo[@"endAnnualSurveyDate"] = self.vc.InspectionDate.text;      //年检到期时间
    if (!NULLString(self.vc.trafficMandatoryInsuranceDate.text)) {
        self.baseInfo[@"trafficInsuranceDate"] = self.vc.trafficMandatoryInsuranceDate.text;      //交强险到期时间
    }
    if (!NULLString(self.vc.businessInsuranceTF.text)) {
        self.baseInfo[@"businessInsuranceDate"] = self.vc.businessInsuranceTF.text;      //商业险到期时间
    }
    if (!NULLString(self.vc.priceFT.text)) {
        self.baseInfo[@"offer"] = self.vc.priceFT.text;      //报价
    }
    self.baseInfo[@"carDesc"] = self.photoVC.carDesc;
    self.baseInfo[@"isHelpCar"] = ((_bangMaiB.selected)? (@"1") : (@"0"));
#else
    
    
    self.baseInfo[@"carBrandName"] = @"carBrandName";  //车系名称
    
    self.baseInfo[@"vin"] = @"test";
    self.baseInfo[@"carStyle"] = @"test";
    self.baseInfo[@"dynamicParameter"] = @"test";
    self.baseInfo[@"model"] = @"test";
    self.baseInfo[@"plateNo"] = @"test";
    self.baseInfo[@"userName"] = @"test";
    self.baseInfo[@"phone"] = @"18679807890";
    self.baseInfo[@"carAddress"] = @"test";
    self.baseInfo[@"emissionsStandards"] = @"test";
    self.baseInfo[@"tripDistance"] = @"2018-12";
    
    self.baseInfo[@"productionDate"] = @"2018-12";
    self.baseInfo[@"registrationDate"] = @"2018-12-22";
    self.baseInfo[@"issueDate"] = @"2018-12-12";
    self.baseInfo[@"endAnnualSurveyDate"] = @"2018-12";
    self.baseInfo[@"trafficInsuranceDate"] = @"2018-12";
    self.baseInfo[@"businessInsuranceDate"] = @"2018-12-11";
    self.baseInfo[@"offer"] = @"123333";
    self.baseInfo[@"carDesc"] = @"test";
    self.baseInfo[@"isHelpCar"] = ((_bangMaiB.selected)? (@"1") : (@"0"));
    
#endif
    
    __weak __typeof__(self) weakSelf = self;
    
    [YHSVProgressHUD showWithStatus:@"提交中..."];
    
    //新建工单网络请求
    [[YHNetworkManager sharedYHNetworkManager]submitBasicInformationWithDictionary:self.baseInfo  token:[YHTools getAccessToken] onComplete:^(NSDictionary *info) {
        
        NSLog(@"info------%@",info);
        
        //btn.userInteractionEnabled = YES;
        
        [YHSVProgressHUD dismiss];
        if ([info[@"retCode"] longLongValue] == 0) {//请求成功
            NSDictionary *result = info[@"result"];
            [YHPhotoManger moveItemAtPath:weakSelf.photoVC.vinStr toPath:result[@"carId"]];
            [MBProgressHUD showSuccess:@"发布成功" toView:weakSelf.navigationController.view];
            
            __strong typeof(self) strongSelf = weakSelf;
            [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[YHCarSourceController class]]) {
                    [strongSelf.navigationController popToViewController:obj animated:YES];
                    *stop = YES;
                }
            }];
        }else{  //错误信息提示
            [MBProgressHUD showError:info[@"retMsg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        
    } onError:^(NSError *error) {
        [YHSVProgressHUD dismiss];
    }];
}


//判断是否为手机号
- (BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

#pragma mark - baseInfo字典
-(NSMutableDictionary *)baseInfo
{
    if (_baseInfo == nil) {
        _baseInfo = [NSMutableDictionary dictionary];
    }
    return _baseInfo;
}

#pragma mark scrollViewDelegate
///点击了顶部的第几个按钮
-(void)clickLXKScroolViewTopBtnWithIndex:(NSInteger)index
{
    NSLog(@"click the Btn Tag is == %ld",(long)index);
}
///滑动到scrollview的第几个content
-(void)scroolToIndex:(NSInteger)index
{
    NSLog(@"scroll to frame index is == %ld",(long)index);
}

-(void)alertShow
{
    _alertViewBox = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    [_alertViewBox setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
    [_alertViewBox addSubview:_alertView];
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@160);
        make.width.equalTo(@280);
        make.centerX.equalTo(_alertViewBox.mas_centerX).with.offset(0);
        make.centerY.equalTo(_alertViewBox.mas_centerY).with.offset(0);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:_alertViewBox];
}

- (IBAction)bangMaiAction:(UIButton*)button
{
    button.selected = !button.selected;
}

@end
