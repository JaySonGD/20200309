//
//  YHSiteModel.h
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/12/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHSiteModel : NSObject

@property (nonatomic, copy)NSString *carBrandId;
@property (nonatomic, copy)NSString *carBrandName;
@property (nonatomic, copy)NSString *carCc;
@property (nonatomic, copy)NSString *carLineId;
@property (nonatomic, copy)NSString *carLineName;
@property (nonatomic, copy)NSString *carModelFullName;
@property (nonatomic, copy)NSString *carModelId;
@property (nonatomic, copy)NSString *gearboxType;
@property (nonatomic, copy)NSString *nianKuan;
@property (nonatomic, copy)NSString *produceYear;
@property (nonatomic, copy)NSString *unit;
@property (nonatomic, copy)NSString *vin;
//@property (nonatomic, copy)NSString *carCc;
//@property (nonatomic, copy)NSString *unit;
//{
//    carBrandId = 2000210;
//    carBrandName = "\U5965\U8fea";
//    carCc = 55;
//    carLineId = 20000155;
//    carLineName = Q3;
//    carModelFullName = "\U5965\U8fea Q3 2018\U6b3e 55L \U65e0\U7ea7\U53d8\U901f\U5668";
//    carModelId = "";
//    gearboxType = "\U65e0\U7ea7\U53d8\U901f\U5668";
//    nianKuan = 2018;
//    produceYear = "";
//    unit = L;
//    vin = 55555555555555555;
//}

@end

NS_ASSUME_NONNULL_END
