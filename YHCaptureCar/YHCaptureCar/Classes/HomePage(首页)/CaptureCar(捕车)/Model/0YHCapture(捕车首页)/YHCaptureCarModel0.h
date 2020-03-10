//
//  YHCaptureCarModel0.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/17.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseModel.h"

@interface YHCaptureCarModel0 : YHBaseModel

@property (nonatomic, copy)NSString *ID;             //竞价ID
@property (nonatomic, copy)NSString *name;           //汽车名称
@property (nonatomic, copy)NSString *mileage;        //里程
@property (nonatomic, copy)NSString *useTime;        //使用时间（上牌时间到现在时间）
@property (nonatomic, copy)NSString *bidNum;         //剩余出价次数
@property (nonatomic, copy)NSString *raisePrice;     //加价幅度
@property (nonatomic, copy)NSString *bottomPrice;    //起拍价
@property (nonatomic, copy)NSString *topPrice;       //当前最高价
@property (nonatomic, copy)NSString *ultimatelyPrice;//最终成交价（只有状态为5时,字段时才会有值）
@property (nonatomic, copy)NSString *status;         //是否有效（我是否是最高价） 0 无效（不是最高价） 1 有效（是最高价）
@property (nonatomic, copy)NSString *startTime;      //活动开始时间
@property (nonatomic, copy)NSString *endTime;        //活动结束时间
@property (nonatomic, copy)NSString *carPicture;     //汽车图片
@property (nonatomic, copy)NSString *bidTime;        //竞价成功时间
@property (nonatomic, copy)NSString *myTopPrice;     //我的最高价 （只有页面有这个字段时才会有值）

@end
