//
//  YHCarVersionModel.h
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/9.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHCarVersionModel : NSObject

//@property (nonatomic,copy)NSString *carLineId;          //车系ID
//@property (nonatomic, copy)NSString *carLineName;       //车系名称
//@property (nonatomic, copy)NSString *carBrandId;        //品牌ID
//@property (nonatomic, copy)NSString *carBrandName;      //品牌名称
//@property (nonatomic, copy)NSString *carModelId;        //车型Id
//@property (nonatomic, copy)NSString *carModelName;      //车型名称
//@property (nonatomic, copy)NSString *carModelFullName;  //车款全名
//@property (nonatomic, copy)NSString *carCc;             //汽车排量
//@property (nonatomic, copy)NSString *produceYear;       //生产年份
//@property (nonatomic, copy)NSString *gearboxType;       //变速箱类型
//@property (nonatomic, copy)NSString *airAdmission;      //发动机排气类型
//@property (nonatomic, copy)NSString *icoName;           //图标名称
//
//@property(nonatomic,assign)BOOL isSelect;

@property (nonatomic, copy)NSString *carLineId;         //车系ID
@property (nonatomic, copy)NSString *carLineName;       //车系名称
@property (nonatomic, copy)NSString *carBrandId;        //车辆品牌ID
@property (nonatomic, copy)NSString *carBrandName;      //车辆品牌名称
@property (nonatomic, copy)NSString *carModelId;        //车型ID
@property (nonatomic, copy)NSString *carModelName;      //车型名称
@property (nonatomic, copy)NSString *carModelFullName;  //车款全名
@property (nonatomic, copy)NSString *carCc;             //汽车排量
@property (nonatomic, copy)NSString *produceYear;       //生产年份
@property (nonatomic, copy)NSString *gearboxType;       //变速箱类型
@property (nonatomic, copy)NSString *airAdmission;      //进气模式

@property (nonatomic, copy)NSString *icoName;           //品牌图标标识
@property (nonatomic, copy)NSString *brandModelId;      //生产厂家id
@property (nonatomic, copy)NSString *brandModel;        //生产厂家（如广汽丰田、东风本田）
@property (nonatomic, copy)NSString *cheXing;           //车型/型号 (如卡罗拉双擎）
@property (nonatomic, copy)NSString *saleName;          //销售名称（版本）
@property (nonatomic, copy)NSString *nianKuan;          //年款
@property (nonatomic, copy)NSString *paiFang;           //排放标准

//@property (nonatomic, copy)NSString *userName;
//@property (nonatomic, copy)NSString *phone;
//@property (nonatomic, copy)NSString *plateNumber;
//@property (nonatomic, copy)NSString *plateNumberC;
//@property (nonatomic, copy)NSString *plateNumberP;

@property(nonatomic,assign)BOOL isSelect;


//id = 227;
//isBlockPolicy = 1;
//isWxOpenId = 1;
//name = sss;
//vin = WBAPH1100AA638222;

@end
