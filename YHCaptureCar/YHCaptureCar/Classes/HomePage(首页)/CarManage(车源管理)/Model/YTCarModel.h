//
//  YTCarModel.h
//  YHCaptureCar
//
//  Created by Jay on 27/5/2019.
//  Copyright © 2019 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTCarModel : NSObject
//-vin    String    车架号
@property (nonatomic, copy) NSString *vin;

//-carBrandName    String    车型车系
@property (nonatomic, copy) NSString *carBrandName;

//-carStyle    String    年款
@property (nonatomic, copy) NSString *carStyle;

//-dynamicParameter    String    动力参数
@property (nonatomic, copy) NSString *dynamicParameter;

//-model    String    型号
@property (nonatomic, copy) NSString *model;

//-plateNo    String    车牌号
@property (nonatomic, copy) NSString *plateNo;

//-emissionsStandards    String    排放标准
@property (nonatomic, copy) NSString *emissionsStandards;

//-tripDistance    String    公里数
@property (nonatomic, copy) NSString *tripDistance;

@property (nonatomic, copy) NSString *carFullName;

@property (nonatomic, copy) NSString *carPic;
@property (nonatomic, copy) NSString *carIcon;

//-productionDate    String    生产时间
@property (nonatomic, copy) NSString *productionDate;

//-registrationDate    String    注册时间
@property (nonatomic, copy) NSString *registrationDate;

//-issueDate    String    发证时间
@property (nonatomic, copy) NSString *issueDate;

//-carNature    String    车辆性质 0 营运 1 非营运
//@property (nonatomic, assign) NSInteger carNature;
@property (nonatomic, copy) NSString *carNature;

//@property (nonatomic, assign) NSInteger userNature;
@property (nonatomic, copy) NSString *userNature;


//-endAnnualSurveyDate    String    年检到期时间
@property (nonatomic, copy) NSString *endAnnualSurveyDate;

//-businessInsuranceDate    String    商业保险到期时间
@property (nonatomic, copy) NSString *businessInsuranceDate;
@property (nonatomic, copy) NSString *carLocation;

//-trafficInsuranceDate    String    交强险到期时间
@property (nonatomic, copy) NSString *trafficInsuranceDate;

//-suggestPrice    String    车辆估值范围
@property (nonatomic, copy) NSString *suggestPrice;
@property (nonatomic, copy) NSString *carPrice;
@property (nonatomic, copy) NSString *carContact;
@property (nonatomic, copy) NSString *carContactTel;
@property (nonatomic, copy) NSString *rptToken;

@property (nonatomic, assign) NSInteger payStatus;

@property (nonatomic, assign) BOOL favorite;
//-offer    String    售价
@property (nonatomic, copy) NSString *offer;

//-workOrderId    String    PHP工单ID
@property (nonatomic, copy) NSString *workOrderId;

//-status    String    状态 0 库存 1 拍卖 2 帮卖 5 帮买
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL flag;
//-flag    String    是否是认证检测 0 不是 1 是

@property (nonatomic , strong) NSArray *cannotChangeFields;

@end

NS_ASSUME_NONNULL_END
