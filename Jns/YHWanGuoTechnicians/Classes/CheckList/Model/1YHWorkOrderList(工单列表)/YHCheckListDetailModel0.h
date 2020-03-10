//
//  YHCheckListDetailModel0.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/6.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHCheckListDetailModel0 : NSObject

//共有
@property (nonatomic, copy)NSString *vin;                 //车架号
@property (nonatomic, copy)NSString *billNumber;          //工单号
@property (nonatomic, copy)NSString *carModelFullName;    //车系车型
@property (nonatomic, copy)NSString *carBrandLogo;        //车logo
@property (nonatomic, copy)NSString *skilledWorker;       //检测技师

//未完成
@property (nonatomic, assign)int ID;                      //捕车预约ID
@property (nonatomic, copy)NSString *billType;            //工单类型
@property (nonatomic, copy)NSString *creationTime;        //创建时间
@property (nonatomic, copy)NSString *nowStatusCode;       //当前状态
@property (nonatomic, copy)NSString *nextStatusCode;      //下一步状态
@property (nonatomic, copy)NSString *handleType;          //处理类型 handle(有权限) detail(无权限)

//已完成
@property (nonatomic, copy)NSString *userName;            //车主
@property (nonatomic, copy)NSString *plateNumberP;        //车牌所在地
@property (nonatomic, copy)NSString *plateNumberC;        //车牌所在市
@property (nonatomic, copy)NSString *plateNumber;         //车牌号
@property (nonatomic, copy)NSString *endTime;             //结束时间

@end
