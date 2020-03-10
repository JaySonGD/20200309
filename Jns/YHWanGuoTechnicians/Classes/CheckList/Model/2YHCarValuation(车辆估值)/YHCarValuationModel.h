//
//  YHCarValuationModel.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/9/10.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHCarValuationModel : NSObject

/*
 成交均价
 */
@property (nonatomic, copy) NSString *minPrice;

/*
 成交最高价
 */
@property (nonatomic, copy) NSString *maxPrice;

/*
 推送价格
 */
@property (nonatomic, copy) NSString *price;

/*
 推送手机号码
 */
@property (nonatomic, copy) NSString *phone;

/*
 报告链接地址(分享地址)
 */
@property (nonatomic, copy) NSString *reportUrl;

/*
 分享主标题
 */
@property (nonatomic, copy) NSString *shareHeading;

/*
 分享副标题
 */
@property (nonatomic, copy) NSString *shareSubheading;

/*
 分享图片
 */
@property (nonatomic, copy) NSString *shareImg;

/*
 车辆品牌logo
 */
@property (nonatomic, copy) NSString *carBrandLogo;

@end
