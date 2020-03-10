//
//  ApiService.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "ApiService.h"
#import "YHNetworkManager.h"

@implementation ApiService

DEFINE_SINGLETON_FOR_CLASS(ApiService);




/**
 *根据VIN获取报告信息
 */
#pragma mark  -   根据VIN获取报告信息

- (NSString *)findVinReportURL{
    
    return [NSString stringWithFormat:@"%@/carSource/myCar", SERVER_JAVA_Trunk];
}


/**
 * 检测车商是否是关联车商
 */
#pragma mark  -   检测车商是否是关联车商

- (NSString *)checkDealerURL{
    
    return [NSString stringWithFormat:@"%@/test", SERVER_JAVA_Trunk];
}



/**
 * 捕车广告列表
 */
#pragma mark  -   捕车广告列表

- (NSString *)advListURL{
    
    return [NSString stringWithFormat:@"%@/carSource/myCar", SERVER_JAVA_Trunk];
}




/**
 * 发起帮卖报告费的支付
 */
#pragma mark  -   发起帮卖报告费的支付

- (NSString *)rptTradeURL{
    
    return [NSString stringWithFormat:@"%@/rptTrade", SERVER_JAVA_Trunk];
}

/**
 * 发起帮检费的支付/APP支付回调接口
 */
#pragma mark  -   发起帮检费的支付/APP支付回调接口

- (NSString *)helpTradeURL{
    
    return [NSString stringWithFormat:@"%@/helpTrade", SERVER_JAVA_Trunk];
}


/**
 *  站点列表/预约帮检
 */
#pragma mark  -   站点列表/预约帮检

- (NSString *)helpDetectionURL{
    
    return [NSString stringWithFormat:@"%@/helpDetection", SERVER_JAVA_Trunk];
}




/**
 *  车商联盟
 */
#pragma mark  -   车商联盟
- (NSString *)helpSellCarURL{
    
    return [NSString stringWithFormat:@"%@/entrustTrade/helpSellCar", SERVER_JAVA_Trunk];
}


/**
 *  上传工单图片接口
 */
#pragma mark  -  上传工单图片接口
- (NSString *)uploadBillImageURL{
    return [NSString stringWithFormat:@"%@/%@/upload/imgUpload", @SERVER_JAVA_URL,SERVER_JAVA_Trunk];
}


/**
 *  我的车辆
 */
#pragma mark  -   我的车辆
- (NSString *)myCarURL{
    
    return [NSString stringWithFormat:@"%@/carSource/myCar", SERVER_JAVA_Trunk];
}

/**
 *  报价咨询
 */
#pragma mark  -   报价咨询
- (NSString *)findSuggestPriceURL{
    
    return [NSString stringWithFormat:@"%@/carSource/myCar", SERVER_JAVA_Trunk];
}


/**
 *  城市列表
 */
#pragma mark  -   城市列表
- (NSString *)findCityListURL{
    
    return [NSString stringWithFormat:@"%@/auction/user", SERVER_JAVA_Trunk];
}

/**
 *  在库车辆详情
 */
#pragma mark  -   在库车辆详情

- (NSString *)detailURL{
    
    return [NSString stringWithFormat:@"%@/usedCar/car", SERVER_JAVA_Trunk];
}


/**
 *  车辆详情
 */
#pragma mark  -   车辆详情

- (NSString *)helpBuyDetailURL{
    
    return [NSString stringWithFormat:@"%@/usedCar/pay", SERVER_JAVA_Trunk];
}

@end
