//
//  ZZCityListViewController.h
//  YHCaptureCar
//
//  Created by Jay on 14/11/2018.
//  Copyright © 2018 YH. All rights reserved.
//

#import "YHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZCityModel;
@interface ZZCityListViewController : YHBaseViewController
@property (nonatomic, copy) void (^selectCityBlock) (ZZCityModel *city);
@end

NS_ASSUME_NONNULL_END
