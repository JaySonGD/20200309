//
//  YHAuctionDetailModel3.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/24.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseModel.h"

@interface YHAuctionDetailModel3 : YHBaseModel

@property(nonatomic,copy)NSString *bidNum;      //出价次数
@property(nonatomic,copy)NSString *isFirstBid;  //是否第一次出价 0是  1否 (如果是第一次，那么需要显示保证金金额)
@property(nonatomic,copy)NSString *depositAmt;  //保证金金额

@end
