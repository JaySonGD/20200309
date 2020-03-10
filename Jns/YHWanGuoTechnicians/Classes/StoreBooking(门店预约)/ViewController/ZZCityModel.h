//
//  ZZCityModel.h
//  YHCaptureCar
//
//  Created by Jay on 15/11/2018.
//  Copyright © 2018 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//城市
@interface ZZCityModel : NSObject

@property (nonatomic, copy) NSString *initial;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *regionName;

@end
// 区域 eg. A ...Z
@interface ZZCityRegionModel : NSObject

@property (nonatomic, copy) NSString *initial;
@property (nonatomic, strong) NSMutableArray <ZZCityModel *>*cityList;

@end

@interface ZZCity : NSObject

@property (nonatomic, strong) NSMutableArray <ZZCityRegionModel *>*regionList;
@property (nonatomic, strong) NSMutableArray <ZZCityModel *>*hotCityList;

@end

NS_ASSUME_NONNULL_END
