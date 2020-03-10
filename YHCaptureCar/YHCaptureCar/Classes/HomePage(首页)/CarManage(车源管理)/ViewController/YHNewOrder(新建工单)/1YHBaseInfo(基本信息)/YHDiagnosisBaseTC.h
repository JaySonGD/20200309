//
//  YHDiagnosisBaseTC.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//  车辆检测基本信息控制器

#import <UIKit/UIKit.h>
#import "BRTextField.h"
#import "YHCustomLabel.h"
#import "YHBaseTableViewController.h"
#import "CMInputView.h"
#import "YHCarVersionModel.h"
@class YHCarBaseModel;

@interface YHDiagnosisBaseTC : YHBaseTableViewController

/** VIN码 */
@property (nonatomic, copy)NSString *vinStr;

//保存用户点击模型
@property (nonatomic, strong) YHCarVersionModel *carVersionModel;

/** baseInfo */
@property (nonatomic, strong)  YHCarBaseModel *model;

/** 点击完成 */
@property (nonatomic, copy) void(^doAciton)(YHCarBaseModel *model);

@property (nonatomic, assign) BOOL isSupInfo;//是否从补充车辆信息过来
/**
 车架号
 */
@property (weak, nonatomic) IBOutlet UITextField *vinFT;

/**
 车型车系
 */
@property (weak, nonatomic) IBOutlet YHCustomLabel *carModelsL;

/**
 年款
 */
@property (weak, nonatomic) IBOutlet BRTextField *yearTF;

/**
 动力参数
 */
@property (weak, nonatomic) IBOutlet UITextField *powerL;

/**
 型号
 */
@property (weak, nonatomic) IBOutlet UITextField *modelTF;

/**
 车辆描述
 */
@property (weak, nonatomic) IBOutlet UITextView *carDesTV;

/**
 车牌号
 */
@property (weak, nonatomic) IBOutlet BRTextField *carNumberTF;

/**
 排放标准
 */
@property (weak, nonatomic) IBOutlet UIButton *dischargeButton;

/**
 里程表
 */
@property (weak, nonatomic) IBOutlet UITextField *odometerTF;

/**
 出厂日期
 */
@property (weak, nonatomic) IBOutlet BRTextField *dateOfManufactureTF;

/**
 注册日期
 */
@property (weak, nonatomic) IBOutlet BRTextField *registerDateTF;

/**
 发证日期
 */
@property (weak, nonatomic) IBOutlet BRTextField *certificationDateTF;

/**
 车辆性质
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *carPropertiesS;

/**
 车辆所有者性质
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *ownerProS;

/**
 年检到期日
 */
@property (weak, nonatomic) IBOutlet BRTextField *InspectionDate;

/**
 交强险到期日
 */
@property (weak, nonatomic) IBOutlet BRTextField *trafficMandatoryInsuranceDate;

/**
 商业保险到期日
 */
@property (weak, nonatomic) IBOutlet BRTextField *businessInsuranceTF;


/**
 联系人
 */
@property (weak, nonatomic) IBOutlet UITextField *Contact;

/**
 联系号码
 */
@property (weak, nonatomic) IBOutlet UITextField *contactNumberTF;

/**
 车辆估价
 */
@property (weak, nonatomic) IBOutlet UILabel *evaluateLab;

/**
 价格
 */
@property (weak, nonatomic) IBOutlet UITextField *priceFT;

@property (weak, nonatomic) IBOutlet UITextField *addrFT;

//是否由其它选项进入此界面
@property(nonatomic,assign)BOOL isOther;

//所选省份
@property (strong, nonatomic)NSString *selectedProvince;

//所选城市
@property (strong, nonatomic)NSString *selectedCity;

//所选排放标准
@property (strong, nonatomic)NSString *selectedDischarge;

@end
