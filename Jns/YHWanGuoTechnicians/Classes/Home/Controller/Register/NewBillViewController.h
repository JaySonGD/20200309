//
//  NewBillViewController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/8/18.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHWebFuncViewController.h"
typedef NS_ENUM(NSInteger, YYNewBilltyle) {
    YYNewBillStyleDefault,          //开单
    YYNewBillStyleUsedSale,         // 二手车检车
    YYNewBillStyleHelpSale,         // 代售检车
    YYNewBillStyleHelpHelper,//技术帮手 menu_help
    YYNewBillStyleSchemaQuery,//方案查询  W001
    YYNewBillStyleOrderAir,//ai诊断  order_air
    YYNewBillStyleReturnRefresh,//返回顶层web并刷新
    YYNewBillStyleOrderJ005,//深度诊断 J005
    YYNewBillStyleOrderJ007,//尾气 J007


};

typedef NS_ENUM(NSInteger, YYNewVin) {
    YYNewVinNone,          //未定义
    YYNewVinCar,          //单独车牌
    YYNewVinVin,          //单独vin码
    YYNewVinCarAndVin,          //车牌和斌码
};


@interface NewBillViewController : YHBaseViewController
@property (nonatomic, copy) NSString *reportType;
@property (nonatomic)BOOL isShowImageBtn;//J003工单类型显示指引按钮
@property (nonatomic, copy) NSString *vin;

@property (nonatomic,copy) NSString *billId;

@property (nonatomic, assign) YYNewBilltyle type;

@property (nonatomic, copy) NSString *imageByCode;

@property (nonatomic, copy) NSString *webURLString;
@property (weak,nonatomic)YHWebFuncViewController *webController;

- (void)setControllerTitle:(NSString *)title;
@property (nonatomic, copy) NSString *bill_type;//工单类型
@property (nonatomic) YYNewVin textType;

@property (nonatomic, assign) BOOL isOnlyVin;

@property (nonatomic, copy) NSString *car_brand_name;

@end
