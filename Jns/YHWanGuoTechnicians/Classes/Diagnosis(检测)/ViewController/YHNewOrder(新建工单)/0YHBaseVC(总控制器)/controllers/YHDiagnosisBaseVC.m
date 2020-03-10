
//
//  YHDiagnosisBaseVC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHDiagnosisBaseVC.h"
#import "YHDiagnosisBaseTC.h"
#import "UIColor+ColorChange.h"
#import "LXKTopScrollViews.h"
#import "YHCarPhotoController.h"
#import "YHDiagnosisProjectVC.h"
#import "YHNetworkPHPManager.h"
#import "YHTools.h"
//#import "MBProgressHUD+MJ.h"
#import "YHBillStatusModel.h"
#import <MJExtension.h>
#import "YHPhotoManger.h"
#import "YHCarBaseModel.h"

#import "YHCarPhotoService.h"
#import "UIView+Frame.h"

#import "YHNewOrderCompeteVC.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface YHDiagnosisBaseVC ()<LXKTopScrollViewsDelegate>

@property(nonatomic,strong)LXKTopScrollViews *topScrollViews;

@property(nonatomic,weak)YHDiagnosisBaseTC *vc;//基本信息控制器

@property (nonatomic, weak) YHCarPhotoController *photoVC;

@property(nonatomic,strong)YHBillStatusModel *billModel;

@property(nonatomic,strong)NSMutableDictionary *baseInfo;

@property(nonatomic,strong)NSDictionary *info;

@end

@implementation YHDiagnosisBaseVC


- (void)initData{
    WeakSelf;
    [[YHNetworkPHPManager sharedYHNetworkPHPManager] checkTheCarCreateNewWorkOrderWithToken:[YHTools getAccessToken] Vin:self.vinStr onComplete:^(NSDictionary *info) {
        
        
        if ([info[@"code"]longLongValue] == 20000) {
            NSArray *tempArray = info[@"data"];
            if (tempArray.count > 0) {
                weakSelf.info = tempArray[0];
            }
            
            [weakSelf refreshBaseInfoUI];
        }
    } onError:^(NSError *error) {
        
    }];
}

- (void)refreshBaseInfoUI{
    //年款
    self.vc.yearTF.text = self.info[@"nianKuan"];
    
    //动力参数
    self.vc.powerL.text = self.info[@"carCc"];
    
    //型号
    self.vc.modelTF.text = self.info[@"cheXing"];
    
    //车牌号码
    //self.vc.carNumberTF.text = [NSString stringWithFormat:@"%@%@%@", self.info[@"plateNumberP"], self.info[@"plateNumberC"], self.info[@"plateNumber"]];
    
    //排放标准
    NSString *paifang = self.info[@"paiFang"];
    if ([paifang isEqualToString:@"国5"]) {
        paifang = @"国V";
    } else if ([paifang isEqualToString:@"国4"]) {
        paifang = @"国IV";
    } else if ([paifang isEqualToString:@"国3"]) {
        paifang = @"国III";
    } else if ([paifang isEqualToString:@"国2"]) {
        paifang = @"国II";
    } else if ([paifang isEqualToString:@"国1"]) {
        paifang = @"国I";
    } else if ([paifang isEqualToString:@"欧5"]) {
        paifang = @"欧V";
    } else if ([paifang isEqualToString:@"欧4"]) {
        paifang = @"欧IV";
    } else if ([paifang isEqualToString:@"欧3"]) {
        paifang = @"欧III";
    } else if ([paifang isEqualToString:@"欧2"]) {
        paifang = @"欧II";
    } else if ([paifang isEqualToString:@"欧1"]) {
        paifang = @"欧I";
    }
    
    [self.vc.dischargeButton setTitle:paifang forState:UIControlStateNormal];

    //表显里程
    //self.vc.odometerTF.text = self.info[@"tripDistance"];

    //出厂日期
    //self.vc.dateOfManufactureTF.text = self.info[@"nianKuan"];

    //注册日期
    //self.vc.yearTF.text = self.info[@"nianKuan"];

    //发证日期
    //self.vc.yearTF.text = self.info[@"nianKuan"];

    //车辆性质
    //self.vc.powerL.text = self.info[@"carCc"];

    //车辆所有者性质
    //self.vc.yearTF.text = self.info[@"nianKuan"];

    //年检到期日
    //self.vc.yearTF.text = self.info[@"nianKuan"];

    //交强险到期日
    //self.vc.yearTF.text = self.info[@"nianKuan"];

    //商业险到期日
    //self.vc.powerL.text = self.info[@"carCc"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E5"];
    
    //去掉返回按钮上面的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.navigationItem.title =@"检车信息" ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doClick:)];
    
    [self addNavigateController];//添加导航控制器
    
    //如果从检车项目控制器进入
    if (self.baseInfoM) {
        [self setValueForUnWorkBase];//从未完成工单跳转进来的时候进行赋值
    }else{
        //1.车架号
        self.vc.FrameNumberL.text = self.vinStr;
        
        //2.车型车系
        if (!self.isOther && !self.carType) {
            if ([self.model.carLineName containsString:self.model.carBrandName]) {
                self.vc.carModelsL.text = [NSString stringWithFormat:@"%@",self.model.carLineName];
            }else{
                self.vc.carModelsL.text = [NSString stringWithFormat:@"%@%@",self.model.carBrandName,self.model.carLineName];
            }
        }
        
        if (self.checkCustomerModel) {//car-Type = 1
            if ([self.checkCustomerModel.carLineName containsString:self.checkCustomerModel.carBrandName]) {
                self.vc.carModelsL.text = [NSString stringWithFormat:@"%@",self.checkCustomerModel.carLineName];
            }else{
                self.vc.carModelsL.text = [NSString stringWithFormat:@"%@%@",self.checkCustomerModel.carBrandName,self.checkCustomerModel.carLineName];
            }
            
            //联系人
            self.vc.Contact.text = self.checkCustomerModel.userName;
            
            //联系号码
            //self.vc.carNumberTF.text = [NSString stringWithFormat:@"%@%@",self.checkCustomerModel.plateNumberP,self.checkCustomerModel.plateNumberC];
            self.vc.contactNumberTF.text = self.checkCustomerModel.phone;
            
             //品牌ID
            self.baseInfo[@"carBrandId"] = self.checkCustomerModel.carBrandId;//notice.userInfo[@"brandId"];
            
            //品牌名称
            self.baseInfo[@"carBrandName"] = self.checkCustomerModel.carBrandName;//notice.userInfo[@"brandName"];
            
            //车系id
            self.baseInfo[@"carLineId"] = self.checkCustomerModel.carLineId;//notice.userInfo[@"lineId"];
            
            //车系名称
            self.baseInfo[@"carLineName"] = self.checkCustomerModel.carLineName;//notice.userInfo[@"lineName"];
        }
    }
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReceiveBrandName:) name:@"brandName" object:nil];
    [self getCheckRestrict];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)getCheckRestrict
{
    float amount = [self.amount floatValue];
    if (amount <= 0) {
        return;
    }
    //    NSString *vin = self.vinStr? self.vinStr : self.baseInfoM.vin;
    //    if(!vin) return;
    //    [[YHCarPhotoService new] checkRestrictForVin:vin
    //                                         Success:^(NSString *amount) {
    //                                             //NSLog(@"%s", __func__);
    
    UILabel *amountLB = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight + 47, screenWidth, 44)];
    amountLB.text = [NSString stringWithFormat:@"该车已预交二手车检测费用￥%@元",self.amount];
    amountLB.textAlignment = NSTextAlignmentCenter;
    amountLB.backgroundColor = [UIColor colorWithHexString:@"#E2FEF5"];
    [self.view addSubview:amountLB];
    
    //                                             [UIView animateWithDuration:0.25 animations:^{
    self.vc.view.y = 44;
    self.vc.view.height -= 44;
    self.photoVC.view.y = 44;
    self.photoVC.view.height -= 44;
    if (!iPhoneX) {
        self.photoVC.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
    
    //                                             }];
    //                                         } failure:^(NSError *error) {
    //
    //                                         }];
}

#pragma mark - 导航控制器切换
-(void)addNavigateController
{
    self.topScrollViews = [LXKTopScrollViews instanceViewWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarAndNavigationBarHeight) titleArr:@[@"基本信息",@"车辆图片"] selectColor:[UIColor colorWithHexString:@"#46AEF7"] unSelectColor:[UIColor colorWithHexString:@"BEBEBE"] selectFont:[UIFont systemFontOfSize:16] unSelectFont:[UIFont systemFontOfSize:14]];
    //设置滑块颜色
    self.topScrollViews.lineColor = [UIColor colorWithHexString:@"#46AEF7"];
    //设置滚动块的类型 ，线条，色块，椭圆色块
    //    self.topScrollViews.lineType = LXKScrollViewTypeAboutRectangle;
    //设置顶部的背景色
    self.topScrollViews.backgroundColor = [UIColor whiteColor];
    
    self.topScrollViews.delegate = self;
    
    [self.view addSubview:self.topScrollViews];
    //往scrollview添加的控件，由于addsub方法中重写了frame方法，所以此处初始化时可以不写frame
    
    YHDiagnosisBaseTC *carVersionVC = [[UIStoryboard storyboardWithName:@"diagnosis" bundle:nil] instantiateViewControllerWithIdentifier:@"YHDiagnosisBaseTC"];
    carVersionVC.isHelp = _isHelp;
    carVersionVC.isOther = self.isOther;
    carVersionVC.model = self.model; //_baseInfoM;
    self.vc = carVersionVC;
    
    YHCarPhotoController * vc = [[YHCarPhotoController alloc]init];
    if (self.billId.length) {
        vc.billId = self.billId;
        vc.carPhotos = self.baseInfoM.carPhotos;
    }else{
        vc.vinStr = self.vinStr;
        //        vc.model = self.model;
    }
    self.photoVC = vc;
    
    [self addChildViewController:carVersionVC];
    [self addChildViewController:vc];
    
    [self.topScrollViews addSubViewToScrollViewWithSubArr:@[carVersionVC.view,vc.view]];
    
    [self reloadCheckCustomerData];
}

#pragma mark - 检测客户车辆信息
- (void)reloadCheckCustomerData
{
    //    if (self.checkCustomerDic) {
    //        "id": "13",
    //        "name": "王涛",
    //        "phone": "13698569856",
    //        "carBrandId": "2000221",
    //        "carBrandName": "本田",
    //        "carLineId": "20000236",
    //        "carLineName": "锋范",
    //        "gearboxType": "自动变速器",
    //        "produceYear": "2011",
    //        "carCc": "1.5L",
    //        "vin": "LHGGM263GG2044273",
    //        "plateNumber": "JK599",
    //        "plateNumberP": "京",
    //        "plateNumberC": "B",
    //        "carModelId": "1025878",
    //        "carModelFullName": "锋范 2011款 1.5 自动 精英品致版",
    //        "userName": "王涛"
    //        "isBlockPolicy":"1"
    
    //        id    int    客户id
    //        userName    string    用户名   ----
    //        phone    string    手机号   ----
    //        carBrandId    string    车型id ---
    //        carBrandName    string    车型名 ---
    //        carLineId    string    车系id  ---
    //        carLineName    string    车系名  ---
    //        gearboxType    string    变速箱型号
    //        produceYear    string    生产年份 ---
    //        carCc    string    排量
    //        vin    string    车架号 ---
    //        plateNumber    string    车牌号后五位 ----
    //        plateNumberP    string    车牌首位 ----
    //        plateNumberC    string    车牌次位 ----
    //        carModelId    int    模型id ----
    //        carModelFullName    string    车辆全名 ----
    //        isBlockPolicy    string    延长保修标识 1为有，0没有
    
    
    //        NSString *carBrandId = [self.checkCustomerDic valueForKey:@"carBrandId"];
    //        NSString *carBrandName = [self.checkCustomerDic valueForKey:@"carBrandName"];
    //
    //        NSString *carLineId = [self.checkCustomerDic valueForKey:@"carLineId"];
    //        NSString *carLineName = [self.checkCustomerDic valueForKey:@"carLineName"];
    //
    //        NSString *produceYear = [self.checkCustomerDic valueForKey:@"produceYear"];
    //
    //        NSString *plateNumber = [self.checkCustomerDic valueForKey:@"plateNumber"];
    //        NSString *plateNumberP = [self.checkCustomerDic valueForKey:@"plateNumberP"];
    //        NSString *plateNumberC = [self.checkCustomerDic valueForKey:@"plateNumberC"];
    //
    //        NSString *carModelId = [self.checkCustomerDic valueForKey:@"carModelId"];
    //        NSString *carModelName = [self.checkCustomerDic valueForKey:@"carModelFullName"];
    //
    //        //联系人
    //        NSString *Contact = [self.checkCustomerDic valueForKey:@"userName"];
    //        //车辆全名
    //        NSString *carModelsL = [self.checkCustomerDic valueForKey:@"carModelFullName"];
    //        //车牌号码
    //        NSString *carNumberTF = [NSString stringWithFormat:@"%@%@",[self.checkCustomerDic valueForKey:@"plateNumberP"],[self.checkCustomerDic valueForKey:@"plateNumberC"]];
    //        // 联系电话
    //        NSString *contactNumberTF = [self.checkCustomerDic valueForKey:@"phone"];
    //
    //
    //        self.vc.Contact.text = Contact;
    //        self.vc.carModelsL.text = carModelsL;
    //        self.vc.carNumberTF.text = carNumberTF;
    //        self.vc.contactNumberTF.text = contactNumberTF;
    
    //    }
}
#pragma mark - 车牌校验 ---
- (BOOL)checkUpCarLicense:(NSString *)carText{
    
    NSString *expressStr1 = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领警港澳学]{1}[A-Z]{1}[A-Z0-9]{5}$";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", expressStr1];
    BOOL isSevenNum = [predicate1 evaluateWithObject:carText];
    
    NSString *expressStr2 = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领警港澳学]{1}[A-Z]{1}$";
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", expressStr2];
    BOOL isTwoNum = [predicate2 evaluateWithObject:carText];
    
    return (isTwoNum || isSevenNum);
}
#pragma mark - 从未完成工单 跳进来进行赋值
-(void)setValueForUnWorkBase
{
    self.vc.FrameNumberL.text = self.baseInfoM.vin;
    
    NSString *carModelSeries;   //车型车系
    if ([self.baseInfoM.carLineName containsString:self.baseInfoM.carBrandName]) { //如果车系名称包含品牌名称
        carModelSeries = [NSString stringWithFormat:@"%@",self.baseInfoM.carLineName];
    }else{
        carModelSeries = [NSString stringWithFormat:@"%@%@",self.baseInfoM.carBrandName,self.baseInfoM.carLineName];
    }
    self.vc.carModelsL.text = carModelSeries;     //车型车系
    
    self.vc.yearTF.text = self.baseInfoM.carStyle; //年款
    self.vc.powerL.text = self.baseInfoM.dynamicParameter;
    self.vc.modelTF.text = self.baseInfoM.model;
    
    //    self.vc.carDesTV.text //车辆描述  后台没有返回对应的字段
    self.vc.carNumberTF.text = [NSString stringWithFormat:@"%@%@%@",self.baseInfoM.plateNumberP,self.baseInfoM.plateNumberC,self.baseInfoM.plateNumber];//车牌号码
    
    //    //标准排放
//    if ([self.baseInfoM.emissionsStandards isEqualToString:@"国V"]) {
//        self.vc.emissionStandardsS.selectedSegmentIndex = 1;
//    }else if ([self.baseInfoM.emissionsStandards isEqualToString:@"国IV"]){
//        self.vc.emissionStandardsS.selectedSegmentIndex = 2;
//    }else if ([self.baseInfoM.emissionsStandards isEqualToString:@"国III"]){
//        self.vc.emissionStandardsS.selectedSegmentIndex = 3;
//    }else if ([self.baseInfoM.emissionsStandards isEqualToString:@"国II"]){
//        self.vc.emissionStandardsS.selectedSegmentIndex = 4;
//    }else if ([self.baseInfoM.emissionsStandards isEqualToString:@"国I"]){
//        self.vc.emissionStandardsS.selectedSegmentIndex = 5;
//    }
    
    self.vc.odometerTF.text = self.baseInfoM.tripDistance;   //里程
    self.vc.dateOfManufactureTF.text = self.baseInfoM.productionDate;  //出厂日期
    self.vc.registerDateTF.text = self.baseInfoM.registrationDate;   //注册日期
    self.vc.certificationDateTF.text = self.baseInfoM.issueDate;   //发证日期
    
    //车辆性质
    if ([self.baseInfoM.carNature isEqualToString:@"运营"]) {
        self.vc.carPropertiesS.selectedSegmentIndex = 0;
    }else if ([self.baseInfoM.carNature isEqualToString:@"非运营"]){
        self.vc.carPropertiesS.selectedSegmentIndex = 1;
    }
    
    //    //车辆所有者性质
    if ([self.baseInfoM.userNature isEqualToString:@"私户"]) {
        self.vc.ownerProS.selectedSegmentIndex = 0;
    }else if ([self.baseInfoM.userNature isEqualToString:@"公户"]){
        self.vc.ownerProS.selectedSegmentIndex = 1;
    }
    
    self.vc.InspectionDate.text = self.baseInfoM.endAnnualSurveyDate;   //年检到期时间
    self.vc.trafficMandatoryInsuranceDate.text = self.baseInfoM.trafficInsuranceDate;   //交强险到期日
    self.vc.businessInsuranceTF.text = self.baseInfoM.businessInsuranceDate;   //商业保险到期日
    self.vc.carAddress.text = self.baseInfoM.carAddress;
    self.vc.Contact.text = self.baseInfoM.userName;
    self.vc.contactNumberTF.text = self.baseInfoM.phone;
    // 设置排放标准 van_mr
    [self.vc.dischargeButton setTitle:self.baseInfoM.emissionsStandards forState:UIControlStateNormal];
}

#pragma mark - 接收通知返回的消息
-(void)ReceiveBrandName:(NSNotification*)notice{
    self.carType = 1;
    self.baseInfo[@"carBrandId"] = notice.userInfo[@"brandId"];        //品牌ID
    self.baseInfo[@"carBrandName"] = notice.userInfo[@"brandName"];  //品牌名称
    self.baseInfo[@"carLineId"] = notice.userInfo[@"lineId"];      //车系id
    self.baseInfo[@"carLineName"] = notice.userInfo[@"lineName"];      //车系名称
}

//移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:nil object:self];
}

//修改baseInfoM ，再修改基础数据
- (void)reLoadBaseInfoM
{
    /**
     车架号
     */
    self.baseInfoM.vin = self.vc.FrameNumberL.text;
    
    /**
     车型车系
     */
    if (_model != nil) {
        self.baseInfoM.carBrandName = _model.carBrandName;
        self.baseInfoM.carBrandId = _model.carBrandId;
        self.baseInfoM.carLineName = _model.carLineName;
        self.baseInfoM.carLineId = _model.carLineId;
    }
    
    /**
     年款
     */
    self.baseInfoM.carStyle = self.vc.yearTF.text;
    
    /**
     动力参数
     */
    self.baseInfoM.dynamicParameter = self.vc.powerL.text;
    
    /**
     型号
     */
    self.baseInfoM.model = self.vc.modelTF.text;
    
    /**
     车辆描述
     */
    self.baseInfoM.carModelDesc = self.vc.carDesTV.text;
    
    /**
     车牌号
     */
    self.baseInfoM.plateNumberP = [self.vc.carNumberTF.text substringToIndex:1]; //车牌-省;
    self.baseInfoM.plateNumberC = [self.vc.carNumberTF.text substringWithRange:NSMakeRange(1, 1)];     //车牌-市
    self.baseInfoM.plateNumber = [self.vc.carNumberTF.text substringFromIndex:2];     //车牌-号码
    
    /**
     排放标准
     */
    self.baseInfoM.emissionsStandards = self.vc.dischargeButton.titleLabel.text;
    
    /**
     里程表
     */
    self.baseInfoM.tripDistance = self.vc.odometerTF.text;
    
    /**
     出厂日期
     */
    self.baseInfoM.productionDate= self.vc.dateOfManufactureTF.text;
    
    /**
     注册日期
     */
    self.baseInfoM.registrationDate = self.vc.registerDateTF.text;
    
    /**
     发证日期
     */
    self.baseInfoM.issueDate = self.vc.certificationDateTF.text;
    
    /**
     车辆性质
     */
    self.baseInfoM.carNature = @[@"运营", @"非运营"][self.vc.carPropertiesS.selectedSegmentIndex];
    
    /**
     车辆所有者性质
     */
    self.baseInfoM.userNature = @[@"私户", @"公户"][self.vc.ownerProS.selectedSegmentIndex];
    
    /**
     年检到期日
     */
    self.baseInfoM.endAnnualSurveyDate = self.vc.InspectionDate.text;
    
    /**
     交强险到期日
     */
    self.baseInfoM.trafficInsuranceDate = self.vc.trafficMandatoryInsuranceDate.text;
    
    /**
     商业保险到期日
     */
    self.baseInfoM.businessInsuranceDate = self.vc.businessInsuranceTF.text;
    
    /**
     看车地址
     */
    self.baseInfoM.carAddress = self.vc.carAddress.text;
    
    /**
     联系人
     */
    self.baseInfoM.userName = self.vc.Contact.text;
    
    /**
     联系号码
     */
    self.baseInfoM.phone = self.vc.contactNumberTF.text;
}

#pragma mark  -  事件监听 ---
- (void)doClick:(UIBarButtonItem *)btn
{
    if(![self judgeIsEmpty])return;
    
    //车辆性质
    NSString *carPropertiesStr;
    if (self.vc.carPropertiesS.selectedSegmentIndex ==0) { //运营
        carPropertiesStr = @"运营";
    }else{ //非运营
        carPropertiesStr = @"非运营";
    }
    
    //车辆所有者性质
    NSString *ownerProStr;
    if (self.vc.ownerProS.selectedSegmentIndex ==0) {//私户
        ownerProStr = @"私户";
    }else{//公户
        ownerProStr = @"公户";
    }
    
    //标准排放
//    NSString *emissionStandards;
//    if (self.vc.emissionStandardsS.selectedSegmentIndex ==1) {
//        emissionStandards = @"国V";
//    }else if (self.vc.emissionStandardsS.selectedSegmentIndex ==2){
//        emissionStandards = @"国IV";
//    }else if (self.vc.emissionStandardsS.selectedSegmentIndex ==3){
//        emissionStandards = @"国III";
//    }else if (self.vc.emissionStandardsS.selectedSegmentIndex ==4){
//        emissionStandards = @"国II";
//    }else if (self.vc.emissionStandardsS.selectedSegmentIndex ==5){
//        emissionStandards = @"国I";
//    }
    /*****************************************************************/

    //可选的参数在baseInfo里面进行判断   判断在上面
    self.baseInfo[@"vin"] = self.vc.FrameNumberL.text;           //vin码
    if (self.carType == 0) {
        self.baseInfo[@"carBrandId"] = self.model.carBrandId;        //品牌ID
        self.baseInfo[@"carBrandName"] = self.model.carBrandName;  //品牌名称
        self.baseInfo[@"carLineId"] = self.model.carLineId;      //车系id
        self.baseInfo[@"carLineName"] = self.model.carLineName;      //车系名称
    }
    
    if (self.carType ==0) { //如果carType为0就传此字段 为1就不需要 因为只有0 1两种状态
        self.baseInfo[@"carModelId"] = self.model.carModelId;      //车辆版本id
        self.baseInfo[@"carModelName"] = self.model.carModelName;      //车辆版本名称
    }
    
    self.baseInfo[@"carType"] = @(self.carType);      //0估车网 1系统和车主填写信息（就是vin号能检测出来0否则1）
    self.baseInfo[@"carStyle"] = self.vc.yearTF.text;      //年款
    self.baseInfo[@"dynamicParameter"] = self.vc.powerL.text;    //动力参数
    self.baseInfo[@"model"] = self.vc.modelTF.text;      //型号
    if (!NULLString(self.vc.carDesTV.text)) {
        self.baseInfo[@"carModelDesc"] = self.vc.carDesTV.text;   //车辆描述
    }
    self.baseInfo[@"plateNumberP"] = [self.vc.carNumberTF.text substringToIndex:1]; //车牌-省
    self.baseInfo[@"plateNumberC"] = [self.vc.carNumberTF.text substringWithRange:NSMakeRange(1, 1)];      //车牌-市
    if (!NULLString([self.vc.carNumberTF.text substringFromIndex:2])) {
        self.baseInfo[@"plateNumber"] = [self.vc.carNumberTF.text substringFromIndex:2];      //车牌-号码
    }else{
        [self.baseInfo removeObjectForKey:@"plateNumber"];
    }
    
    self.baseInfo[@"emissionsStandards"] = self.vc.dischargeButton.titleLabel.text;      //排放标准
    
    
    self.baseInfo[@"tripDistance"] = self.vc.odometerTF.text;      //行驶里程
    self.baseInfo[@"productionDate"] = self.vc.dateOfManufactureTF.text;      //出厂日期
    self.baseInfo[@"registrationDate"] = self.vc.registerDateTF.text;      //注册日期
    self.baseInfo[@"issueDate"] = self.vc.certificationDateTF.text;      //发证日期
    self.baseInfo[@"carNature"] = carPropertiesStr;    //车辆性质
    self.baseInfo[@"userNature"] = ownerProStr;      //车辆所有者性质
    self.baseInfo[@"endAnnualSurveyDate"] = self.vc.InspectionDate.text;      //年检到期时间
    if (!NULLString(self.vc.trafficMandatoryInsuranceDate.text)) {
        self.baseInfo[@"trafficInsuranceDate"] = self.vc.trafficMandatoryInsuranceDate.text;      //交强险到期时间
    }
    if (!NULLString(self.vc.businessInsuranceTF.text)) {
        self.baseInfo[@"businessInsuranceDate"] = self.vc.businessInsuranceTF.text;      //商业险到期时间
    }
    self.baseInfo[@"carAddress"] = self.vc.carAddress.text;      //看车地址
    if (!NULLString(self.vc.Contact.text)) {
        self.baseInfo[@"userName"] = self.vc.Contact.text;      //用户名
    }
    self.baseInfo[@"phone"] = self.vc.contactNumberTF.text;      //联系方式
    
    //参数定义
    NSMutableDictionary *params = [@{
                                     @"token":[YHTools getAccessToken],
                                     @"baseInfo":self.baseInfo
                                     }mutableCopy];
    if (!_isHelp) {
        params[@"bucheBookingId"] = @(self.bucheBookingId);
    }
    if (self.model.carModelId != nil) {
        [self.baseInfo setObject:self.model.carModelId forKey:@"carModelId"];
    }
    if (self.model.carModelId != nil) {
        [self.baseInfo setObject:self.model.carModelName forKey:@"carModelName"];
    }
    
    if (self.baseInfoM) {
        
         [MBProgressHUD showMessage:@"提交中..." toView:self.view];
        btn.enabled = NO;
        [self reLoadBaseInfoM];
        !(_doAciton)? : _doAciton(self.baseInfoM);
        
        NSDictionary *storeParams = @{
                                      @"token":[YHTools getAccessToken],
                                      @"billId":self.billId,
                                      @"val":@{
                                              @"baseInfo":self.baseInfo
                                              }
                                      };
        //调用  工单暂存接口 更新用户更新信息
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] temporaryDepositBasicInformationWithDictionary:storeParams isHelp:_isHelp  onComplete:^(NSDictionary *info) {
            [MBProgressHUD hideHUDForView:self.view];
            btn.enabled = YES;

            if ([info[@"code"] longLongValue] == 20000) {//请求成功
                [self.navigationController popViewControllerAnimated:YES];
                
                [YHPhotoManger moveItemAtPath:self.billId toPath:self.billId];
                
            }else{  //错误信息提示
                [MBProgressHUD showError:info[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            }
            
            NSLog(@"info------%@",info);
        } onError:^(NSError *error) {
               btn.enabled = YES;
            [MBProgressHUD hideHUDForView:self.view];
        }];
    }else{
        
        if (_isHelp) { // 是帮检单
            
            //新建工单网络请求
            YHNewOrderCompeteVC *comptVC = [[YHNewOrderCompeteVC alloc] init];
            comptVC.params = params;
            comptVC.vinStr = self.vinStr;
            comptVC.vinController = self.vinController;
            comptVC.isHelp = _isHelp;
            comptVC.billId = self.photoVC.billId;
            [self.navigationController pushViewController:comptVC animated:YES];
            
            return;
        }
        btn.enabled = NO;
        [MBProgressHUD showMessage:@"提交中..." toView:self.view];
        //新建工单网络请求
        [[YHNetworkPHPManager sharedYHNetworkPHPManager] submitBasicInformationWithDictionary:params isHelp:_isHelp onComplete:^(NSDictionary *info) {
            [MBProgressHUD hideHUDForView:self.view];
            NSLog(@"info------%@",info);
            //        btn.userInteractionEnabled = YES;
            btn.enabled = YES;

            if ([info[@"code"] longLongValue] == 20000) {//请求成功
                //将字典转化成模型
                YHBillStatusModel *billModel = [YHBillStatusModel mj_objectWithKeyValues:info[@"data"][@"billStatus"]];
                
                YHDiagnosisProjectVC *diagnosisProjectVC = [[YHDiagnosisProjectVC alloc] init];
                
                diagnosisProjectVC.billModel = billModel;
                diagnosisProjectVC.isHelp = _isHelp;
                [self.navigationController pushViewController:diagnosisProjectVC animated:YES];
                
                [YHPhotoManger moveItemAtPath:self.vinStr toPath:billModel.billId];
                
            }else{  //错误信息提示
                [MBProgressHUD showError:info[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            }
            
        } onError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            btn.enabled = YES;

            //        btn.userInteractionEnabled = YES;
        }];
        
    }
}

-(BOOL)judgeIsEmpty{
#if 1
    //数据校验
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
    if (![self checkUpCarLicense:self.vc.carNumberTF.text]) {  //车牌号码
        [MBProgressHUD showError:@"请输入正确车牌号" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    if (NULLString(self.vc.odometerTF.text)) {  //表显里程
        [MBProgressHUD showError:@"里程表不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    if (NULLString(self.vc.dateOfManufactureTF.text)) {  // 出厂日期
        [MBProgressHUD showError:@" 出厂日期不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    if (NULLString(self.vc.registerDateTF.text)) {  //注册日期
        [MBProgressHUD showError:@"注册日期不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    if (NULLString(self.vc.certificationDateTF.text)) {  // 发证日期
        [MBProgressHUD showError:@"发证日期不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    if (NULLString(self.vc.InspectionDate.text)) {  // 年检到期日
        [MBProgressHUD showError:@"年检到期日不能为空" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    //    if (NULLString(self.vc.trafficMandatoryInsuranceDate.text)) {  //交强险到期日
    //        [MBProgressHUD showError:@"交强险到期日不能为空" toView:[UIApplication sharedApplication].keyWindow];
    //        return;
    //    }
    //    if (NULLString(self.vc.businessInsuranceTF.text)) {  // 商业保险到期日
    //        [MBProgressHUD showError:@"商业保险到期日不能为空" toView:[UIApplication sharedApplication].keyWindow];
    //        return;
    //    }
//    if (NULLString(self.vc.carAddress.text)) {  //看车地址
//        [MBProgressHUD showError:@"看车地址不能为空" toView:[UIApplication sharedApplication].keyWindow];
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
    
    if (!self.photoVC.isFinished) {  //是否添加完了图片
        [MBProgressHUD showError:@"你还没有添加完车辆图片" toView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    return YES;
#endif
    
}


//判断是否为手机号
- (BOOL)validatePhone:(NSString *)phone{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

#pragma mark - baseInfo字典
-(NSMutableDictionary *)baseInfo{
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
-(void)scroolToIndex:(NSInteger)index{
    
    NSLog(@"scroll to frame index is == %ld",(long)index);
}

@end
