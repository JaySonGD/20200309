//
//  YHCarBaseModel.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/13.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHCarPicModel:NSObject
//    基本信息 - 车辆正面照
//    基本信息 - 车辆背面照
//    基本信息 - 车辆左侧照
//    基本信息 - 车辆右侧照
//    基本信息 - 机舱
//    基本信息 - 后尾箱
//    基本信息 - 内饰 - 一排
//    基本信息 - 内饰 - 二排
//    基本信息 - 内饰 - 三排
//    基本信息 - 仪表盘
//
@property (nonatomic, copy) NSString *car_surface_front;
@property (nonatomic, copy) NSString *car_surface_back;

@property (nonatomic, copy) NSString *car_surface_left;
@property (nonatomic, copy) NSString *car_surface_right;

@property (nonatomic, copy) NSString *car_engine_room;
@property (nonatomic, copy) NSString *car_rear_box;

@property (nonatomic, copy) NSString *car_interior_1;
@property (nonatomic, copy) NSString *car_interior_2;

@property (nonatomic, copy) NSString *car_interior_3;
@property (nonatomic, copy) NSString *car_instrument_panel;
@property (nonatomic, strong) NSArray<NSString *> *car_other;

@end

@interface YHCarBaseModel : NSObject
@property (nonatomic, assign) NSInteger carType;
@property (nonatomic, copy) NSString *carBrandName;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *plateNumberP;

@property (nonatomic, copy) NSString *plateNumberC;
@property (nonatomic, copy) NSString *vin;

@property (nonatomic, copy) NSString *carBrandId;
@property (nonatomic, copy) NSString *carLineId;

@property (nonatomic, copy) NSString *carLineName;
@property (nonatomic, copy) NSString *tripDistance;

@property (nonatomic, copy) NSString *carModelId;
@property (nonatomic, copy) NSString *carModelName;

@property (nonatomic, copy) NSString *emissionsStandards;
@property (nonatomic, copy) NSString *dynamicParameter;

@property (nonatomic, copy) NSString *carStyle;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *carModelDesc;

@property (nonatomic, copy) NSString *productionDate;
@property (nonatomic, copy) NSString *registrationDate;

@property (nonatomic, copy) NSString *issueDate;
@property (nonatomic, copy) NSString *carNature;

@property (nonatomic, copy) NSString *userNature;
@property (nonatomic, copy) NSString *endAnnualSurveyDate;

@property (nonatomic, copy) NSString *trafficInsuranceDate;
@property (nonatomic, copy) NSString *businessInsuranceDate;

@property (nonatomic, copy) NSString *offer;//售价
@property (nonatomic, copy) NSString *carId;//车辆ID
//-suggestPrice    String    车辆估值范围
@property (nonatomic, copy) NSString *suggestPrice;
//-plateNo    String    车牌号
@property (nonatomic, copy) NSString *plateNo;
@property (nonatomic, copy) NSString *carContact;
@property (nonatomic, copy) NSString *carContactTel;
@property (nonatomic , strong) NSArray *cannotChangeFields;

@property (nonatomic, copy) NSString *carAddress;
@property (nonatomic, copy) NSString *carModelFullName;


@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *plateNumber;


@property (nonatomic, copy) NSString *carCc;
@property (nonatomic, copy) NSString *carBrandLogo;


@property (nonatomic, strong) YHCarPicModel *carPhotos;




@end
