//
//  TTZCarModel.h
//  YHCaptureCar
//
//  Created by Jay on 2018/3/21.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface offerModel : NSObject
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *commission;
@property (nonatomic, copy) NSString *offerPrice;
@end

@interface TTZCarModel : NSObject


/** 车辆ID */
@property (nonatomic, copy) NSString *carId;

/** 车商名称 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *userPic;

/** 发布时间  */
@property (nonatomic, copy) NSString *addTime;

/** 车辆描述  */
@property (nonatomic, copy) NSString *carDesc;


/** 城市名称  */
@property (nonatomic, copy) NSString *city;



/** 汽车销售名称  */
@property (nonatomic, copy) NSString *carName;

/** 里程  */
@property (nonatomic, copy) NSString *mileage;

/** 使用时间（上牌时间到现在时间）  */
@property (nonatomic, copy) NSString *useTime;

/** 价格（帮卖价，万元）  */
@property (nonatomic, copy) NSString *price;

/** 汽车图片  */
@property (nonatomic, copy) NSString *carPicture;

/** 是否是认证检测  0 不是 1 是  */
@property (nonatomic, assign) BOOL flag;

/** 状态 0 库存  1 拍卖  2 帮卖  5 帮买*/
@property (nonatomic, assign) NSInteger carStatus;


/** 中拍时间 */
@property (nonatomic, copy) NSString *winTime;


/** 竞拍结束时间  */
@property (nonatomic, copy) NSString *endTime;
/** 竞拍开始时间  */
@property (nonatomic, copy) NSString *startTime;


/** 辅助属性 */
@property (nonatomic, assign) NSInteger imageWidth;

//审核失败/下架原因
@property (nonatomic, copy) NSString *remark;

/** 建议价格 例 12-18 */
@property (nonatomic, copy) NSString *suggestPrice;
/** 是否已询价 0 未询价 1 已询价  */
@property (nonatomic, assign) BOOL isEnquiry;


@end



