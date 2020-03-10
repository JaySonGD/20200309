//
//  YHCheckListModel0.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/3/6.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHCheckListModel0 : NSObject

@property (nonatomic, assign)int ID;                     //捕车预约ID
@property (nonatomic, copy)NSString *bookId;             //预约ID
@property (nonatomic, copy)NSString *carDealerName;      //车商名称
@property (nonatomic, copy)NSString *contactName;        //车商联系人姓名
@property (nonatomic, copy)NSString *contactPhone;       //车商联系人电话
@property (nonatomic, copy)NSString *address;            //地址
@property (nonatomic, copy)NSString *carNum;             //预约检测车辆数量
@property (nonatomic, copy)NSString *finishCarNum;       //已检测车辆数量
@property (nonatomic, copy)NSString *amount;             //结算金额
@property (nonatomic, copy)NSString *bookTime;           //预约时间
@property (nonatomic, copy)NSString *status;             //状态 0:未完成 1:已完成 2:关闭

@end
