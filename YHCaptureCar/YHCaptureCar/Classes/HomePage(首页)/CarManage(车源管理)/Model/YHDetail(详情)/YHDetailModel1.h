//
//  YHDetailModel1.h
//  YHCaptureCar
//
//  Created by mwf on 2018/4/8.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHDetailModel2.h"

@interface YHDetailModel1 : NSObject

//竞拍状态 0未竞拍 1竞拍中 2 竞拍成功  4竞拍结果计算中，请稍后查看 5-已取消
@property (nonatomic, copy)NSString *aucStatus;

//成交价格
@property (nonatomic, copy)NSString *tradePrice;

//卖家服务费价格
@property (nonatomic, copy)NSString *serviceAmt;

//服务费支付状态 0待支付  1支付成功 2支付失败
@property (nonatomic, copy)NSString *payStatus;

@property (nonatomic, strong)YHDetailModel2 *buyInfo;

@end
