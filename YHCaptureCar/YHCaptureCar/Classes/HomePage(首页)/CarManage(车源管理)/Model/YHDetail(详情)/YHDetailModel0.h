//
//  YHDetailModel0.h
//  YHCaptureCar
//
//  Created by mwf on 2018/3/26.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHDetailModel0 : NSObject

@property (nonatomic, copy)NSString *url;               //H5报告链接
@property (nonatomic, copy)NSString *auctionId;         //竞拍ID
@property (nonatomic, copy)NSString *startTime;         //竞拍开始时间
@property (nonatomic, copy)NSString *endTime;           //竞拍结束时间
@property (nonatomic, copy)NSString *nowTime;           //系统当前时间

//审核状态
//0 待审核
//1 审核通过（待安排）（待开拍状态： 审核状态 = 1 and 竞拍开始时间不等于空）(开拍中： 审核状态 = 1 and 竞拍开始时间不等于空 and 竞拍开始时间 < 当前时间 )
//2 审核失败
@property (nonatomic, copy)NSString *autditStatus;
@property (nonatomic, copy)NSString *reason;            //审核失败原因
@property (nonatomic, copy)NSString *cashDeposit;       //保证金（上拍卖需要扣除的保证金)

//以上是认证车辆时返回的数据，不是认证车辆时返回以下数据

@property (nonatomic, copy)NSString *carPicture;        //车辆图片
@property (nonatomic, copy)NSString *carName;           //车辆名称
@property (nonatomic, copy)NSString *carNo;             //车源编号

@property (nonatomic, copy)NSString *year;              //年款
@property (nonatomic, copy)NSString *powerParam;        //动力参数
@property (nonatomic, copy)NSString *model;             //型号
@property (nonatomic, copy)NSString *userName;          //联系人名称
@property (nonatomic, copy)NSString *phone;             //联系人电话
@property (nonatomic, copy)NSString *certificateTime;   //发证时间
@property (nonatomic, copy)NSString *asTime;            //年检到期时间
@property (nonatomic, copy)NSString *ciTime;            //商业险到期时间
@property (nonatomic, copy)NSString *inExpireTime;      //交强险到期时间

@property (nonatomic, copy)NSString *licenseTime;       //上牌时间
@property (nonatomic, copy)NSString *mileage;           //里程
@property (nonatomic, copy)NSString *cc;                //排放标准
@property (nonatomic, copy)NSString *plateNo;           //车牌号
@property (nonatomic, copy)NSString *address;           //看车地址
@property (nonatomic, copy)NSString *carNature;         //车辆性质
@property (nonatomic, copy)NSString *useNature;         //车辆所有者性质
@property (nonatomic, copy)NSString *keyType;           //钥匙类型
@property (nonatomic, copy)NSString *oilType;           //燃油类型
@property (nonatomic, copy)NSString *color;             //车身颜色
@property (nonatomic, copy)NSString *transferNun;       //过户次数
@property (nonatomic, copy)NSString *productDate;       //生产时间

@property (nonatomic, copy)NSString *favorite;          //收藏 0 未收藏  1 已收藏

@property (nonatomic, copy)NSString *carCaseDesc;       //车况描述


@property (nonatomic, copy)NSString *desc;             //
@property (nonatomic, copy)NSString *name;             //
@property (nonatomic, copy)NSString *fullName;         //车辆全名称

//以下字段不管是否认证检测车辆都会返回
@property (nonatomic, copy)NSString *carId;             //车辆ID
@property (nonatomic, copy)NSString *carStatus;         //车辆状态 0-库存 1-帮卖 2-拍卖
@property (nonatomic, copy)NSString *tradeStatus;       //车辆状态 0-库存 1-帮卖 2-拍卖
@property (nonatomic, copy)NSString *flag;              //是否是认证检测  0 不是 1 是
@property (nonatomic, copy)NSString *price;             //帮卖价/竞拍价


/** 帮卖费/帮买费 */
@property (nonatomic, copy) NSString *helpSellPrice;


/**支付查看报告费*/
@property (nonatomic, assign) CGFloat payPrice;
/**支付查看报告费状态    支付状态 0-待支付 1-支付成功 2-支付失败*/
@property (nonatomic, assign) NSInteger parStatus;

/**是否已报价 0 未报价 1 已报价*/
@property (nonatomic, assign) BOOL isOffer;

/** 佣金*/
@property (nonatomic, copy) NSString * brokerage;
/** 活动价格，当活动价格不为空时，中划线划掉报告原价格显示活动价格（帮买才会有该字段 ）*/
@property (nonatomic, copy) NSString *activityPrice;
/** 报告原价格（帮买才会有该字段 ）*/
@property (nonatomic, copy) NSString *originalPrice;
@property (nonatomic, copy) NSString *code;

/** 买家报价*/
@property (nonatomic, copy) NSString *buyerPrice;

@end
