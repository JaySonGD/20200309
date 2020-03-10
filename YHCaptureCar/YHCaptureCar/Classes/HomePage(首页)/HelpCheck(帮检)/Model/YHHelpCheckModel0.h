//
//  YHHelpCheckModel0.h
//  YHCaptureCar
//
//  Created by mwf on 2018/4/14.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHHelpCheckModel0 : NSObject

//帮检ID
@property (nonatomic, copy)NSString *ID;

//站点名称
@property (nonatomic, copy)NSString *orgName;

//车型描述
@property (nonatomic, copy)NSString *carDesc;

//预约时间，格式yyyy-MM-dd
@property (nonatomic, copy)NSString *bookDate;

//预约单状态：-1 待接单 0-待检测，1-检测完成，2-已取消，3-退款中，4-退款完成
@property (nonatomic, copy)NSString *orderStatus;

//支付状态： 0 待支付 1 支付完成 2 支付失败
@property (nonatomic, copy)NSString *payStatus;

//检测费用
@property (nonatomic, copy)NSString *detectFee;

//检测报告code，只有检测完成才能会有，可以跳转到报告详情
@property (nonatomic, copy)NSString *rptCode;


@end
