//
//  YHDiagnosisBaseVC.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCarVersionModel.h"
#import "YHBaseViewController.h"
@class YHCarVersionModel,YHCarBaseModel;
@interface YHDiagnosisBaseVC : YHBaseViewController

/**
 VIN码
 */
@property(nonatomic,copy)NSString *vinStr;

//捕车ID
@property(nonatomic,assign)int bucheBookingId;

//保存用户点击模型
@property (nonatomic, strong)YHCarVersionModel *model;

//carType类型 0Vin可识别 1Vin不识别
@property(nonatomic,assign)int carType;

//是否是选择其它 项
@property(nonatomic,assign)int isOther;

/** baseInfo */
@property (nonatomic, strong) YHCarBaseModel*baseInfoM;

/** 传工单号为我的车辆图片用 */
@property (nonatomic, copy)NSString*billId;


/**检测客户车辆信息*/
@property (nonatomic, strong) YHCarVersionModel *checkCustomerModel;

//是否是帮检单
@property (nonatomic)BOOL isHelp;

@property (nonatomic, copy) NSString *amount;

/** 点击完成 */
@property (nonatomic, copy)void(^doAciton)(YHCarBaseModel *baseInfo);

@property (nonatomic, strong) UIViewController *vinController;

@end
