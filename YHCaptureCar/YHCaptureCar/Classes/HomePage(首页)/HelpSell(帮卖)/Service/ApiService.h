//
//  ApiService.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/9.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface ApiService : NSObject
DEFINE_SINGLETON_FOR_HEADER(ApiService);




/**
 *根据VIN获取报告信息
 */
#pragma mark  -   根据VIN获取报告信息

- (NSString *)findVinReportURL;

/**
 * 检测车商是否是关联车商
 */
#pragma mark  -   检测车商是否是关联车商

- (NSString *)checkDealerURL;

/**
 * 捕车广告列表
 */
#pragma mark  -   捕车广告列表

- (NSString *)advListURL;
/**
 * 发起帮卖报告费的支付
 */
#pragma mark  -   发起帮卖报告费的支付

- (NSString *)rptTradeURL;
/**
 * 发起帮检费的支付
 */
#pragma mark  -   发起帮检费的支付
- (NSString *)helpTradeURL;

/**
 *  车商联盟
 */
#pragma mark  -   车商联盟
- (NSString *)helpSellCarURL;


/**
 *  上传工单图片接口
 */
- (NSString *)uploadBillImageURL;

/**
 *  我的车辆
 */
#pragma mark  -   我的车辆
- (NSString *)myCarURL;



/**
 *  站点列表/预约帮检
 */
#pragma mark  -   站点列表/预约帮检
- (NSString *)helpDetectionURL;


/**
 *  报价咨询
 */
#pragma mark  -   报价咨询
- (NSString *)findSuggestPriceURL;

/**
 *  城市列表
 */
#pragma mark  -   城市列表
- (NSString *)findCityListURL;


/**
 *  在库车辆详情
 */
#pragma mark  -   在库车辆详情
- (NSString *)detailURL;


/**
 *  车辆详情
 */
#pragma mark  -   车辆详情

- (NSString *)helpBuyDetailURL;
@end
