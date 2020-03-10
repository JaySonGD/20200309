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

@property (nonatomic, strong) YHCarVersionModel *carVersionModel;  //保存用户点击模型

@property(nonatomic,assign)int carType;//carType类型 0Vin可识别 1Vin不识别

@property(nonatomic,assign)int isOther;//是否是选择其它 项

/** 点击完成 */
@property (nonatomic, copy) void(^doAciton)(YHCarBaseModel *baseInfo);
/** baseInfo */
@property (nonatomic, strong)  YHCarBaseModel*baseInfoM;
/** 传工单号为我的车辆图片用 */
@property (nonatomic, copy)  NSString*billId;


@end
