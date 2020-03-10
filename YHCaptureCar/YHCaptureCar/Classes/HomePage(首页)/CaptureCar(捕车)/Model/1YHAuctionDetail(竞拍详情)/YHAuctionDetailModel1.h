//
//  YHAuctionDetailModel1.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/24.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseModel.h"
#import "YHAuctionDetailModel2.h"

@interface YHAuctionDetailModel1 : YHBaseModel

@property (nonatomic,copy) NSString *aucStatus;   //竞价状态 0未竞价 1竞价中 2 竞价成功 3 竞价失败
@property (nonatomic,copy) NSString *startPrice;  //0 未竞得字段
@property (nonatomic,copy) NSString *maxPrice;    //1 竞价中 2 竞价成功字段 3 竞价失败字段
@property (nonatomic,copy) NSString *userPrice;   //3 竞价失败字段
@property (nonatomic,copy) NSString *serviceAmt;  //服务费金额
@property (nonatomic,copy) NSString *payStatus;   //2 竞价成功字段
@property (nonatomic,copy) NSString *startTime;   //开拍起始时间
@property (nonatomic,copy) NSString *endTime;     //开拍结束时间
@property (nonatomic,copy) NSString *nowTime;     //当前时间
@property (nonatomic,copy) NSString *isMax;       //我是否是最高价标识 0否 1是
@property (nonatomic,strong) YHAuctionDetailModel2 *tradeInfo; //2 竞价成功模型

@end
