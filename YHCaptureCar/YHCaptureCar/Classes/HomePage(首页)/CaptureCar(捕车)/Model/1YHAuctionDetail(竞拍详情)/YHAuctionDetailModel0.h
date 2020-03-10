//
//  YHAuctionDetailModel0.h
//  YHCaptureCar
//
//  Created by mwf on 2018/1/20.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseModel.h"

@interface YHAuctionDetailModel0 : YHBaseModel

@property (nonatomic, assign)int ID;                   //竞价ID
@property (nonatomic, copy)NSString *licenseTime;      //上牌时间
@property (nonatomic, copy)NSString *mileage;          //里程
@property (nonatomic, copy)NSString *cc;               //排量
@property (nonatomic, copy)NSString *plateNo;          //车牌号
@property (nonatomic, copy)NSString *address;          //看车地址
@property (nonatomic, copy)NSString *carNature;        //车辆性质
@property (nonatomic, copy)NSString *useNature;        //使用性质
@property (nonatomic, copy)NSString *keyType;          //钥匙类型
@property (nonatomic, copy)NSString *oilType;          //燃油类型
@property (nonatomic, copy)NSString *color;            //车身颜色
@property (nonatomic, copy)NSString *transferNun;      //过户次数
@property (nonatomic, copy)NSString *productDate;      //生产时间
@property (nonatomic, copy)NSString *isStatus;         //是否中拍 0 未中拍  1 中拍
@property (nonatomic, copy)NSString *isPurpose;        //是否是意向竞价 0 否  1 是
@property (nonatomic, copy)NSString *surplusNo;        //剩余出价次数
@property (nonatomic, copy)NSString *depositStatus;    //保证金状态 0 未交保证金 1 已交保证金 2 保证金余额不足
@property (nonatomic, copy)NSString *raisePrice;       //加价幅度
@property (nonatomic, copy)NSString *auctionNum;       //竞价次数
@property (nonatomic, copy)NSString *techName;         //检测技师姓名
@property (nonatomic, copy)NSString *offer;            //车辆报价
@property (nonatomic, copy)NSString *status;           //车辆状态 0 - 待审核 1 - 审核通过 2 - 审核不通过 3 - 已下架 4 - 已上架
@property (nonatomic, copy)NSString *rptUrl;           //检测报告ID
@property (nonatomic, copy)NSString *carPicture;       //车辆图片
@property (nonatomic, copy)NSString *carNo;            //车源编号
@property (nonatomic, copy)NSString *desc;             //
@property (nonatomic, copy)NSString *name;             //
@property (nonatomic, copy)NSString *fullName;         //车辆全名称

@end
