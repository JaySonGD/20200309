//
//  YHDetectionRecordModel.h
//  YHCaptureCar
//
//  Created by liusong on 2018/1/30.
//  Copyright © 2018年 YH. All rights reserved.
//  检测中心模型

#import "YHBaseModel.h"

@interface YHDetectionRecordModel : YHBaseModel
@property (nonatomic, copy)NSString *carPicture;       //汽车图片
@property (nonatomic, assign)long ID;                 //车辆ID
@property (nonatomic, copy)NSString *desc;            //车辆描述
@property (nonatomic, copy)NSString *prodDate;       //生产时间
@property (nonatomic, assign)float km;                 //公里数
@property (nonatomic, assign)float price;          //价格(万元)

@end
