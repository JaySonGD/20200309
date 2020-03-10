//
//  YHCompetingOrderVC.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/16.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
// 未完成工单——>进入基本信息

#import "YHCompetingOrderVC.h"
#import "YHCommon.h"
#import <Masonry/Masonry.h>
#import "YHDiagnosisOrderModel.h"

#import "YHOrderInfoCell.h"
#import "YHOrderInfoSelectCell.h"

@interface YHCompetingOrderVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *orderInfoTableview;

@property(nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation YHCompetingOrderVC

- (NSMutableArray *)dataArr{
    if (!_dataArr.count) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initBaseData];
   
}

- (void)setBaseInfoM:(YHCarBaseModel *)baseInfoM{
    _baseInfoM = baseInfoM;
  
    // 车架号
    YHDiagnosisOrderModel *VinModel = [[YHDiagnosisOrderModel alloc] init];
    VinModel.title = @"车架号";
    VinModel.subTitle = baseInfoM.vin;
    [self.dataArr addObject:VinModel];
    // 车系车型
    YHDiagnosisOrderModel *carSysModel = [[YHDiagnosisOrderModel alloc] init];
    NSString *carModelSeries = [NSString stringWithFormat:@"%@%@",self.baseInfoM.carBrandName,self.baseInfoM.carLineName];
    if ([baseInfoM.carLineName containsString:baseInfoM.carBrandName]) { //如果车系名称包含品牌名称
        carModelSeries = [NSString stringWithFormat:@"%@",self.baseInfoM.carLineName];
    }
    carSysModel.title = @"车系车型";
    carSysModel.subTitle = [NSString stringWithFormat:@"%@%@",baseInfoM.carBrandName,baseInfoM.carLineName];
    [self.dataArr addObject:carSysModel];
    // 年款
    YHDiagnosisOrderModel *yearPatternModel = [[YHDiagnosisOrderModel alloc] init];
    yearPatternModel.title = @"年款";
    yearPatternModel.subTitle = baseInfoM.carStyle;
    [self.dataArr addObject:yearPatternModel];
    // 动力参数
    YHDiagnosisOrderModel *dynamicParameterModel = [[YHDiagnosisOrderModel alloc] init];
    dynamicParameterModel.title = @"动力参数";
    dynamicParameterModel.subTitle = baseInfoM.dynamicParameter;
    [self.dataArr addObject:dynamicParameterModel];
    // 型号
    YHDiagnosisOrderModel *parModel = [[YHDiagnosisOrderModel alloc] init];
    parModel.title = @"型号";
    parModel.subTitle = baseInfoM.model;
    [self.dataArr addObject:parModel];
    // 车牌号码
    YHDiagnosisOrderModel *plateNumberModel = [[YHDiagnosisOrderModel alloc] init];
    plateNumberModel.title = @"车牌号码";
    plateNumberModel.subTitle = [NSString stringWithFormat:@"%@%@%@",baseInfoM.plateNumberP,baseInfoM.plateNumberC,baseInfoM.plateNumber];
    [self.dataArr addObject:plateNumberModel];
    // 排放标准
    YHDiagnosisOrderModel *emissionModel = [[YHDiagnosisOrderModel alloc] init];
    emissionModel.title = @"排放标准";
    emissionModel.subTitle = baseInfoM.emissionsStandards;
    [self.dataArr addObject:emissionModel];
    // 表显里程
    YHDiagnosisOrderModel *tripDistanceModel = [[YHDiagnosisOrderModel alloc] init];
    tripDistanceModel.title = @"表显里程";
    tripDistanceModel.subTitle = [NSString stringWithFormat:@"%@ KM",baseInfoM.tripDistance] ;
    [self.dataArr addObject:tripDistanceModel];
    // 出厂日期
    YHDiagnosisOrderModel *productModel = [[YHDiagnosisOrderModel alloc] init];
    productModel.title = @"出厂日期";
    productModel.subTitle = baseInfoM.productionDate;
    [self.dataArr addObject:productModel];
    // 注册日期
    YHDiagnosisOrderModel *rigisterModel = [[YHDiagnosisOrderModel alloc] init];
    rigisterModel.title = @"注册日期";
    rigisterModel.subTitle = baseInfoM.registrationDate;
    [self.dataArr addObject:rigisterModel];
    // 发证日期
    YHDiagnosisOrderModel *issueDateModel = [[YHDiagnosisOrderModel alloc] init];
    issueDateModel.title = @"发证日期";
    issueDateModel.subTitle = baseInfoM.issueDate;
    [self.dataArr addObject:issueDateModel];
    // 车辆性质
    YHDiagnosisOrderModel *carNatureModel = [[YHDiagnosisOrderModel alloc] init];
    carNatureModel.isShowSegamentContrroll = YES;
    carNatureModel.title = @"车辆性质";
    carNatureModel.subTitle = baseInfoM.carNature;
    [self.dataArr addObject:carNatureModel];
    // 车辆所有者性质
    YHDiagnosisOrderModel *userNatureModel = [[YHDiagnosisOrderModel alloc] init];
    userNatureModel.isShowSegamentContrroll = YES;
    userNatureModel.title = @"车辆所有者性质";
    userNatureModel.subTitle = baseInfoM.userNature;
    [self.dataArr addObject:userNatureModel];
    // 年检到期日
    YHDiagnosisOrderModel *endAnnualSurveyDateModel = [[YHDiagnosisOrderModel alloc] init];
    endAnnualSurveyDateModel.title = @"年检到期日";
    endAnnualSurveyDateModel.subTitle = baseInfoM.endAnnualSurveyDate;
    [self.dataArr addObject:endAnnualSurveyDateModel];
    // 交强险到期日
    YHDiagnosisOrderModel *trafficInsuranceModel = [[YHDiagnosisOrderModel alloc] init];
    trafficInsuranceModel.title = @"交强险到期日";
    trafficInsuranceModel.subTitle = baseInfoM.trafficInsuranceDate;
    [self.dataArr addObject:trafficInsuranceModel];
    // 商业险到期日
    YHDiagnosisOrderModel *businessInsuranceModel = [[YHDiagnosisOrderModel alloc] init];
    businessInsuranceModel.title = @"商业险到期日";
    businessInsuranceModel.subTitle = baseInfoM.businessInsuranceDate;
    [self.dataArr addObject:businessInsuranceModel];
    // 联系人
    YHDiagnosisOrderModel *nameModel = [[YHDiagnosisOrderModel alloc] init];
    nameModel.title = @"联系人";
    nameModel.subTitle = baseInfoM.userName;
    [self.dataArr addObject:nameModel];
    // 联系电话
    YHDiagnosisOrderModel *phoneModel = [[YHDiagnosisOrderModel alloc] init];
    phoneModel.title = @"联系电话";
    phoneModel.subTitle = baseInfoM.phone;
    [self.dataArr addObject:phoneModel];
    
    [self.orderInfoTableview reloadData];
}

- (void)initBaseData{
    self.title = @"检车信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //去掉返回按钮上面的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
}
- (void)initUI{
    
    UITableView *orderInfo = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.orderInfoTableview = orderInfo;
    orderInfo.delegate = self;
    orderInfo.dataSource = self;
    [self.view addSubview:orderInfo];
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    CGFloat bottomMargin = iPhoneX ? 34 : 0;
    [orderInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderInfo.superview);
        make.right.equalTo(orderInfo.superview);
        make.bottom.equalTo(orderInfo.superview).offset(bottomMargin);
        make.top.equalTo(orderInfo.superview).offset(topMargin);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *orderInfoCell = @"orderInfoCellId";
    static NSString *orderInfoSelectCellId = @"orderInfoSelectCellId";
    YHDiagnosisOrderModel *model = self.dataArr[indexPath.row];

    if (model.isShowSegamentContrroll) {
        YHOrderInfoSelectCell *selectCell = [tableView dequeueReusableCellWithIdentifier:orderInfoSelectCellId];
        if (!selectCell) {
            selectCell = [[YHOrderInfoSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderInfoSelectCellId];
            selectCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        selectCell.model = model;
        return selectCell;
    }
    
    // 不需要显示segamentControll的情况
    YHOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoCell];
    if (!cell) {
        cell = [[YHOrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderInfoCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.orderInfoModel = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 52;
}

@end
