//
//  YHToBeDetectionModel.h
//  YHCaptureCar
//
//  Created by liusong on 2018/1/30.
//  Copyright © 2018年 YH. All rights reserved.
//  待检测模型

#import "YHBaseModel.h"

/**
 待检测模型
 */
@interface YHToBeDetectionModel : YHBaseModel

@property (nonatomic, copy) NSString *arrivalEndTime;
@property (nonatomic, assign)long ID;                 //预约ID
@property (nonatomic, copy)NSString *name;            //站点名称
@property (nonatomic, copy)NSString *bookDate;       //预约时间
@property (nonatomic, assign)int amount;            //检测数量

@end
